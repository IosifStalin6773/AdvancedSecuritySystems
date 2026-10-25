// [concesionario] — catálogo de vehículos
params ["_d"];
ADVSEC_dealerCur = _d;
["dealer", (_d getVariable ["ADVSEC_dealer", ["Concesionario"]]) select 0, [
    ["Comprar", {params ["_i"]; if (!isNil "_i") then {["buy", player, [ADVSEC_dealerCur, _i]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    ["Mis vehículos", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_plateMine}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["dealer", player, [ADVSEC_dealerCur]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}] call ADVSEC_fnc_panelOpen;
