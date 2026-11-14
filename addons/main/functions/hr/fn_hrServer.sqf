/*
    [acción, llamador, args] (servidor) — recursos humanos de la PM/PMC (1.22)
    "cert" [uid, curso, tipo] · "certs" [uid] · "leave" [tipo, días] · "leaves" · "decide" [id, aprobar]
    "medLeave" [uid, nombre, días] · "rota" [día, nombres] · "rotaShow" · "eval" [uid, nombre]
    "tplSave" [nombre, tipo, cliente, pago, minutos] · "tplUse" [nombre] (Zeus) · "scenSave" [nombre, plantillas] · "scenLoad" [nombre] (Zeus)
    "pass" [nombre, minutos, zona] · "passCheck" [nombre] · "detect" [unidad] · "airlock" [nombre, lado] · "accGrant" [uid, zona] · "accMap" [uid]
    Base: localNamespace ADVSEC_hrDB (persistida con mapDB, clave "hr").
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = ["hr", "ADVSEC_hrDB"] call ADVSEC_fnc_mapDB;
private _say = {if (!isNull _caller) then {_this remoteExecCall ["hint", _caller]}};
private _hrOk = {[_caller, "hr"] call ADVSEC_fnc_perm};
private _seq = {private _n = (_db getOrDefault ["seq", 0]) + 1; _db set ["seq", _n]; _n};
private _find = {params ["_l", "_id"]; _l findIf {(_x select 0) == _id}};
private _notifyUid = {params ["_uid", "_txt"]; private _u = [_uid] call ADVSEC_fnc_uidUnit; if (!isNull _u) then {_txt remoteExecCall ["hint", _u]}};
switch (_action) do {
    case "cert": {
        _args params [["_uid", ""], ["_name", ""], ["_kind", "Curso"]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith {};
        private _k = "cert:" + _uid;
        private _l = +(_db getOrDefault [_k, []]);
        _l pushBack [_name select [0, 40], _kind, call ADVSEC_fnc_now];
        _db set [_k, _l];
        ["hr"] call ADVSEC_fnc_dbDirty;
        ["hrCert", _caller, [_uid, _name, _kind]] call ADVSEC_fnc_logEvent;
        [_uid, format [("STR_ADVSEC_hr_cert_you" call ADVSEC_fnc_L), _kind, _name]] call _notifyUid;
        (format [("STR_ADVSEC_hr_cert_done" call ADVSEC_fnc_L), _name]) call _say;
    };
    case "certs": {
        _args params [["_uid", ""]];
        if (_uid isEqualTo "") then {_uid = getPlayerUID _caller};
        if (_uid != getPlayerUID _caller && {!(call _hrOk)}) exitWith {};
        private _l = _db getOrDefault ["cert:" + _uid, []];
        private _txt = if (_l isEqualTo []) then {("STR_ADVSEC_hr_none" call ADVSEC_fnc_L)} else {(_l apply {format ["%1 · %2 · %3", _x select 1, _x select 0, _x select 2]}) joinString endl};
        _txt call _say;
    };
    case "leave": {
        _args params [["_type", "Vacaciones"], ["_days", 1]];
        private _id = call _seq;
        private _l = +(_db getOrDefault ["leave", []]);
        _l pushBack [_id, getPlayerUID _caller, name _caller, _type select [0, 30], (round _days) max 1 min 60, "Pendiente", call ADVSEC_fnc_now];
        _db set ["leave", _l];
        ["hr"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_hr_leave_sent" call ADVSEC_fnc_L), _id]) call _say;
    };
    case "leaves": {
        if !(call _hrOk) exitWith {};
        private _l = _db getOrDefault ["leave", []];
        private _pend = _l select {(_x select 5) == "Pendiente"};
        private _txt = if (_pend isEqualTo []) then {("STR_ADVSEC_hr_none" call ADVSEC_fnc_L)} else {(_pend apply {format ["#%1 · %2 · %3 · %4 días", _x select 0, _x select 2, _x select 3, _x select 4]}) joinString endl};
        _txt call _say;
    };
    case "decide": {
        _args params [["_id", -1], ["_ok", true]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _l = +(_db getOrDefault ["leave", []]);
        private _i = [_l, _id] call _find;
        if (_i < 0) exitWith {};
        private _e = _l select _i;
        if ((_e select 5) != "Pendiente") exitWith {};
        _e set [5, ["Denegada", "Aprobada"] select _ok];
        _l set [_i, _e];
        _db set ["leave", _l];
        ["hr"] call ADVSEC_fnc_dbDirty;
        ["hrLeave", _caller, [_id, _e select 5, _e select 3]] call ADVSEC_fnc_logEvent;
        [_e select 1, format [("STR_ADVSEC_hr_leave_result" call ADVSEC_fnc_L), _id, _e select 5]] call _notifyUid;
    };
    case "medLeave": {
        _args params [["_uid", ""], ["_name", ""], ["_days", 1]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "") exitWith {};
        private _l = +(_db getOrDefault ["leave", []]);
        _l pushBack [call _seq, _uid, _name select [0, 30], "Médica", (round _days) max 1 min 365, "Aprobada", call ADVSEC_fnc_now];
        _db set ["leave", _l];
        ["hr"] call ADVSEC_fnc_dbDirty;
        ["hrMedLeave", _caller, [_uid, _name, _days]] call ADVSEC_fnc_logEvent;
        [_uid, ("STR_ADVSEC_hr_medleave_you" call ADVSEC_fnc_L)] call _notifyUid;
        (format [("STR_ADVSEC_hr_medleave_done" call ADVSEC_fnc_L), _name]) call _say;
    };
    case "rota": {
        _args params [["_day", 0], ["_names", []]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _db set ["rota:" + str (_day max 0 min 6), +_names];
        ["hr"] call ADVSEC_fnc_dbDirty;
    };
    case "rotaShow": {
        private _days = ["STR_ADVSEC_hr_day_0", "STR_ADVSEC_hr_day_1", "STR_ADVSEC_hr_day_2", "STR_ADVSEC_hr_day_3", "STR_ADVSEC_hr_day_4", "STR_ADVSEC_hr_day_5", "STR_ADVSEC_hr_day_6"];
        private _txt = "";
        for "_d" from 0 to 6 do {
            private _n = _db getOrDefault ["rota:" + str _d, []];
            _txt = _txt + format ["%1: %2", (_days select _d) call ADVSEC_fnc_L, if (_n isEqualTo []) then {"-"} else {_n joinString ", "}] + endl;
        };
        _txt call _say;
    };
    case "eval": {
        _args params [["_uid", ""], ["_name", ""]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _n = 0;
        {if ((_x select 4) == _uid && {serverTime - (_x select 1) < 7 * 86400}) then {_n = _n + 1}} forEach (localNamespace getVariable ["ADVSEC_eventLog", []]);
        _db set ["eval:" + _uid, [call ADVSEC_fnc_now, _n]];
        ["hr"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_hr_eval_done" call ADVSEC_fnc_L), _name, _n]) call _say;
    };
    case "tplSave": {
        _args params [["_name", ""], ["_type", "escort"], ["_client", ""], ["_pay", 0], ["_min", 0]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_name isEqualTo "") exitWith {};
        _db set ["tpl:" + _name, [_type, _client, _pay max 0, _min max 0]];
        ["hr"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_hr_tpl_saved" call ADVSEC_fnc_L), _name]) call _say;
    };
    case "tplUse": {
        _args params [["_name", ""]];
        if !([_caller] call ADVSEC_fnc_isZeus) exitWith {[_caller, ("STR_ADVSEC_hr_zeus_only" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _t = _db getOrDefault ["tpl:" + _name, []];
        if (_t isEqualTo []) exitWith {("STR_ADVSEC_hr_tpl_none" call ADVSEC_fnc_L) call _say};
        _t params ["_type", "_client", "_pay", "_min"];
        ["offer", _caller, [_type, _client, getPosATL _caller, 150, _pay, _min, [], objNull, _name]] call ADVSEC_fnc_ctrServer;
    };
    case "scenSave": {
        _args params [["_name", ""], ["_tpls", []]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_name isEqualTo "") exitWith {};
        _db set ["scen:" + _name, +_tpls];
        ["hr"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_hr_scen_saved" call ADVSEC_fnc_L), _name]) call _say;
    };
    case "scenLoad": {
        _args params [["_name", ""]];
        if !([_caller] call ADVSEC_fnc_isZeus) exitWith {[_caller, ("STR_ADVSEC_hr_zeus_only" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        {["tplUse", _caller, [_x]] call ADVSEC_fnc_hrServer} forEach (_db getOrDefault ["scen:" + _name, []]);
    };
    case "pass": {
        _args params [["_name", ""], ["_min", 60], ["_zone", ""]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_name isEqualTo "") exitWith {};
        _db set ["pass:" + _name, [serverTime + (_min max 1) * 60, _zone select [0, 30]]];
        ["hr"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_hr_pass_done" call ADVSEC_fnc_L), _name, round (_min max 1)]) call _say;
    };
    case "passCheck": {
        _args params [["_name", ""]];
        private _p = _db getOrDefault ["pass:" + _name, []];
        private _txt = if (_p isEqualTo []) then {("STR_ADVSEC_hr_pass_none" call ADVSEC_fnc_L)} else {if ((_p select 0) > serverTime) then {format [("STR_ADVSEC_hr_pass_valid" call ADVSEC_fnc_L), _p select 1, round (((_p select 0) - serverTime) / 60)]} else {("STR_ADVSEC_hr_pass_expired" call ADVSEC_fnc_L)}};
        _txt call _say;
    };
    case "detect": {
        // Detector de metales: avisa si un agente no PM lleva armas. El control de la puerta lo decide quien lo use.
        _args params [["_u", objNull]];
        if (isNull _u) exitWith {};
        private _armed = (primaryWeapon _u) isNotEqualTo "" || {(handgunWeapon _u) isNotEqualTo ""};
        if (_armed && {!([_u, "PM"] call ADVSEC_fnc_repAccess)}) then {
            ["detectorHit", _u, [mapGridPosition _u]] call ADVSEC_fnc_logEvent;
            ("STR_ADVSEC_hr_detect_hit" call ADVSEC_fnc_L) call _say;
        } else {("STR_ADVSEC_hr_detect_ok" call ADVSEC_fnc_L) call _say};
    };
    case "airlock": {
        // Esclusa: solo una puerta a la vez. Lleva el estado; cada puerta debe consultarlo antes de abrir.
        _args params [["_name", ""], ["_side", "in"]];
        private _st = _db getOrDefault ["air:" + _name, ""];
        if (_side isEqualTo "") then {_db set ["air:" + _name, ""]} else {
            if (_st isNotEqualTo "" && {_st isNotEqualTo _side}) exitWith {("STR_ADVSEC_hr_airlock_busy" call ADVSEC_fnc_L) call _say};
            _db set ["air:" + _name, _side];
        };
        ["hr"] call ADVSEC_fnc_dbDirty;
    };
    case "accGrant": {
        _args params [["_uid", ""], ["_zone", ""]];
        if !(call _hrOk) exitWith {[_caller, ("STR_ADVSEC_hr_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "" || {_zone isEqualTo ""}) exitWith {};
        private _l = +(_db getOrDefault ["acc:" + _uid, []]);
        _l pushBackUnique (_zone select [0, 30]);
        _db set ["acc:" + _uid, _l];
        ["hr"] call ADVSEC_fnc_dbDirty;
    };
    case "accMap": {
        _args params [["_uid", ""]];
        private _l = _db getOrDefault ["acc:" + _uid, []];
        (if (_l isEqualTo []) then {("STR_ADVSEC_hr_none" call ADVSEC_fnc_L)} else {_l joinString ", "}) call _say;
    };
};
