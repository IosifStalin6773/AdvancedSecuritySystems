params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_Laptop_unfolded_F", "ADVSEC_fnc_dutyTermInit", ["Fichaje"]] call ADVSEC_fnc_moduleSpawn};
{[_x] call ADVSEC_fnc_dutyTermInit} forEach _objs;
