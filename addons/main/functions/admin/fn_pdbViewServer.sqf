/*
    ["list" | "player" | "edit", llamador, args] (servidor) — base de datos de jugadores del superadministrador.
    "list": todas las fichas -> ADVSEC_fnc_pdbViewSet ["list", filas].
    "player": todas las secciones de un SteamID -> ADVSEC_fnc_pdbViewSet ["player", datos].
    "edit": [SteamID, operación, dato] -> cambia la ficha y reenvía "list" y "player".
    Cada sección: [cabeceras, filas]; cada fila: [celdas, detalle, clave]. Los textos llegan sin escapar: el cliente los escapa.
    Solo superadministradores.
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller] call ADVSEC_fnc_adminIs) exitWith {[_caller, ("STR_ADVSEC_view_the_player_database" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
if (isNil "ADVSEC_jailDB") then {[] call ADVSEC_fnc_policeDBLoad};

private _pdb = [] call ADVSEC_fnc_pdbDB;
private _online = createHashMap;
{_online set [getPlayerUID _x, _x]} forEach allPlayers;
private _admins = missionNamespace getVariable ["ADVSEC_superAdmins", []];
private _currency = ["currency", "€"] call ADVSEC_fnc_setting;

private _rank = {[_this select 0, _this select 1] call ADVSEC_fnc_pdbRankName};

switch (_action) do {
    case "list": {
        private _rows = [];
        {
            private _uid = _x;
            _y params ["_name", "", "", "_last", "", "_pm", "_ai", "_glob"];
            private _on = _uid in _online;
            private _adm = _uid in _admins;
            private _mark = "";
            if (_on) then {_mark = "● "};
            if (_adm) then {_mark = _mark + "★ "};
            _rows pushBack [_uid, [_mark + _name, [5, _pm] call _rank, [6, _ai] call _rank, [7, _glob] call _rank, _last], _on, _adm, _pm, _ai, _glob];
        } forEach _pdb;
        _rows = [_rows, [], {toLower ((_x select 1) select 0)}, "ASCEND"] call BIS_fnc_sortBy;
        ["list", _rows] remoteExecCall ["ADVSEC_fnc_pdbViewSet", _caller];
    };

    case "player": {
        private _uid = _args param [0, ""];
        private _e = _pdb getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {["player", []] remoteExecCall ["ADVSEC_fnc_pdbViewSet", _caller]};
        _e params ["_name", "_alias", "_first", "_seen", "_visits", "_pm", "_ai", "_glob", "_notes", "_hist", "_mins"];
        private _u = _online getOrDefault [_uid, objNull];
        private _on = !isNull _u;
        private _adm = _uid in _admins;

        // Saldo, multas y conteos para las tarjetas
        private _eco = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_uid, [0, 0, "", []]];
        private _cash = _eco select 0;
        if (_on) then {_cash = [_u] call ADVSEC_fnc_ecoCash};
        private _fines = ([] call ADVSEC_fnc_fineDB) getOrDefault [_uid, []];
        private _debt = 0;
        {if ((_x select 6) == "Pendiente") then {_debt = _debt + (_x select 2)}} forEach _fines;
        private _wanted = ADVSEC_wantedDB getOrDefault [_uid, []];
        private _jail = ADVSEC_jailDB getOrDefault [_uid, []];
        private _plates = [] call ADVSEC_fnc_plateDB;
        private _wpns = [] call ADVSEC_fnc_wpnDB;
        private _myPlates = (keys _plates) select {((_plates get _x) select 1) == _uid};
        private _myWpns = (keys _wpns) select {((_wpns get _x) select 1) == _uid};

        // 1. Resumen
        private _ecoBank = _eco select 1;
        private _res = [
            [("STR_ADVSEC_name" call ADVSEC_fnc_L), _name],
            [("STR_ADVSEC_previous_names" call ADVSEC_fnc_L), _alias joinString ", "],
            ["SteamID", _uid],
            [("STR_ADVSEC_status" call ADVSEC_fnc_L), [("STR_ADVSEC_offline" call ADVSEC_fnc_L), ("STR_ADVSEC_online_2" call ADVSEC_fnc_L)] select _on],
            [("STR_ADVSEC_superadmin_4" call ADVSEC_fnc_L), ["No", ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select _adm, "admin"],
            [("STR_ADVSEC_mp_rank" call ADVSEC_fnc_L), [5, _pm] call _rank, "profile"],
            [("STR_ADVSEC_ia_rank" call ADVSEC_fnc_L), [6, _ai] call _rank, "profile"],
            [("STR_ADVSEC_global_rank" call ADVSEC_fnc_L), [7, _glob] call _rank, "profile"],
            [("STR_ADVSEC_first_connection" call ADVSEC_fnc_L), _first],
            [("STR_ADVSEC_last_connection" call ADVSEC_fnc_L), _seen],
            [("STR_ADVSEC_connections" call ADVSEC_fnc_L), str _visits],
            [("STR_ADVSEC_time_played_2" call ADVSEC_fnc_L), format ["%1 h %2 min", floor (_mins / 60), _mins mod 60]],
            [("STR_ADVSEC_cash" call ADVSEC_fnc_L), format ["%1 %2", _cash, _currency], "money"],
            [("STR_ADVSEC_bank" call ADVSEC_fnc_L), format ["%1 %2", _ecoBank, _currency], "money"],
            [("STR_ADVSEC_pending_fines" call ADVSEC_fnc_L), format ["%1 %2", _debt, _currency], "fines"],
            [("STR_ADVSEC_wanted_3" call ADVSEC_fnc_L), ["No", format [("STR_ADVSEC_yes_2" call ADVSEC_fnc_L), _wanted select 2]] select (_wanted isNotEqualTo []), "wanted"],
            [("STR_ADVSEC_detained" call ADVSEC_fnc_L), ["No", ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select (_jail isNotEqualTo []), "jail"],
            [("STR_ADVSEC_registered_vehicles" call ADVSEC_fnc_L), str (count _myPlates)],
            [("STR_ADVSEC_registered_weapons" call ADVSEC_fnc_L), str (count _myWpns)],
            [("STR_ADVSEC_notes" call ADVSEC_fnc_L), _notes, "profile"]
        ];
        // Taquilla personal (TS_Lockers integrado)
        if (!isNil "TSL_uidMap") then {
            private _lk = TSL_uidMap getOrDefault [_uid, objNull];
            _res pushBack [("STR_ADVSEC_locker" call ADVSEC_fnc_L), [("STR_ADVSEC_no_locker_assigned" call ADVSEC_fnc_L), format [("STR_ADVSEC_assigned_grid" call ADVSEC_fnc_L), mapGridPosition _lk]] select !isNull _lk, "locker"];
        };
        private _resRows = _res apply {[[_x select 0, _x select 1], _x select 1, ["sum", _x param [2, ""]]]};

        // 2. Documentos (documentos, matrículas y armas)
        private _docRows = [];
        {
            private _d = _x;
            private _di = _forEachIndex;
            _docRows pushBack [[_d getOrDefault ["type", ""], _d getOrDefault ["number", ""], str (_d getOrDefault ["clearance", ""]), _d getOrDefault ["expires", ("STR_ADVSEC_no_expiry" call ADVSEC_fnc_L)]],
                format [("STR_ADVSEC_type_number_level_expires" call ADVSEC_fnc_L), _d getOrDefault ["type", ""], _d getOrDefault ["number", ""], _d getOrDefault ["clearance", ""], _d getOrDefault ["expires", ("STR_ADVSEC_no_expiry" call ADVSEC_fnc_L)]], ["doc", _di, _d getOrDefault ["number", ""], _d getOrDefault ["clearance", 0], _d getOrDefault ["expires", ""], _d getOrDefault ["type", ""]]];
        } forEach (([] call ADVSEC_fnc_docStore) getOrDefault [_uid, []]);
        {
            private _p = _plates get _x;
            _docRows pushBack [[("STR_ADVSEC_vehicle" call ADVSEC_fnc_L), _x, "—", _p select 0], format [("STR_ADVSEC_plate_owner_since" call ADVSEC_fnc_L), _x, _p select 0, _p select 2, _p select 3, ["", ("STR_ADVSEC_reported_stolen" call ADVSEC_fnc_L)] select (_p select 4)], ["plate", _x, _p select 4]];
        } forEach _myPlates;
        {
            private _w = _wpns get _x;
            _docRows pushBack [[("STR_ADVSEC_weapon" call ADVSEC_fnc_L), _x, "—", _w select 0], format [("STR_ADVSEC_weapon_registered_on" call ADVSEC_fnc_L), _x, _w select 0, _w select 3], ["wpn", _x]];
        } forEach _myWpns;

        // 3. Sanciones: multas, buscados y detenciones
        private _sanRows = [];
        {
            _x params ["_id", "_date", "_amt", "_reason", "_off", "", "_state"];
            _sanRows pushBack [[("STR_ADVSEC_fine_3" call ADVSEC_fnc_L), _date, format ["%1 %2", _amt, _currency], _reason select [0, 48], _state], format [("STR_ADVSEC_fine_officer" call ADVSEC_fnc_L), _id, _amt, _currency, _off, _state, _reason], ["fine", _id, _state, _amt, _reason]];
        } forEach _fines;
        if (_wanted isNotEqualTo []) then {
            _wanted params ["_wn", "_wreason", "_wlevel", "_wby", "_wdate"];
            _sanRows pushBack [[("STR_ADVSEC_wanted_3" call ADVSEC_fnc_L), _wdate, format [("STR_ADVSEC_level" call ADVSEC_fnc_L), _wlevel call ADVSEC_fnc_Lv], _wreason, ("STR_ADVSEC_active" call ADVSEC_fnc_L)], format [("STR_ADVSEC_warrant_declared_by" call ADVSEC_fnc_L), _wby], ["wanted", _wreason, _wlevel]];
        };
        if (_jail isNotEqualTo []) then {
            _jail params ["_secs", "_jreason", "_jn", "_jby", "_jname"];
            private _cond = [("STR_ADVSEC_until_further_notice" call ADVSEC_fnc_L), format ["%1 min", round (_secs / 60)]] select (_secs < 1e6);
            _sanRows pushBack [[("STR_ADVSEC_arrest" call ADVSEC_fnc_L), "—", _cond, _jreason, _jname], format [("STR_ADVSEC_detained_at_by" call ADVSEC_fnc_L), _jname, _jby], ["jail", [round (_secs / 60), -1] select (_secs >= 1e6), _jreason]];
        };

        // 4. Informes en los que aparece (autor o implicado)
        private _repRows = [];
        {
            private _r = _y;
            private _isAuthor = (_r getOrDefault ["authorUid", ""]) == _uid;
            if (_isAuthor || {_uid in (_r getOrDefault ["subjects", []])}) then {
                _repRows pushBack [[_r getOrDefault ["id", ""], _r getOrDefault ["created", ""], _r getOrDefault ["title", ""], [("STR_ADVSEC_involved" call ADVSEC_fnc_L), ("STR_ADVSEC_author" call ADVSEC_fnc_L)] select _isAuthor],
                    format [("STR_ADVSEC_status_severity_author" call ADVSEC_fnc_L), _r getOrDefault ["id", ""], _r getOrDefault ["title", ""], (_r getOrDefault ["status", ""] call ADVSEC_fnc_Lv), (_r getOrDefault ["gravity", ""] call ADVSEC_fnc_Lv), _r getOrDefault ["author", ""]], ["rep", _r getOrDefault ["id", ""], _r getOrDefault ["title", ""], (_r getOrDefault ["status", ""] call ADVSEC_fnc_Lv), (_r getOrDefault ["gravity", ""] call ADVSEC_fnc_Lv)]];
            };
        } forEach ADVSEC_repDB;

        // 5. Sospecha (AA.II.)
        private _heat = ([] call ADVSEC_fnc_heatDB) getOrDefault [_uid, []];
        private _heatRows = [];
        if (_heat isNotEqualTo []) then {
            _heat params ["_pts", "", "_evs", "", ["_case", ""]];
            {
                _x params ["_d", "_m", "_p"];
                _heatRows pushBack [[_d, _m, str _p], format [("STR_ADVSEC_points_2" call ADVSEC_fnc_L), _p, _m], ["heat", round (_heat select 0)]];
            } forEach _evs;
            _heatRows = [[["—", format [("STR_ADVSEC_current_index_case_file" call ADVSEC_fnc_L), ["ninguno", _case] select (_case isNotEqualTo "")], str round _pts], format [("STR_ADVSEC_current_index_case_file_2" call ADVSEC_fnc_L), round _pts, ["ninguno", _case] select (_case isNotEqualTo "")], ["heat", round _pts]]] + _heatRows;
        };

        // 6. Evidencias: recogidas por el jugador o en su custodia
        private _evRows = [];
        {
            private _ev = _y;
            if (((_ev getOrDefault ["uid", ""]) == _uid) || {(_ev getOrDefault ["holder", ""]) == _uid}) then {
                _evRows pushBack [[_x, _ev getOrDefault ["type", ""], _ev getOrDefault ["state", ""], _ev getOrDefault ["holderName", ""], _ev getOrDefault ["result", ""]],
                    format [("STR_ADVSEC_source_grid" call ADVSEC_fnc_L), _x, _ev getOrDefault ["type", ""], _ev getOrDefault ["name", ""], _ev getOrDefault ["grid", ""], _ev getOrDefault ["time", ""]], ["ev", _x, _ev getOrDefault ["state", ""], _ev getOrDefault ["result", ""]]];
            };
        } forEach ([] call ADVSEC_fnc_evDB);

        // 7. Economía: últimos movimientos
        private _ecoRows = [];
        private _hist = _eco select 3;
        for "_i" from ((count _hist) - 1) to (((count _hist) - 60) max 0) step -1 do {
            (_hist select _i) params ["_hd", "_ht", "_ha"];
            _ecoRows pushBack [[_hd, _ht, str _ha], format ["%1 · %2 · %3 %4", _hd, _ht, _ha, _currency]];
        };
        _ecoRows = [[["—", ("STR_ADVSEC_current_balance_cash_bank" call ADVSEC_fnc_L), format ["%1 / %2", _cash, _eco select 1]], format [("STR_ADVSEC_cash_bank_2" call ADVSEC_fnc_L), _cash, _eco select 1, _currency], ["sum", "money"]]] + _ecoRows;

        // 8. Especialidades
        private _specRows = [];
        private _specDB = [] call ADVSEC_fnc_specDB;
        {
            private _sid = _x;
            _y params ["_mem", "_man", "_req", ""];
            if (_uid in _mem) then {_specRows pushBack [[_sid, ("STR_ADVSEC_member" call ADVSEC_fnc_L), ""], format [("STR_ADVSEC_specialty_member" call ADVSEC_fnc_L), _sid], ["spec", _sid, 0]]};
            if (_uid in _man) then {_specRows pushBack [[_sid, ("STR_ADVSEC_manager" call ADVSEC_fnc_L), ""], format [("STR_ADVSEC_specialty_manager" call ADVSEC_fnc_L), _sid], ["spec", _sid, 1]]};
            {
                _x params ["_ru", "_rn", "_rd"];
                if (_ru == _uid) then {_specRows pushBack [[_sid, ("STR_ADVSEC_request" call ADVSEC_fnc_L), _rd], format [("STR_ADVSEC_request_for_from" call ADVSEC_fnc_L), _sid, _rd, _rn], ["spec", _sid, 2]]};
            } forEach _req;
        } forEach _specDB;

        // 9. Registro: eventos del servidor y visionados de bodycam
        private _logRows = [];
        private _log = localNamespace getVariable ["ADVSEC_eventLog", nil];
        if (isNil "_log") then {_log = +(profileNamespace getVariable [ADVSEC_repKey + "_log", []])};
        {
            _x params ["_ld", "", "_lt", "_ln", "_lu", "_lg", "_lx"];
            if (_lu == _uid || {(str _lx) find _uid > -1}) then {
                _logRows pushBack [[_ld, _lt, _ln], format [("STR_ADVSEC_grid" call ADVSEC_fnc_L), _ld, _lt, _ln, _lg, str _lx]];
            };
        } forEach _log;
        private _bodyRec = ([] call ADVSEC_fnc_bodyDB) getOrDefault [_uid, ["", []]];
        {
            _x params ["_bd", "_bt", "_bg", "_bx"];
            _logRows pushBack [[_bd, "Bodycam: " + _bt, _name], format [("STR_ADVSEC_bodycam_grid" call ADVSEC_fnc_L), _bd, _bt, _bg, str _bx]];
        } forEach (_bodyRec select 1);
        _logRows = [_logRows, [], {(_x select 0) select 0}, "DESCEND"] call BIS_fnc_sortBy;
        if (count _logRows > 150) then {_logRows resize 150};

        // 10. PMC: célula, QRF, deuda y material de la armería, contratos, equipo de taquilla y alertas ciber
        private _pmcRows = [];
        private _cell = ([] call ADVSEC_fnc_cellDB) getOrDefault [_uid, []];
        private _qrf = (localNamespace getVariable ["ADVSEC_qrfStats", createHashMap]) getOrDefault [_uid, []];
        private _roleTxt = {[(format ["STR_ADVSEC_pmc_role_%1", _this]) call ADVSEC_fnc_L, ("STR_ADVSEC_pmc_role_none" call ADVSEC_fnc_L)] select (_this isEqualTo "")};
        if (_cell isEqualTo []) then {
            _pmcRows pushBack [[("STR_ADVSEC_pdb_cell" call ADVSEC_fnc_L), "" call _roleTxt, "—", ""], ("STR_ADVSEC_pdb_cell_none" call ADVSEC_fnc_L), ["cell", "", ""]];
        } else {
            _cell params ["_cr", "", "_cs", ["_cav", 0], ["_cdt", 0]];
            private _pct = round (100 * _cav / (_cdt max 1));
            _pmcRows pushBack [[("STR_ADVSEC_pdb_cell" call ADVSEC_fnc_L), _cr call _roleTxt, _cs call ADVSEC_fnc_Lv, (str _pct) + " %"],
                format [("STR_ADVSEC_pdb_cell_det" call ADVSEC_fnc_L), _cr call _roleTxt, _cs call ADVSEC_fnc_Lv, _pct], ["cell", _cr, _cs]];
        };
        if (_qrf isNotEqualTo []) then {
            _qrf params [["_qn", 0], ["_qs", 0], ["_qb", 0], ["_qi", 0]];
            private _avg = [[_qs / (_qn max 1), "MM:SS"] call BIS_fnc_secondsToString, "—"] select (_qn == 0);
            _pmcRows pushBack [["QRF", format [("STR_ADVSEC_pdb_qrf_n" call ADVSEC_fnc_L), _qn], _avg, format ["%1 %2", _qb, _currency]],
                format [("STR_ADVSEC_pdb_qrf_det" call ADVSEC_fnc_L), _qn, _avg, _qb, _currency, _qi], ["qrf"]];
        };
        private _adebt = (localNamespace getVariable ["ADVSEC_armDebts", createHashMap]) getOrDefault [_uid, [0, []]];
        _pmcRows pushBack [[("STR_ADVSEC_pdb_debt" call ADVSEC_fnc_L), format ["%1 %2", _adebt select 0, _currency], "", (_adebt select 1) joinString ", "],
            format [("STR_ADVSEC_pdb_debt_det" call ADVSEC_fnc_L), _adebt select 0, _currency, [(_adebt select 1) joinString ", ", "—"] select ((_adebt select 1) isEqualTo [])], ["debt", _adebt select 0]];
        {
            private _we = _y;
            if ((_we param [4, ""]) == "CORP" && {(_we select 1) == _uid || {((_we select 6) param [0, ""]) == _uid}}) then {
                private _wn = getText (configFile >> "CfgWeapons" >> (_we select 0) >> "displayName");
                _pmcRows pushBack [[("STR_ADVSEC_pdb_corp" call ADVSEC_fnc_L), format ["%1 · %2", _x, _wn], (_we select 5) call ADVSEC_fnc_Lv, (str round ((_we select 7) * 100)) + " %"],
                    format [("STR_ADVSEC_pdb_corp_det" call ADVSEC_fnc_L), _x, _wn, (_we select 5) call ADVSEC_fnc_Lv, round ((_we select 7) * 100), (_we select 6) param [1, "—"], (_we select 6) param [2, "—"], (_we select 8), _currency,
                        ((_we select 9) apply {format ["%1 · %2", _x select 0, _x select 1]}) joinString "<br/>"], ["corp", _x, _we select 5, round ((_we select 7) * 100)]];
            };
        } forEach _wpns;
        {
            private _cc = _y;
            private _isSig = ((_cc get "signer") param [0, ""]) == _uid;
            if (_isSig || {((_cc get "assigned") findIf {(_x select 0) == _uid}) >= 0}) then {
                _pmcRows pushBack [[("STR_ADVSEC_pdb_ctr" call ADVSEC_fnc_L), format ["%1 · %2", _x, _cc get "title"], (_cc get "state") call ADVSEC_fnc_Lv, [("STR_ADVSEC_pdb_assigned" call ADVSEC_fnc_L), ("STR_ADVSEC_pdb_signer" call ADVSEC_fnc_L)] select _isSig],
                    format [("STR_ADVSEC_pdb_ctr_det" call ADVSEC_fnc_L), _x, _cc get "title", (_cc get "state") call ADVSEC_fnc_Lv, _cc get "created", [_cc get "end", "—"] select ((_cc get "end") isEqualTo ""), _cc get "result"],
                    ["ctr", _x, _cc get "state", _cc get "title"]];
            };
        } forEach ([] call ADVSEC_fnc_ctrDB);
        private _lk = (localNamespace getVariable ["ADVSEC_lkitDB", createHashMap]) getOrDefault [_uid, []];
        if (_lk isEqualTo [] && {isNil {localNamespace getVariable "ADVSEC_lkitDB"}}) then {
            _lk = ((profileNamespace getVariable [ADVSEC_repKey + "_lkit", []]) select {(_x select 0) == _uid}) apply {_x select 1};
            _lk = _lk param [0, []];
        };
        if (_lk isNotEqualTo []) then {
            _pmcRows pushBack [[("STR_ADVSEC_pdb_lkit" call ADVSEC_fnc_L), _lk select 0, "", ""], format [("STR_ADVSEC_pdb_lkit_det" call ADVSEC_fnc_L), _lk select 0], ["lkit"]];
        };
        {
            _x params ["_ad", "", "_at", "_an", "_au", "_ag", "_atx", "_ast"];
            if (_au == _uid) then {
                _pmcRows pushBack [[("STR_ADVSEC_pdb_cy" call ADVSEC_fnc_L), _ad, _ast call ADVSEC_fnc_Lv, _atx], format ["%1 · %2 · %3<br/>%4", _ad, _at, _ag, _atx], ["cy", _forEachIndex, _ast]];
            };
        } forEach (localNamespace getVariable ["ADVSEC_cyAlerts", profileNamespace getVariable [ADVSEC_repKey + "_cyber", []]]);

        // 11. Servicio: horas, suspensión y patrullas
        private _srvRows = [];
        private _duty = ([] call ADVSEC_fnc_dutyDB) getOrDefault [_uid, [0, _name, []]];
        private _onDuty = _on && {_u getVariable ["ADVSEC_onDuty", false]};
        _srvRows pushBack [[("STR_ADVSEC_pdb_duty" call ADVSEC_fnc_L), format ["%1 h %2 min", floor ((_duty select 0) / 60), round ((_duty select 0) mod 60)], [("STR_ADVSEC_pdb_off" call ADVSEC_fnc_L), ("STR_ADVSEC_pdb_on" call ADVSEC_fnc_L)] select _onDuty, format [("STR_ADVSEC_pdb_shifts" call ADVSEC_fnc_L), count (_duty select 2)]],
            format [("STR_ADVSEC_pdb_duty_det" call ADVSEC_fnc_L), round (_duty select 0), (((_duty select 2) select [((count (_duty select 2)) - 10) max 0]) apply {format ["%1 → %2 (%3 min)", _x select 0, _x select 1, round (_x select 2)]}) joinString "<br/>"],
            ["duty", round (_duty select 0)]];
        ["check"] call ADVSEC_fnc_susServer;
        private _sus = (localNamespace getVariable ["ADVSEC_susDB", createHashMap]) getOrDefault [_uid, []];
        if (_sus isNotEqualTo []) then {
            _sus params ["_su", "", "_sw", "_sb", "", "_sd", "_sh"];
            private _left = (_su - (call ADVSEC_fnc_utcMin)) max 0;
            _srvRows pushBack [[("STR_ADVSEC_pdb_susp" call ADVSEC_fnc_L), _sd, format ["%1 h %2 min", floor (_left / 60), round (_left mod 60)], _sw],
                format [("STR_ADVSEC_steamid_suspended_by_h_reason" call ADVSEC_fnc_L), _name, _uid, _sd, _sb, _sh, _sw], ["susp"]];
        };
        {
            private _pp = _y;
            if (((_pp select 6) findIf {(_x select 0) == _uid}) >= 0 || {(_pp select 1) == _uid}) then {
                private _pst = switch (_pp select 8) do {case "assigned": {("STR_ADVSEC_assigned" call ADVSEC_fnc_L)}; case "active": {("STR_ADVSEC_in_progress" call ADVSEC_fnc_L)}; case "done": {("STR_ADVSEC_completed" call ADVSEC_fnc_L)}; case "failed": {("STR_ADVSEC_incomplete" call ADVSEC_fnc_L)}; default {("STR_ADVSEC_cancelled" call ADVSEC_fnc_L)}};
                _srvRows pushBack [[("STR_ADVSEC_pdb_patrol" call ADVSEC_fnc_L), format ["%1 · %2", _x, _pp select 0], _pst, _pp select 7],
                    format [("STR_ADVSEC_pdb_patrol_det" call ADVSEC_fnc_L), _x, _pp select 0, _pp select 2, _pst, _pp select 7, count (_pp select 3), {_x isNotEqualTo []} count (_pp select 9)],
                    ["pat", _x, _pp select 8]];
            };
        } forEach ([] call ADVSEC_fnc_patrolDB);

        private _sections = [
            [[("STR_ADVSEC_field" call ADVSEC_fnc_L), ("STR_ADVSEC_value" call ADVSEC_fnc_L)], _resRows],
            [[("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_number" call ADVSEC_fnc_L), ("STR_ADVSEC_level_2" call ADVSEC_fnc_L), ("STR_ADVSEC_expiry" call ADVSEC_fnc_L)], _docRows],
            [[("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_date" call ADVSEC_fnc_L), ("STR_ADVSEC_amount_sentence" call ADVSEC_fnc_L), ("STR_ADVSEC_reason" call ADVSEC_fnc_L), ("STR_ADVSEC_status" call ADVSEC_fnc_L)], _sanRows],
            [[("STR_ADVSEC_number" call ADVSEC_fnc_L), ("STR_ADVSEC_date" call ADVSEC_fnc_L), ("STR_ADVSEC_title" call ADVSEC_fnc_L), ("STR_ADVSEC_role" call ADVSEC_fnc_L)], _repRows],
            [[("STR_ADVSEC_date" call ADVSEC_fnc_L), ("STR_ADVSEC_reason" call ADVSEC_fnc_L), ("STR_ADVSEC_points" call ADVSEC_fnc_L)], _heatRows],
            [["Id", ("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_status" call ADVSEC_fnc_L), ("STR_ADVSEC_custody" call ADVSEC_fnc_L), ("STR_ADVSEC_result" call ADVSEC_fnc_L)], _evRows],
            [[("STR_ADVSEC_date" call ADVSEC_fnc_L), ("STR_ADVSEC_item" call ADVSEC_fnc_L), ("STR_ADVSEC_amount" call ADVSEC_fnc_L)], _ecoRows],
            [[("STR_ADVSEC_specialty_2" call ADVSEC_fnc_L), ("STR_ADVSEC_role" call ADVSEC_fnc_L), ("STR_ADVSEC_date" call ADVSEC_fnc_L)], _specRows],
            [[("STR_ADVSEC_date" call ADVSEC_fnc_L), ("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_detail" call ADVSEC_fnc_L)], _logRows],
            [[("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_pdb_element" call ADVSEC_fnc_L), ("STR_ADVSEC_status" call ADVSEC_fnc_L), ("STR_ADVSEC_detail" call ADVSEC_fnc_L)], _pmcRows],
            [[("STR_ADVSEC_type" call ADVSEC_fnc_L), ("STR_ADVSEC_pdb_element" call ADVSEC_fnc_L), ("STR_ADVSEC_status" call ADVSEC_fnc_L), ("STR_ADVSEC_detail" call ADVSEC_fnc_L)], _srvRows]
        ];

        // Cabecera: nombre, estado, cuatro tarjetas (conexiones, tiempo, efectivo, banco)
        private _stats = [str _visits, format ["%1 h %2 min", floor (_mins / 60), _mins mod 60], format ["%1 %2", _cash, _currency], format ["%1 %2", _eco select 1, _currency]];
        ["player", [_uid, _name, _on, _adm, _stats, _sections, [_pm, _ai, _glob, _notes, _cash, _eco select 1]]] remoteExecCall ["ADVSEC_fnc_pdbViewSet", _caller];
    };

    case "edit": {
        _args params [["_uid", ""], ["_op", ""], ["_data", []]];
        private _e = _pdb getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {("STR_ADVSEC_that_player_no_longer_has" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        private _u = _online getOrDefault [_uid, objNull];
        private _log = {["superAdmin", _caller, [_this, _uid]] call ADVSEC_fnc_logEvent};
        private _hist = {(_e select 9) pushBack [call ADVSEC_fnc_now, name _caller, _this]; if (count (_e select 9) > 40) then {(_e select 9) deleteAt 0}};
        // Operaciones que ya resuelve la terminal de superadministrador: [acción, categoría, dato]
        private _viaAdmin = switch (_op) do {
            case "money": {["ecoAdd", "economy", [_uid, _data]]};
            case "zero": {["ecoZero", "economy", _uid]};
            case "admin": {["adminToggle", "admins", _uid]};
            case "delete": {["pdbDel", "players", _uid]};
            case "docsOff": {["docDel", "docs", _uid]};
            case "fineDel": {["fineDel", "fines", [_uid, _data]]};
            case "wantedDel": {["wantedDel", "wanted", _uid]};
            case "jailDel": {["jailDel", "jail", _uid]};
            case "repDel": {["repDel", "reports", _data]};
            case "heatDel": {["heatDel", "heat", _uid]};
            case "evDel": {["evDel", "evidence", _data]};
            default {[]};
        };
        if (_viaAdmin isNotEqualTo []) then {
            _viaAdmin params ["_a", "_c", "_d"];
            [_a, _caller, [_c, _d]] call ADVSEC_fnc_adminServer;
        } else {
            switch (_op) do {
                // [rangoPM, rangoAI, rangoGlobal, notas]: el superadministrador no tiene límite de rango
                case "profile": {
                    _data params [["_pm", _e select 5], ["_ai", _e select 6], ["_glob", _e select 7], ["_notes", _e select 8]];
                    private _maxG = count (["ranksGlobal", []] call ADVSEC_fnc_setting) - 1;
                    private _changes = [];
                    {
                        _x params ["_v", "_i", "_label", "_max"];
                        if (_v isEqualType 0 && {_v >= -1} && {_v <= _max} && {_v != (_e select _i)}) then {
                            _changes pushBack format ["%1: %2 -> %3", _label, [_i, _e select _i] call ADVSEC_fnc_pdbRankName, [_i, _v] call ADVSEC_fnc_pdbRankName];
                            _e set [_i, _v];
                        };
                    } forEach [[_pm, 5, "PM", 5], [_ai, 6, ("STR_ADVSEC_ia" call ADVSEC_fnc_L), 5], [_glob, 7, "global", _maxG]];
                    if (_notes isEqualType "" && {_notes isNotEqualTo (_e select 8)}) then {_e set [8, _notes select [0, 1000]]; _changes pushBack ("STR_ADVSEC_notes_updated" call ADVSEC_fnc_L)};
                    if (_changes isEqualTo []) exitWith {};
                    {format ["Superadmin: %1", _x] call _hist} forEach _changes;
                    ["players"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_record_edited" call ADVSEC_fnc_L) + (_changes joinString ", ")) call _log;
                    if (!isNull _u) then {
                        [_u] call ADVSEC_fnc_pdbApply;
                        (format ["Tu ficha ha sido actualizada por %1:\n%2", name _caller, _changes joinString "\n"]) remoteExecCall ["hint", _u];
                    };
                };
                // Multa: id -> Pagada / Anulada sin cobrar
                case "finePaid";
                case "fineCancel": {
                    private _f = (([] call ADVSEC_fnc_fineDB) getOrDefault [_uid, []]) param [((([] call ADVSEC_fnc_fineDB) getOrDefault [_uid, []]) findIf {(_x select 0) isEqualTo _data}), []];
                    if (_f isEqualTo []) exitWith {};
                    private _st = ["Pagada", "Anulada"] select (_op == "fineCancel");
                    _f set [6, _st];
                    _f set [8, format [("STR_ADVSEC_by_the_administration_on" call ADVSEC_fnc_L), _st, name _caller, call ADVSEC_fnc_now]];
                    ["fines"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_fine_marked_as" call ADVSEC_fnc_L), _data, _st]) call _log;
                };
                // [importe, motivo]: solo con el jugador conectado (la multa se le notifica)
                case "fineAdd": {
                    if (isNull _u) exitWith {("STR_ADVSEC_the_player_is_not_connected" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
                    _data params [["_amt", "0"], ["_why", ""]];
                    _amt = round parseNumber _amt;
                    if (_amt <= 0) exitWith {("STR_ADVSEC_invalid_amount" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
                    private _id = [_u, _amt, _why, name _caller + ("STR_ADVSEC_administration" call ADVSEC_fnc_L), getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
                    (format [("STR_ADVSEC_fine_of_issued" call ADVSEC_fnc_L), _id, _amt]) call _log;
                };
                case "plateDel": {
                    private _db = [] call ADVSEC_fnc_plateDB;
                    if (((_db getOrDefault [_data, ["", ""]]) select 1) isNotEqualTo _uid) exitWith {};
                    _db deleteAt _data;
                    ["plates"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_plate_deleted" call ADVSEC_fnc_L) + _data) call _log;
                };
                case "wpnDel": {
                    private _db = [] call ADVSEC_fnc_wpnDB;
                    if (((_db getOrDefault [_data, ["", ""]]) select 1) isNotEqualTo _uid) exitWith {};
                    _db deleteAt _data;
                    ["weapons"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_weapon_deleted_from_registry" call ADVSEC_fnc_L) + _data) call _log;
                };
                // [especialidad, 0 miembro | 1 encargado | 2 solicitud]
                case "specDel": {
                    _data params [["_sid", ""], ["_role", 0]];
                    private _s = ([] call ADVSEC_fnc_specDB) getOrDefault [_sid, []];
                    if (_s isEqualTo []) exitWith {};
                    if (_role == 2) then {
                        _s set [2, (_s select 2) select {(_x select 0) isNotEqualTo _uid}];
                    } else {
                        private _l = _s select _role;
                        if (_uid in _l) then {_l deleteAt (_l find _uid)};
                    };
                    (_s select 3) pushBack [call ADVSEC_fnc_now, name _caller, format [("STR_ADVSEC_administration_removes" call ADVSEC_fnc_L), _e select 0, ["miembro", "encargado", "solicitud"] select _role]];
                    ["spec"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_specApply};
                    (format [("STR_ADVSEC_specialty_removed" call ADVSEC_fnc_L), _sid]) call _log;
                };
                // Taquilla: liberar la asignada (el equipo queda guardado) o borrar también lo guardado
                case "lockerFree";
                case "lockerWipe": {
                    if (isNil "TSL_uidMap") exitWith {};
                    private _lk = TSL_uidMap getOrDefault [_uid, objNull];
                    if (!isNull _lk) then {
                        [_lk] call TSL_fnc_reconcileTransfer;
                        [_lk] call TSL_fnc_save;
                        [_lk] call TSL_fnc_clear;
                        TSL_uidMap deleteAt _uid;
                    };
                    if (_op == "lockerWipe") then {
                        private _sc = [_uid] call TSL_fnc_scenarioKey;
                        {profileNamespace setVariable [_x, nil]} forEach [_sc + "_Kit", _sc + "_Locker", "TS_Locker_v1_" + _uid, "TS_Locker_backup_" + _uid];
                        saveProfileNamespace;
                    };
                    ([("STR_ADVSEC_locker_freed" call ADVSEC_fnc_L), ("STR_ADVSEC_locker_freed_and_its_saved" call ADVSEC_fnc_L)] select (_op == "lockerWipe")) call _log;
                };
                // [efectivo, banco] exactos
                case "moneySet": {
                    _data params [["_c", ""], ["_b", ""]];
                    private _db = [] call ADVSEC_fnc_ecoDB;
                    private _a = _db getOrDefault [_uid, []];
                    if (_a isEqualTo []) then {_a = [0, 0, _e select 0, []]; _db set [_uid, _a]};
                    private _nc = (round parseNumber _c) max 0;
                    private _nb = (round parseNumber _b) max 0;
                    private _oc = [_a select 0, [_u] call ADVSEC_fnc_ecoCash] select !isNull _u;
                    if (!isNull _u) then {[_u, _nc] call ADVSEC_fnc_ecoSetCash} else {_a set [0, _nc]};
                    _a set [1, _nb];
                    [_a, format [("STR_ADVSEC_balance_set_by_the_administration" call ADVSEC_fnc_L), _nc, _nb], (_nc - _oc)] call ADVSEC_fnc_ecoHist;
                    ["eco"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_ecoPush};
                    (format [("STR_ADVSEC_balance_set_cash_bank" call ADVSEC_fnc_L), _nc, _nb]) call _log;
                };
                // [índice, [número, nivel, caducidad]]
                case "docEdit": {
                    _data params ["_i", ["_v", []]];
                    _v params [["_num", ""], ["_lvl", "0"], ["_exp", ""]];
                    private _docs = ([] call ADVSEC_fnc_docStore) getOrDefault [_uid, []];
                    private _d = _docs param [_i, createHashMap];
                    if (count _d == 0) exitWith {};
                    if (_num isNotEqualTo "") then {_d set ["number", _num]};
                    _d set ["clearance", parseNumber _lvl];
                    _d set ["expires", _exp];
                    ["docs"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_docPublish};
                    (format [("STR_ADVSEC_document_edited" call ADVSEC_fnc_L), _d getOrDefault ["type", ""]]) call _log;
                };
                case "docDelOne": {
                    private _docs = ([] call ADVSEC_fnc_docStore) getOrDefault [_uid, []];
                    if (_data >= count _docs) exitWith {};
                    private _d = _docs deleteAt _data;
                    ["docs"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_docPublish};
                    (format [("STR_ADVSEC_document_revoked" call ADVSEC_fnc_L), _d getOrDefault ["type", ""]]) call _log;
                };
                // [tipo, número, nivel, caducidad]: solo con el jugador conectado (recibe el objeto)
                case "docAdd": {
                    if (isNull _u) exitWith {("STR_ADVSEC_the_player_is_not_connected_2" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
                    _data params [["_t", ""], ["_num", ""], ["_lvl", ""], ["_exp", ""]];
                    if (_t isEqualTo "") exitWith {};
                    private _dd = [["expires", _exp]];
                    if (_num isNotEqualTo "") then {_dd pushBack ["number", _num]};
                    if (_lvl isNotEqualTo "") then {_dd pushBack ["clearance", parseNumber _lvl]};
                    private _id = [_u, _t, _dd] call ADVSEC_fnc_docCreate;
                    (("STR_ADVSEC_document_issued" call ADVSEC_fnc_L) + _id) call _log;
                };
                case "plateStolen": {
                    private _p = ([] call ADVSEC_fnc_plateDB) getOrDefault [_data, []];
                    if (_p isEqualTo [] || {(_p select 1) isNotEqualTo _uid}) exitWith {};
                    _p set [4, !(_p select 4)];
                    ["plates"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_plate_theft" call ADVSEC_fnc_L), _data, _p select 4]) call _log;
                };
                // [id, [importe, motivo, estado]]
                case "fineEdit": {
                    _data params ["_id", ["_v", []]];
                    _v params [["_amt", ""], ["_why", ""], ["_st", ""]];
                    private _l = ([] call ADVSEC_fnc_fineDB) getOrDefault [_uid, []];
                    private _f = _l param [_l findIf {(_x select 0) isEqualTo _id}, []];
                    if (_f isEqualTo []) exitWith {};
                    if (_amt isNotEqualTo "") then {_f set [2, (round parseNumber _amt) max 0]};
                    _f set [3, _why];
                    if (_st in ["Pendiente", "Pagada", "Anulada"] && {_st isNotEqualTo (_f select 6)}) then {
                        _f set [6, _st];
                        _f set [8, format [("STR_ADVSEC_by_the_administration_on" call ADVSEC_fnc_L), _st, name _caller, call ADVSEC_fnc_now]];
                    };
                    ["fines"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_fine_edited" call ADVSEC_fnc_L) + _id) call _log;
                };
                // [motivo, peligrosidad]: crea o modifica la requisitoria
                case "wantedSet": {
                    _data params [["_why", ""], ["_lvl", "Media"]];
                    private _w = ADVSEC_wantedDB getOrDefault [_uid, []];
                    if (_w isEqualTo []) then {
                        ADVSEC_wantedDB set [_uid, [_e select 0, _why, _lvl, name _caller, call ADVSEC_fnc_now, getPlayerUID _caller]];
                        (format [("STR_ADVSEC_mp_declared_wanted_danger_level" call ADVSEC_fnc_L), _e select 0, toLower (_lvl call ADVSEC_fnc_Lv)]) remoteExecCall ["systemChat", 0];
                    } else {_w set [1, _why]; _w set [2, _lvl]};
                    ["wanted"] call ADVSEC_fnc_policeDBSave;
                    (format [("STR_ADVSEC_warrant_2" call ADVSEC_fnc_L), _why, _lvl]) call _log;
                };
                // [minutos (-1 = hasta nueva orden), motivo]
                case "jailEdit": {
                    _data params [["_min", ""], ["_why", ""]];
                    private _j = ADVSEC_jailDB getOrDefault [_uid, []];
                    if (_j isEqualTo []) exitWith {};
                    private _m = parseNumber _min;
                    private _secs = [_m * 60, 1e7] select (_m < 0);
                    _j set [0, _secs];
                    _j set [1, _why];
                    if (!isNull _u && {(_u getVariable ["ADVSEC_jailUntil", 0]) > 0}) then {_u setVariable ["ADVSEC_jailUntil", serverTime + _secs]};
                    ["jail"] call ADVSEC_fnc_policeDBSave;
                    (format [("STR_ADVSEC_detention_edited_min" call ADVSEC_fnc_L), _m, _why]) call _log;
                };
                // [id, [título, estado, gravedad]]
                case "repEdit": {
                    _data params ["_id", ["_v", []]];
                    _v params [["_t", ""], ["_st", ""], ["_g", ""]];
                    private _r = ADVSEC_repDB getOrDefault [_id, createHashMap];
                    if (count _r == 0) exitWith {};
                    if (_t isNotEqualTo "") then {_r set ["title", _t]};
                    if (_st isNotEqualTo "") then {_r set ["status", _st]};
                    if (_g isNotEqualTo "") then {_r set ["gravity", _g]};
                    ["rep"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_report_edited" call ADVSEC_fnc_L) + _id) call _log;
                };
                case "heatSet": {
                    private _n = (parseNumber (_data param [0, "0"])) max 0;
                    private _h = [_uid] call ADVSEC_fnc_heatGet;
                    _h set [0, _n];
                    _h set [3, _e select 0];
                    (_h select 2) pushBack [call ADVSEC_fnc_now, format [("STR_ADVSEC_index_set_by_the_administration" call ADVSEC_fnc_L), name _caller], 0];
                    ([] call ADVSEC_fnc_heatDB) set [_uid, _h];
                    ["heat"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_suspicion_index_set_to" call ADVSEC_fnc_L), _n]) call _log;
                };
                // [id, [estado, resultado]]
                case "evEdit": {
                    _data params ["_id", ["_v", []]];
                    _v params [["_st", ""], ["_res", ""]];
                    private _ev = ([] call ADVSEC_fnc_evDB) getOrDefault [_id, createHashMap];
                    if (count _ev == 0) exitWith {};
                    if (_st in ["field", "bagged", "analyzing", "analyzed"]) then {_ev set ["state", _st]};
                    _ev set ["result", _res];
                    ["ev"] call ADVSEC_fnc_dbDirty;
                    (("STR_ADVSEC_evidence_edited" call ADVSEC_fnc_L) + _id) call _log;
                };
                // [especialidad, 0 miembro | 1 encargado]
                case "specAdd": {
                    _data params [["_sid", ""], ["_role", 0]];
                    private _s = ([] call ADVSEC_fnc_specDB) getOrDefault [_sid, []];
                    if (_s isEqualTo []) exitWith {};
                    (_s select 0) pushBackUnique _uid;
                    if (_role == 1) then {(_s select 1) pushBackUnique _uid};
                    _s set [2, (_s select 2) select {(_x select 0) isNotEqualTo _uid}];
                    (_s select 3) pushBack [call ADVSEC_fnc_now, name _caller, format [("STR_ADVSEC_administration_adds" call ADVSEC_fnc_L), _e select 0, ["miembro", "encargado"] select _role]];
                    ["spec"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_specApply};
                    (format [("STR_ADVSEC_specialty_added" call ADVSEC_fnc_L), _sid]) call _log;
                };
                // --- PMC
                // [rol ("" | CP | QRF | SEC), estado]
                case "cellSet": {
                    _data params [["_role", ""], ["_st", "Disponible"]];
                    private _cdb = [] call ADVSEC_fnc_cellDB;
                    if (_role isEqualTo "") then {_cdb deleteAt _uid} else {
                        if !(_role in ["CP", "QRF", "SEC"]) exitWith {};
                        private _ce = _cdb getOrDefault [_uid, [_role, _e select 0, "Disponible", 0, 0]];
                        _ce set [0, _role];
                        _ce set [1, _e select 0];
                        if (_st in ["Disponible", "Movilizado", "Descanso"]) then {_ce set [2, _st]};
                        _cdb set [_uid, _ce];
                    };
                    missionNamespace setVariable ["ADVSEC_cellRoles", (keys _cdb) apply {[_x, (_cdb get _x) select 0, (_cdb get _x) select 2]}, true];
                    ["cells"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_cell" call ADVSEC_fnc_L), [_role, "-"] select (_role isEqualTo ""), _st]) call _log;
                    if (!isNull _u) then {(format [("STR_ADVSEC_pmc_cell_assigned" call ADVSEC_fnc_L), [(format ["STR_ADVSEC_pmc_role_%1", _role]) call ADVSEC_fnc_L, ("STR_ADVSEC_pmc_role_none" call ADVSEC_fnc_L)] select (_role isEqualTo "")]) remoteExecCall ["hint", _u]};
                };
                case "qrfReset": {
                    (localNamespace getVariable ["ADVSEC_qrfStats", createHashMap]) deleteAt _uid;
                    ["qrf"] call ADVSEC_fnc_dbDirty;
                    ("STR_ADVSEC_pdb_log_qrf" call ADVSEC_fnc_L) call _log;
                };
                // [importe]: 0 perdona la deuda
                case "debtSet": {
                    [] call ADVSEC_fnc_armDB;
                    private _debts = localNamespace getVariable ["ADVSEC_armDebts", createHashMap];
                    private _n = (round parseNumber (_data param [0, "0"])) max 0;
                    if (_n == 0) then {_debts deleteAt _uid} else {
                        private _dd = _debts getOrDefault [_uid, [0, []]];
                        _dd set [0, _n];
                        _debts set [_uid, _dd];
                    };
                    ["armory"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_debt" call ADVSEC_fnc_L), _n]) call _log;
                };
                // [serie, [estado, desgaste %]]
                case "corpEdit": {
                    _data params ["_sn", ["_v", []]];
                    _v params [["_st", ""], ["_wear", ""]];
                    private _we = ([] call ADVSEC_fnc_wpnDB) getOrDefault [_sn, []];
                    if (_we isEqualTo [] || {(_we param [4, ""]) != "CORP"}) exitWith {};
                    if (_st in ["Armería", "Firmada", "Perdida", "Incautada", "Destruida", "Retirada"] && {_st != (_we select 5)}) then {
                        _we set [5, _st];
                        if (_st == "Armería") then {_we set [1, ""]; _we set [2, ("STR_ADVSEC_pmc_company" call ADVSEC_fnc_L)]};
                        if (_st == "Firmada") then {_we set [1, _uid]; _we set [2, format [("STR_ADVSEC_pmc_company_signed" call ADVSEC_fnc_L), _e select 0]]; _we set [6, [_uid, _e select 0, call ADVSEC_fnc_now]]};
                    };
                    if (_wear isNotEqualTo "") then {_we set [7, ((parseNumber _wear) / 100) max 0 min 1]};
                    (_we select 9) pushBack [call ADVSEC_fnc_now, format [("STR_ADVSEC_pdb_corp_hist" call ADVSEC_fnc_L), name _caller, (_we select 5) call ADVSEC_fnc_Lv, round ((_we select 7) * 100)]];
                    ["weapons"] call ADVSEC_fnc_dbDirty;
                    ["armory"] call ADVSEC_fnc_dbDirty;
                    [_uid] call ADVSEC_fnc_armSigned;
                    (format [("STR_ADVSEC_pdb_log_corp" call ADVSEC_fnc_L), _sn, _we select 5]) call _log;
                };
                // [id]: quita al jugador del contrato
                case "ctrDrop": {
                    private _cc = ([] call ADVSEC_fnc_ctrDB) getOrDefault [_data, createHashMap];
                    if (count _cc == 0) exitWith {};
                    _cc set ["assigned", (_cc get "assigned") select {(_x select 0) != _uid}];
                    if (((_cc get "signer") param [0, ""]) == _uid && {!((_cc get "state") in ["Firmado", "En curso"])}) then {_cc set ["signer", []]};
                    ["contracts"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_ctrdrop" call ADVSEC_fnc_L), _data]) call _log;
                };
                // [id, [título, estado]]: el estado se cambia sin liquidar el contrato
                case "ctrEdit": {
                    _data params ["_cid", ["_v", []]];
                    _v params [["_t", ""], ["_st", ""]];
                    private _cc = ([] call ADVSEC_fnc_ctrDB) getOrDefault [_cid, createHashMap];
                    if (count _cc == 0) exitWith {};
                    if (_t isNotEqualTo "") then {_cc set ["title", _t select [0, 60]]};
                    if (_st in ["Ofertado", "Firmado", "En curso", "Revisión", "Cumplido", "Parcial", "Fallido", "Rescindido", "Retirado"] && {_st != (_cc get "state")}) then {
                        if ((_cc get "state") == "En curso" && {!(_st in ["Firmado", "En curso"])}) then {["end", _cid] call ADVSEC_fnc_ctrHostiles};
                        _cc set ["state", _st];
                        if (_st in ["Cumplido", "Parcial", "Fallido", "Rescindido", "Retirado"] && {(_cc get "end") isEqualTo ""}) then {_cc set ["end", call ADVSEC_fnc_now]};
                        _cc set ["result", format [("STR_ADVSEC_pdb_ctr_byadmin" call ADVSEC_fnc_L), name _caller]];
                    };
                    ["contracts"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_ctredit" call ADVSEC_fnc_L), _cid, _cc get "state"]) call _log;
                };
                case "lkitDel": {
                    private _ldb = localNamespace getVariable ["ADVSEC_lkitDB", createHashMap];
                    if (isNil {localNamespace getVariable "ADVSEC_lkitDB"}) then {
                        {if (_x isEqualType [] && {count _x == 2}) then {_ldb set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_lkit", []]);
                        localNamespace setVariable ["ADVSEC_lkitDB", _ldb];
                    };
                    _ldb deleteAt _uid;
                    ["lkit"] call ADVSEC_fnc_dbDirty;
                    ("STR_ADVSEC_pdb_log_lkit" call ADVSEC_fnc_L) call _log;
                };
                // [índice]: alerta ciber revisada / borrada
                case "cyAck";
                case "cyDel": {
                    if (isNil {localNamespace getVariable "ADVSEC_cyAlerts"}) then {localNamespace setVariable ["ADVSEC_cyAlerts", +(profileNamespace getVariable [ADVSEC_repKey + "_cyber", []])]};
                    private _al = localNamespace getVariable ["ADVSEC_cyAlerts", []];
                    private _a = _al param [_data, []];
                    if (_a isEqualTo [] || {(_a select 4) != _uid}) exitWith {};
                    if (_op == "cyDel") then {_al deleteAt _data} else {_a set [7, "Revisada"]};
                    ["cyber"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_cy" call ADVSEC_fnc_L), _a select 0]) call _log;
                };
                // --- Servicio
                // [minutos totales]
                case "dutySet": {
                    private _ddb = [] call ADVSEC_fnc_dutyDB;
                    private _n = (round parseNumber (_data param [0, "0"])) max 0;
                    private _de = _ddb getOrDefault [_uid, [0, _e select 0, []]];
                    _de set [0, _n];
                    _ddb set [_uid, _de];
                    ["duty"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_duty" call ADVSEC_fnc_L), _n]) call _log;
                };
                case "dutyReset": {
                    ([] call ADVSEC_fnc_dutyDB) deleteAt _uid;
                    ["duty"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_duty" call ADVSEC_fnc_L), 0]) call _log;
                };
                case "suspLift": {
                    ["check"] call ADVSEC_fnc_susServer;
                    private _sdb = localNamespace getVariable ["ADVSEC_susDB", createHashMap];
                    private _ss = _sdb deleteAt _uid;
                    if (isNil "_ss") exitWith {};
                    (_ss select 1) params ["_spm", "_sai", "_sg"];
                    _e set [5, _spm]; _e set [6, _sai]; _e set [7, _sg];
                    format [("STR_ADVSEC_lifted_by" call ADVSEC_fnc_L), name _caller] call _hist;
                    ["players"] call ADVSEC_fnc_dbDirty;
                    ["susp"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_pdbApply; ("STR_ADVSEC_your_suspension_has_ended_ranks" call ADVSEC_fnc_L) remoteExecCall ["hint", _u]};
                    ("STR_ADVSEC_pdb_log_susp" call ADVSEC_fnc_L) call _log;
                };
                // [id]: quita al jugador de la patrulla
                case "patDrop": {
                    private _pp = ([] call ADVSEC_fnc_patrolDB) getOrDefault [_data, []];
                    if (_pp isEqualTo []) exitWith {};
                    _pp set [6, (_pp select 6) select {(_x select 0) != _uid}];
                    ["patrols"] call ADVSEC_fnc_dbDirty;
                    (format [("STR_ADVSEC_pdb_log_pat" call ADVSEC_fnc_L), _data]) call _log;
                };
                default {};
            };
        };
        ["list", _caller] call ADVSEC_fnc_pdbViewServer;
        if (_op != "delete") then {["player", _caller, [_uid]] call ADVSEC_fnc_pdbViewServer};
    };

    default {};
};
