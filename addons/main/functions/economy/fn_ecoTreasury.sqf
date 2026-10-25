// [variación, concepto] (servidor) -> nuevo saldo de la tesorería de la PM
params ["_d", ["_why", ""]];
[] call ADVSEC_fnc_ecoDB;
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
