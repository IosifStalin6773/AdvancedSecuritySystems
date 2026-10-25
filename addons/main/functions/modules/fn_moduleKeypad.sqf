params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _sync = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _devices = _sync select {!([_x] call ADVSEC_fnc_hasDoors)};
private _building = (_sync select {[_x] call ADVSEC_fnc_hasDoors}) param [0, objNull];
private _req = [_logic] call ADVSEC_fnc_moduleReq;
if (_devices isEqualTo []) exitWith {
    private _b = [_building, [_logic] call ADVSEC_fnc_findBuilding] select (isNull _building);
    private _doors = if (isNull _b) then {[]} else {([_b, _logic getVariable ["Doors", "all"]] call ADVSEC_fnc_doorList) apply {[_b, _x]}};
    [_logic, "Land_Tablet_01_F", "ADVSEC_fnc_keypadInit", [_logic getVariable ["Pin", "1234"], _doors, _logic getVariable ["Zone", ""], _req, _logic getVariable ["Label", "INTRODUZCA PIN"]]] call ADVSEC_fnc_moduleSpawn;
};
{
    private _b = if (isNull _building) then {[_x] call ADVSEC_fnc_findBuilding} else {_building};
    if (isNull _b) then {diag_log format ["[ADVSEC] Keypad %1: no hay edificio con puertas a menos de 50 m", _x]};
    private _doors = if (isNull _b) then {[]} else {([_b, _logic getVariable ["Doors", "all"]] call ADVSEC_fnc_doorList) apply {[_b, _x]}};
    [_x, _logic getVariable ["Pin", "1234"], _doors, _logic getVariable ["Zone", ""], _req, _logic getVariable ["Label", "INTRODUZCA PIN"]] call ADVSEC_fnc_keypadInit;
} forEach _devices;
