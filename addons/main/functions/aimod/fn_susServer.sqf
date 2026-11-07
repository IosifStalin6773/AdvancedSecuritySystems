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
        (_e select 9) pushBack [call ADVSEC_fnc_now, ("STR_ADVSEC_system" call ADVSEC_fnc_L), format [("STR_ADVSEC_end_of_suspension_ranks_restored" call ADVSEC_fnc_L), _why]];
        ["players"] call ADVSEC_fnc_dbDirty;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {[_u] call ADVSEC_fnc_pdbApply; ("STR_ADVSEC_your_suspension_has_ended_ranks" call ADVSEC_fnc_L) remoteExecCall ["hint", _u]};
    };
    ["susp"] call ADVSEC_fnc_dbDirty;
    ["suspendEnd", _caller, [_uid, _why]] call ADVSEC_fnc_logEvent;
};
switch (_action) do {
    case "check": {
        private _now = call ADVSEC_fnc_utcMin;
        {if (_now >= (_y select 0)) then {[_x, ("STR_ADVSEC_term_served" call ADVSEC_fnc_L)] call _restore}} forEach +_db;
    };
    case "suspend": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_suspend_officers" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_u", objNull], ["_h", 24], ["_why", ""]];
        if (isNull _u || {_u isEqualTo _caller}) exitWith {("STR_ADVSEC_choose_another_officer" call ADVSEC_fnc_L) call _say};
        private _uid = getPlayerUID _u;
        if (_uid in _db) exitWith {("STR_ADVSEC_that_officer_is_already_suspended" call ADVSEC_fnc_L) call _say};
        private _e = _pdb getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {("STR_ADVSEC_not_found_in_the_player" call ADVSEC_fnc_L) call _say};
        _h = (_h max 1) min 720;
        _db set [_uid, [(call ADVSEC_fnc_utcMin) + _h * 60, [_e select 5, _e select 6, _e select 7], _why select [0, 200], name _caller, name _u, call ADVSEC_fnc_now, _h]];
        _e set [5, 0]; _e set [6, 0]; _e set [7, 0];
        (_e select 9) pushBack [call ADVSEC_fnc_now, name _caller, format [("STR_ADVSEC_suspended_h" call ADVSEC_fnc_L), _h, _why]];
        ["players"] call ADVSEC_fnc_dbDirty;
        ["susp"] call ADVSEC_fnc_dbDirty;
        [_u] call ADVSEC_fnc_pdbApply;
        (format [("STR_ADVSEC_you_have_been_suspended_by" call ADVSEC_fnc_L), _h, _why]) remoteExecCall ["hint", _u];
        ["suspend", _caller, [name _u, _uid, _h, _why]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_susServer;
    };
    case "lift": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_lift_suspensions" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        [_args param [0, ""], format [("STR_ADVSEC_lifted_by" call ADVSEC_fnc_L), name _caller]] call _restore;
        ["list", _caller] call ADVSEC_fnc_susServer;
    };
    case "list": {
        if !([_caller, "suspend"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_view_suspensions" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _now = call ADVSEC_fnc_utcMin;
        private _rows = [];
        {
            _y params ["_until", "", "_why", "_by", "_name", "_date", "_h"];
            private _left = (_until - _now) max 0;
            _rows pushBack [format [("STR_ADVSEC_h_min_left" call ADVSEC_fnc_L), _name, floor (_left / 60), round (_left mod 60)], _x,
                format [("STR_ADVSEC_steamid_suspended_by_h_reason" call ADVSEC_fnc_L), _name call ADVSEC_fnc_repEsc, _x, _date, _by call ADVSEC_fnc_repEsc, _h, _why call ADVSEC_fnc_repEsc], [1, 0.6, 0.3, 1], ""];
        } forEach _db;
        ["susp", format [("STR_ADVSEC_suspended_officers" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
