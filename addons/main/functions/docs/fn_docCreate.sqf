/*
    [unidad, tipo, datos (HashMap o [[clave, valor], ...]), darItem, silencioso, único] -> id
    único: elimina los demás documentos del mismo tipo (documentación automática).
    Solo el servidor emite: desde un cliente se pide a ADVSEC_fnc_docServer, que valida la autoridad.
*/
params ["_unit", "_type", ["_data", []], ["_giveItem", true], ["_silent", false], ["_unique", false]];
if (isNull _unit) exitWith {""};
if (!isServer) exitWith {["issue", player, [_unit, _type, _data, objNull]] remoteExecCall ["ADVSEC_fnc_docServer", 2]; ""};

private _cfg = [_type] call ADVSEC_fnc_docTypeCfg;
if (!isClass _cfg) exitWith {diag_log format ["[ADVSEC] Tipo de documento desconocido: %1", _type]; ""};
if (_data isEqualType []) then {_data = createHashMapFromArray _data};

private _doc = createHashMapFromArray [["clearance", getNumber (_cfg >> "clearance")], ["keys", []], ["expires", ""]];
_doc merge [_data, true];
if ((_doc getOrDefault ["number", ""]) isEqualTo "") then {_doc set ["number", (100000 + floor random 900000) toFixed 0]};
if ((_doc get "clearance") isEqualType "") then {_doc set ["clearance", parseNumber (_doc get "clearance")]};
if ((_doc get "keys") isEqualType "") then {_doc set ["keys", (_doc get "keys") splitString ", "]};

private _id = format ["%1-%2", _type, _doc get "number"];
_doc set ["type", _type];
_doc set ["id", _id];

private _db = [] call ADVSEC_fnc_docStore;
private _key = [_unit] call ADVSEC_fnc_docKey;
private _docs = _db getOrDefault [_key, []];
if (_unique) then {_docs = _docs select {(_x get "type") != _type || {(_x get "id") isEqualTo _id}}};
private _idx = _docs findIf {(_x get "id") isEqualTo _id};
private _isNew = _idx < 0;
if (_isNew) then {_docs pushBack _doc} else {(_docs select _idx) merge [_doc, true]};
_db set [_key, _docs];
if (isPlayer _unit) then {["docs"] call ADVSEC_fnc_dbDirty};
[_unit] call ADVSEC_fnc_docPublish;

private _item = [getText (_cfg >> "item"), ""] select !_giveItem;
private _msg = ["", format ["Has recibido: %1", getText (_cfg >> "displayName")]] select (_isNew && {!_silent});
[_unit, _item, _msg] remoteExecCall ["ADVSEC_fnc_docGive", _unit];
_id
