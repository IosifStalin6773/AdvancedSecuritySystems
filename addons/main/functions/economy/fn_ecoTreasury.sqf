// [variación, concepto] (servidor) -> nuevo saldo de la tesorería de la PM
params ["_d", ["_why", ""]];
[] call ADVSEC_fnc_ecoDB;
// Antistasi con a3aTreasury: la tesorería es el dinero de la facción rebelde
if ([] call ADVSEC_fnc_ecoA3A && {(["a3aTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1} && {!isNil "server"}) exitWith {
    private _t = round ((server getVariable ["resourcesFIA", 0]) + _d);
    if (_d != 0) then {[0, round _d] spawn A3A_fnc_resourcesFIA};
    localNamespace setVariable ["ADVSEC_treasury", _t];
    _t
};
private _t = round ((localNamespace getVariable ["ADVSEC_treasury", 0]) + _d);
localNamespace setVariable ["ADVSEC_treasury", _t];
if (_d != 0) then {
    private _h = localNamespace getVariable ["ADVSEC_treasuryHist", []];
    _h pushBack [call ADVSEC_fnc_now, _why, round _d];
    if (count _h > 60) then {_h deleteRange [0, count _h - 60]};
};
["eco"] call ADVSEC_fnc_dbDirty;
[] call ADVSEC_fnc_ecoPublish;
_t
