// [tienda] — catálogo: comprar (1 o 5) y vender
params ["_shop"];
if !([] call ADVSEC_fnc_ecoOn) exitWith {hint "La economía de ADVSEC está desactivada en esta misión."};
ADVSEC_ecoShop = _shop;
["shop", (_shop getVariable ["ADVSEC_shop", ["Tienda"]]) select 0, [
    ["Comprar", {params ["_i"]; if (!isNil "_i") then {["buy", player, [ADVSEC_ecoShop, _i, 1]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}}],
    ["Comprar × 5", {params ["_i"]; if (!isNil "_i") then {["buy", player, [ADVSEC_ecoShop, _i, 5]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}}],
    ["Vender uno", {params ["_i"]; if (!isNil "_i") then {["sell", player, [ADVSEC_ecoShop, _i]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}}],
    ["Mi cartera", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoOpen}}]
], {["shop", player, [ADVSEC_ecoShop]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}] call ADVSEC_fnc_panelOpen;
