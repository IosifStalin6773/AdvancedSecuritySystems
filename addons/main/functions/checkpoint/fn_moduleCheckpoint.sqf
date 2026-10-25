params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
private _officers = (synchronizedObjects _logic) select {_x isKindOf "CAManBase"};
{_officers append units group _x} forEach +_officers;
_officers = _officers arrayIntersect _officers;
[getPosATL _logic, _logic getVariable ["Name", "Control PM"], _logic getVariable ["Radius", 20], _officers, objNull, getDir _logic, [0, _logic getVariable ["SpawnUnits", 2]] select (_officers isEqualTo [])] call ADVSEC_fnc_checkpointInit;
