params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _h = _logic getVariable ["Hidden", 0];
private _args = [_logic getVariable ["Name", "Tienda"], _logic getVariable ["Items", ""], _h isEqualTo true || {_h isEqualTo 1}];
if (_objs isEqualTo []) exitWith {[_logic, "Land_CampingTable_F", "ADVSEC_fnc_shopInit", _args] call ADVSEC_fnc_moduleSpawn};
{([_x] + _args) call ADVSEC_fnc_shopInit} forEach _objs;
