// [SteamID] (servidor): suma el tiempo de la sesión al desconectarse
params ["_uid"];
private _since = localNamespace getVariable ["ADVSEC_pdbSince", createHashMap];
private _t = _since getOrDefault [_uid, -1];
if (_t < 0) exitWith {};
_since deleteAt _uid;
private _e = ([] call ADVSEC_fnc_pdbDB) getOrDefault [_uid, []];
if (_e isEqualTo []) exitWith {};
_e set [10, (_e select 10) + round ((diag_tickTime - _t) / 60)];
_e set [3, call ADVSEC_fnc_now];
["players"] call ADVSEC_fnc_dbDirty;
