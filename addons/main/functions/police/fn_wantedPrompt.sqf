params [["_unit", objNull]];
[("STR_ADVSEC_declare_wanted" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_person" call ADVSEC_fnc_L), _unit, "players"],
    [("STR_ADVSEC_reason" call ADVSEC_fnc_L), ""],
    [("STR_ADVSEC_danger_level" call ADVSEC_fnc_L), "Media", ["Baja", "Media", "Alta", "Extrema"]]
], {
    params ["_v"];
    _v params ["_u", "_reason", "_level"];
    if (isNull _u) exitWith {hint ("STR_ADVSEC_select_a_person" call ADVSEC_fnc_L)};
    ["add", player, [getPlayerUID _u, name _u, _reason, _level]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
