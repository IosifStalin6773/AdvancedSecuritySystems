/*
    [acción, llamador, args] (servidor) — células operativas (CP, QRF, SEC) y respuesta rápida
    "list" · "set" [uid, rol] · "state" [estado] · "tick" (disponibilidad, interno) · "qrfTick" (llegadas, interno)
    "panic" [idAviso] (desde la central) · "accept" [idAviso] (desde la central)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (_action in ["tick", "qrfTick"] && {call ADVSEC_fnc_fromClient}) exitWith {};
if (!(_action in ["tick", "qrfTick"]) && {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _db = [] call ADVSEC_fnc_cellDB;
private _st = localNamespace getVariable ["ADVSEC_qrfStats", createHashMap];
private _runs = localNamespace getVariable ["ADVSEC_qrfRuns", createHashMap];
private _say = {if (!isNull _caller) then {_this remoteExecCall ["hint", _caller]}};
private _publish = {missionNamespace setVariable ["ADVSEC_cellRoles", (keys _db) apply {[_x, (_db get _x) select 0, (_db get _x) select 2]}, true]};
private _members = {
    params ["_role", ["_avail", false]];
    ((keys _db) select {((_db get _x) select 0) == _role && {!_avail || {((_db get _x) select 2) == "Disponible"}}}) apply {[_x] call ADVSEC_fnc_uidUnit} select {!isNull _x && {alive _x} && {_x getVariable ["ADVSEC_onDuty", false]}}
};
private _ctrs = {
    // contratos en curso de un tipo
    params ["_type"];
    private _c = [] call ADVSEC_fnc_ctrDB;
    (values _c) select {(_x get "state") == "En curso" && {_type == "" || {(_x get "type") == _type}}}
};
switch (_action) do {
    case "list": {
        if !([_caller, "cellView"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_cell" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _rows = [];
        {
            _y params ["_role", "_name", "_state", "_av", "_dt"];
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            private _s = _st getOrDefault [_x, [0, 0, 0, 0]];
            private _avg = [(_s select 1) / ((_s select 0) max 1), 0] select ((_s select 0) == 0);
            private _on = !isNull _u && {_u getVariable ["ADVSEC_onDuty", false]};
            _rows pushBack [
                format ["%1 · %2 · %3%4", (format ["STR_ADVSEC_pmc_role_%1", _role]) call ADVSEC_fnc_L, _name, _state call ADVSEC_fnc_Lv, ["", " · " + ("STR_ADVSEC_pmc_offduty" call ADVSEC_fnc_L)] select !_on],
                _x,
                format [("STR_ADVSEC_pmc_cell_detail" call ADVSEC_fnc_L), _name call ADVSEC_fnc_repEsc, (format ["STR_ADVSEC_pmc_role_%1", _role]) call ADVSEC_fnc_L, _state call ADVSEC_fnc_Lv,
                    round (100 * _av / (_dt max 1)), _s select 0, [_avg, "MM:SS"] call BIS_fnc_secondsToString, _s select 2, _s param [3, 0],
                    [("STR_ADVSEC_no" call ADVSEC_fnc_L), ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select _on],
                switch (true) do {case (!_on): {[0.55, 0.55, 0.55, 1]}; case (_state == "Movilizado"): {[1, 0.5, 0.3, 1]}; case (_state == "Disponible"): {[0.45, 1, 0.45, 1]}; default {[]}},
                ""
            ];
        } forEach _db;
        private _open = {!(_x select 3)} count (values _runs);
        ["cell", format [("STR_ADVSEC_pmc_cell_info" call ADVSEC_fnc_L), count (["QRF", true] call _members), count (["CP"] call _members), count (["SEC"] call _members), _open, ["qrfTarget", 8] call ADVSEC_fnc_setting], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "set": {
        if !([_caller, "cellManage"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_cellmanage" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_uid", ""], ["_role", ""]];
        if (_uid isEqualTo "") exitWith {};
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        private _nm = [(_db getOrDefault [_uid, ["", "?"]]) select 1, name _u] select !isNull _u;
        if (_role isEqualTo "") then {_db deleteAt _uid} else {
            if !(_role in ["CP", "QRF", "SEC"]) exitWith {};
            private _e = _db getOrDefault [_uid, [_role, _nm, "Disponible", 0, 0]];
            _e set [0, _role];
            _e set [1, _nm];
            _db set [_uid, _e];
        };
        call _publish;
        ["cells"] call ADVSEC_fnc_dbDirty;
        ["cellRole", _caller, [_uid, _nm, _role]] call ADVSEC_fnc_logEvent;
        if (!isNull _u) then {(format [("STR_ADVSEC_pmc_cell_assigned" call ADVSEC_fnc_L), [(format ["STR_ADVSEC_pmc_role_%1", _role]) call ADVSEC_fnc_L, ("STR_ADVSEC_pmc_role_none" call ADVSEC_fnc_L)] select (_role isEqualTo "")]) remoteExecCall ["hint", _u]};
        ["list", _caller] call ADVSEC_fnc_cellServer;
    };
    case "state": {
        _args params [["_s", "Disponible"]];
        private _uid = getPlayerUID _caller;
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {("STR_ADVSEC_pmc_not_in_cell" call ADVSEC_fnc_L) call _say};
        if !(_s in ["Disponible", "Descanso"]) exitWith {};
        if ((_e select 2) == "Movilizado" && {_s == "Descanso"}) exitWith {("STR_ADVSEC_pmc_cell_busy" call ADVSEC_fnc_L) call _say};
        _e set [2, _s];
        call _publish;
        (format [("STR_ADVSEC_pmc_cell_state" call ADVSEC_fnc_L), _s call ADVSEC_fnc_Lv]) call _say;
        ["list", _caller] call ADVSEC_fnc_cellServer;
    };
    case "tick": {
        // Cada 30 s: tiempo de servicio y tiempo disponible de cada miembro conectado
        {
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            if (!isNull _u && {alive _u} && {_u getVariable ["ADVSEC_onDuty", false]}) then {
                _y set [4, (_y select 4) + 1];
                if ((_y select 2) == "Disponible") then {_y set [3, (_y select 3) + 1]};
            };
        } forEach _db;
        ["cells"] call ADVSEC_fnc_dbDirty;
    };
    case "panic": {
        if (!isNull _caller && {!([_caller, "PM"] call ADVSEC_fnc_repAccess)} && {call ADVSEC_fnc_fromClient} && {isNil {(localNamespace getVariable ["ADVSEC_dspCalls", createHashMap]) get (_args param [0, ""])}}) exitWith {};
        if (!isNil {_runs get (_args param [0, ""])}) exitWith {};
        // Pánico o aviso dentro de un contrato: la QRF disponible recibe prioridad; en un contrato VIP sigue al VIP en vivo
        _args params [["_cid", ""], ["_who", objNull]];
        private _calls = localNamespace getVariable ["ADVSEC_dspCalls", createHashMap];
        private _call = _calls getOrDefault [_cid, []];
        if (_call isEqualTo []) exitWith {};
        private _uid = _call select 1;
        private _vip = objNull;
        {
            if ((_x get "type") == "vip" && {((_x get "assigned") findIf {(_x select 0) == _uid}) >= 0}) exitWith {_vip = objectFromNetId (_x getOrDefault ["vipNet", ""])};
        } forEach (["vip"] call _ctrs);
        private _tgt = [[_uid] call ADVSEC_fnc_uidUnit, _vip] select (!isNull _vip && {alive _vip});
        _runs set [_cid, [_call select 3, serverTime, [], false, [netId _tgt, ""] select isNull _tgt, false]];
        localNamespace setVariable ["ADVSEC_qrfRuns", _runs];
        private _q = ["QRF", true] call _members;
        if (_q isNotEqualTo []) then {
            private _txt = format [("STR_ADVSEC_pmc_qrf_alert" call ADVSEC_fnc_L), _cid, _call select 2, mapGridPosition (_call select 3), ["qrfTarget", 8] call ADVSEC_fnc_setting,
                ["", format [("STR_ADVSEC_pmc_qrf_vip" call ADVSEC_fnc_L), mapGridPosition _vip]] select (!isNull _vip)];
            [_cid, format ["QRF · %1", _call select 2], _txt, _call select 3, true] remoteExecCall ["ADVSEC_fnc_dspNotify", _q];
        };
        ["qrfAlert", objNull, [_cid, count _q, mapGridPosition (_call select 3)]] call ADVSEC_fnc_logEvent;
    };
    case "accept": {
        if !([_caller, "dispatch"] call ADVSEC_fnc_perm) exitWith {};
        _args params [["_cid", ""]];
        private _r = _runs getOrDefault [_cid, []];
        if (_r isEqualTo [] || {_r select 3}) exitWith {};
        private _uid = getPlayerUID _caller;
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo [] || {(_e select 0) != "QRF"}) exitWith {};
        (_r select 2) pushBackUnique _uid;
        _e set [2, "Movilizado"];
        call _publish;
        (format [("STR_ADVSEC_pmc_qrf_go" call ADVSEC_fnc_L), _cid, ["qrfArriveRadius", 50] call ADVSEC_fnc_setting]) remoteExecCall ["hint", _caller];
    };
    case "qrfTick": {
        private _radius = ["qrfArriveRadius", 50] call ADVSEC_fnc_setting;
        private _target = 60 * (["qrfTarget", 8] call ADVSEC_fnc_setting);
        private _bonus = ["qrfBonus", 250] call ADVSEC_fnc_setting;
        private _dirty = false;
        {
            private _cid = _x;
            private _r = _runs get _cid;
            _r params ["_pos", "_t0", "_acc", "_done", "_tgtNet", ["_ign", false]];
            if (!_done) then {
                private _tgt = objectFromNetId _tgtNet;
                if (!isNull _tgt && {alive _tgt}) then {_pos = getPosATL _tgt; _r set [0, _pos]};
                private _here = (_acc apply {[_x] call ADVSEC_fnc_uidUnit}) select {!isNull _x && {alive _x} && {(_x distance2D _pos) <= _radius}};
                if (_here isNotEqualTo []) then {
                    _r set [3, true];
                    _dirty = true;
                    private _secs = round (serverTime - _t0);
                    private _fast = _secs <= _target;
                    {
                        private _uid = getPlayerUID _x;
                        private _s = _st getOrDefault [_uid, [0, 0, 0, 0]];
                        _s set [0, (_s select 0) + 1];
                        _s set [1, (_s select 1) + _secs];
                        if (_fast && {_bonus > 0}) then {
                            _s set [2, (_s select 2) + _bonus];
                            [_uid, name _x, _bonus, format [("STR_ADVSEC_pmc_qrf_bonus" call ADVSEC_fnc_L), _cid]] call ADVSEC_fnc_pmcPay;
                        };
                        _st set [_uid, _s];
                        (format [("STR_ADVSEC_pmc_qrf_arrived" call ADVSEC_fnc_L), _cid, [_secs, "MM:SS"] call BIS_fnc_secondsToString, [("STR_ADVSEC_pmc_qrf_late" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_qrf_ontime" call ADVSEC_fnc_L)] select _fast]) remoteExecCall ["hint", _x];
                    } forEach _here;
                    {
                        if ((_x get "pos") distance2D _pos <= ((_x get "radius") + 1000) || {((_x get "assigned") findIf {(_x select 0) in _acc}) >= 0}) then {
                            ((_x get "metrics") get "responses") pushBack [_cid, _secs];
                        };
                    } forEach (["qrf"] call _ctrs);
                    ["qrfArrive", _here select 0, [_cid, _secs, _here apply {name _x}]] call ADVSEC_fnc_logEvent;
                } else {
                    // Nadie de la QRF aceptó en 3 minutos: queda como respuesta fallida
                    if (!_ign && {_acc isEqualTo []} && {serverTime - _t0 > 180}) then {
                        _r set [5, true];
                        private _q = ["QRF", true] call _members;
                        {
                            ((_x get "metrics") get "responses") pushBack [_cid, -1];
                        } forEach ((["qrf"] call _ctrs) select {(_x get "pos") distance2D _pos <= ((_x get "radius") + 1000)});
                        {
                            [_x, "qrfIgnored", _cid] call ADVSEC_fnc_heatAdd;
                            private _s = _st getOrDefault [getPlayerUID _x, [0, 0, 0, 0]];
                            _s set [3, (_s param [3, 0]) + 1];
                            _st set [getPlayerUID _x, _s];
                        } forEach _q;
                        ["qrfIgnored", objNull, [_cid, _q apply {name _x}]] call ADVSEC_fnc_logEvent;
                        _dirty = true;
                    };
                };
            };
            if (serverTime - _t0 > 1800) then {_runs deleteAt _cid};
        } forEach (keys _runs);
        if (_dirty) then {
            // Quien llegó vuelve a quedar disponible
            {
                private _uid = _x;
                private _e = _db get _uid;
                if ((_e select 2) == "Movilizado" && {((values _runs) findIf {!(_x select 3) && {_uid in (_x select 2)}}) < 0}) then {_e set [2, "Disponible"]};
            } forEach (keys _db);
            call _publish;
            ["qrf"] call ADVSEC_fnc_dbDirty;
            ["contracts"] call ADVSEC_fnc_dbDirty;
        };
        // Vehículos de la QRF (variable ADVSEC_qrfVehicle): abiertos solo con una respuesta en marcha
        private _open = ((values _runs) findIf {!(_x select 3) && {(_x select 2) isNotEqualTo []}}) >= 0;
        {
            if (_x getVariable ["ADVSEC_qrfVehicle", false] && {alive _x}) then {
                private _want = [2, 0] select (_open || {(crew _x) isNotEqualTo []});
                if (locked _x != _want) then {[_x, _want] remoteExecCall ["lock", _x]};
            };
        } forEach vehicles;
        // Protección cercana: posición en vivo del VIP para la escolta asignada y la QRF, cada 6 s
        private _n = (localNamespace getVariable ["ADVSEC_cpTick", 0]) + 1;
        localNamespace setVariable ["ADVSEC_cpTick", _n];
        if (_n % 2 == 0) then {
            {
                private _vip = objectFromNetId (_x getOrDefault ["vipNet", ""]);
                if (!isNull _vip) then {
                    private _to = ((_x get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x && {(([_x] call ADVSEC_fnc_cellRole) select 0) in ["CP", "QRF"]}};
                    _to = _to + (["QRF", true] call _members);
                    _to = _to arrayIntersect _to;
                    if (_to isNotEqualTo []) then {[_x get "id", [[], getPosATL _vip] select (alive _vip), name _vip] remoteExecCall ["ADVSEC_fnc_cellVipMark", _to]};
                };
            } forEach (["vip"] call _ctrs);
        };
    };
};
