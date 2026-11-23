// Módulo Eden "Hospital" (1.24): los objetos sincronizados (o una casa de evacuación creada en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_Medevac_house_V1_F", "ADVSEC_fnc_hospInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_hospInit} forEach _objs;
