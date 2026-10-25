/*
    [ancla, posición, nombre, radio, agentes, objetosPropios] (servidor) — bucle del control de carretera.
    Fases por vehículo: stop (alto) -> wait (detenido, sin agente libre) -> approach (agente va a la ventanilla)
    -> papers (documentación) -> searchMove / search (registro con animación) -> salida.
*/
params ["_anchor", "_pos", "_name", "_radius", "_officers", ["_owned", []]];
private _state = createHashMap;     // netId vehículo -> [fase, tiempo, vehículo, agente, resultados, detenciones]
private _cleared = createHashMap;   // netId vehículo -> serverTime hasta el que puede pasar
private _idTypes = ["checkpointDocs", ["IDCard", "Passport", "MilitaryID", "MPBadge", "IABadge"]] call ADVSEC_fnc_setting;
private _say = {params ["_veh", "_txt"]; {if (isPlayer _x) then {_txt remoteExecCall ["hint", _x]}} forEach crew _veh};
private _popup = {params ["_veh", "_t", "_txt"]; {if (isPlayer _x) then {[_t, _txt] remoteExecCall ["ADVSEC_fnc_cpAlert", _x]}} forEach crew _veh};
private _cmd = {params ["_u", "_c", "_a"]; [_u, _a] remoteExecCall [_c, _u]};
private _anim = {
    params ["_u", "_kind"];
    private _rifle = primaryWeapon _u isNotEqualTo "" && {currentWeapon _u isEqualTo primaryWeapon _u};
    private _m = switch (_kind) do {
        case "papers": {["AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon", "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon"] select _rifle};
        default {["AinvPknlMstpSnonWnonDnon_medic_1", "AinvPknlMstpSlayWrflDnon_medic"] select _rifle};
    };
    [_u, "playMoveNow", _m] call _cmd;
};
private _free = {
    private _l = _officers select {alive _x && {!(_x getVariable ["ADVSEC_cpBusy", false])} && {lifeState _x in ["HEALTHY", "INJURED"]} && {(_x distance _pos) < (_radius * 3)}};
    _l = [_l, [_this], {_x distance _input0}, "ASCEND"] call BIS_fnc_sortBy;
    _l param [0, objNull]
};
private _goHome = {
    params ["_u"];
    if (isNull _u) exitWith {};
    _u setVariable ["ADVSEC_cpBusy", false];
    [_u, "doWatch", objNull] call _cmd;
    private _post = _u getVariable ["ADVSEC_cpPost", []];
    if (_post isNotEqualTo []) then {[_u, "doMove", _post select 0] call _cmd};
};
private _hold = {
    params ["_veh", "_stop"];
    _veh setVariable ["ADVSEC_cpHold", _stop, true];
    if (_stop) then {[_veh] remoteExecCall ["ADVSEC_fnc_cpBrake", _veh]};
    private _d = driver _veh;
    if (isNull _d || {isPlayer _d}) exitWith {};
    if (_stop) then {
        [_d, "MOVE"] remoteExecCall ["disableAI", _d];
        [_d] remoteExecCall ["doStop", _d];
    } else {
        [_d, "MOVE"] remoteExecCall ["enableAI", _d];
        [_d, leader _d] remoteExecCall ["doFollow", _d];
    };
};
private _release = {
    params ["_k", "_veh", "_off", "_txt", ["_secs", 45]];
    [_veh, false] call _hold;
    [_off] call _goHome;
    _state deleteAt _k;
    _cleared set [_k, serverTime + _secs];
    if (_txt isNotEqualTo "") then {[_veh, "PUEDE CONTINUAR", _txt] call _popup};
};
private _fled = {
    params ["_k", "_veh", "_off"];
    private _d = driver _veh;
    {
        if (isPlayer _x) then {[getPlayerUID _x, name _x, format ["Saltarse el %1", _name], "Alta"] call ADVSEC_fnc_wantedSys};
    } forEach ([crew _veh, [_d]] select (!isNull _d));
    ["checkpointFlee", _d, [_name, typeOf _veh, getPlateNumber _veh]] call ADVSEC_fnc_logEvent;
    (format ["%1: un %2 (matrícula %3) se ha saltado el control.", _name, getText (configOf _veh >> "displayName"), getPlateNumber _veh]) remoteExecCall ["systemChat", 0];
    [_k, _veh, _off, "", 45] call _release;
};

private _tick = 0;
while {!isNull _anchor} do {
    _tick = _tick + 1;
    // Nuevos vehículos: alto
    // Se detecta desde el doble del radio para que ningún vehículo pase entre dos comprobaciones
    private _exemptPM = (["checkpointExemptPM", 0] call ADVSEC_fnc_setting) isEqualTo 1;
    private _here = (_pos nearEntities [["Car", "Motorcycle", "Tank"], _radius * 2]) select {
        alive _x && {!isNull driver _x} && {!((driver _x) in _officers)} && {(_cleared getOrDefault [netId _x, -1]) < serverTime}
        && {!_exemptPM || {!(isPlayer driver _x && {[driver _x, "PM"] call ADVSEC_fnc_repAccess})}}
    };
    {
        private _veh = _x;
        if !(netId _veh in _state) then {
            _state set [netId _veh, ["stop", serverTime, _veh, objNull, [], [], 0, false]];
            [_veh, true] call _hold;
            [_veh, "ALTO", format ["<t font='RobotoCondensedBold'>%1</t><br/>Detenga el vehículo y prepare la documentación.", _name]] call _popup;
            {
                if (alive _x) then {[_x, "doWatch", _veh] call _cmd; [_x, "playActionNow", "gestureFreeze"] call _cmd};
            } forEach (_officers select {!(_x getVariable ["ADVSEC_cpBusy", false])});
        };
    } forEach _here;

    if (_tick mod 4 != 0) then {sleep 0.25; continue};
    {
        private _k = _x;
        private _e = _state get _k;
        _e params ["_phase", "_t", "_veh", "_off", "_out", "_arrest"];
        if (isNull _veh || {!alive _veh}) then {[_off] call _goHome; _state deleteAt _k; continue};
        private _d = driver _veh;
        private _dist = _veh distance2D _pos;
        private _moving = speed _veh > 6;
        private _offOk = !isNull _off && {alive _off} && {lifeState _off in ["HEALTHY", "INJURED"]};
        if (_phase != "stop" && {_moving || {_dist > _radius * 3}}) then {[_k, _veh, _off] call _fled; continue};
        if (_phase in ["approach", "ask", "papers", "searchMove", "search"] && {!_offOk}) then {_e set [0, "wait"]; _e set [1, serverTime]; _e set [3, objNull]; continue};
        switch (_phase) do {
            case "stop": {
                if (speed _veh < 2) then {_e set [0, "wait"]; _e set [1, serverTime]} else {
                    if (_dist > _radius * 3 || {serverTime - _t > 60}) then {[_k, _veh, objNull] call _fled};
                };
            };
            case "wait": {
                private _o = _veh call _free;
                if (!isNull _o) then {
                    _o setVariable ["ADVSEC_cpBusy", true];
                    _e set [3, _o];
                    _e set [0, "approach"]; _e set [1, serverTime];
                    [_o, "doMove", _veh modelToWorld [-2.3, 1, 0]] call _cmd;
                } else {
                    // Sin agentes vivos: comprobación a distancia
                    if ((_officers findIf {alive _x}) < 0 && {serverTime - _t > 6}) then {_e set [0, "papers"]; _e set [1, serverTime - 6]};
                };
            };
            case "approach": {
                if ((_off distance (_veh modelToWorld [-2.3, 1, 0])) < 2.5 || {serverTime - _t > 30}) then {
                    [_off, "doMove", getPosATL _off] call _cmd;
                    [_off, "doWatch", [_d, _veh] select (isNull _d)] call _cmd;
                    [_off, "papers"] call _anim;
                    _veh setVariable ["ADVSEC_cpShown", []];
                    {
                        if (isPlayer _x) then {[_veh, name _off, _name] remoteExecCall ["ADVSEC_fnc_cpAsk", _x]};
                    } forEach crew _veh;
                    _e set [0, "ask"]; _e set [1, serverTime];
                };
            };
            case "ask": {
                // Espera a que cada jugador pulse "Mostrar documentación" (40 s máx.; si no, cuenta como negativa)
                private _players = (crew _veh) select {isPlayer _x};
                private _shown = _veh getVariable ["ADVSEC_cpShown", []];
                private _refused = _veh getVariable ["ADVSEC_cpRefused", []];
                if ((_players findIf {!(getPlayerUID _x in _shown) && {!(getPlayerUID _x in _refused)}}) > -1 && {serverTime - _t < 40}) then {
                    if ((round (serverTime - _t)) mod 6 == 0) then {[_off, "papers"] call _anim};
                    continue;
                };
                {
                    if !(getPlayerUID _x in _shown) then {_arrest pushBackUnique [_x, "Negarse a identificarse"]};
                } forEach _players;
                _veh setVariable ["ADVSEC_cpRefused", nil];
                private _papers = ["checkpointPapersTime", 8] call ADVSEC_fnc_setting;
                private _search = _arrest isEqualTo [] && {random 1 < (["checkpointSearchChance", 1] call ADVSEC_fnc_setting)} && {_offOk};
                private _total = _papers + ([0, ["checkpointVehicleTime", 15] call ADVSEC_fnc_setting] select _search);
                _e set [6, serverTime + _total];
                _e set [7, _search];
                {
                    if (isPlayer _x) then {[[ "Revisando documentación", "Revisando documentación y vehículo"] select _search, _total, _veh] remoteExecCall ["ADVSEC_fnc_cpProgress", _x]};
                } forEach crew _veh;
                [_off, "papers"] call _anim;
                _e set [0, "papers"]; _e set [1, serverTime];
            };
            case "papers": {
                if (serverTime - _t < (["checkpointPapersTime", 8] call ADVSEC_fnc_setting)) then {continue};
                {
                    private _u = _x;
                    private _uid = getPlayerUID _u;
                    if (_uid isNotEqualTo "" && {_uid in (missionNamespace getVariable ["ADVSEC_wantedUIDs", []])}) then {_arrest pushBack [_u, "Requisitoria en vigor"]; continue};
                    if !([_u, -1, _idTypes] call ADVSEC_fnc_docCheck) then {
                        private _amt = ["checkpointFine", 150] call ADVSEC_fnc_setting;
                        private _fid = [_u, _amt, format ["Circular sin documentación (%1)", _name], _name, ""] call ADVSEC_fnc_fineAdd;
                        _out pushBack format ["%1: sin documentación, multa %2.", name _u, _fid];
                    };
                } forEach crew _veh;
                if (_e param [7, false] && {_arrest isEqualTo []} && {_offOk}) then {
                    private _bb = boundingBoxReal _veh;
                    [_off, "doWatch", objNull] call _cmd;
                    [_off, "doMove", _veh modelToWorld [0, ((_bb select 0) select 1) - 1.2, 0]] call _cmd;
                    _e set [0, "searchMove"]; _e set [1, serverTime];
                } else {_e set [0, "decide"]; _e set [1, serverTime]};
            };
            case "searchMove": {
                private _bb = boundingBoxReal _veh;
                if ((_off distance (_veh modelToWorld [0, ((_bb select 0) select 1) - 1.2, 0])) < 2.5 || {serverTime - _t > 8}) then {
                    [_off, "doMove", getPosATL _off] call _cmd;
                    [_off, "doWatch", _veh] call _cmd;
                    [_off, "search"] call _anim;
                    _e set [0, "search"]; _e set [1, serverTime];
                };
            };
            case "search": {
                if (serverTime < (_e param [6, 0])) then {
                    if ((round (serverTime - _t)) mod 4 == 0) then {[_off, "search"] call _anim};
                    continue;
                };
                _out pushBack "Vehículo registrado.";
                private _ill = ["illegalItems", []] call ADVSEC_fnc_setting;
                if (_ill isNotEqualTo []) then {
                    private _cargo = (getItemCargo _veh select 0) + (getWeaponCargo _veh select 0) + (getMagazineCargo _veh select 0);
                    {
                        private _u = _x;
                        if (((items _u + weapons _u + magazines _u + assignedItems _u) findIf {_x in _ill}) > -1) then {_arrest pushBackUnique [_u, "Material ilegal"]};
                    } forEach crew _veh;
                    if ((_cargo findIf {_x in _ill}) > -1 && {!isNull _d} && {(_arrest findIf {(_x select 0) isEqualTo _d}) < 0}) then {_arrest pushBack [_d, "Material ilegal en el vehículo"]};
                };
                _e set [0, "decide"]; _e set [1, serverTime];
            };
            case "decide": {
                private _boss = [_off, _officers param [_officers findIf {alive _x}, objNull]] select (isNull _off);
                {
                    _x params ["_u", "_why"];
                    if (!isNull _boss && {(missionNamespace getVariable ["ADVSEC_jails", []]) isNotEqualTo []}) then {
                        ["jail", _boss, [_u, 15, format ["%1 (%2)", _why, _name], objNull, false]] call ADVSEC_fnc_jailServer;
                        ["FPM04", format ["Detención en %1", _name], [format ["%1 [%2]", name _u, getPlayerUID _u]],
                            format ["Detención automática en %1 (cuadrícula %2) por %3. Motivo: %4. Vehículo: %5, matrícula %6.", _name, mapGridPosition _pos, name _boss, _why, getText (configOf _veh >> "displayName"), getPlateNumber _veh],
                            "Grave", false] call ADVSEC_fnc_repSystem;
                        _out pushBack format ["%1: detenido (%2).", name _u, _why];
                    } else {
                        if (isPlayer _u) then {[getPlayerUID _u, name _u, format ["%1 (%2)", _why, _name], "Alta"] call ADVSEC_fnc_wantedSys};
                        (format ["%1: %2 retenido (%3). Se requiere una patrulla.", _name, name _u, _why]) remoteExecCall ["systemChat", 0];
                        _out pushBack format ["%1: retenido (%2).", name _u, _why];
                    };
                } forEach _arrest;
                ["checkpointCheck", _d, [_name, typeOf _veh, getPlateNumber _veh, _out]] call ADVSEC_fnc_logEvent;
                [_k, _veh, _off, [_out joinString "<br/>", "Todo en orden. Buen viaje."] select (_out isEqualTo [])] call _release;
            };
        };
    } forEach (keys _state);
    sleep 0.25;
};
{
    _y params ["", "", "_veh", "_off"];
    [_veh, false] call _hold;
} forEach _state;
{deleteVehicle _x} forEach _owned;
