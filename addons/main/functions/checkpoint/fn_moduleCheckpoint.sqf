// Módulo de Eden (isGlobal = 0: solo servidor). Una sola inicialización por módulo; borrar el módulo retira el control.
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer} || {!isNull (_logic getVariable ["ADVSEC_cpAnchor", objNull])}) exitWith {};
private _officers = (synchronizedObjects _logic) select {_x isKindOf "CAManBase"};
{_officers append units group _x} forEach +_officers;
_officers = _officers arrayIntersect _officers;
private _anchor = [getPosATL _logic, _logic getVariable ["Name", "Control PM"], _logic getVariable ["Radius", 20], _officers, objNull, getDir _logic, [0, _logic getVariable ["SpawnUnits", 2]] select (_officers isEqualTo [])] call ADVSEC_fnc_checkpointInit;
_logic setVariable ["ADVSEC_cpAnchor", _anchor];
_logic addEventHandler ["Deleted", {
    params ["_l"];
    private _a = _l getVariable ["ADVSEC_cpAnchor", objNull];
    if (!isNull _a) then {[_a] call ADVSEC_fnc_cpCleanup};
}];
