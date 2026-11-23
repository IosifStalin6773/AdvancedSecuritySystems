/*
    [departamento, importe] (servidor) — presupuesto diario por departamento (1.22).
    Presupuesto = ajuste budget<DEP> (0 = sin límite). Se reinicia cada día (fecha UTC). Devuelve true si cabe.
*/
params ["_dep", "_amt"];
private _max = ["budget" + _dep, 0] call ADVSEC_fnc_setting;
if (_max <= 0) exitWith {true};
private _day = (call ADVSEC_fnc_now) select [0, 10];
private _b = localNamespace getVariable ["ADVSEC_budget_" + _dep, [_day, 0]];
if ((_b select 0) != _day) then {_b = [_day, 0]};
if ((_b select 1) + _amt > _max) exitWith {localNamespace setVariable ["ADVSEC_budget_" + _dep, _b]; false};
_b set [1, (_b select 1) + _amt];
localNamespace setVariable ["ADVSEC_budget_" + _dep, _b];
true
