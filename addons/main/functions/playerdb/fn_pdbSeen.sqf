// [SteamID, nombre, nuevaConexión] (servidor): da de alta o actualiza la ficha del jugador -> ficha
params ["_uid", "_name", ["_visit", false]];
if (!isServer || {_uid in ["", "__SERVER__"]} || {(_uid select [0, 2]) == "HC"}) exitWith {[]};
private _db = [] call ADVSEC_fnc_pdbDB;
private _now = call ADVSEC_fnc_now;
private _e = _db getOrDefault [_uid, []];
if (_e isEqualTo []) then {
    _e = [_name, [], _now, _now, 0, -1, -1, 0, "", [], 0];
    _db set [_uid, _e];
};
if (_name isNotEqualTo "" && {(_e select 0) isNotEqualTo _name}) then {
    (_e select 1) pushBackUnique (_e select 0);
    _e set [0, _name];
};
_e set [3, _now];
if (_visit) then {
    _e set [4, (_e select 4) + 1];
    (localNamespace getVariable ["ADVSEC_pdbSince", createHashMap]) set [_uid, diag_tickTime];
};
["players"] call ADVSEC_fnc_dbDirty;
_e
