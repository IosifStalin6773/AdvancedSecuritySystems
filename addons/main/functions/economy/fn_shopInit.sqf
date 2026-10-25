/*
    [objeto, nombre, artículos] — tienda (init del objeto, todas las máquinas)
    artículos: "clase:precio, clase:precio" o [[clase, precio], ...]; vacío = shopItems de ADVSEC_Settings.
*/
params ["_obj", ["_name", "Tienda"], ["_items", ""]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (_items isEqualType "") then {
    _items = ((_items splitString ",") apply {(_x splitString ":") apply {_x trim [" ", 0]}}) select {count _x == 2} apply {[_x select 0, parseNumber (_x select 1)]};
};
if (_items isEqualTo []) then {_items = ["shopItems", []] call ADVSEC_fnc_setting};
_items = _items select {_x isEqualType [] && {count _x == 2} && {([_x select 0] call ADVSEC_fnc_ecoItemName) isNotEqualTo ""} && {(_x select 1) isEqualType 0} && {(_x select 1) > 0}};
_obj setVariable ["ADVSEC_shop", [_name, _items]];
if (isServer) then {[_obj, "shop", _name] call ADVSEC_fnc_register};
[_obj, "advsec_shop", format ["%1: comprar / vender", _name], ADVSEC_icSearch,
    {[_target] call ADVSEC_fnc_ecoShopOpen},
    {[] call ADVSEC_fnc_ecoOn},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
