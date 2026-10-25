params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _sync = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _emitter = (_sync select {!([_x] call ADVSEC_fnc_hasDoors)}) param [0, objNull];
private _building = (_sync select {[_x] call ADVSEC_fnc_hasDoors}) param [0, objNull];

private _spec = _logic getVariable ["Doors", ""];
if (_spec isNotEqualTo "" && {isNull _building}) then {_building = [_logic] call ADVSEC_fnc_findBuilding};
private _doors = if (isNull _building || {_spec isEqualTo ""}) then {[]} else {([_building, _spec] call ADVSEC_fnc_doorList) apply {[_building, _x]}};

private _args = [
    _logic getVariable ["Radius", 15],
    [_logic] call ADVSEC_fnc_moduleReq,
    _doors,
    _logic getVariable ["Armed", true],
    _logic getVariable ["Name", "Alarma"],
    _logic getVariable ["Zone", ""]
];
// Sin emisor sincronizado: altavoces en la posición del módulo (como en Zeus)
if (isNull _emitter) exitWith {[_logic, "Land_Loudspeakers_F", "ADVSEC_fnc_alarmInit", _args] call ADVSEC_fnc_moduleSpawn};
([_emitter] + _args) call ADVSEC_fnc_alarmInit;
