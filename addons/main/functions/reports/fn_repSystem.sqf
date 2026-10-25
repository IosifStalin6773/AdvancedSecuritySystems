// [tipo, título, sujetos, cuerpo, gravedad, confidencial] -> id (servidor). Registra un informe firmado por el sistema.
params ["_type", "_title", ["_subjects", []], ["_body", ""], ["_gravity", "Grave"], ["_conf", true]];
if (!isServer) exitWith {""};
if (isNil "ADVSEC_repDB") then {[] call ADVSEC_fnc_repLoad};
private _cfg = [_type] call ADVSEC_fnc_repTypeCfg;
if (!isClass _cfg) exitWith {""};
private _pad = {params ["_n", "_len"]; private _s = str _n; while {count _s < _len} do {_s = "0" + _s}; _s};
private _year = systemTimeUTC select 0;
private _code = getText (_cfg >> "code");
private _seqKey = format ["%1/%2", _code, _year];
private _n = (ADVSEC_repSeq getOrDefault [_seqKey, 0]) + 1;
ADVSEC_repSeq set [_seqKey, _n];
private _id = format ["%1/%2/%3", _code, _year, [_n, 4] call _pad];
private _ts = call ADVSEC_fnc_now;
ADVSEC_repDB set [_id, createHashMapFromArray [
    ["id", _id], ["type", _type], ["dept", getText (_cfg >> "dept")], ["code", _code], ["typeName", getText (_cfg >> "displayName")],
    ["title", _title], ["subjects", _subjects], ["body", _body], ["gravity", _gravity], ["confidential", _conf],
    ["place", worldName], ["witnesses", ""], ["sanction", "Ninguna"], ["status", "Registrado"],
    ["author", "Sistema ADVSEC"], ["authorUid", ""], ["created", _ts], ["updated", _ts],
    ["mission", format ["%1 (%2)", briefingName, worldName]], ["notes", []], ["access", []]
]];
[] call ADVSEC_fnc_repSave;
["report", objNull, [_id, _subjects]] call ADVSEC_fnc_logEvent;
_id
