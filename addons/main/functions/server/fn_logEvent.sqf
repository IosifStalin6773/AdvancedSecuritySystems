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
// Cámara corporal: todo lo que hace un agente con la cámara encendida queda en su grabación
if (!isNull _actor && {_actor getVariable ["ADVSEC_bodycam", false]}) then {
    private _bdb = [] call ADVSEC_fnc_bodyDB;
    private _b = _bdb getOrDefault [getPlayerUID _actor, [name _actor, []]];
    (_b select 1) pushBack [_e select 0, _type, _e select 5, _data];
    if (count (_b select 1) > 150) then {(_b select 1) deleteAt 0};
    _bdb set [getPlayerUID _actor, _b];
    ["bodycam"] call ADVSEC_fnc_dbDirty;
};
// Discord: eventos de discordEvents[]
if (_type in (["discordEvents", []] call ADVSEC_fnc_setting)) then {
    [_type, format ["%1%2", ["", (_e select 3) + ": "] select ((_e select 3) isNotEqualTo ""), ((if (_data isEqualType []) then {_data} else {[_data]}) apply {[str _x, _x] select (_x isEqualType "")}) joinString " · "],
        [13672496, 15158332] select (_type in ["jail", "wantedAdd", "panic", "plateStolen"])] spawn {
        params ["_t", "_d", "_c"];
        private _titles = createHashMapFromArray [["jail", "Detención"], ["wantedAdd", "Busca y captura"], ["bail", "Fianza pagada"], ["suspend", "Suspensión de AA.II."], ["alertLevel", "Nivel de alerta"], ["panic", "Botón de pánico"], ["plateStolen", "Vehículo robado"]];
        [_titles getOrDefault [_t, _t], _d, _c] call ADVSEC_fnc_discord;
    };
};
