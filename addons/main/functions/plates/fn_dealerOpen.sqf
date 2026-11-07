// [concesionario] — catálogo de vehículos
params ["_d"];
ADVSEC_dealerCur = _d;
["dealer", (_d getVariable ["ADVSEC_dealer", [("STR_ADVSEC_car_dealer" call ADVSEC_fnc_L)]]) select 0, [
    [("STR_ADVSEC_buy" call ADVSEC_fnc_L), {params ["_i"]; if (!isNil "_i") then {["buy", player, [ADVSEC_dealerCur, _i]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    [("STR_ADVSEC_my_vehicles" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_plateMine}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["dealer", player, [ADVSEC_dealerCur]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}] call ADVSEC_fnc_panelOpen;
