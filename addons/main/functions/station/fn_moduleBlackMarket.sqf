// Módulo Eden "Mercado negro en pueblos" (1.24): casas con vendedor y material robado alrededor del módulo
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
private _items = _logic getVariable ["Items", ""];
if (_items isEqualType "" && {_items isNotEqualTo ""}) then {
    _items = ((_items splitString ",") apply {(_x splitString ":") apply {_x trim [" ", 0]}}) select {count _x == 2} apply {[_x select 0, parseNumber (_x select 1)]};
} else {_items = []};
["start", objNull, [getPosATL _logic, _logic getVariable ["Radius", 3000], _logic getVariable ["Count", 3], _items]] call ADVSEC_fnc_bmServer;
