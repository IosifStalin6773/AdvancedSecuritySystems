// Módulo Eden "Caja de equipo PM" (1.24): los objetos sincronizados (o una caja creada en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Box_NATO_Equip_F", "ADVSEC_fnc_crateInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_crateInit} forEach _objs;
