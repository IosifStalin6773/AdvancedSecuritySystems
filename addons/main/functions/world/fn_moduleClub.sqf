// Módulo Eden "Club de suboficiales" (1.24): los objetos sincronizados (o una barra creada en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_CampingTable_F", "ADVSEC_fnc_clubInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_clubInit} forEach _objs;
