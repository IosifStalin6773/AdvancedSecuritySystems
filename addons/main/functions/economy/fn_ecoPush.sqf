// [unidad] (servidor): crea la cuenta si hace falta y publica el efectivo y el banco en el jugador
params ["_unit"];
if (isNull _unit || {getPlayerUID _unit isEqualTo ""}) exitWith {};
private _a = [getPlayerUID _unit, name _unit] call ADVSEC_fnc_ecoAcc;
if !([] call ADVSEC_fnc_ecoA3A) then {[_unit, _a select 0] call ADVSEC_fnc_ecoSetCash};
_unit setVariable ["ADVSEC_bank", _a select 1, true];
