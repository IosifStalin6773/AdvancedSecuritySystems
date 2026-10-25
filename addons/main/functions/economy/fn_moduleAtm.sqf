params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _name = _logic getVariable ["Name", "Cajero automático"];
if (_objs isEqualTo []) exitWith {[_logic, "Land_Atm_01_F", "ADVSEC_fnc_atmInit", [_name]] call ADVSEC_fnc_moduleSpawn};
{[_x, _name] call ADVSEC_fnc_atmInit} forEach _objs;
