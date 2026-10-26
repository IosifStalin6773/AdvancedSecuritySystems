// Módulo Eden «Radar fijo»: sincronizado con un objeto lo convierte en radar; solo, crea la cámara (speedCamClass)
params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _args = [_logic getVariable ["Name", "Radar"], _logic getVariable ["Limit", 0], _logic getVariable ["Range", 40], _logic getVariable ["FineBase", 0], _logic getVariable ["FinePer", 0]];
if (_objs isEqualTo []) exitWith {[_logic, [] call ADVSEC_fnc_speedCamClass, "ADVSEC_fnc_speedCamInit", _args] call ADVSEC_fnc_moduleSpawn};
{([_x] + _args) call ADVSEC_fnc_speedCamInit} forEach _objs;
