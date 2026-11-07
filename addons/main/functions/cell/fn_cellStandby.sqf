/*
    [uid] -> importe (servidor) Plus de guardia de la QRF para la nómina: qrfStandbyPay si el miembro estuvo
    Disponible al menos qrfStandbyMin (0-1) del tiempo de servicio desde la última nómina. Reinicia los contadores.
*/
params ["_uid"];
private _db = [] call ADVSEC_fnc_cellDB;
private _e = _db getOrDefault [_uid, []];
if (_e isEqualTo [] || {(_e select 0) != "QRF"}) exitWith {0};
private _r = (_e select 3) / ((_e select 4) max 1);
private _ok = (_e select 4) > 0 && {_r >= (["qrfStandbyMin", 0.8] call ADVSEC_fnc_setting)};
_e set [3, 0];
_e set [4, 0];
["cells"] call ADVSEC_fnc_dbDirty;
[0, ["qrfStandbyPay", 150] call ADVSEC_fnc_setting] select _ok
