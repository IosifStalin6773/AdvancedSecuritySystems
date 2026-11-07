// [vehículo] — registro policial de un vehículo por compartimentos
params ["_veh"];
if (isNull _veh) exitWith {};
ADVSEC_vehTarget = _veh;
["veh", format [("STR_ADVSEC_search" call ADVSEC_fnc_L), getText (configOf _veh >> "displayName")], [
    [("STR_ADVSEC_glovebox" call ADVSEC_fnc_L), {["scan", player, [ADVSEC_vehTarget, "glove"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    [("STR_ADVSEC_under_seats" call ADVSEC_fnc_L), {["scan", player, [ADVSEC_vehTarget, "seats"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    [("STR_ADVSEC_trunk" call ADVSEC_fnc_L), {["scan", player, [ADVSEC_vehTarget, "trunk"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    [("STR_ADVSEC_underside_wheel" call ADVSEC_fnc_L), {["scan", player, [ADVSEC_vehTarget, "stash"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    [("STR_ADVSEC_seize" call ADVSEC_fnc_L), {
        params ["_d"];
        if (isNil "_d" || {count _d < 3}) exitWith {hint ("STR_ADVSEC_select_an_object" call ADVSEC_fnc_L)};
        ["seize", player, [ADVSEC_vehTarget] + _d] remoteExecCall ["ADVSEC_fnc_vehServer", 2];
    }]
], {["list", player, [ADVSEC_vehTarget]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}] call ADVSEC_fnc_panelOpen;
