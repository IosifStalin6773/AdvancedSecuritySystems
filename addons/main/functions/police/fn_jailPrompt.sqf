params ["_unit"];
private _jails = (missionNamespace getVariable ["ADVSEC_jails", []]) select {!isNull _x};
if (_jails isEqualTo []) exitWith {hint ("STR_ADVSEC_there_is_no_detention_centre" call ADVSEC_fnc_L)};
_jails = [_jails, [], {_x distance _unit}, "ASCEND"] call BIS_fnc_sortBy;
[format [("STR_ADVSEC_arrest_2" call ADVSEC_fnc_L), name _unit], [
    [("STR_ADVSEC_time" call ADVSEC_fnc_L), 10, [[("STR_ADVSEC_5_minutes" call ADVSEC_fnc_L), 5], [("STR_ADVSEC_10_minutes" call ADVSEC_fnc_L), 10], [("STR_ADVSEC_15_minutes" call ADVSEC_fnc_L), 15], [("STR_ADVSEC_30_minutes" call ADVSEC_fnc_L), 30], [("STR_ADVSEC_1_hour" call ADVSEC_fnc_L), 60], [("STR_ADVSEC_2_hours" call ADVSEC_fnc_L), 120], [("STR_ADVSEC_until_further_notice_2" call ADVSEC_fnc_L), -1]]],
    [("STR_ADVSEC_reason" call ADVSEC_fnc_L), ""],
    [("STR_ADVSEC_facility" call ADVSEC_fnc_L), _jails select 0, _jails apply {[format ["%1 · %2 m", _x getVariable ["ADVSEC_jailName", ("STR_ADVSEC_cell" call ADVSEC_fnc_L)], round (_x distance _unit)], _x]}],
    [("STR_ADVSEC_generate_report_f_pm_04" call ADVSEC_fnc_L), true, "bool"]
], {
    params ["_v", "_unit"];
    ["jail", player, [_unit, _v#0, _v#1, _v#2, _v#3]] remoteExecCall ["ADVSEC_fnc_jailServer", 2];
}, _unit] call ADVSEC_fnc_zeusPrompt;
