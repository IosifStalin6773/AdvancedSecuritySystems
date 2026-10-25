// ["list"|"get"|"create"|"note"|"status", llamador, datos] (servidor). Todas las comprobaciones de acceso se hacen aquí.
params ["_action", "_caller", ["_data", []]];
if (!isServer || {isNull _caller}) exitWith {};
if (isMultiplayer && {remoteExecutedOwner != 0} && {remoteExecutedOwner != owner _caller}) exitWith {};
if (isNil "ADVSEC_repDB") then {[] call ADVSEC_fnc_repLoad};

private _canPM = [_caller, "PM"] call ADVSEC_fnc_repAccess;
private _canAI = [_caller, "AI"] call ADVSEC_fnc_repAccess;
private _canRead = {
    params ["_r"];
    if ((_r get "dept") == "AI" || {_r getOrDefault ["confidential", false]}) then {_canAI} else {_canPM || _canAI}
};
private _reply = {[_this select 0, _this select 1] remoteExecCall ["ADVSEC_fnc_repClient", _caller]};
private _pad = {params ["_n", "_len"]; private _s = str _n; while {count _s < _len} do {_s = "0" + _s}; _s};
private _now = {
    systemTimeUTC params ["_y", "_mo", "_d", "_h", "_mi"];
    format ["%1-%2-%3 %4:%5 UTC", _y, [_mo, 2] call _pad, [_d, 2] call _pad, [_h, 2] call _pad, [_mi, 2] call _pad]
};
private _get = {
    private _r = ADVSEC_repDB getOrDefault [_this, createHashMap];
    if (count _r == 0 || {!([_r] call _canRead)}) then {createHashMap} else {_r}
};

switch (_action) do {
    case "list": {
        _data params [["_dept", "ALL"], ["_filter", ""], ["_type", ""]];
        private _not = _type select [0, 1] == "!";
        private _tc = [_type, _type select [1]] select _not;
        _filter = toLower _filter;
        private _rows = [];
        {
            private _t = _y getOrDefault ["type", ""];
            if ([_y] call _canRead && {_dept == "ALL" || {(_y get "dept") == _dept}} && {_type isEqualTo "" || {(_t == _tc) != _not}}) then {
                private _hay = toLower ([_x, _y get "title", (_y get "subjects") joinString " ", _y get "author", _y get "authorUid", _y get "status", _y get "gravity"] joinString " ");
                if (_filter isEqualTo "" || {_hay find _filter > -1}) then {
                    _rows pushBack [_y get "created", _x, _y get "status", _y get "gravity", _y get "title"];
                };
            };
        } forEach ADVSEC_repDB;
        _rows sort false;
        ["list", _rows] call _reply;
    };
    case "stats": {
        private _closed = ["Resuelto", "Archivado"];
        private _n = [0, 0, 0, 0, 0];
        private _uid = getPlayerUID _caller;
        {
            if ([_y] call _canRead) then {
                private _t = _y getOrDefault ["type", ""];
                private _st = _y get "status";
                private _live = !(_st in _closed);
                if (_t == "FPM02" && _live) then {_n set [0, (_n select 0) + 1]};
                if (_t == "FPM02" && {_st == "Remitido a AA.II."}) then {_n set [1, (_n select 1) + 1]};
                if ((_y get "dept") == "PM" && {_t != "FPM02"}) then {_n set [2, (_n select 2) + 1]};
                if ((_y get "dept") == "AI" && _live) then {_n set [3, (_n select 3) + 1]};
                if ((_y get "authorUid") == _uid) then {_n set [4, (_n select 4) + 1]};
            };
        } forEach ADVSEC_repDB;
        ["stats", _n + [count (missionNamespace getVariable ["ADVSEC_jailDB", createHashMap])]] call _reply;
    };
    case "get": {
        private _r = _data call _get;
        if (count _r == 0) exitWith {["msg", "No tienes acceso a ese informe."] call _reply};
        if ((_r get "dept") == "AI" || {_r getOrDefault ["confidential", false]}) then {
            if (((_r getOrDefault ["subjects", []]) joinString " ") find getPlayerUID _caller > -1) then {
                [_caller, "ownCaseAccess", _r get "id"] call ADVSEC_fnc_heatAdd;
            };
            (_r get "access") pushBack [call _now, name _caller, getPlayerUID _caller];
            [] call ADVSEC_fnc_repSave;
        };
        ["report", [_r] call ADVSEC_fnc_docPairs] call _reply;
    };
    case "create": {
        private _r = createHashMapFromArray _data;
        private _cfg = [_r getOrDefault ["type", ""]] call ADVSEC_fnc_repTypeCfg;
        if (!isClass _cfg) exitWith {["msg", "Formato de informe no válido."] call _reply};
        private _dept = getText (_cfg >> "dept");
        if !([_canPM || _canAI, _canAI] select (_dept == "AI")) exitWith {["msg", "No tienes acreditación para ese formato."] call _reply};

        private _year = systemTimeUTC select 0;
        private _code = getText (_cfg >> "code");
        private _seqKey = format ["%1/%2", _code, _year];
        private _n = (ADVSEC_repSeq getOrDefault [_seqKey, 0]) + 1;
        ADVSEC_repSeq set [_seqKey, _n];
        private _id = format ["%1/%2/%3", _code, _year, [_n, 4] call _pad];

        private _ts = call _now;
        _r set ["id", _id];
        _r set ["dept", _dept];
        _r set ["code", _code];
        _r set ["typeName", getText (_cfg >> "displayName")];
        _r set ["status", "Registrado"];
        _r set ["author", name _caller];
        _r set ["authorUid", getPlayerUID _caller];
        _r set ["created", _ts];
        _r set ["updated", _ts];
        _r set ["mission", format ["%1 (%2)", briefingName, worldName]];
        _r set ["notes", []];
        _r set ["access", []];
        ADVSEC_repDB set [_id, _r];
        [] call ADVSEC_fnc_repSave;
        ["report", _caller, [_id, _r get "subjects"]] call ADVSEC_fnc_logEvent;
        ["created", _id] call _reply;
    };
    case "note": {
        _data params ["_id", "_text"];
        private _r = _id call _get;
        if (count _r == 0 || {_text isEqualTo ""}) exitWith {["msg", "No se pudo añadir la anotación."] call _reply};
        (_r get "notes") pushBack [call _now, name _caller, getPlayerUID _caller, _text];
        _r set ["updated", call _now];
        [] call ADVSEC_fnc_repSave;
        ["report", [_r] call ADVSEC_fnc_docPairs] call _reply;
    };
    case "status": {
        _data params ["_id", "_status", "_sanction", ["_reason", ""]];
        private _r = _id call _get;
        if (count _r == 0) exitWith {["msg", "No tienes acceso a ese informe."] call _reply};
        private _need = ["reportStatus", "caseClose"] select ((_r get "dept") == "AI" && {_status in ["Resuelto", "Archivado"]});
        if !([_caller, _need] call ADVSEC_fnc_perm) exitWith {["msg", "Tu rango no permite cambiar el estado de este informe."] call _reply};
        ["reportStatus", _caller, [_id, _status, _sanction]] call ADVSEC_fnc_logEvent;
        _r set ["status", _status];
        _r set ["sanction", _sanction];
        _r set ["updated", call _now];
        (_r get "notes") pushBack [call _now, name _caller, getPlayerUID _caller, format ["Estado: %1. Sanción: %2. %3", _status, _sanction, _reason]];
        [] call ADVSEC_fnc_repSave;
        ["report", [_r] call ADVSEC_fnc_docPairs] call _reply;
    };
};
