// [unidad, efectivo] (servidor): fija el efectivo y lo publica en el jugador (moneyX: lo lee el HUD THUD)
params ["_unit", "_v"];
_v = round (_v max 0);
if !([] call ADVSEC_fnc_ecoA3A) then {
    ([getPlayerUID _unit, name _unit] call ADVSEC_fnc_ecoAcc) set [0, _v];
    ["eco"] call ADVSEC_fnc_dbDirty;
};
// En Antistasi el cambio pasa por su función, que avisa a su HUD y a sus estadísticas
if ([] call ADVSEC_fnc_ecoA3A && {isPlayer _unit}) exitWith {
    private _old = _unit getVariable ["moneyX", 0];
    if !(_old isEqualType 0) then {_old = 0};
    if (_v != _old) then {[_v - _old] remoteExecCall ["A3A_fnc_resourcesPlayer", _unit]};
};
_unit setVariable ["moneyX", _v, true];
private _var = ["moneyVar", ""] call ADVSEC_fnc_setting;
if (_var isNotEqualTo "" && {_var != "moneyX"}) then {_unit setVariable [_var, _v, true]};
