params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
if (_objs isEqualTo []) then {_objs = [_logic]};
{
    [_x, _logic getVariable ["Name", "CAM"], _logic getVariable ["Pitch", -20], _logic getVariable ["Yaw", 0], _logic getVariable ["Network", "default"]] call ADVSEC_fnc_cameraInit;
} forEach _objs;
