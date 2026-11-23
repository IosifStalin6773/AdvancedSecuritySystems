// ["trainDone", llamador] (servidor, 1.24): fin de la instrucción guiada. Comprueba servicio e informe y da trainMerit una sola vez.
params ["_action", "_caller", ["_args", []]];
if (!isServer || {_action != "trainDone"}) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if (!(_caller getVariable ["ADVSEC_onDuty", false]) || {!(_caller getVariable ["ADVSEC_trainRep", false])}) exitWith {};
private _db = ["career", "ADVSEC_carDB"] call ADVSEC_fnc_mapDB;
private _uid = getPlayerUID _caller;
if (_db getOrDefault ["train:" + _uid, false]) exitWith {("STR_ADVSEC_tr_done_again" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
_db set ["train:" + _uid, true];
["career"] call ADVSEC_fnc_dbDirty;
// Mérito como acción del sistema (no la limita el permiso del recluta)
localNamespace setVariable ["ADVSEC_carSys", true];
["merit", _caller, [_uid, name _caller, ["trainMerit", 5] call ADVSEC_fnc_setting, "STR_ADVSEC_tr_title" call ADVSEC_fnc_L]] call ADVSEC_fnc_carServer;
("STR_ADVSEC_tr_done" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
