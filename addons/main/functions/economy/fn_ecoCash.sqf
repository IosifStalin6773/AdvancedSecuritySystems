// [unidad] (servidor) -> efectivo. En Antistasi manda la variable moneyX del jugador; si no, la cuenta del servidor.
params ["_unit"];
if ([] call ADVSEC_fnc_ecoA3A) exitWith {
    private _m = _unit getVariable ["moneyX", 0];
    [0, _m] select (_m isEqualType 0)
};
([getPlayerUID _unit, name _unit] call ADVSEC_fnc_ecoAcc) select 0
