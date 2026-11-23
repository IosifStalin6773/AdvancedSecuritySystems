/*
    [acción, llamador, args] (servidor) — justicia militar (1.24)
    "art15" [unidad, motivo] · "court" [unidad, cargo, gravedad 1-6, fallo "acquit"|"fine"|"reduce", importe]
    "trialStart" [unidad, cargo, gravedad] · "trialPlea" [id, culpable] · "trialExhibit" [id, texto] · "trialRest" [id] · "trialList"
    Constancias en la hoja de servicio: base de carrera, clave "jus:uid".
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _L = {_this call ADVSEC_fnc_L};
private _say = {if (!isNull _caller && {isPlayer _caller}) then {_this remoteExecCall ["hint", _caller]}};
private _car = ["career", "ADVSEC_carDB"] call ADVSEC_fnc_mapDB;
private _note = {
    params ["_uid", "_type", "_txt"];
    if (_uid isEqualTo "") exitWith {};
    private _l = +(_car getOrDefault ["jus:" + _uid, []]);
    _l pushBack [call ADVSEC_fnc_now, _type, _txt select [0, 140], name _caller];
    _car set ["jus:" + _uid, _l];
    ["career"] call ADVSEC_fnc_dbDirty;
};
// Baja un rango global (si tiene) y publica el cambio
private _demote = {
    params ["_u"];
    private _uid = getPlayerUID _u;
    if (_uid isEqualTo "") exitWith {false};
    private _e = ([] call ADVSEC_fnc_pdbDB) getOrDefault [_uid, []];
    if (_e isEqualTo [] || {(_e param [7, 0]) <= 1}) exitWith {false};
    _e set [7, (_e select 7) - 1];
    ["players"] call ADVSEC_fnc_dbDirty;
    [_u] call ADVSEC_fnc_pdbApply;
    ["rankChange", _caller, [name _u, _uid, _e select 7, "demote"]] call ADVSEC_fnc_logEvent;
    true
};
private _trials = localNamespace getVariable ["ADVSEC_trials", createHashMap];
localNamespace setVariable ["ADVSEC_trials", _trials];

switch (_action) do {
    case "art15": {
        _args params [["_u", objNull], ["_why", ""]];
        if !([_caller, "article15"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_jus_no_art15" call _L)] call ADVSEC_fnc_deny};
        if (isNull _u || {!isPlayer _u}) exitWith {};
        if (_why isEqualTo "") then {_why = "STR_ADVSEC_unspecified" call _L};
        private _down = [_u] call _demote;
        private _loss = ["art15Merit", -10] call ADVSEC_fnc_setting;
        if (_loss != 0) then {["merit", objNull, [getPlayerUID _u, name _u, _loss, "Art. 15: " + _why]] call ADVSEC_fnc_carServer};
        [getPlayerUID _u, "Art15", format ["%1%2", _why, ["", " · " + ("STR_ADVSEC_jus_demoted" call _L)] select _down]] call _note;
        ["article15", _caller, [name _u, getPlayerUID _u, _why, _down]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_jus_art15_you" call _L), _why, ["", ("STR_ADVSEC_jus_demoted" call _L)] select _down]) remoteExecCall ["hint", _u];
        (format [("STR_ADVSEC_jus_art15_done" call _L), name _u]) call _say;
    };
    case "court": {
        _args params [["_u", objNull], ["_charge", ""], ["_sev", 1], ["_verdict", "acquit"], ["_amt", 0]];
        if !([_caller, "courtMartial"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_jus_no_court" call _L)] call ADVSEC_fnc_deny};
        if (isNull _u || {_caller isEqualTo _u}) exitWith {};
        _sev = (round _sev) max 1 min 6;
        if (_charge isEqualTo "") then {_charge = "STR_ADVSEC_unspecified" call _L};
        private _res = switch (_verdict) do {
            case "fine": {
                _amt = (round _amt) max 0;
                if (_amt == 0) then {_amt = _sev * (["courtFinePerLevel", 500] call ADVSEC_fnc_setting)};
                private _fid = [_u, _amt, format [("STR_ADVSEC_jus_court_fine_reason" call _L), _charge], name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
                format [("STR_ADVSEC_jus_res_fine" call _L), _amt, _fid]
            };
            case "reduce": {[("STR_ADVSEC_jus_res_noreduce" call _L), ("STR_ADVSEC_jus_res_reduce" call _L)] select ([_u] call _demote)};
            default {"STR_ADVSEC_jus_res_acquit" call _L};
        };
        [getPlayerUID _u, "Consejo", format ["%1 (G%2) · %3", _charge, _sev, _res]] call _note;
        if (_verdict != "acquit") then {["merit", objNull, [getPlayerUID _caller, name _caller, _sev, format [("STR_ADVSEC_jus_court_merit" call _L), name _u]]] call ADVSEC_fnc_carServer};
        ["courtMartial", _caller, [name _u, getPlayerUID _u, _charge, _sev, _verdict]] call ADVSEC_fnc_logEvent;
        private _txt = format [("STR_ADVSEC_jus_court_txt" call _L), name _u, _charge, _sev, _res];
        _txt call _say;
        if (isPlayer _u) then {_txt remoteExecCall ["hint", _u]};
    };
    case "trialStart": {
        _args params [["_u", objNull], ["_charge", ""], ["_sev", 1]];
        if !([_caller, "trial"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_jus_no_trial" call _L)] call ADVSEC_fnc_deny};
        if (isNull _u || {!alive _u} || {(_caller distance _u) > 15} || {_u isEqualTo _caller}) exitWith {("STR_ADVSEC_jus_trial_near" call _L) call _say};
        if (((values _trials) findIf {(_x select 1) isEqualTo _u}) >= 0) exitWith {("STR_ADVSEC_jus_trial_open" call _L) call _say};
        private _n = (localNamespace getVariable ["ADVSEC_trialSeq", 0]) + 1;
        localNamespace setVariable ["ADVSEC_trialSeq", _n];
        private _id = format ["J-%1", _n];
        if (_charge isEqualTo "") then {_charge = "STR_ADVSEC_unspecified" call _L};
        // Juez y abogado: IA civil quieta junto al acusado
        private _grp = createGroup [civilian, true];
        private _mk = {
            params ["_cls", "_off", "_title"];
            private _p = _u getPos [3, (getDir _u) + _off];
            private _a = _grp createUnit [_cls, _p, [], 0, "CAN_COLLIDE"];
            if (isNull _a) exitWith {objNull};
            {_a disableAI _x} forEach ["MOVE", "TARGET", "AUTOTARGET", "FSM"];
            _a setCaptive true;
            _a allowDamage false;
            removeAllWeapons _a;
            _a setDir (_a getDir _u);
            _a setVariable ["ADVSEC_trialRole", _title, true];
            _a
        };
        private _judge = [["trialJudgeClass", "C_man_1"] call ADVSEC_fnc_setting, 40, "STR_ADVSEC_jus_judge" call _L] call _mk;
        private _counsel = [["trialCounselClass", "C_man_1"] call ADVSEC_fnc_setting, -40, "STR_ADVSEC_jus_counsel" call _L] call _mk;
        _trials set [_id, [_id, _u, _charge select [0, 80], _caller, serverTime, "", [], _judge, _counsel, getPosATL _u, (round _sev) max 1 min 6]];
        ["trialStart", _caller, [_id, name _u, _charge]] call ADVSEC_fnc_logEvent;
        private _txt = format [("STR_ADVSEC_jus_trial_open_txt" call _L), _id, name _u, _charge];
        _txt call _say;
        if (isPlayer _u) then {(_txt + endl + endl + ("STR_ADVSEC_jus_trial_plea_hint" call _L)) remoteExecCall ["hint", _u]; [_id] remoteExecCall ["ADVSEC_fnc_jusPlea", _u]};
    };
    case "trialPlea": {
        _args params [["_id", ""], ["_guilty", false]];
        private _t = _trials getOrDefault [_id, []];
        if (_t isEqualTo []) exitWith {};
        private _def = _t select 1;
        // Un acusado jugador declara por sí mismo; por una IA declara el instructor (la IA decide)
        if (isPlayer _def && {_caller isNotEqualTo _def} && {!([_caller] call ADVSEC_fnc_isZeus)}) exitWith {("STR_ADVSEC_jus_plea_self" call _L) call _say};
        if (!isPlayer _def && {_caller isNotEqualTo (_t select 3)} && {!([_caller, "trial"] call ADVSEC_fnc_perm)}) exitWith {};
        if (!isPlayer _def) then {_guilty = random 1 < (0.15 + 0.15 * count (_t select 6))};
        _t set [5, ["notguilty", "guilty"] select _guilty];
        (format [("STR_ADVSEC_jus_plea_done" call _L), name _def, [("STR_ADVSEC_jus_notguilty" call _L), ("STR_ADVSEC_jus_guilty" call _L)] select _guilty]) remoteExecCall ["hint", [_t select 3, _caller] arrayIntersect [_t select 3, _caller]];
    };
    case "trialExhibit": {
        _args params [["_id", ""], ["_txt", ""]];
        private _t = _trials getOrDefault [_id, []];
        if (_t isEqualTo [] || {_txt isEqualTo ""}) exitWith {};
        if (_caller isNotEqualTo (_t select 3) && {!([_caller, "trial"] call ADVSEC_fnc_perm)}) exitWith {};
        (_t select 6) pushBack (_txt select [0, 100]);
        (format [("STR_ADVSEC_jus_exhibit_done" call _L), count (_t select 6), _id]) call _say;
    };
    case "trialList": {
        private _rows = (values _trials) apply {[format ["%1 · %2 · %3", _x select 0, name (_x select 1), _x select 2], _x select 0, format [("STR_ADVSEC_jus_trial_row" call _L), _x select 0, (name (_x select 1)) call ADVSEC_fnc_repEsc, (_x select 2) call ADVSEC_fnc_repEsc, _x select 10, switch (_x select 5) do {case "guilty": {"STR_ADVSEC_jus_guilty" call _L}; case "notguilty": {"STR_ADVSEC_jus_notguilty" call _L}; default {"STR_ADVSEC_jus_pending" call _L}}, ((_x select 6) apply {_x call ADVSEC_fnc_repEsc}) joinString "<br/>"], [], ""]};
        ["trials", format [("STR_ADVSEC_jus_trials_info" call _L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "trialRest": {
        _args params [["_id", ""]];
        private _t = _trials getOrDefault [_id, []];
        if (_t isEqualTo []) exitWith {};
        if (_caller isNotEqualTo (_t select 3) && {!([_caller] call ADVSEC_fnc_isZeus)}) exitWith {("STR_ADVSEC_jus_rest_only" call _L) call _say};
        _t params ["", "_def", "_charge", "_off", "", "_plea", "_ex", "_judge", "_counsel", "_pos", "_sev"];
        if (_plea isEqualTo "") exitWith {("STR_ADVSEC_jus_no_plea" call _L) call _say};
        // Peso: pruebas presentadas y el testimonio del agente que arrestó (más si está presente a menos de 30 m)
        private _wit = [1, 2] select (!isNull _off && {alive _off} && {(_off distance _pos) < 30});
        private _score = (count _ex) + _wit + random 2;
        private _need = ["trialThreshold", 3] call ADVSEC_fnc_setting;
        private _guilty = _plea == "guilty" || {_score >= _need};
        private _res = if (_guilty) then {
            private _min = _sev * (["trialJailPerLevel", 10] call ADVSEC_fnc_setting);
            private _amt = _sev * (["trialFinePerLevel", 300] call ADVSEC_fnc_setting);
            if (_plea == "guilty") then {_min = round (_min * 0.5); _amt = round (_amt * 0.5)};
            if (_amt > 0) then {[_def, _amt, format [("STR_ADVSEC_jus_court_fine_reason" call _L), _charge], name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd};
            if (_min > 0 && {!isNil "ADVSEC_jails"} && {(ADVSEC_jails select {!isNull _x}) isNotEqualTo []}) then {["jail", _caller, [_def, _min, format [("STR_ADVSEC_jus_court_fine_reason" call _L), _charge], objNull, false]] call ADVSEC_fnc_jailServer};
            format [("STR_ADVSEC_jus_res_guilty" call _L), _min, _amt]
        } else {"STR_ADVSEC_jus_res_acquit" call _L};
        if (isPlayer _def) then {[getPlayerUID _def, "Juicio", format ["%1 · %2", _charge, _res]] call _note};
        if (_guilty && {!isNull _off}) then {["merit", objNull, [getPlayerUID _off, name _off, _sev, format [("STR_ADVSEC_jus_court_merit" call _L), name _def]]] call ADVSEC_fnc_carServer};
        ["trialEnd", _caller, [_id, name _def, _charge, _guilty, count _ex, _wit]] call ADVSEC_fnc_logEvent;
        ["create", _caller, [
            ["type", "FPM01"], ["gravity", "Grave"], ["confidential", false],
            ["subjects", [format ["%1 [%2]", name _def, getPlayerUID _def]]],
            ["title", format [("STR_ADVSEC_jus_rep_title" call _L), _id, name _def]],
            ["place", format [("STR_ADVSEC_grid_3" call ADVSEC_fnc_L), worldName, mapGridPosition _pos]],
            ["witnesses", name _off],
            ["body", format [("STR_ADVSEC_jus_rep_body" call _L), _charge, _sev, [("STR_ADVSEC_jus_notguilty" call _L), ("STR_ADVSEC_jus_guilty" call _L)] select (_plea == "guilty"), (_ex joinString "; "), _wit, _res]],
            ["sanction", "Ninguna"]
        ]] call ADVSEC_fnc_repServer;
        private _txt = format [("STR_ADVSEC_jus_verdict" call _L), _id, name _def, [("STR_ADVSEC_jus_notguilty" call _L), ("STR_ADVSEC_jus_guilty" call _L)] select _guilty, _res];
        _txt remoteExecCall ["hint", ([_caller, _def, _off] select {!isNull _x && {isPlayer _x}}) arrayIntersect ([_caller, _def, _off] select {!isNull _x && {isPlayer _x}})];
        {if (!isNull _x) then {deleteVehicle _x}} forEach [_judge, _counsel];
        _trials deleteAt _id;
    };
};
