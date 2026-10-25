// [vehículo] — registro policial de un vehículo por compartimentos
params ["_veh"];
if (isNull _veh) exitWith {};
ADVSEC_vehTarget = _veh;
["veh", format ["Registro · %1", getText (configOf _veh >> "displayName")], [
    ["Guantera", {["scan", player, [ADVSEC_vehTarget, "glove"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    ["Bajo asientos", {["scan", player, [ADVSEC_vehTarget, "seats"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    ["Maletero", {["scan", player, [ADVSEC_vehTarget, "trunk"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    ["Bajos / rueda", {["scan", player, [ADVSEC_vehTarget, "stash"]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}],
    ["Incautar", {
        params ["_d"];
        if (isNil "_d" || {count _d < 3}) exitWith {hint "Selecciona un objeto."};
        ["seize", player, [ADVSEC_vehTarget] + _d] remoteExecCall ["ADVSEC_fnc_vehServer", 2];
    }]
], {["list", player, [ADVSEC_vehTarget]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]}] call ADVSEC_fnc_panelOpen;
