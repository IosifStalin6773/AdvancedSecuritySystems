// Módulo Eden "Teléfono de comisaría" (1.24): los objetos sincronizados (o un teléfono creado en su sitio)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_MobilePhone_old_F", "ADVSEC_fnc_phoneInit", []] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_phoneInit} forEach _objs;
