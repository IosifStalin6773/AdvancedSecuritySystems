// [unidad] — mete al detenido en el vehículo con plazas libres más cercano
params ["_unit"];
private _veh = ((nearestObjects [_unit, ["Car", "Tank", "Air", "Ship"], 12]) select {alive _x && {(_x emptyPositions ("STR_ADVSEC_charge" call ADVSEC_fnc_L)) > 0}}) param [0, objNull];
if (isNull _veh) exitWith {hint ("STR_ADVSEC_there_are_no_vehicles_with" call ADVSEC_fnc_L)};
if ((attachedTo _unit) isEqualTo player) then {[_unit, false] call ADVSEC_fnc_escort};
[_unit, "load", [_veh]] call ADVSEC_fnc_policeLocal;
hint format [("STR_ADVSEC_put_into" call ADVSEC_fnc_L), name _unit, getText (configOf _veh >> "displayName")];
