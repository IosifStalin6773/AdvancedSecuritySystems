params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _name = _logic getVariable ["Name", ("STR_ADVSEC_pmc_armory" call ADVSEC_fnc_L)];
if (_objs isEqualTo []) exitWith {[_logic, "B_supplyCrate_F", "ADVSEC_fnc_armInit", [_name]] call ADVSEC_fnc_moduleSpawn};
{[_x, _name] call ADVSEC_fnc_armInit} forEach _objs;
