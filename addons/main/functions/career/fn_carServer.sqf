/*
    [acción, llamador, args] (servidor) — carrera del agente (1.24)
    "merit" [uid, nombre, puntos, motivo] · "award" [uid, nombre, idMedalla] · "awardDel" [uid, idMedalla]
    "record" [uid] (hoja de servicio) · "org" (organigrama) · "stats" (clasificación)
    "evalSet" [uid, nombre, nota, comentario] · "shift" [unidad, minutos] (interno, fin de turno)
    "school" [uid, nombre, aprobado] · "inspect" [unidad] · "priority" [idAviso, prioridad] (supervisor)
    "sync" [unidad] (interno: publica medallas y escuela en la unidad)
    Base: localNamespace ADVSEC_carDB (persistida con mapDB, clave "career").
    Claves: "pts:uid" número · "hist:uid" [[fecha, puntos, motivo, por]] · "aw:uid" [[id, fecha, por]]
            "ev:uid" [[fecha, nota, horas, eventos, comentario, por]] · "sch:uid" [fecha, por] · "jus:uid" [[fecha, tipo, detalle, por]]
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = ["career", "ADVSEC_carDB"] call ADVSEC_fnc_mapDB;
private _L = {_this call ADVSEC_fnc_L};
private _say = {if (!isNull _caller && {isPlayer _caller}) then {_this remoteExecCall ["hint", _caller]}};
// Acción del sistema: llamada interna del servidor, o validada antes por él (ADVSEC_carSys, de un solo uso)
private _sys = !(call ADVSEC_fnc_fromClient) || {localNamespace getVariable ["ADVSEC_carSys", false]};
localNamespace setVariable ["ADVSEC_carSys", false];
private _can = {params ["_p"]; _sys || {[_caller, _p] call ADVSEC_fnc_perm}};
private _push = {
    params ["_k", "_e", ["_max", 60]];
    private _l = +(_db getOrDefault [_k, []]);
    _l pushBack _e;
    if (count _l > _max) then {_l deleteAt 0};
    _db set [_k, _l];
};
private _notify = {params ["_uid", "_txt"]; private _u = [_uid] call ADVSEC_fnc_uidUnit; if (!isNull _u) then {_txt remoteExecCall ["hint", _u]}};
private _by = ["Sistema", name _caller] select (!isNull _caller);
private _medals = ["medals", []] call ADVSEC_fnc_setting;
private _medalName = {params ["_id"]; private _i = _medals findIf {(_x select 0) == _id}; [_id, (_medals select _i) select 1] select (_i >= 0)};

switch (_action) do {
    case "merit": {
        _args params [["_uid", ""], ["_name", ""], ["_pts", 0], ["_why", ""]];
        if !(["merit"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_merit" call _L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "") exitWith {};
        private _cap = ["meritMaxPerCall", 10] call ADVSEC_fnc_setting;
        _pts = round _pts;
        if (!_sys) then {_pts = (_pts max (-_cap)) min _cap};
        if (_pts == 0) exitWith {};
        private _tot = (_db getOrDefault ["pts:" + _uid, 0]) + _pts;
        _db set ["pts:" + _uid, _tot];
        ["hist:" + _uid, [call ADVSEC_fnc_now, _pts, _why select [0, 80], _by], 100] call _push;
        ["career"] call ADVSEC_fnc_dbDirty;
        ["merit", _caller, [_name, _uid, _pts, _tot, _why]] call ADVSEC_fnc_logEvent;
        [_uid, format [("STR_ADVSEC_car_merit_you" call _L), _pts, _tot, _why]] call _notify;
        if (!_sys) then {(format [("STR_ADVSEC_car_merit_done" call _L), _name, _pts, _tot]) call _say};
    };
    case "award": {
        _args params [["_uid", ""], ["_name", ""], ["_id", ""]];
        if !(["award"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_award" call _L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "" || {(_medals findIf {(_x select 0) == _id}) < 0}) exitWith {};
        private _l = _db getOrDefault ["aw:" + _uid, []];
        if ((_l findIf {(_x select 0) == _id}) >= 0) exitWith {(format [("STR_ADVSEC_car_award_has" call _L), _name, [_id] call _medalName]) call _say};
        ["aw:" + _uid, [_id, call ADVSEC_fnc_now, _by], 50] call _push;
        ["career"] call ADVSEC_fnc_dbDirty;
        ["award", _caller, [_name, _uid, _id]] call ADVSEC_fnc_logEvent;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {["sync", objNull, [_u]] call ADVSEC_fnc_carServer};
        [_uid, format [("STR_ADVSEC_car_award_you" call _L), [_id] call _medalName]] call _notify;
        (format [("STR_ADVSEC_car_award_done" call _L), _name, [_id] call _medalName]) call _say;
    };
    case "awardDel": {
        _args params [["_uid", ""], ["_id", ""]];
        if !(["award"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_award" call _L)] call ADVSEC_fnc_deny};
        private _l = (_db getOrDefault ["aw:" + _uid, []]) select {(_x select 0) != _id};
        _db set ["aw:" + _uid, _l];
        ["career"] call ADVSEC_fnc_dbDirty;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {["sync", objNull, [_u]] call ADVSEC_fnc_carServer};
        ("STR_ADVSEC_car_award_removed" call _L) call _say;
    };
    case "sync": {
        _args params [["_u", objNull]];
        if (isNull _u || {!isPlayer _u}) exitWith {};
        private _uid = getPlayerUID _u;
        private _aw = (_db getOrDefault ["aw:" + _uid, []]) apply {_x select 0};
        _u setVariable ["ADVSEC_medals", _aw, true];
        _u setVariable ["ADVSEC_schoolOk", (_db getOrDefault ["sch:" + _uid, []]) isNotEqualTo [], true];
        _u setVariable ["ADVSEC_meritPts", _db getOrDefault ["pts:" + _uid, 0], true];
    };
    case "record": {
        _args params [["_uid", ""]];
        if (_uid isEqualTo "") then {_uid = getPlayerUID _caller};
        if (_uid != getPlayerUID _caller && {!(["hr"] call _can)}) exitWith {[_caller, ("STR_ADVSEC_hr_no" call _L)] call ADVSEC_fnc_deny};
        private _pdb = [] call ADVSEC_fnc_pdbDB;
        private _e = _pdb getOrDefault [_uid, []];
        private _name = _e param [0, _uid];
        private _ranks = ["ranksGlobal", []] call ADVSEC_fnc_setting;
        private _g = _e param [7, 0];
        private _hr = ["hr", "ADVSEC_hrDB"] call ADVSEC_fnc_mapDB;
        private _line = {params ["_t", "_l"]; format ["<t font='RobotoCondensedBold' color='#c8a050'>%1</t><br/>%2<br/><br/>", _t, if (_l isEqualTo []) then {"-"} else {_l joinString "<br/>"}]};
        private _txt = format ["<t size='1.3' font='RobotoCondensedBold'>%1</t><br/>%2 · %3: %4<br/><br/>", _name call ADVSEC_fnc_repEsc, [("STR_ADVSEC_no_rank" call _L), _ranks param [_g, ""]] select (_g > 0), ("STR_ADVSEC_car_points" call _L), _db getOrDefault ["pts:" + _uid, 0]];
        _txt = _txt + ([("STR_ADVSEC_car_medals" call _L), (_db getOrDefault ["aw:" + _uid, []]) apply {format ["%1 · %2", [_x select 0] call _medalName, _x select 1]}] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_school" call _L), [[], [format [("STR_ADVSEC_car_school_ok" call _L), (_db get ("sch:" + _uid)) select 0, (_db get ("sch:" + _uid)) select 1]]] select ((_db getOrDefault ["sch:" + _uid, []]) isNotEqualTo [])] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_training" call _L), (_hr getOrDefault ["cert:" + _uid, []]) apply {format ["%1 · %2 · %3", _x select 1, (_x select 0) call ADVSEC_fnc_repEsc, _x select 2]}] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_evals" call _L), ((_db getOrDefault ["ev:" + _uid, []]) select [((count (_db getOrDefault ["ev:" + _uid, []])) - 8) max 0]) apply {format ["%1 · %2 · %3 h · %4", _x select 0, _x select 1, _x select 2, (_x select 4) call ADVSEC_fnc_repEsc]}] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_discipline" call _L), (_db getOrDefault ["jus:" + _uid, []]) apply {format ["%1 · %2 · %3", _x select 0, (_x select 1) call ADVSEC_fnc_Lv, (_x select 2) call ADVSEC_fnc_repEsc]}] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_fines" call _L), ((([] call ADVSEC_fnc_fineDB) getOrDefault [_uid, []]) select [0, 10]) apply {format ["%1 · %2 · %3", _x select 1, _x select 2, (_x select 3) call ADVSEC_fnc_repEsc]}] call _line);
        _txt = _txt + ([("STR_ADVSEC_car_history" call _L), ((_db getOrDefault ["hist:" + _uid, []]) select [((count (_db getOrDefault ["hist:" + _uid, []])) - 10) max 0]) apply {format ["%1 · %2%3 · %4", _x select 0, ["", "+"] select ((_x select 1) > 0), _x select 1, (_x select 2) call ADVSEC_fnc_repEsc]}] call _line);
        [_txt] remoteExecCall ["ADVSEC_fnc_carShow", _caller];
    };
    case "org": {
        private _pdb = [] call ADVSEC_fnc_pdbDB;
        private _ranks = ["ranksGlobal", []] call ADVSEC_fnc_setting;
        private _rows = [];
        {
            private _uid = _x;
            _y params [["_name", ""], "", "", "", "", ["_pm", 0], "", ["_g", 0]];
            if (_g > 0 || {_pm isNotEqualTo 0}) then {
                private _u = [_uid] call ADVSEC_fnc_uidUnit;
                private _on = !isNull _u && {_u getVariable ["ADVSEC_onDuty", false]};
                private _spec = if (isNull _u) then {""} else {((_u getVariable ["ADVSEC_specs", []]) apply {[_x] call ADVSEC_fnc_specName}) joinString ", "};
                _rows pushBack [_g, format ["%1%2 · %3%4", ["", "● "] select _on, [("STR_ADVSEC_no_rank" call _L), _ranks param [_g, ""]] select (_g > 0), _name, ["", " · " + _spec] select (_spec isNotEqualTo "")], _uid, _on];
            };
        } forEach _pdb;
        _rows = [_rows, [], {-(_x select 0)}, "ASCEND"] call BIS_fnc_sortBy;
        private _out = _rows apply {[_x select 1, _x select 2, "", [[], [0.45, 1, 0.45, 1]] select (_x select 3), ""]};
        ["org", format [("STR_ADVSEC_car_org_info" call _L), count _out, {_x select 3} count _rows], _out] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "stats": {
        private _cnt = createHashMap;
        private _add = {params ["_uid", "_name", "_i"]; private _e = _cnt getOrDefault [_uid, [_name, 0, 0, 0, 0]]; _e set [_i, (_e select _i) + 1]; _cnt set [_uid, _e]};
        {
            _x params ["", "_t", "_type", "_name", "_uid"];
            if (_uid isNotEqualTo "" && {serverTime - _t < 30 * 86400}) then {
                switch (_type) do {
                    case "jail": {[_uid, _name, 1] call _add};
                    case "report": {[_uid, _name, 2] call _add};
                    case "dispatch": {[_uid, _name, 3] call _add};
                };
            };
        } forEach (localNamespace getVariable ["ADVSEC_eventLog", []]);
        {
            if ((_x select [0, 4]) == "pts:") then {
                private _uid = _x select [4];
                private _e = _cnt getOrDefault [_uid, [(([] call ADVSEC_fnc_pdbDB) getOrDefault [_uid, [_uid]]) select 0, 0, 0, 0, 0]];
                _e set [4, _y];
                _cnt set [_uid, _e];
            };
        } forEach _db;
        private _rows = (values _cnt) apply {[(_x select 4) + 5 * (_x select 1) + 3 * (_x select 2) + (_x select 3), _x]};
        _rows = [_rows, [], {-(_x select 0)}, "ASCEND"] call BIS_fnc_sortBy;
        private _out = [];
        {
            (_x select 1) params ["_name", "_arr", "_rep", "_dsp", "_pts"];
            _out pushBack [format ["%1. %2 · %3", _forEachIndex + 1, _name, _x select 0], "", format [("STR_ADVSEC_car_stats_row" call _L), _name call ADVSEC_fnc_repEsc, _pts, _arr, _rep, _dsp], [], ""];
        } forEach (_rows select [0, 20]);
        ["stats", ("STR_ADVSEC_car_stats_info" call _L), _out] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "shift": {
        // Fin de turno: nota automática por eventos registrados por hora de servicio
        _args params [["_u", objNull], ["_min", 0]];
        if (_sys isEqualTo false || {isNull _u} || {_min < 10}) exitWith {};
        private _uid = getPlayerUID _u;
        private _from = serverTime - _min * 60;
        private _skip = ["dutyOn", "dutyOff", "bodycamOn", "bodycamOff", "merit", "pdaMarkClear"];
        private _n = {(_x select 4) == _uid && {(_x select 1) >= _from} && {!((_x select 2) in _skip)}} count (localNamespace getVariable ["ADVSEC_eventLog", []]);
        private _h = _min / 60;
        private _rate = _n / (_h max 0.25);
        private _grade = switch (true) do {case (_rate >= 4): {"A"}; case (_rate >= 2): {"B"}; case (_rate >= 1): {"C"}; case (_n > 0): {"D"}; default {"E"}};
        ["ev:" + _uid, [call ADVSEC_fnc_now, _grade, (round (_h * 10)) / 10, _n, "", "Auto"]] call _push;
        ["career"] call ADVSEC_fnc_dbDirty;
        private _pts = ((["evalMerit", [5, 3, 1, 0, 0]] call ADVSEC_fnc_setting) param [["A", "B", "C", "D", "E"] find _grade, 0]);
        if (_pts > 0) then {["merit", objNull, [_uid, name _u, _pts, format [("STR_ADVSEC_car_shift_reason" call _L), _grade]]] call ADVSEC_fnc_carServer};
        (format [("STR_ADVSEC_car_shift_you" call _L), _grade, (round (_h * 10)) / 10, _n]) remoteExecCall ["hint", _u];
    };
    case "evalSet": {
        _args params [["_uid", ""], ["_name", ""], ["_grade", "C"], ["_txt", ""]];
        if !(["evaluate"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_eval" call _L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "" || {!(_grade in ["A", "B", "C", "D", "E"])}) exitWith {};
        ["ev:" + _uid, [call ADVSEC_fnc_now, _grade, 0, 0, _txt select [0, 120], _by]] call _push;
        ["career"] call ADVSEC_fnc_dbDirty;
        ["evaluation", _caller, [_name, _uid, _grade]] call ADVSEC_fnc_logEvent;
        [_uid, format [("STR_ADVSEC_car_eval_you" call _L), _grade, _txt]] call _notify;
        (format [("STR_ADVSEC_car_eval_done" call _L), _name, _grade]) call _say;
    };
    case "school": {
        _args params [["_uid", ""], ["_name", ""], ["_ok", true]];
        if !(["school"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_school" call _L)] call ADVSEC_fnc_deny};
        if (_uid isEqualTo "") exitWith {};
        if (_ok) then {_db set ["sch:" + _uid, [call ADVSEC_fnc_now, _by]]} else {_db deleteAt ("sch:" + _uid)};
        ["career"] call ADVSEC_fnc_dbDirty;
        ["school", _caller, [_name, _uid, _ok]] call ADVSEC_fnc_logEvent;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {["sync", objNull, [_u]] call ADVSEC_fnc_carServer};
        [_uid, [("STR_ADVSEC_car_school_revoked_you" call _L), ("STR_ADVSEC_car_school_passed_you" call _L)] select _ok] call _notify;
        (format [[("STR_ADVSEC_car_school_revoked" call _L), ("STR_ADVSEC_car_school_passed" call _L)] select _ok, _name]) call _say;
    };
    case "inspect": {
        // Revista de uniforme: comprueba el equipo obligatorio de la unidad
        _args params [["_u", objNull]];
        if !(["inspect"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_inspect" call _L)] call ADVSEC_fnc_deny};
        if (isNull _u || {!isPlayer _u} || {(_caller distance _u) > 6}) exitWith {};
        private _req = ["inspectItems", []] call ADVSEC_fnc_setting;
        private _all = (uniformItems _u) + (vestItems _u) + (backpackItems _u) + (assignedItems _u) + [uniform _u, vest _u, headgear _u, backpack _u, primaryWeapon _u, handgunWeapon _u];
        private _checks = if (_req isEqualTo []) then {
            [[("STR_ADVSEC_car_ins_uniform" call _L), uniform _u != ""], [("STR_ADVSEC_car_ins_vest" call _L), vest _u != ""], [("STR_ADVSEC_car_ins_head" call _L), headgear _u != ""],
             [("STR_ADVSEC_car_ins_badge" call _L), (_all findIf {"ADVSEC_MPBadge" in _x || {"ADVSEC_PDA" in _x}}) >= 0], [("STR_ADVSEC_car_ins_map" call _L), "ItemMap" in _all], [("STR_ADVSEC_car_ins_radio" call _L), (_all findIf {"radio" in toLower _x || {"tf_" in toLower _x} || {"acre_" in toLower _x}}) >= 0]]
        } else {
            _req apply {private _dn = getText (configFile >> "CfgWeapons" >> _x >> "displayName"); [[_dn, _x] select (_dn isEqualTo ""), _x in _all]}
        };
        private _ok = {_x select 1} count _checks;
        private _pct = round (100 * _ok / ((count _checks) max 1));
        private _txt = format [("STR_ADVSEC_car_ins_result" call _L), name _u, _pct, (_checks apply {format ["%1 %2", ["✗", "✓"] select (_x select 1), _x select 0]}) joinString endl];
        _txt call _say;
        _txt remoteExecCall ["hint", _u];
        private _pts = switch (true) do {case (_pct >= 100): {2}; case (_pct < 50): {-2}; default {0}};
        if (_pts != 0) then {["merit", objNull, [getPlayerUID _u, name _u, _pts, format [("STR_ADVSEC_car_ins_reason" call _L), _pct]]] call ADVSEC_fnc_carServer};
        ["inspection", _caller, [name _u, getPlayerUID _u, _pct]] call ADVSEC_fnc_logEvent;
    };
    case "priority": {
        _args params [["_id", ""], ["_prio", "Media"]];
        if !(["supervisor"] call _can) exitWith {[_caller, ("STR_ADVSEC_car_no_supervisor" call _L)] call ADVSEC_fnc_deny};
        private _calls = localNamespace getVariable ["ADVSEC_dspCalls", createHashMap];
        private _c = _calls getOrDefault [_id, []];
        if (_c isEqualTo [] || {!(_prio in ["Alta", "Media", "Baja"])}) exitWith {("STR_ADVSEC_car_prio_none" call _L) call _say};
        _c set [9, _prio];
        ["priority", _caller, [_id, _prio]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_car_prio_done" call _L), _id, _prio call ADVSEC_fnc_Lv]) call _say;
    };
};
