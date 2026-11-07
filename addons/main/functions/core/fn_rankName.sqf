params ["_unit"];
private _g = _unit getVariable ["ADVSEC_globalRank", ""];
if (_g isNotEqualTo "") exitWith {_g};
switch (rank _unit) do {
    case "PRIVATE": {("STR_ADVSEC_private" call ADVSEC_fnc_L)};
    case "CORPORAL": {("STR_ADVSEC_corporal" call ADVSEC_fnc_L)};
    case "SERGEANT": {("STR_ADVSEC_sergeant" call ADVSEC_fnc_L)};
    case "LIEUTENANT": {("STR_ADVSEC_lieutenant" call ADVSEC_fnc_L)};
    case "CAPTAIN": {("STR_ADVSEC_captain" call ADVSEC_fnc_L)};
    case "MAJOR": {("STR_ADVSEC_major" call ADVSEC_fnc_L)};
    case "COLONEL": {("STR_ADVSEC_colonel" call ADVSEC_fnc_L)};
    default {""};
}
