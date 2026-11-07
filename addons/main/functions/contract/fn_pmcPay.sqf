// [SteamID, nombre, importe, concepto] (servidor): ingresa en el banco del jugador (exista o no conectado)
params ["_uid", "_name", "_amt", "_why"];
_amt = round _amt;
if (_amt == 0 || {_uid isEqualTo ""}) exitWith {};
private _a = [_uid, _name] call ADVSEC_fnc_ecoAcc;
_a set [1, (_a select 1) + _amt];
private _u = [_uid] call ADVSEC_fnc_uidUnit;
if (!isNull _u) then {
    _u setVariable ["ADVSEC_bank", _a select 1, true];
    (format [("STR_ADVSEC_pmc_paid_into_bank" call ADVSEC_fnc_L), _amt, ["currency", "€"] call ADVSEC_fnc_setting, _why]) remoteExecCall ["hintSilent", _u];
};
[_a, _why, _amt] call ADVSEC_fnc_ecoHist;
