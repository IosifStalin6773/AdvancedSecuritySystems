/*
    [acción, llamador, [categoría, dato]] (servidor) — terminal de superadministrador.
    "list" devuelve la categoría; el resto modifica las bases de datos y vuelve a listar.
    Solo superadministradores (Zeus/admin o lista ADVSEC_superAdmins). Todo queda en el registro de eventos.
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller] call ADVSEC_fnc_adminIs) exitWith {[_caller, ("STR_ADVSEC_use_the_superadmin_terminal" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
_args params [["_cat", "reports"], "_data"];
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
if (isNil "ADVSEC_jailDB") then {[] call ADVSEC_fnc_policeDBLoad};
private _esc = {[_this] call ADVSEC_fnc_repEsc};
private _say = {_this remoteExecCall ["hint", _caller]};
private _pdb = [] call ADVSEC_fnc_pdbDB;
private _online = createHashMap;
{_online set [getPlayerUID _x, _x]} forEach allPlayers;
private _nameOf = {
    params ["_k"];
    private _e = _pdb getOrDefault [_k, []];
    [_k, _e select 0] select (_e isNotEqualTo [])
};
private _log = {params ["_what", ["_target", ""]]; ["superAdmin", _caller, [_what, _target]] call ADVSEC_fnc_logEvent};
private _events = {
    private _l = localNamespace getVariable "ADVSEC_eventLog";
    if (isNil "_l") then {
        _l = +(profileNamespace getVariable [ADVSEC_repKey + "_log", []]);
        localNamespace setVariable ["ADVSEC_eventLog", _l];
    };
    _l
};
private _admins = {
    private _l = localNamespace getVariable "ADVSEC_adminList";
    if (isNil "_l") then {[] call ADVSEC_fnc_adminLoad; _l = localNamespace getVariable ["ADVSEC_adminList", []]};
    _l
};
private _saveAdmins = {
    profileNamespace setVariable [ADVSEC_repKey + "_admins", +(call _admins)];
    ["admins"] call ADVSEC_fnc_dbDirty;
    ADVSEC_superAdmins = (call _admins) + (["superAdmins", []] call ADVSEC_fnc_setting);
    publicVariable "ADVSEC_superAdmins";
};
// Rangos de la ficha: [pm, ai, global]; aplica en el acto si el jugador está conectado
private _setRanks = {
    params ["_uid", "_pm", "_ai", "_glob", "_why"];
    private _e = _pdb getOrDefault [_uid, []];
    if (_e isEqualTo []) exitWith {};
    _e set [5, _pm]; _e set [6, _ai]; _e set [7, _glob];
    (_e select 9) pushBack [call ADVSEC_fnc_now, name _caller, _why];
    ["players"] call ADVSEC_fnc_dbDirty;
    private _u = _online getOrDefault [_uid, objNull];
    if (!isNull _u) then {[_u] call ADVSEC_fnc_pdbApply};
};
private _releaseKey = {
    params ["_k"];
    private _u = _online getOrDefault [_k, objNull];
    if (isNull _u && {(_k select [0, 3]) == "AI:"}) then {_u = objectFromNetId (_k select [3])};
    if (!isNull _u) then {[_u] call ADVSEC_fnc_jailRelease} else {ADVSEC_jailDB deleteAt _k; ["jail"] call ADVSEC_fnc_policeDBSave};
};
private _docsOff = {
    params ["_k"];
    ([] call ADVSEC_fnc_docStore) deleteAt _k;
    ["docs"] call ADVSEC_fnc_dbDirty;
    private _u = _online getOrDefault [_k, objNull];
    if (!isNull _u) then {[_u] call ADVSEC_fnc_docPublish};
};

switch (_action) do {
    case "list": {};
    // --- Informes
    case "repDel": {if (!isNil {ADVSEC_repDB deleteAt _data}) then {["rep"] call ADVSEC_fnc_dbDirty; [("STR_ADVSEC_report_deleted" call ADVSEC_fnc_L), _data] call _log}};
    case "repWipe": {
        private _n = count ADVSEC_repDB;
        {ADVSEC_repDB deleteAt _x} forEach (keys ADVSEC_repDB);
        ["rep"] call ADVSEC_fnc_dbDirty;
        [format [("STR_ADVSEC_all_reports_deleted" call ADVSEC_fnc_L), _n]] call _log;
    };
    // --- Jugadores y rangos
    case "pdbStrip": {[_data, 0, 0, 0, ("STR_ADVSEC_superadmin_removes_all_ranks" call ADVSEC_fnc_L)] call _setRanks; [("STR_ADVSEC_ranks_removed" call ADVSEC_fnc_L), _data] call _log};
    case "pdbReset": {[_data, -1, -1, 0, ("STR_ADVSEC_superadmin_ranks_from_the_mission" call ADVSEC_fnc_L)] call _setRanks; [("STR_ADVSEC_ranks_restored" call ADVSEC_fnc_L), _data] call _log};
    case "pdbStripAll": {
        {[_x, 0, 0, 0, ("STR_ADVSEC_superadmin_general_rank_removal" call ADVSEC_fnc_L)] call _setRanks} forEach (keys _pdb);
        [format [("STR_ADVSEC_ranks_removed_from_everyone_records" call ADVSEC_fnc_L), count _pdb]] call _log;
    };
    case "pdbDel": {
        if (!isNil {_pdb deleteAt _data}) then {["players"] call ADVSEC_fnc_dbDirty; [("STR_ADVSEC_player_record_deleted" call ADVSEC_fnc_L), _data] call _log};
    };
    // --- Superadministradores
    case "adminToggle": {
        private _l = call _admins;
        if (_data in _l) then {_l deleteAt (_l find _data); [("STR_ADVSEC_superadmin_removed" call ADVSEC_fnc_L), _data] call _log} else {_l pushBack _data; [("STR_ADVSEC_superadmin_granted" call ADVSEC_fnc_L), _data] call _log};
        call _saveAdmins;
    };
    case "adminDel": {
        private _l = call _admins;
        if (_data in _l) then {_l deleteAt (_l find _data); call _saveAdmins; [("STR_ADVSEC_superadmin_removed" call ADVSEC_fnc_L), _data] call _log} else {
            ("STR_ADVSEC_that_steamid_comes_from_the" call ADVSEC_fnc_L) call _say;
        };
    };
    // --- Buscados
    case "wantedDel": {ADVSEC_wantedDB deleteAt _data; ["wanted"] call ADVSEC_fnc_policeDBSave; [("STR_ADVSEC_warrant_withdrawn" call ADVSEC_fnc_L), _data] call _log};
    case "wantedWipe": {
        {ADVSEC_wantedDB deleteAt _x} forEach (keys ADVSEC_wantedDB);
        ["wanted"] call ADVSEC_fnc_policeDBSave;
        [("STR_ADVSEC_wanted_list_cleared" call ADVSEC_fnc_L)] call _log;
    };
    // --- Detenidos
    case "jailDel": {[_data] call _releaseKey; [("STR_ADVSEC_detainee_released" call ADVSEC_fnc_L), _data] call _log};
    case "jailWipe": {{[_x] call _releaseKey} forEach (keys ADVSEC_jailDB); [("STR_ADVSEC_all_detainees_released" call ADVSEC_fnc_L)] call _log};
    // --- Multas
    case "fineDel": {
        _data params ["_k", "_id"];
        private _db = [] call ADVSEC_fnc_fineDB;
        private _l = (_db getOrDefault [_k, []]) select {(_x select 0) isNotEqualTo _id};
        if (_l isEqualTo []) then {_db deleteAt _k} else {_db set [_k, _l]};
        ["fines"] call ADVSEC_fnc_dbDirty;
        [("STR_ADVSEC_fine_deleted" call ADVSEC_fnc_L), _id] call _log;
    };
    case "fineWipe": {
        private _db = [] call ADVSEC_fnc_fineDB;
        {_db deleteAt _x} forEach (keys _db);
        ["fines"] call ADVSEC_fnc_dbDirty;
        [("STR_ADVSEC_all_fines_deleted" call ADVSEC_fnc_L)] call _log;
    };
    // --- Pruebas
    case "evDel": {([] call ADVSEC_fnc_evDB) deleteAt _data; ["ev"] call ADVSEC_fnc_dbDirty; [("STR_ADVSEC_evidence_deleted" call ADVSEC_fnc_L), _data] call _log};
    case "evWipe": {
        private _db = [] call ADVSEC_fnc_evDB;
        {_db deleteAt _x} forEach (keys _db);
        ["ev"] call ADVSEC_fnc_dbDirty;
        [("STR_ADVSEC_all_evidence_deleted" call ADVSEC_fnc_L)] call _log;
    };
    // --- Sospecha (AA.II.)
    case "heatDel": {([] call ADVSEC_fnc_heatDB) deleteAt _data; ["heat"] call ADVSEC_fnc_dbDirty; [("STR_ADVSEC_suspicion_index_archived" call ADVSEC_fnc_L), _data] call _log};
    case "heatWipe": {
        private _db = [] call ADVSEC_fnc_heatDB;
        {_db deleteAt _x} forEach (keys _db);
        ["heat"] call ADVSEC_fnc_dbDirty;
        [("STR_ADVSEC_all_suspicion_indexes_archived" call ADVSEC_fnc_L)] call _log;
    };
    // --- Documentos
    case "docDel": {[_data] call _docsOff; [("STR_ADVSEC_documents_revoked" call ADVSEC_fnc_L), _data] call _log};
    case "docWipe": {{[_x] call _docsOff} forEach (keys ([] call ADVSEC_fnc_docStore)); [("STR_ADVSEC_all_documents_revoked" call ADVSEC_fnc_L)] call _log};
    // --- Economía
    case "ecoAdd": {
        _data params ["_uid", "_v"];
        _v params [["_where", "bank"], ["_n", "0"]];
        _n = round parseNumber _n;
        private _a = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_uid, []];
        if (_a isEqualTo [] || {_n == 0}) exitWith {};
        private _u = _online getOrDefault [_uid, objNull];
        if (_where == "cash" && {!isNull _u}) then {[_u, ([_u] call ADVSEC_fnc_ecoCash) + _n] call ADVSEC_fnc_ecoSetCash} else {
            if (_where == "cash") then {_a set [0, ((_a select 0) + _n) max 0]} else {_a set [1, ((_a select 1) + _n) max 0]};
        };
        [_a, ("STR_ADVSEC_administrative_adjustment" call ADVSEC_fnc_L), _n] call ADVSEC_fnc_ecoHist;
        if (!isNull _u) then {[_u] call ADVSEC_fnc_ecoPush};
        [format [("STR_ADVSEC_money" call ADVSEC_fnc_L), ["banco", "efectivo"] select (_where == "cash"), _n], _uid] call _log;
    };
    case "ecoZero": {
        private _a = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_data, []];
        if (_a isEqualTo []) exitWith {};
        _a set [0, 0]; _a set [1, 0];
        [_a, ("STR_ADVSEC_balance_reset_to_zero_by" call ADVSEC_fnc_L), 0] call ADVSEC_fnc_ecoHist;
        private _u = _online getOrDefault [_data, objNull];
        if (!isNull _u) then {[_u, 0] call ADVSEC_fnc_ecoSetCash; [_u] call ADVSEC_fnc_ecoPush};
        [("STR_ADVSEC_account_reset_to_zero" call ADVSEC_fnc_L), _data] call _log;
    };
    case "ecoDel": {
        ([] call ADVSEC_fnc_ecoDB) deleteAt _data;
        ["eco"] call ADVSEC_fnc_dbDirty;
        private _u = _online getOrDefault [_data, objNull];
        if (!isNull _u) then {[_u] call ADVSEC_fnc_ecoPush};
        [("STR_ADVSEC_account_deleted" call ADVSEC_fnc_L), _data] call _log;
    };
    case "ecoWipe": {
        private _db = [] call ADVSEC_fnc_ecoDB;
        {(_db get _x) set [0, 0]; (_db get _x) set [1, 0]} forEach (keys _db);
        ["eco"] call ADVSEC_fnc_dbDirty;
        {[_x, 0] call ADVSEC_fnc_ecoSetCash; [_x] call ADVSEC_fnc_ecoPush} forEach (values _online);
        [("STR_ADVSEC_all_accounts_reset_to_zero" call ADVSEC_fnc_L)] call _log;
    };
    case "treasurySet": {
        _data params ["", "_v"];
        private _n = round parseNumber (_v param [0, "0"]);
        [] call ADVSEC_fnc_ecoDB;
        [_n - ([] call ADVSEC_fnc_ecoTreasuryNow), ("STR_ADVSEC_administrative_adjustment" call ADVSEC_fnc_L)] call ADVSEC_fnc_ecoTreasury;
        [format [("STR_ADVSEC_treasury_set_to" call ADVSEC_fnc_L), _n]] call _log;
    };
    // --- Registro de eventos
    case "logWipe": {
        private _l = call _events;
        private _n = count _l;
        _l resize 0;
        ["log"] call ADVSEC_fnc_dbDirty;
        [format [("STR_ADVSEC_event_log_cleared_entries" call ADVSEC_fnc_L), _n]] call _log;
    };
    default {};
};

// --- Listado de la categoría
private _rows = [];
private _info = "";
switch (_cat) do {
    case "reports": {
        private _l = [];
        {_l pushBack [_y getOrDefault ["created", ""], _x]} forEach ADVSEC_repDB;
        _l sort false;
        {
            private _r = ADVSEC_repDB get (_x select 1);
            _rows pushBack [format ["%1 · %2", _r get "id", _r getOrDefault ["title", ""]], _r get "id",
                format [("STR_ADVSEC_form_status_author_date_involved" call ADVSEC_fnc_L),
                    (_r getOrDefault ["title", ""]) call _esc, _r get "id", _r getOrDefault ["type", ""], _r getOrDefault ["status", ""], _r getOrDefault ["gravity", ""],
                    (_r getOrDefault ["author", ""]) call _esc, _r getOrDefault ["created", ""], ((_r getOrDefault ["subjects", []]) joinString ", ") call _esc], []];
        } forEach _l;
        _info = format [("STR_ADVSEC_archived_reports_and_case_files" call ADVSEC_fnc_L), count _rows];
    };
    case "players": {
        {
            _y params ["_name", "", "", "_last", "", "_pm", "_ai", "_glob"];
            private _adm = _x in (missionNamespace getVariable ["ADVSEC_superAdmins", []]);
            _rows pushBack [format [("STR_ADVSEC_mp_ia" call ADVSEC_fnc_L), ["", "★ "] select _adm, _name, [[5, _pm] call ADVSEC_fnc_pdbRankName, "—"] select (_pm == 0), [[6, _ai] call ADVSEC_fnc_pdbRankName, "—"] select (_ai == 0), [7, _glob] call ADVSEC_fnc_pdbRankName], _x,
                format [("STR_ADVSEC_steamid_last_connection_mp_rank" call ADVSEC_fnc_L),
                    _name call _esc, ["", ("STR_ADVSEC_online_3" call ADVSEC_fnc_L)] select (_x in _online), _x, _last,
                    [5, _pm] call ADVSEC_fnc_pdbRankName, [6, _ai] call ADVSEC_fnc_pdbRankName, [7, _glob] call ADVSEC_fnc_pdbRankName,
                    ["", ("STR_ADVSEC_superadmin_3" call ADVSEC_fnc_L)] select _adm], [[], [0.82, 0.64, 0.19, 1]] select _adm];
        } forEach _pdb;
        _info = format [("STR_ADVSEC_registered_players_superadmin" call ADVSEC_fnc_L), count _rows];
    };
    case "admins": {
        private _mine = call _admins;
        {
            private _fromMission = !(_x in _mine);
            _rows pushBack [format ["%1 · %2%3", [_x] call _nameOf, _x, [" ", ("STR_ADVSEC_mission" call ADVSEC_fnc_L)] select _fromMission], _x,
                format [("STR_ADVSEC_steamid_source" call ADVSEC_fnc_L), _x, [("STR_ADVSEC_granted_from_this_terminal" call ADVSEC_fnc_L), ("STR_ADVSEC_mission_superadmins_list" call ADVSEC_fnc_L)] select _fromMission], []];
        } forEach (missionNamespace getVariable ["ADVSEC_superAdmins", []]);
        _info = ("STR_ADVSEC_besides_this_list_zeus_and" call ADVSEC_fnc_L);
    };
    case "wanted": {
        {
            _y params ["_name", "_reason", "_level", "_by", "_date"];
            _rows pushBack [format ["%1 · %2", _name, _level], _x, format [("STR_ADVSEC_steamid_reason_danger_level_declared" call ADVSEC_fnc_L), _name call _esc, _x, _reason call _esc, _level, _by call _esc, _date], []];
        } forEach ADVSEC_wantedDB;
        _info = format [("STR_ADVSEC_active_warrants" call ADVSEC_fnc_L), count _rows];
    };
    case "jail": {
        {
            _y params ["_secs", "_reason", "_name", "_by", "_jname"];
            _rows pushBack [format ["%1 · %2", _name, _jname], _x, format [("STR_ADVSEC_key_facility_reason_arrested_by" call ADVSEC_fnc_L), _name call _esc, _x, _jname call _esc, _reason call _esc, _by call _esc, [("STR_ADVSEC_until_further_notice" call ADVSEC_fnc_L), format ["%1 min", round (_secs / 60)]] select (_secs < 1e6)], []];
        } forEach ADVSEC_jailDB;
        _info = format [("STR_ADVSEC_detainees_2" call ADVSEC_fnc_L), count _rows];
    };
    case "fines": {
        {
            private _k = _x;
            {
                _x params ["_id", "_date", "_amt", "_reason", "_off", "", "_state", ["_name", ""]];
                _rows pushBack [format ["%1 · %2 · %3 %4 · %5", _id, [_name, [_k] call _nameOf] select (_name isEqualTo ""), _amt, ["currency", "€"] call ADVSEC_fnc_setting, _state], [_k, _id],
                    format [("STR_ADVSEC_holder_amount_reason_officer_date" call ADVSEC_fnc_L), _id, _k, _amt, _reason call _esc, _off call _esc, _date, _state], []];
            } forEach _y;
        } forEach ([] call ADVSEC_fnc_fineDB);
        _info = format [("STR_ADVSEC_registered_fines" call ADVSEC_fnc_L), count _rows];
    };
    case "evidence": {
        {
            _rows pushBack [format ["%1 · %2", [_y] call ADVSEC_fnc_evSummary, _y get "state"], _x,
                format [("STR_ADVSEC_status_custody_grid_date_result" call ADVSEC_fnc_L), [_y] call ADVSEC_fnc_evSummary, _y get "state", (_y getOrDefault ["holderName", ""]) call _esc, _y getOrDefault ["grid", ""], _y getOrDefault ["time", ""], (_y getOrDefault ["result", ""]) call _esc], []];
        } forEach ([] call ADVSEC_fnc_evDB);
        _info = format [("STR_ADVSEC_evidence_in_the_database" call ADVSEC_fnc_L), count _rows];
    };
    case "heat": {
        {
            _y params ["_heat", "", "", ["_name", ""], ["_case", ""]];
            _rows pushBack [format ["%1 · %2 pts%3", _name, round _heat, [" · " + _case, ""] select (_case isEqualTo "")], _x, format [("STR_ADVSEC_steamid_index_case_file" call ADVSEC_fnc_L), _name call _esc, _x, round _heat, ["ninguno", _case] select (_case isNotEqualTo "")], []];
        } forEach ([] call ADVSEC_fnc_heatDB);
        _info = format [("STR_ADVSEC_officers_with_a_suspicion_index" call ADVSEC_fnc_L), count _rows];
    };
    case "docs": {
        {
            _rows pushBack [format [("STR_ADVSEC_document_s" call ADVSEC_fnc_L), [_x] call _nameOf, count _y], _x,
                format [("STR_ADVSEC_key" call ADVSEC_fnc_L), ([_x] call _nameOf) call _esc, _x, (_y apply {format ["%1 · %2", _x get "type", _x getOrDefault ["number", ""]]}) joinString "<br/>"], []];
        } forEach ([] call ADVSEC_fnc_docStore);
        _info = format [("STR_ADVSEC_holders_with_documents" call ADVSEC_fnc_L), count _rows];
    };
    case "economy": {
        private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
        {
            _y params ["_cash", "_bank", "_name", "_hist"];
            private _u = _online getOrDefault [_x, objNull];
            if (!isNull _u) then {_cash = [_u] call ADVSEC_fnc_ecoCash};
            _rows pushBack [format [("STR_ADVSEC_cash_bank" call ADVSEC_fnc_L), _name, _cash, _bank], _x,
                format [("STR_ADVSEC_steamid_cash_bank" call ADVSEC_fnc_L), _name call _esc, ["", ("STR_ADVSEC_online_3" call ADVSEC_fnc_L)] select (!isNull _u), _x, _cash, _bank, _cur,
                    ((_hist select [((count _hist) - 10) max 0]) apply {format ["%1 · %2 · %3", _x select 0, (_x select 1) call _esc, _x select 2]}) joinString "<br/>"], []];
        } forEach ([] call ADVSEC_fnc_ecoDB);
        _info = format [("STR_ADVSEC_accounts_mp_treasury" call ADVSEC_fnc_L), count _rows, [] call ADVSEC_fnc_ecoTreasuryNow, _cur];
    };
    case "log": {
        private _l = call _events;
        private _from = (count _l - 300) max 0;
        for "_i" from (count _l - 1) to _from step -1 do {
            (_l select _i) params ["_date", "", "_type", "_name", "_uid", "_grid", "_d"];
            _rows pushBack [format ["%1 · %2 · %3", _date, _type, _name], _i, format [("STR_ADVSEC_author_grid" call ADVSEC_fnc_L), _type, _date, _name call _esc, _uid, _grid, (str _d) call _esc], []];
        };
        _info = format [("STR_ADVSEC_event_log_entries_showing_the" call ADVSEC_fnc_L), count _l];
    };
};
[_cat, _info, _rows] remoteExecCall ["ADVSEC_fnc_adminSet", _caller];
