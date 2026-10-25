/*
    [acción, llamador, args] (servidor) — suspensiones de AA.II.
    "list" · "suspend" [unidad, horas, motivo] · "lift" [SteamID] · "check" (bucle: restaura las vencidas)
    Retira rangos PM/AA.II./global durante X horas (reloj real) y los devuelve solos.
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (_action != "check" && {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _db = localNamespace getVariable "ADVSEC_susDB";
if (isNil "_db") then {
    _db = createHashMap;
    {_db set [_x select 0, +(_x select 1)]} forEach (profileNamespace getVariable [ADVSEC_repKey + "_susp", []]);
    localNamespace setVariable ["ADVSEC_susDB", _db];
};
private _pdb = [] call ADVSEC_fnc_pdbDB;
private _say = {_this remoteExecCall ["hint", _caller]};
private _restore = {
    params ["_uid", "_why"];
    private _s = _db deleteAt _uid;
    if (isNil "_s") exitWith {};
    private _e = _pdb getOrDefault [_uid, []];
    if (_e isNotEqualTo []) then {
        (_s select 1) params ["_pm", "_ai", "_g"];
        _e set [5, _pm]; _e set [6, _ai]; _e set [7, _g];
        (_e select 9) pushBack [call ADVSEC_fnc_now, "Sistema", format ["Fin de suspensión (%1): rangos restaurados", _why]];
        ["players"] call ADVSEC_fnc_dbDirty;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {[_u] call ADVSEC_fnc_pdbApply; "Tu suspensión ha terminado: rangos restaurados." remoteExecCall ["hint", _u]};
    };
    ["susp"] call ADVSEC_fnc_dbDirty;
    ["suspendEnd", _caller, [_uid, _why]] call ADVSEC_fnc_logEvent;
};
switch (_action) do {
    case "check": {
        private _now = call ADVSEC_fnc_utcMin;
        {if (_now >= (_y select 0)) then {[_x, "plazo cumplido"] call _restore}} forEach +_db;
    };
    case "suspend": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, "suspender agentes"] call ADVSEC_fnc_deny};
        _args params [["_u", objNull], ["_h", 24], ["_why", ""]];
        if (isNull _u || {_u isEqualTo _caller}) exitWith {"Elige otro agente." call _say};
        private _uid = getPlayerUID _u;
        if (_uid in _db) exitWith {"Ese agente ya está suspendido." call _say};
        private _e = _pdb getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {"No figura en la base de datos de jugadores." call _say};
        _h = (_h max 1) min 720;
        _db set [_uid, [(call ADVSEC_fnc_utcMin) + _h * 60, [_e select 5, _e select 6, _e select 7], _why select [0, 200], name _caller, name _u, call ADVSEC_fnc_now, _h]];
        _e set [5, 0]; _e set [6, 0]; _e set [7, 0];
        (_e select 9) pushBack [call ADVSEC_fnc_now, name _caller, format ["Suspendido %1 h: %2", _h, _why]];
        ["players"] call ADVSEC_fnc_dbDirty;
        ["susp"] call ADVSEC_fnc_dbDirty;
        [_u] call ADVSEC_fnc_pdbApply;
        (format ["Has sido SUSPENDIDO por AA.II. durante %1 h. Motivo: %2", _h, _why]) remoteExecCall ["hint", _u];
        ["suspend", _caller, [name _u, _uid, _h, _why]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_susServer;
    };
    case "lift": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, "levantar suspensiones"] call ADVSEC_fnc_deny};
        [_args param [0, ""], format ["levantada por %1", name _caller]] call _restore;
        ["list", _caller] call ADVSEC_fnc_susServer;
    };
    case "list": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, "ver suspensiones"] call ADVSEC_fnc_deny};
        private _now = call ADVSEC_fnc_utcMin;
        private _rows = [];
        {
            _y params ["_until", "", "_why", "_by", "_name", "_date", "_h"];
            private _left = (_until - _now) max 0;
            _rows pushBack [format ["%1 · quedan %2 h %3 min", _name, floor (_left / 60), round (_left mod 60)], _x,
                format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Suspendido: %3 por %4 (%5 h)<br/>Motivo: %6", _name call ADVSEC_fnc_repEsc, _x, _date, _by call ADVSEC_fnc_repEsc, _h, _why call ADVSEC_fnc_repEsc], [1, 0.6, 0.3, 1], ""];
        } forEach _db;
        ["susp", format ["Agentes suspendidos: %1", count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
