params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _name = _logic getVariable ["Name", ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L)];
if (_objs isEqualTo []) exitWith {[_logic, "Land_Laptop_unfolded_F", "ADVSEC_fnc_ctrInit", [_name]] call ADVSEC_fnc_moduleSpawn};
{[_x, _name] call ADVSEC_fnc_ctrInit} forEach _objs;
