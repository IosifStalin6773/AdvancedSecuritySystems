params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) then {_objs = [_logic]};
{[_x, _logic getVariable ["Name", "Calabozo PM"], _logic getVariable ["Radius", 6]] call ADVSEC_fnc_jailInit} forEach _objs;
