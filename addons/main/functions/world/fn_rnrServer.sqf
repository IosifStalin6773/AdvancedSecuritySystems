/*
    [acción, llamador, args] (servidor, 1.24) — terminal de permisos
    "status" [terminal]: estado de la base · "leave" [terminal, destino]: vuelo de permiso (rnrMinutes sin poder fichar)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_obj", objNull]];
if !([_caller, _obj, 6] call ADVSEC_fnc_srvCaller) exitWith {};
switch (_action) do {
    case "status": {
        private _pm = (allPlayers - entities "HeadlessClient_F") select {[_x, "PMC"] call ADVSEC_fnc_repAccess};
        private _duty = _pm select {_x getVariable ["ADVSEC_onDuty", false]};
        private _leave = (allPlayers select {(_x getVariable ["ADVSEC_leaveUntil", 0]) > serverTime}) apply {format ["%1 (%2, %3 min)", name _x, _x getVariable ["ADVSEC_leaveDest", ""], ceil (((_x getVariable ["ADVSEC_leaveUntil", 0]) - serverTime) / 60)]};
        private _open = {(_x select 6) != "Cerrado"} count (values (localNamespace getVariable ["ADVSEC_dspCalls", createHashMap]));
        private _lvl = ["STR_ADVSEC_green_normal", "STR_ADVSEC_yellow_alarms_armed", "STR_ADVSEC_red_doors_locked_and_id"] param [missionNamespace getVariable ["ADVSEC_alertLevel", 0], "STR_ADVSEC_green_normal"];
        private _t = format [("STR_ADVSEC_rnr_status_txt" call ADVSEC_fnc_L),
            count _duty, count _pm, _open, count (missionNamespace getVariable ["ADVSEC_aiCalls", createHashMap]),
            round (missionNamespace getVariable ["ADVSEC_unrest", 0]), _lvl call ADVSEC_fnc_L,
            count (missionNamespace getVariable ["ADVSEC_jailDB", createHashMap]),
            [("STR_ADVSEC_no" call ADVSEC_fnc_L), ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select (missionNamespace getVariable ["ADVSEC_curfew", false]),
            [[] call ADVSEC_fnc_ecoTreasuryNow, "-"] select !([] call ADVSEC_fnc_ecoOn), ["currency", "€"] call ADVSEC_fnc_setting,
            [_leave joinString ", ", "-"] select (_leave isEqualTo [])];
        [_t, "STR_ADVSEC_rnr_status" call ADVSEC_fnc_L] remoteExecCall ["ADVSEC_fnc_carShow", _caller];
    };
    case "leave": {
        if ((_caller getVariable ["ADVSEC_leaveUntil", 0]) > serverTime) exitWith {};
        private _dest = (_args param [1, ""]) select [0, 40];
        private _min = ["rnrMinutes", 10] call ADVSEC_fnc_setting;
        if (_caller getVariable ["ADVSEC_onDuty", false]) then {[_caller, false] call ADVSEC_fnc_dutySet};
        _caller setVariable ["ADVSEC_leaveUntil", serverTime + 60 * _min, true];
        _caller setVariable ["ADVSEC_leaveDest", _dest, true];
        [_dest, _min] remoteExecCall ["ADVSEC_fnc_rnrFlight", _caller];
        ["leave", _caller, [_dest, _min]] call ADVSEC_fnc_logEvent;
    };
};
