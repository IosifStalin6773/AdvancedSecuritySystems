params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _buildings = (synchronizedObjects _logic) select {[_x] call ADVSEC_fnc_hasDoors};
if (_buildings isEqualTo []) then {_buildings = [[_logic] call ADVSEC_fnc_findBuilding] - [objNull]};
if (_buildings isEqualTo []) exitWith {diag_log ("STR_ADVSEC_advsec_lock_without_a_building" call ADVSEC_fnc_L)};

private _req = [_logic] call ADVSEC_fnc_moduleReq;
{[_x, _logic getVariable ["Doors", "all"], _req, _logic getVariable ["Locked", true]] call ADVSEC_fnc_doorInit} forEach _buildings;
