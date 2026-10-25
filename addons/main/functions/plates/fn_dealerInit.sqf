// [objeto, nombre, vehículos "clase:precio, ..." o [[clase, precio], ...]] — concesionario (init del objeto, todas las máquinas)
params ["_obj", ["_name", "Concesionario"], ["_items", ""]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (_items isEqualType "") then {
    _items = ((_items splitString ",") apply {(_x splitString ":") apply {_x trim [" ", 0]}}) select {count _x == 2} apply {[_x select 0, parseNumber (_x select 1)]};
};
if (_items isEqualTo []) then {_items = ["dealerVehicles", []] call ADVSEC_fnc_setting};
_items = _items select {_x isEqualType [] && {count _x == 2} && {isClass (configFile >> "CfgVehicles" >> (_x select 0))} && {(_x select 1) > 0}};
_obj setVariable ["ADVSEC_dealer", [_name, _items]];
if (isServer) then {[_obj, "dealer", _name] call ADVSEC_fnc_register};
[_obj, "advsec_dealer", format ["%1: comprar vehículo", _name], ADVSEC_icCar,
    {[_target] call ADVSEC_fnc_dealerOpen},
    {[] call ADVSEC_fnc_ecoOn},
    "main", [], 4
] call ADVSEC_fnc_addInteraction;
