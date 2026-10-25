/*
    [tipo, actor, datos] (servidor): registro de eventos persistente (base de auditoría, evidencias y reputación)
    Cada entrada: [fechaUTC, serverTime, tipo, nombre, SteamID, posición, datos]. Se guardan las últimas ADVSEC_logMax.
*/
params ["_type", ["_actor", objNull], ["_data", []]];
if (!isServer) exitWith {};
private _log = localNamespace getVariable ["ADVSEC_eventLog", nil];
if (isNil "_log") then {
    if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
    _log = +(profileNamespace getVariable [ADVSEC_repKey + "_log", []]);
    localNamespace setVariable ["ADVSEC_eventLog", _log];
};
private _e = [call ADVSEC_fnc_now, round serverTime, _type, ["", name _actor] select !isNull _actor, ["", getPlayerUID _actor] select !isNull _actor, ["", mapGridPosition _actor] select !isNull _actor, _data];
_log pushBack _e;
private _max = (["logMax", 5000] call ADVSEC_fnc_cfg);
if (count _log > _max) then {_log deleteRange [0, count _log - _max]};
["log"] call ADVSEC_fnc_dbDirty;
diag_log (["[ADVSEC] EVENTO"] + _e);
