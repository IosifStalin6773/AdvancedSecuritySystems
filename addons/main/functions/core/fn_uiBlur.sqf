// ["on"|"off"] — desenfoque del fondo mientras haya diálogos del mod abiertos
params ["_mode"];
if (((["uiBlur", 1] call ADVSEC_fnc_cfg)) isNotEqualTo 1) exitWith {};
private _n = ((missionNamespace getVariable ["ADVSEC_blurN", 0]) + ([-1, 1] select (_mode == "on"))) max 0;
ADVSEC_blurN = _n;
private _pp = missionNamespace getVariable ["ADVSEC_blurPP", -1];
if (_n > 0 && {_pp < 0}) then {
    _pp = ppEffectCreate ["DynamicBlur", 476];
    _pp ppEffectEnable true;
    _pp ppEffectAdjust [2.2];
    _pp ppEffectCommit 0.3;
    ADVSEC_blurPP = _pp;
};
if (_n == 0 && {_pp >= 0}) then {
    ppEffectDestroy _pp;
    ADVSEC_blurPP = -1;
};
