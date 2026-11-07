/*
    [acción, llamador, args] (servidor) — Inteligencia y Compliance: terminal ciber
    "alert" [tipo, texto] (interno) · "alerts" · "ack" [índice] · "restore" · "logs" [filtro] · "timeline" [SteamID o nombre]
    "snap" (interno, capturas CCTV) · "cctv" · "replay" [índice] · "hack" [objeto]
    Alertas: [fecha, serverTime, tipo, nombre, SteamID, cuadrícula, texto, estado (Nueva/Revisada)] (persisten en _cyber)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (_action == "snap" && {call ADVSEC_fnc_fromClient}) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _al = localNamespace getVariable "ADVSEC_cyAlerts";
if (isNil "_al") then {
    _al = +(profileNamespace getVariable [ADVSEC_repKey + "_cyber", []]);
    localNamespace setVariable ["ADVSEC_cyAlerts", _al];
};
private _say = {if (!isNull _caller) then {_this remoteExecCall ["hint", _caller]}};
private _view = {
    if ([_caller, "cyberView"] call ADVSEC_fnc_perm || {(([_caller] call ADVSEC_fnc_cellRole) select 0) == "SEC"}) exitWith {true};
    [_caller, ("STR_ADVSEC_pmc_perm_cyber" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny;
    false
};
private _sec = {
    (allPlayers - entities "HeadlessClient_F") select {alive _x && {(([_x] call ADVSEC_fnc_cellRole) select 0) == "SEC" || {[_x, "cyberView"] call ADVSEC_fnc_perm && {_x getVariable ["ADVSEC_onDuty", false]}}}}
};
private _evRow = {
    // fila de panel a partir de una entrada del registro de eventos
    _this params ["_date", "_st", "_type", "_nm", "_uid", "_grid", "_data"];
    private _d = ((if (_data isEqualType []) then {_data} else {[_data]}) apply {[str _x, _x] select (_x isEqualType "")}) joinString " · ";
    [format ["%1 · %2 · %3 · %4", _date, _type, [_nm, "-"] select (_nm isEqualTo ""), _grid], _uid,
        format ["<t size='1.1'>%1</t><br/>%2 · %3 [%4]<br/>%5: %6<br/><br/>%7", _type, _date, _nm call ADVSEC_fnc_repEsc, _uid, ("STR_ADVSEC_grid" call ADVSEC_fnc_L), _grid, (_d select [0, 600]) call ADVSEC_fnc_repEsc],
        [], ""]
};
switch (_action) do {
    case "alert": {
        _args params [["_kind", "anomaly"], ["_text", ""]];
        private _e = [call ADVSEC_fnc_now, round serverTime, _kind, ["", name _caller] select !isNull _caller, ["", getPlayerUID _caller] select !isNull _caller, ["", mapGridPosition _caller] select !isNull _caller, _text select [0, 300], "Nueva"];
        _al pushBack _e;
        if (count _al > (["cyberAlertsMax", 300] call ADVSEC_fnc_setting)) then {_al deleteAt 0};
        ["cyber"] call ADVSEC_fnc_dbDirty;
        ["cyberAlert", _caller, [_kind, _text]] call ADVSEC_fnc_logEvent;
        if (!isNull _caller && {isPlayer _caller} && {[_caller, "PM"] call ADVSEC_fnc_repAccess}) then {[_caller, "cyberAnomaly", format ["%1: %2", _kind, _text]] call ADVSEC_fnc_heatAdd};
        private _to = call _sec;
        if (_to isNotEqualTo []) then {(format [("STR_ADVSEC_pmc_cy_alert_msg" call ADVSEC_fnc_L), (format ["STR_ADVSEC_pmc_cy_k_%1", _kind]) call ADVSEC_fnc_L, _text]) remoteExecCall ["systemChat", _to]};
    };
    case "alerts": {
        if !(call _view) exitWith {};
        private _rows = [];
        {
            _x params ["_date", "", "_kind", "_nm", "_uid", "_grid", "_text", "_state"];
            private _kl = (format ["STR_ADVSEC_pmc_cy_k_%1", _kind]) call ADVSEC_fnc_L;
            _rows pushBack [format ["%1 · %2 · %3 · %4", _date, _kl, [_nm, "-"] select (_nm isEqualTo ""), _state call ADVSEC_fnc_Lv], _forEachIndex,
                format ["<t size='1.1'>%1</t><br/>%2 · %3 [%4] · %5<br/><br/>%6", _kl, _date, _nm call ADVSEC_fnc_repEsc, _uid, _grid, _text call ADVSEC_fnc_repEsc],
                [[], [1, 0.45, 0.35, 1]] select (_state == "Nueva"), ""];
        } forEach _al;
        reverse _rows;
        private _down = missionNamespace getVariable ["ADVSEC_camDown", []];
        private _kps = (missionNamespace getVariable ["ADVSEC_kpHacked", []]) select {!isNull _x};
        ["cyber", format [("STR_ADVSEC_pmc_cy_info" call ADVSEC_fnc_L), {(_x select 7) == "Nueva"} count _al, count _al, [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), _down joinString ", "] select (_down isNotEqualTo []), count _kps], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "ack": {
        if !(call _view) exitWith {};
        _args params [["_i", -1]];
        if (_i < 0 || {_i >= count _al}) exitWith {};
        (_al select _i) set [7, "Revisada"];
        ["cyber"] call ADVSEC_fnc_dbDirty;
        ["cyberAck", _caller, [(_al select _i) select 2, (_al select _i) select 3]] call ADVSEC_fnc_logEvent;
        ["alerts", _caller] call ADVSEC_fnc_cyServer;
    };
    case "restore": {
        if !([_caller, "cyberManage"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_cybermanage" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _down = missionNamespace getVariable ["ADVSEC_camDown", []];
        private _kps = (missionNamespace getVariable ["ADVSEC_kpHacked", []]) select {!isNull _x};
        {
            _x setVariable ["ADVSEC_kpHackedT", nil, true];
            {_x params ["_b", "_i"]; [_b, _i, true] call ADVSEC_fnc_doorSet} forEach (_x getVariable ["ADVSEC_kpDoors", []]);
        } forEach _kps;
        missionNamespace setVariable ["ADVSEC_camDown", [], true];
        missionNamespace setVariable ["ADVSEC_kpHacked", [], true];
        ["cyberRestore", _caller, [_down, count _kps]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_pmc_cy_restored" call ADVSEC_fnc_L), count _down, count _kps]) call _say;
        ["alerts", _caller] call ADVSEC_fnc_cyServer;
    };
    case "logs": {
        if !(call _view) exitWith {};
        _args params [["_f", ""]];
        _f = toLower _f;
        private _log = localNamespace getVariable ["ADVSEC_eventLog", []];
        private _rows = [];
        for "_i" from (count _log - 1) to 0 step -1 do {
            private _e = _log select _i;
            if (_f isEqualTo "" || {(toLower str _e) find _f >= 0}) then {_rows pushBack (_e call _evRow)};
            if (count _rows >= 200) exitWith {};
        };
        ["cyber", format [("STR_ADVSEC_pmc_cy_logs_info" call ADVSEC_fnc_L), count _rows, [_f, "*"] select (_f isEqualTo "")], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "timeline": {
        // Cronología de una persona: dónde estuvo, qué puertas y teclados usó, qué material firmó, qué hizo (cruces de datos)
        if !(call _view) exitWith {};
        _args params [["_q", ""]];
        if (_q isEqualTo "") exitWith {};
        private _ql = toLower _q;
        private _log = localNamespace getVariable ["ADVSEC_eventLog", []];
        private _rows = [];
        {
            private _d = _x select 6;
        if !(_d isEqualType []) then {_d = [_d]};
        private _hit = (_x select 4) == _q || {toLower (_x select 3) == _ql} || {((_d select {_x isEqualType ""}) findIf {_x == _q || {toLower _x == _ql}}) >= 0};
            if (_hit) then {_rows pushBack (_x call _evRow)};
        } forEach _log;
        // capturas CCTV en las que aparece
        private _snaps = localNamespace getVariable ["ADVSEC_cySnaps", []];
        private _seen = {_x select 4 findIf {toLower (_x select 3) == _ql || {(_x select 4) == _q}} >= 0} count _snaps;
        if (count _rows > 250) then {_rows deleteRange [0, count _rows - 250]};
        reverse _rows;
        ["cyber", format [("STR_ADVSEC_pmc_cy_tl_info" call ADVSEC_fnc_L), _q call ADVSEC_fnc_repEsc, count _rows, _seen], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
        ["cyberQuery", _caller, [_q]] call ADVSEC_fnc_logEvent;
    };
    case "snap": {
        // Captura de lo que ven las cámaras (personas y vehículos en su radio) para la reconstrucción posterior
        private _range = ["cctvSnapRange", 60] call ADVSEC_fnc_setting;
        private _snaps = localNamespace getVariable ["ADVSEC_cySnaps", []];
        private _down = missionNamespace getVariable ["ADVSEC_camDown", []];
        private _all = [];
        {
            private _cam = _x;
            if (!isNull _cam && {alive _cam} && {!((_cam getVariable ["ADVSEC_camNet", "default"]) in _down)}) then {
                private _ents = (_cam nearEntities [["CAManBase", "LandVehicle", "Air", "Ship"], _range]) select {alive _x && {!(_x getVariable ["ADVSEC_cyGhost", false])}};
                if (_ents isNotEqualTo []) then {
                    _all pushBack [_cam getVariable ["ADVSEC_camName", "CCTV"], _cam getVariable ["ADVSEC_camNet", "default"], getPosASL _cam,
                        _ents apply {[typeOf _x, getPosASL _x, getDir _x, [getText (configOf _x >> "displayName"), name _x] select (_x isKindOf "CAManBase"), [getPlayerUID _x, ""] select !isPlayer _x]}];
                };
            };
        } forEach (missionNamespace getVariable ["ADVSEC_camRegistry", []]);
        {
            _snaps pushBack [call ADVSEC_fnc_now, round serverTime, _x select 0, _x select 1, _x select 3, _x select 2];
        } forEach _all;
        private _keep = ["cctvSnapKeep", 300] call ADVSEC_fnc_setting;
        if (count _snaps > _keep) then {_snaps deleteRange [0, count _snaps - _keep]};
        localNamespace setVariable ["ADVSEC_cySnaps", _snaps];
    };
    case "cctv": {
        if !(call _view) exitWith {};
        private _snaps = localNamespace getVariable ["ADVSEC_cySnaps", []];
        private _rows = [];
        {
            _x params ["_date", "_st", "_cam", "_net", "_ents"];
            private _who = (_ents select {(_x select 0) isKindOf "CAManBase"}) apply {_x select 3};
            _rows pushBack [format ["%1 · %2 (%3) · %4", _date, _cam, _net, count _ents], _forEachIndex,
                format [("STR_ADVSEC_pmc_cy_snap_detail" call ADVSEC_fnc_L), _cam call ADVSEC_fnc_repEsc, _net, _date, [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), (_who joinString ", ") call ADVSEC_fnc_repEsc] select (_who isNotEqualTo []),
                    ((_ents select {!((_x select 0) isKindOf "CAManBase")}) apply {_x select 3}) joinString ", "],
                [], ""];
        } forEach _snaps;
        reverse _rows;
        if (count _rows > 150) then {_rows resize 150};
        ["cyber", format [("STR_ADVSEC_pmc_cy_cctv_info" call ADVSEC_fnc_L), count _snaps, ["cctvSnapEvery", 20] call ADVSEC_fnc_setting], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "replay": {
        if !(call _view) exitWith {};
        _args params [["_i", -1]];
        private _snaps = localNamespace getVariable ["ADVSEC_cySnaps", []];
        if (_i < 0 || {_i >= count _snaps}) exitWith {};
        // la reconstrucción junta las capturas de esa cámara en ±1 minuto
        private _s = _snaps select _i;
        private _set = _snaps select {(_x select 2) == (_s select 2) && {abs ((_x select 1) - (_s select 1)) <= 60}};
        [_s, _set apply {_x select 4}] remoteExecCall ["ADVSEC_fnc_cyReplay", _caller];
        ["cctvReplay", _caller, [_s select 2, _s select 0]] call ADVSEC_fnc_logEvent;
    };
    case "hack": {
        _args params [["_o", objNull]];
        if (isNull _o || {(_caller distance _o) > 5}) exitWith {};
        if !("ADVSEC_HackKit" in (items _caller)) exitWith {("STR_ADVSEC_pmc_cy_need_kit" call ADVSEC_fnc_L) call _say};
        private _isKp = !isNil {_o getVariable "ADVSEC_kpDoors"};
        private _net = "";
        if (!_isKp) then {
            private _c = _o getVariable ["ADVSEC_cams", []];
            _net = switch (true) do {
                case (_c isEqualType ""): {_c};
                case (_c isEqualType [] && {_c isNotEqualTo []}): {(_c select 0) getVariable ["ADVSEC_camNet", "default"]};
                case (!isNil {_o getVariable "ADVSEC_camNet"}): {_o getVariable ["ADVSEC_camNet", "default"]};
                default {""};
            };
        };
        if (!_isKp && {_net isEqualTo ""}) exitWith {};
        private _p = ["hackChance", 0.5] call ADVSEC_fnc_setting;
        if ((([_caller] call ADVSEC_fnc_cellRole) select 0) == "SEC") then {_p = _p + 0.3};
        private _ok = random 1 < _p;
        private _where = [_net, _o getVariable ["ADVSEC_kpLabel", typeOf _o]] select _isKp;
        // El intento siempre deja rastro; si falla, además salta la alarma del teclado
        ["alert", _caller, [["hackFail", "hack"] select _ok, format [("STR_ADVSEC_pmc_cy_hack_text" call ADVSEC_fnc_L), [("STR_ADVSEC_pmc_cy_camnet" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_cy_keypad" call ADVSEC_fnc_L)] select _isKp, _where, mapGridPosition _o]]] call ADVSEC_fnc_cyServer;
        if (!_ok) exitWith {
            ("STR_ADVSEC_pmc_cy_hack_fail" call ADVSEC_fnc_L) call _say;
            if (_isKp) then {
                private _alarm = _o getVariable ["ADVSEC_kpAlarm", objNull];
                if (_alarm isEqualType "") then {
                    private _i = ADVSEC_alarms findIf {(_x getVariable ["ADVSEC_alarmZone", ""]) isEqualTo _alarm};
                    _alarm = if (_i > -1) then {ADVSEC_alarms select _i} else {objNull};
                };
                if (!isNull _alarm) then {[_alarm, "trigger", format [("STR_ADVSEC_keypad_forced_by" call ADVSEC_fnc_L), name _caller]] call ADVSEC_fnc_alarmSet};
            };
        };
        if (_isKp) then {
            {_x params ["_b", "_i"]; [_b, _i, false] call ADVSEC_fnc_doorSet} forEach (_o getVariable ["ADVSEC_kpDoors", []]);
            private _alarm = _o getVariable ["ADVSEC_kpAlarm", objNull];
            if (_alarm isEqualType objNull && {!isNull _alarm}) then {[_alarm, "disarm"] call ADVSEC_fnc_alarmSet};
            private _k = missionNamespace getVariable ["ADVSEC_kpHacked", []];
            _k pushBackUnique _o;
            missionNamespace setVariable ["ADVSEC_kpHacked", _k, true];
        } else {
            private _d = missionNamespace getVariable ["ADVSEC_camDown", []];
            _d pushBackUnique _net;
            missionNamespace setVariable ["ADVSEC_camDown", _d, true];
        };
        ("STR_ADVSEC_pmc_cy_hack_ok" call ADVSEC_fnc_L) call _say;
    };
};
