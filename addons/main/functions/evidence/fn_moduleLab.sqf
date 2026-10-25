params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) exitWith {[_logic, "Land_CampingTable_F", "ADVSEC_fnc_labInit", [_logic getVariable ["Name", "Laboratorio forense"]]] call ADVSEC_fnc_moduleSpawn};
{[_x, _logic getVariable ["Name", "Laboratorio forense"]] call ADVSEC_fnc_labInit} forEach _objs;
