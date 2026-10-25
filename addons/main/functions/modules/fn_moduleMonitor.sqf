params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _req = [_logic] call ADVSEC_fnc_moduleReq;
if (_objs isEqualTo []) exitWith {[_logic, "Land_FlatTV_01_F", "ADVSEC_fnc_monitorInit", [_logic getVariable ["Network", "default"], _req]] call ADVSEC_fnc_moduleSpawn};
{[_x, _logic getVariable ["Network", "default"], _req] call ADVSEC_fnc_monitorInit} forEach _objs;
