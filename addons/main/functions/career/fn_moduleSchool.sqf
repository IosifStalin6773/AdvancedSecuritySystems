// Módulo Eden "Escuela PM" (1.24): convierte los objetos sincronizados (o un atril creado en su sitio) en el punto de la escuela
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_Noticeboard_F", "ADVSEC_fnc_schoolInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_schoolInit} forEach _objs;
