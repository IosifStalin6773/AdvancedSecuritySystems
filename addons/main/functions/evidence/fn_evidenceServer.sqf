/*
    [acción, llamador, args] (servidor)
    Generación: "casing" [arma, munición, pos], "print" [objeto], "blood" [pos], "hitRestrained" [agresor]
    Investigación: "scene", "collect" [id], "list", "transfer" [id, unidad], "analyze" [id, laboratorio],
                   "attach" [id, idInforme], "tamper" [id, unidad], "audit" [id, laboratorio]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = [] call ADVSEC_fnc_evDB;
private _say = {_this remoteExecCall ["hint", _caller]};
private _chain = {params ["_e", "_what"]; (_e get "chain") pushBack [call ADVSEC_fnc_now, name _caller, getPlayerUID _caller, _what]};
private _throttle = {
    params ["_key", "_secs"];
    private _t = localNamespace getVariable ["ADVSEC_evThrottle", createHashMap];
    localNamespace setVariable ["ADVSEC_evThrottle", _t];
    if ((_t getOrDefault [_key, -1e9]) > serverTime) exitWith {true};
    _t set [_key, serverTime + _secs];
    false
};
private _gloved = {
    private _g = ["gloveItems", []] call ADVSEC_fnc_setting;
    _g isNotEqualTo [] && {((items _caller + assignedItems _caller + [uniform _caller, vest _caller, goggles _caller, headgear _caller]) findIf {_x in _g}) > -1}
};
private _get = {
    private _e = _db getOrDefault [_this, createHashMap];
    if (count _e == 0) then {("STR_ADVSEC_that_evidence_does_not_exist" call ADVSEC_fnc_L) call _say};
    _e
};
private _isHolder = {params ["_e"]; (_e get "holder") isEqualTo getPlayerUID _caller};
private _bag = "ADVSEC_EvidenceBag";

switch (_action) do {
    case "casing": {
        _args params ["_weapon", "_ammo", "_pos"];
        if ((_caller distance _pos) > 6 || {[netId _caller + "c", 1] call _throttle}) exitWith {};
        private _wc = configFile >> "CfgWeapons" >> _weapon;
        private _h = 0;
        {_h = (_h * 31 + _x) mod 9999991} forEach toArray (getPlayerUID _caller + _weapon);
        private _serial = format ["%1-%2", toUpper (_weapon select [0, 3]), _h];
        // Arma corporativa firmada: la vaina lleva el número de serie de la armería y el firmante
        private _corp = ((_caller getVariable ["ADVSEC_corpArms", []]) select {(_x select 0) == ([_weapon] call BIS_fnc_baseWeapon)}) param [0, []];
        if (_corp isNotEqualTo []) then {_serial = _corp select 1};
        ["casing", _pos, createHashMapFromArray [
            ["uid", getPlayerUID _caller], ["name", name _caller], ["weapon", _weapon], ["weaponName", getText (_wc >> "displayName")],
            ["serial", _serial], ["ammo", _ammo], ["ammoName", getText (configFile >> "CfgMagazines" >> _ammo >> "displayNameShort")]
        ]] call ADVSEC_fnc_evAdd;
    };
    case "print": {
        _args params ["_obj"];
        if (isNull _obj || {(_caller distance _obj) > 10} || {[netId _caller + netId _obj, 120] call _throttle}) exitWith {};
        private _chance = ([["printChance", 0.8], ["gloveChance", 0.15]] select (call _gloved)) call ADVSEC_fnc_setting;
        if (random 1 > _chance) exitWith {};
        private _pos = (getPosATL _caller) vectorAdd [random 0.6 - 0.3, random 0.6 - 0.3, 0];
        ["print", _pos, createHashMapFromArray [
            ["uid", getPlayerUID _caller], ["name", name _caller], ["objName", getText (configOf _obj >> "displayName")]
        ]] call ADVSEC_fnc_evAdd;
    };
    case "blood": {
        _args params ["_pos"];
        if ((_caller distance _pos) > 4 || {[netId _caller + "b", 30] call _throttle}) exitWith {};
        ["blood", _pos, createHashMapFromArray [["uid", getPlayerUID _caller], ["name", name _caller]]] call ADVSEC_fnc_evAdd;
    };
    case "hitRestrained": {
        _args params ["_by"];
        if (isNull _by || {_by isEqualTo _caller} || {!([_caller] call ADVSEC_fnc_isRestrained)} || {(_by distance _caller) > 300}) exitWith {};
        if ([getPlayerUID _by + getPlayerUID _caller + "h", 60] call _throttle) exitWith {};
        [_by, "hitRestrained", name _caller] call ADVSEC_fnc_heatAdd;
    };
    case "scene": {
        if !([_caller, "evidenceCollect"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_inspect_a_scene" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _r = ["sceneRadius", 15] call ADVSEC_fnc_setting;
        private _ttl = ["evidenceTTL", 3600] call ADVSEC_fnc_setting;
        private _old = [];
        private _found = [];
        {
            if ((_y get "state") == "field") then {
                if (serverTime - (_y get "t") > _ttl) then {_old pushBack _x} else {
                    if ((_caller distance (_y get "pos")) < _r) then {_found pushBack [_x, _y get "type", _y get "pos", [_y] call ADVSEC_fnc_evSummary]};
                };
            };
        } forEach _db;
        {_db deleteAt _x} forEach _old;
        [_found] remoteExecCall ["ADVSEC_fnc_evShow", _caller];
    };
    case "collect": {
        _args params ["_id"];
        private _e = _id call _get;
        if (count _e == 0) exitWith {};
        if !([_caller, "evidenceCollect"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_collect_evidence" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if ((_e get "state") != "field" || {(_caller distance (_e get "pos")) > 4}) exitWith {("STR_ADVSEC_get_closer_to_the_evidence" call ADVSEC_fnc_L) call _say};
        _e set ["state", "bagged"];
        _e set ["holder", getPlayerUID _caller];
        _e set ["holderName", name _caller];
        [_e, ("STR_ADVSEC_collected_and_sealed_at_the" call ADVSEC_fnc_L)] call _chain;
        ["ev"] call ADVSEC_fnc_dbDirty;
        ["evidenceCollect", _caller, [_id, _e get "type"]] call ADVSEC_fnc_logEvent;
        [_caller, _bag, format [("STR_ADVSEC_bagged_2" call ADVSEC_fnc_L), _id]] remoteExecCall ["ADVSEC_fnc_docGive", _caller];
    };
    case "list": {
        private _all = [_caller, "evidenceAnalyze"] call ADVSEC_fnc_perm || {[_caller, "AI"] call ADVSEC_fnc_repAccess};
        private _rows = [];
        {
            if ((_y get "state") != "field" && {_all || {[_y] call _isHolder}}) then {
                private _mine = [_y] call _isHolder;
                _rows pushBack [
                    format ["%1%2", [_y] call ADVSEC_fnc_evSummary, ["", ("STR_ADVSEC_in_your_possession" call ADVSEC_fnc_L)] select _mine],
                    _x, [_y] call ADVSEC_fnc_evDetail, [[], [0.816, 0.639, 0.188, 1]] select _mine, ""
                ];
            };
        } forEach _db;
        _rows sort false;
        ["evidence", format [("STR_ADVSEC_evidence_log_items_in_custody" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "transfer": {
        _args params ["_id", "_to"];
        private _e = _id call _get;
        if (count _e == 0) exitWith {};
        if (!([_e] call _isHolder) || {isNull _to} || {(_to distance _caller) > 5} || {!([_to, "PM"] call ADVSEC_fnc_repAccess)}) exitWith {("STR_ADVSEC_you_can_only_hand_evidence" call ADVSEC_fnc_L) call _say};
        if !(_bag in items _caller) exitWith {("STR_ADVSEC_you_are_not_carrying_the" call ADVSEC_fnc_L) call _say};
        [_e, format [("STR_ADVSEC_handed_to_2" call ADVSEC_fnc_L), name _to]] call _chain;
        _e set ["holder", getPlayerUID _to];
        _e set ["holderName", name _to];
        ["ev"] call ADVSEC_fnc_dbDirty;
        [_caller, _bag, false] remoteExecCall ["ADVSEC_fnc_evBagMove", _caller];
        [_to, _bag, format [("STR_ADVSEC_hands_you_evidence" call ADVSEC_fnc_L), name _caller, _id]] remoteExecCall ["ADVSEC_fnc_docGive", _to];
        format [("STR_ADVSEC_evidence_handed_to" call ADVSEC_fnc_L), _id, name _to] call _say;
    };
    case "analyze": {
        _args params ["_id", "_lab"];
        private _e = _id call _get;
        if (count _e == 0) exitWith {};
        if !([_caller, "evidenceAnalyze"] call ADVSEC_fnc_perm) exitWith {("STR_ADVSEC_your_rank_does_not_allow_12" call ADVSEC_fnc_L) call _say};
        if (isNull _lab || {!(_lab getVariable ["ADVSEC_lab", false])} || {(_caller distance _lab) > 6}) exitWith {("STR_ADVSEC_you_must_be_at_the_3" call ADVSEC_fnc_L) call _say};
        if (!([_e] call _isHolder) || {(_e get "state") != "bagged"}) exitWith {("STR_ADVSEC_you_can_only_analyse_bagged" call ADVSEC_fnc_L) call _say};
        private _secs = ["labTime", 90] call ADVSEC_fnc_setting;
        _e set ["state", "analyzing"];
        [_e, format [("STR_ADVSEC_handed_to_lab" call ADVSEC_fnc_L), _lab getVariable ["ADVSEC_labName", ""]]] call _chain;
        [_caller, _bag, false] remoteExecCall ["ADVSEC_fnc_evBagMove", _caller];
        format [("STR_ADVSEC_analysis_in_progress_s" call ADVSEC_fnc_L), _secs] call _say;
        [_e, _secs, _caller] spawn {
            params ["_e", "_secs", "_caller"];
            sleep _secs;
            private _who = [[_e get "name", _e get "uid"], _e get "fake"] select ((_e get "fake") isNotEqualTo []);
            private _res = switch (_e get "type") do {
                case "casing": {
                    // Registro de armas: el titular sale del registro; un arma sin registrar no identifica a nadie (weaponRegistryStrict)
                    private _reg = ([] call ADVSEC_fnc_wpnDB) getOrDefault [_e get "serial", []];
                    switch (true) do {
                        case ((_e get "fake") isNotEqualTo []): {format [("STR_ADVSEC_fired_with_serial_weapon_registered" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial", _who select 0, _who select 1]};
                        case (_reg isNotEqualTo [] && {(_reg param [4, ""]) == "CORP"}): {format [("STR_ADVSEC_pmc_ev_corp" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial", (_reg select 6) param [1, "-"], (_reg select 6) param [0, "-"], (_reg select 6) param [2, "-"], (_reg select 5) call ADVSEC_fnc_Lv]};
                        case (_reg isNotEqualTo []): {format [("STR_ADVSEC_fired_with_serial_weapon_registered_2" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial", _reg select 2, _reg select 1, _reg select 3]};
                        case ((["weaponRegistryStrict", 1] call ADVSEC_fnc_setting) isEqualTo 1): {format [("STR_ADVSEC_fired_with_serial_unregistered_weapon" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial"]};
                        default {format [("STR_ADVSEC_fired_with_serial_unregistered_ballistic" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial", _who select 0, _who select 1]};
                    };
                };
                case "print": {format [("STR_ADVSEC_fingerprint_matching" call ADVSEC_fnc_L), _who select 0, _who select 1]};
                default {format [("STR_ADVSEC_dna_profile_matching" call ADVSEC_fnc_L), _who select 0, _who select 1]};
            };
            _e set ["result", _res];
            _e set ["state", "analyzed"];
            (_e get "chain") pushBack [call ADVSEC_fnc_now, ("STR_ADVSEC_lab" call ADVSEC_fnc_L), "", ("STR_ADVSEC_analysis_completed" call ADVSEC_fnc_L)];
            ["ev"] call ADVSEC_fnc_dbDirty;
            if (!isNull _caller) then {(format [("STR_ADVSEC_lab_analysed" call ADVSEC_fnc_L), _e get "id"]) remoteExecCall ["hint", _caller]};
        };
    };
    case "attach": {
        _args params ["_id", "_rid"];
        private _e = _id call _get;
        if (count _e == 0) exitWith {};
        if (isNil "ADVSEC_repDB") then {[] call ADVSEC_fnc_repLoad};
        private _r = ADVSEC_repDB getOrDefault [_rid, createHashMap];
        if (count _r == 0) exitWith {format [("STR_ADVSEC_report_does_not_exist" call ADVSEC_fnc_L), _rid] call _say};
        (_r get "notes") pushBack [call ADVSEC_fnc_now, name _caller, getPlayerUID _caller,
            format [("STR_ADVSEC_attached_evidence_custody_result" call ADVSEC_fnc_L), _id, _e get "time", _e get "grid", _e get "holderName", ["pendiente", _e get "result"] select ((_e get "result") isNotEqualTo "")]];
        [] call ADVSEC_fnc_repSave;
        [_e, format [("STR_ADVSEC_attached_to_report" call ADVSEC_fnc_L), _rid]] call _chain;
        format [("STR_ADVSEC_attached_to" call ADVSEC_fnc_L), _id, _rid] call _say;
    };
    case "tamper": {
        _args params ["_id", "_victim"];
        private _e = _id call _get;
        if (count _e == 0 || {isNull _victim}) exitWith {};
        if !([_caller, "evidenceTamper"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_tamper_with_evidence" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (!([_e] call _isHolder) || {!((_e get "state") in ["bagged", "analyzed"])}) exitWith {("STR_ADVSEC_you_can_only_alter_evidence" call ADVSEC_fnc_L) call _say};
        _e set ["fake", [name _victim, getPlayerUID _victim]];
        (_e get "tamper") pushBack [call ADVSEC_fnc_now, name _caller, getPlayerUID _caller, name _victim];
        [_e, ("STR_ADVSEC_seal_check" call ADVSEC_fnc_L)] call _chain;
        if ((_e get "state") == "analyzed") then {
            private _res = switch (_e get "type") do {
                case "casing": {format [("STR_ADVSEC_fired_with_serial_weapon_registered" call ADVSEC_fnc_L), _e get "weaponName", _e get "serial", name _victim, getPlayerUID _victim]};
                case "print": {format [("STR_ADVSEC_fingerprint_matching" call ADVSEC_fnc_L), name _victim, getPlayerUID _victim]};
                default {format [("STR_ADVSEC_dna_profile_matching" call ADVSEC_fnc_L), name _victim, getPlayerUID _victim]};
            };
            _e set ["result", _res];
        };
        ["ev"] call ADVSEC_fnc_dbDirty;
        ("STR_ADVSEC_evidence_altered_if_audited_the" call ADVSEC_fnc_L) call _say;
    };
    case "auditStart";
    case "audit": {
        _args params ["_id", "_lab"];
        private _e = _id call _get;
        if (count _e == 0) exitWith {};
        if !([_caller, "evidenceAudit"] call ADVSEC_fnc_perm) exitWith {("STR_ADVSEC_your_rank_does_not_allow_13" call ADVSEC_fnc_L) call _say};
        if (isNull _lab || {!(_lab getVariable ["ADVSEC_lab", false])} || {(_caller distance _lab) > 6}) exitWith {("STR_ADVSEC_the_audit_is_done_at" call ADVSEC_fnc_L) call _say};
        // Primero se inicia (barra de progreso en el cliente) y solo se resuelve cuando ha pasado el tiempo
        private _secs = ["auditTime", 25] call ADVSEC_fnc_setting;
        private _starts = localNamespace getVariable ["ADVSEC_auditStart", createHashMap];
        localNamespace setVariable ["ADVSEC_auditStart", _starts];
        private _k = getPlayerUID _caller + _id;
        if (_action == "auditStart") exitWith {
            _starts set [_k, serverTime];
            [_id, _lab, _secs] remoteExecCall ["ADVSEC_fnc_evAuditBar", _caller];
        };
        private _t0 = _starts getOrDefault [_k, -1];
        if (_t0 < 0 || {serverTime - _t0 < _secs - 2}) exitWith {("STR_ADVSEC_the_audit_was_not_completed" call ADVSEC_fnc_L) call _say};
        _starts deleteAt _k;
        [_e, ("STR_ADVSEC_forensic_audit" call ADVSEC_fnc_L)] call _chain;
        private _t = _e get "tamper";
        if (_t isEqualTo []) exitWith {
            ["ev"] call ADVSEC_fnc_dbDirty;
            format [("STR_ADVSEC_audit_of_seals_and_batch" call ADVSEC_fnc_L), _id] call _say;
        };
        (_t select -1) params ["_ts", "_tname", "_tuid", "_vname"];
        _e set ["fake", []];
        _e set ["result", format [("STR_ADVSEC_tampered_the_chemical_signature_does" call ADVSEC_fnc_L), _tname, _ts, [("STR_ADVSEC_original_identity" call ADVSEC_fnc_L) + (_e getOrDefault ["name", "?"]) + ".", ""] select ((_e get "state") != "analyzed")]];
        ["ev"] call ADVSEC_fnc_dbDirty;
        [[_tuid, _tname], "evidenceTamper", format [("STR_ADVSEC_framing" call ADVSEC_fnc_L), _id, _vname]] call ADVSEC_fnc_heatAdd;
        ["evidenceAudit", _caller, [_id, _tname, _tuid]] call ADVSEC_fnc_logEvent;
        format [("STR_ADVSEC_audit_of_tampering_detected_responsible" call ADVSEC_fnc_L), _id, _tname] call _say;
    };
};
