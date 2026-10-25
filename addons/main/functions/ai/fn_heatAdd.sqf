/*
    [agente (unidad o [SteamID, nombre]), regla, detalle] (servidor)
    Suma los puntos de la regla (ADVSEC_Settings >> Rules) a la sospecha del agente. Al superar el umbral abre un F-AI-01 automático.
*/
params ["_who", "_rule", ["_detail", ""]];
if (!isServer) exitWith {};
private _pts = [["Rules", _rule], 0] call ADVSEC_fnc_setting;
if (isNil "_pts" || {!(_pts isEqualType 0)} || {_pts <= 0}) exitWith {};
private _uid = ""; private _name = "";
if (_who isEqualType objNull) then {
    if (isNull _who || {!isPlayer _who} || {[_who] call ADVSEC_fnc_isZeus}) exitWith {};
    _uid = getPlayerUID _who; _name = name _who;
} else {_who params ["_uid0", "_name0"]; _uid = _uid0; _name = _name0};
if (_uid isEqualTo "") exitWith {};

private _db = [] call ADVSEC_fnc_heatDB;
private _e = [_uid] call ADVSEC_fnc_heatGet;
_e set [0, (_e select 0) + _pts];
_e set [3, _name];
(_e select 2) pushBack [call ADVSEC_fnc_now, format ["%1: %2", _rule, _detail], _pts];
if (count (_e select 2) > 50) then {(_e select 2) deleteAt 0};
_db set [_uid, _e];
["heat"] call ADVSEC_fnc_dbDirty;
["heat", objNull, [_uid, _name, _rule, _pts, _detail]] call ADVSEC_fnc_logEvent;

private _thr = ["heatThreshold", 30] call ADVSEC_fnc_setting;
if ((_e select 0) >= _thr && {(_e select 4) isEqualTo ""}) then {
    private _lines = (_e select 2) apply {format ["- %1 · %2 (+%3)", _x select 0, _x select 1, _x select 2]};
    private _id = ["FAI01",
        format ["Expediente automático: índice de sospecha de %1", _name],
        [format ["%1 [%2]", _name, _uid]],
        format ["Apertura automática por el sistema al alcanzar %1 puntos de sospecha (umbral %2).%3%3Eventos registrados:%3%4", round (_e select 0), _thr, endl, _lines joinString endl],
        "Grave", true
    ] call ADVSEC_fnc_repSystem;
    _e set [4, _id];
    {
        if ([_x, "AI"] call ADVSEC_fnc_repAccess) then {
            (format ["AA.II.: expediente automático %1 abierto sobre %2.", _id, _name]) remoteExecCall ["systemChat", _x];
        };
    } forEach allPlayers;
};
