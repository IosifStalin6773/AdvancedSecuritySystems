// Módulo Eden "Terminal de permisos" (1.24): los objetos sincronizados (o un terminal creado en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_DataTerminal_01_F", "ADVSEC_fnc_rnrInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_rnrInit} forEach _objs;
