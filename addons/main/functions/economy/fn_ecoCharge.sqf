/*
    [unidad, importe, concepto, aTesorería] (servidor) -> bool
    Cobra primero del efectivo y el resto del banco. Si aTesorería, el importe pasa a la tesorería de la PM.
*/
params ["_unit", "_amt", "_why", ["_toTreasury", false]];
_amt = round _amt;
if (_amt <= 0) exitWith {true};
private _a = [getPlayerUID _unit, name _unit] call ADVSEC_fnc_ecoAcc;
private _cash = [_unit] call ADVSEC_fnc_ecoCash;
if ((_cash + (_a select 1)) < _amt) exitWith {false};
private _fromCash = _cash min _amt;
[_unit, _cash - _fromCash] call ADVSEC_fnc_ecoSetCash;
_a set [1, (_a select 1) - (_amt - _fromCash)];
_unit setVariable ["ADVSEC_bank", _a select 1, true];
[_a, _why, -_amt] call ADVSEC_fnc_ecoHist;
if (_toTreasury) then {[_amt, format ["%1 · %2", _why, name _unit]] call ADVSEC_fnc_ecoTreasury};
true
