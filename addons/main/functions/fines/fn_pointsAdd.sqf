// [unidad, puntos, motivo] (servidor) — puntos de carnet (1.22). Con pointsLicenseType y puntos <= 0 retira esa licencia.
params ["_u", "_delta", ["_why", ""]];
if (!isServer || {isNull _u} || {(["pointsStart", 0] call ADVSEC_fnc_setting) <= 0}) exitWith {};
private _db = ["points", "ADVSEC_pointsDB"] call ADVSEC_fnc_mapDB;
private _uid = getPlayerUID _u;
if (_uid isEqualTo "") exitWith {};
private _p = (_db getOrDefault [_uid, ["pointsStart", 12] call ADVSEC_fnc_setting]) + _delta;
_p = _p min (["pointsStart", 12] call ADVSEC_fnc_setting);
_db set [_uid, _p];
["points"] call ADVSEC_fnc_dbDirty;
["points", objNull, [name _u, _uid, _delta, _p, _why]] call ADVSEC_fnc_logEvent;
(format [("STR_ADVSEC_m_points_now" call ADVSEC_fnc_L), _delta, _p]) remoteExecCall ["hint", _u];
private _lic = ["pointsLicenseType", ""] call ADVSEC_fnc_setting;
if (_p <= 0 && {_lic isNotEqualTo ""}) then {
    private _ids = ((([] call ADVSEC_fnc_docStore) getOrDefault [[_u] call ADVSEC_fnc_docKey, []]) select {(_x get "type") == _lic}) apply {_x get "id"};
    {[_u, _x] call ADVSEC_fnc_docRevoke} forEach _ids;
    if (_ids isNotEqualTo []) then {(format [("STR_ADVSEC_m_points_lost" call ADVSEC_fnc_L), name _u]) remoteExecCall ["hint", _u]};
};
