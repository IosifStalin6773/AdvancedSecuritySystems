// [agente] — saca a los detenidos del vehículo más cercano
params ["_cop"];
private _veh = ((nearestObjects [_cop, ["Car", "Tank", "Air", "Ship"], 10]) select {alive _x}) param [0, objNull];
if (isNull _veh) exitWith {hint "No hay ningún vehículo cerca."};
private _out = (crew _veh) select {[_x] call ADVSEC_fnc_isRestrained};
if (_out isEqualTo []) exitWith {hint "No hay detenidos en el vehículo."};
{[_x, "unload"] call ADVSEC_fnc_policeLocal} forEach _out;
hint format ["Detenidos fuera: %1", (_out apply {name _x}) joinString ", "];
