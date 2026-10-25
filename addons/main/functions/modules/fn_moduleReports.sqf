params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _req = [_logic] call ADVSEC_fnc_moduleReq;
if (_objs isEqualTo []) exitWith {[_logic, "Land_Laptop_unfolded_F", "ADVSEC_fnc_repTerminalInit", [_logic getVariable ["Dept", "PM"], _req]] call ADVSEC_fnc_moduleSpawn};
{[_x, _logic getVariable ["Dept", "PM"], _req] call ADVSEC_fnc_repTerminalInit} forEach _objs;
