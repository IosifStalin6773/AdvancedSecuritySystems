params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _args = [_logic getVariable ["Name", "Concesionario"], _logic getVariable ["Items", ""]];
if (_objs isEqualTo []) exitWith {[_logic, "Land_CampingTable_F", "ADVSEC_fnc_dealerInit", _args] call ADVSEC_fnc_moduleSpawn};
{([_x] + _args) call ADVSEC_fnc_dealerInit} forEach _objs;
