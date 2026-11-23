// Módulo Eden "Sirena de la base" (1.24): los objetos sincronizados (o un altavoz creado en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_Loudspeakers_F", "ADVSEC_fnc_sirenInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_sirenInit} forEach _objs;
