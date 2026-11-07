// [agente] — saca a los detenidos del vehículo más cercano
params ["_cop"];
private _veh = ((nearestObjects [_cop, ["Car", "Tank", "Air", "Ship"], 10]) select {alive _x}) param [0, objNull];
if (isNull _veh) exitWith {hint ("STR_ADVSEC_there_is_no_vehicle_nearby" call ADVSEC_fnc_L)};
private _out = (crew _veh) select {[_x] call ADVSEC_fnc_isRestrained};
if (_out isEqualTo []) exitWith {hint ("STR_ADVSEC_there_are_no_detainees_in" call ADVSEC_fnc_L)};
{[_x, "unload"] call ADVSEC_fnc_policeLocal} forEach _out;
hint format [("STR_ADVSEC_detainees_out" call ADVSEC_fnc_L), (_out apply {name _x}) joinString ", "];
