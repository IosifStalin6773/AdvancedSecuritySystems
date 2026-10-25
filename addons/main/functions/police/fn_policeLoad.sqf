// [unidad] — mete al detenido en el vehículo con plazas libres más cercano
params ["_unit"];
private _veh = ((nearestObjects [_unit, ["Car", "Tank", "Air", "Ship"], 12]) select {alive _x && {(_x emptyPositions "Cargo") > 0}}) param [0, objNull];
if (isNull _veh) exitWith {hint "No hay vehículos con plazas libres cerca."};
if ((attachedTo _unit) isEqualTo player) then {[_unit, false] call ADVSEC_fnc_escort};
[_unit, "load", [_veh]] call ADVSEC_fnc_policeLocal;
hint format ["%1 introducido en %2.", name _unit, getText (configOf _veh >> "displayName")];
