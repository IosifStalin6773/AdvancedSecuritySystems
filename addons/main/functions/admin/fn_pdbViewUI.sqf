// ["filter"|"select"|"tab"|"row"|"refresh"|"header"|"render"|"acts"|"act", dato] (cliente) — base de datos de jugadores del superadministrador
params ["_action", ["_arg", 0]];
private _disp = findDisplay 87850;
if (isNull _disp) exitWith {};

private _tabNames = [("STR_ADVSEC_summary" call ADVSEC_fnc_L), ("STR_ADVSEC_documents" call ADVSEC_fnc_L), ("STR_ADVSEC_sanctions" call ADVSEC_fnc_L), ("STR_ADVSEC_reports" call ADVSEC_fnc_L), ("STR_ADVSEC_suspicion" call ADVSEC_fnc_L), ("STR_ADVSEC_evidence" call ADVSEC_fnc_L), ("STR_ADVSEC_economy" call ADVSEC_fnc_L), ("STR_ADVSEC_specialties" call ADVSEC_fnc_L), ("STR_ADVSEC_log" call ADVSEC_fnc_L)];
private _tabPos = [
    [0, 0.3], [0, 0.3, 0.55, 0.75], [0, 0.09, 0.26, 0.38, 0.86], [0, 0.2, 0.42, 0.8], [0, 0.35, 0.9],
    [0, 0.16, 0.34, 0.56, 0.78], [0, 0.34, 0.8], [0, 0.4, 0.7], [0, 0.3, 0.6]
];
private _esc = {[_this] call ADVSEC_fnc_repEsc};
private _rowKey = {
    private _r = lnbCurSelRow (_disp displayCtrl 87890);
    if (_r < 1) exitWith {[]};
    ((((ADVSEC_pdbSections param [ADVSEC_pdbTab, [[], []]]) select 1) param [_r - 1, []]) param [2, []])
};

switch (_action) do {
    // Filtra y ordena la lista de jugadores por texto y por grupo
    case "filter": {
        private _q = toLower ctrlText (_disp displayCtrl 87852);
        private _mode = lbCurSel (_disp displayCtrl 87853);
        private _shown = ADVSEC_pdbList select {
            private _cells = _x select 1;
            private _match = ((toLower (_cells select 0)) find _q) >= 0 || {((toLower (_x select 0)) find _q) >= 0};
            private _grp = switch (_mode) do {
                case 1: {_x select 2};
                case 2: {(_x select 4) > 0};
                case 3: {(_x select 5) > 0};
                case 4: {_x select 3};
                case 5: {(_x select 4) == 0 && {(_x select 5) == 0} && {(_x select 6) == 0}};
                default {true};
            };
            _match && _grp
        };
        private _c = _disp displayCtrl 87859;
        lnbClear _c;
        _c lnbSetColumnsPos [0, 0.46, 0.64, 0.82];
        _c lnbAddRow ["NOMBRE", "PM", ("STR_ADVSEC_ia" call ADVSEC_fnc_L), "GLOBAL"];
        {
            private _r = _c lnbAddRow (_x select 1);
            _c lnbSetData [[_r, 0], _x select 0];
        } forEach _shown;
        private _at = _shown findIf {(_x select 0) == ADVSEC_pdbSel};
        if (_at >= 0) then {_c lnbSetCurSelRow (_at + 1)};
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText format [("STR_ADVSEC_players_shown" call ADVSEC_fnc_L), count ADVSEC_pdbList, count _shown];
    };

    // Selección de un jugador en la lista: pide su ficha completa al servidor
    case "select": {
        private _c = _disp displayCtrl 87859;
        private _r = lnbCurSelRow _c;
        if (_r < 1) exitWith {};
        private _uid = _c lnbData [_r, 0];
        if (_uid isEqualTo "" || {_uid isEqualTo ADVSEC_pdbSel}) exitWith {};
        ADVSEC_pdbSel = _uid;
        ADVSEC_pdbSections = [];
        ADVSEC_pdbCur = [];
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText ("STR_ADVSEC_loading_record" call ADVSEC_fnc_L);
        ["render"] call ADVSEC_fnc_pdbViewUI;
        ["player", player, [_uid]] remoteExecCall ["ADVSEC_fnc_pdbViewServer", 2];
    };

    case "refresh": {
        ["list", player] remoteExecCall ["ADVSEC_fnc_pdbViewServer", 2];
        if (ADVSEC_pdbSel isNotEqualTo "") then {["player", player, [ADVSEC_pdbSel]] remoteExecCall ["ADVSEC_fnc_pdbViewServer", 2]};
    };

    case "tab": {
        ADVSEC_pdbTab = _arg;
        ["render"] call ADVSEC_fnc_pdbViewUI;
    };

    // Cabecera del jugador y tarjetas. _arg = [nombre, SteamID, en línea, superadmin, [conexiones, tiempo, efectivo, banco]]
    case "header": {
        _arg params ["_name", "_uid", "_on", "_adm", "_stats"];
        _stats params ["_conn", "_play", "_cash", "_bank"];
        private _tile = {
            params ["_idc", "_label", "_value"];
            (_disp displayCtrl _idc) ctrlSetStructuredText parseText format [
                "<t size='0.8' color='#8C8C8C'>%1</t><br/><t size='1.5' font='RobotoCondensedBold'>%2</t>", _label, _value];
        };
        [87860, "CONEXIONES", _conn] call _tile;
        [87861, ("STR_ADVSEC_time_played" call ADVSEC_fnc_L), _play] call _tile;
        [87862, "EFECTIVO", _cash] call _tile;
        [87863, "BANCO", _bank] call _tile;
        private _flags = [];
        if (_on) then {_flags pushBack ("STR_ADVSEC_online" call ADVSEC_fnc_L)};
        if (_adm) then {_flags pushBack ("STR_ADVSEC_superadmin" call ADVSEC_fnc_L)};
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText format [
            "<t size='1.25' font='RobotoCondensedBold'>%1</t>  %2<br/><t color='#8C8C8C'>SteamID</t> %3",
            _name call _esc, _flags joinString " · ", _uid call _esc];
    };

    // Pinta la tabla de la pestaña activa y las etiquetas de las pestañas con su número de filas
    case "render": {
        for "_i" from 0 to 8 do {
            private _sec = ADVSEC_pdbSections param [_i, [[], []]];
            private _n = count (_sec select 1);
            private _b = _disp displayCtrl (87870 + _i);
            _b ctrlSetText format ["%1%2", _tabNames select _i, [format [" (%1)", _n], ""] select (_n == 0)];
            if (_i == ADVSEC_pdbTab) then {
                _b ctrlSetBackgroundColor [0.816, 0.639, 0.188, 1];
                _b ctrlSetTextColor [0.078, 0.078, 0.078, 1];
            } else {
                _b ctrlSetBackgroundColor [0.157, 0.157, 0.157, 1];
                _b ctrlSetTextColor [0.667, 0.667, 0.667, 1];
            };
        };
        private _c = _disp displayCtrl 87890;
        lnbClear _c;
        _c lnbSetColumnsPos (_tabPos param [ADVSEC_pdbTab, [0, 0.5]]);
        private _sec = ADVSEC_pdbSections param [ADVSEC_pdbTab, [[], []]];
        _sec params ["_heads", "_rows"];
        if (_heads isNotEqualTo []) then {_c lnbAddRow _heads};
        if (_rows isEqualTo []) then {
            private _e = _c lnbAddRow (_heads apply {""});
            _c lnbSetText [[_e, 0], ("STR_ADVSEC_no_entries_in_this_section" call ADVSEC_fnc_L)];
        };
        {
            _x params ["_cells", "_det"];
            private _r = _c lnbAddRow _cells;
            _c lnbSetData [[_r, 0], _det];
        } forEach _rows;
        (_disp displayCtrl 87891) ctrlSetStructuredText parseText ("STR_ADVSEC_select_a_row_to_see" call ADVSEC_fnc_L);
        ["acts"] call ADVSEC_fnc_pdbViewUI;
    };

    // Detalle de la fila seleccionada
    case "row": {
        private _c = _disp displayCtrl 87890;
        private _r = lnbCurSelRow _c;
        private _txt = if (_r < 1) then {("STR_ADVSEC_select_a_row_to_see" call ADVSEC_fnc_L)} else {(_c lnbData [_r, 0]) call _esc};
        private _d = _disp displayCtrl 87891;
        _d ctrlSetStructuredText parseText _txt;
        private _p = ctrlPosition _d;
        _d ctrlSetPosition [_p select 0, _p select 1, _p select 2, (ctrlTextHeight _d) max (safezoneH * 0.09)];
        _d ctrlCommit 0;
        ["acts"] call ADVSEC_fnc_pdbViewUI;
    };

    // Botones de acción según la pestaña y la fila elegida: [texto, operación, dato, confirmar, formulario]
    // Con formulario se envía [dato, valores], o solo los valores si el dato es ""
    case "acts": {
        private _acts = [];
        if (ADVSEC_pdbSel isNotEqualTo "" && {ADVSEC_pdbCur isNotEqualTo []}) then {
            ADVSEC_pdbCur params ["_name", "_on", "_adm", ["_cur", []]];
            _cur params [["_pm", -1], ["_ai", -1], ["_glob", 0], ["_notes", ""], ["_cash", 0], ["_bank", 0]];
            private _key = call _rowKey;
            private _kt = _key param [0, ""];
            private _who = toUpper _name;
            private _lists = configFile >> "ADVSEC_ReportLists";
            private _opt = {
                private _o = [[("STR_ADVSEC_as_set_by_the_mission" call ADVSEC_fnc_L), -1], [("STR_ADVSEC_no_rank" call ADVSEC_fnc_L), 0]];
                {_o pushBack [_x, _forEachIndex + 1]} forEach _this;
                _o
            };
            private _gO = [];
            {_gO pushBack [_x, _forEachIndex]} forEach (["ranksGlobal", []] call ADVSEC_fnc_setting);
            private _profile = [("STR_ADVSEC_edit_ranks_and_notes" call ADVSEC_fnc_L), "profile", "", false, [format [("STR_ADVSEC_edit_record" call ADVSEC_fnc_L), _who], [
                [("STR_ADVSEC_mp_rank" call ADVSEC_fnc_L), _pm, (["ranksPM", []] call ADVSEC_fnc_setting) call _opt],
                [("STR_ADVSEC_ia_rank" call ADVSEC_fnc_L), _ai, (["ranksAI", []] call ADVSEC_fnc_setting) call _opt],
                [("STR_ADVSEC_global_rank" call ADVSEC_fnc_L), _glob, _gO],
                [("STR_ADVSEC_notes" call ADVSEC_fnc_L), _notes, "text"]]]];
            private _moneySet = [("STR_ADVSEC_set_balance" call ADVSEC_fnc_L), "moneySet", "", false, [format [("STR_ADVSEC_balance" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_cash" call ADVSEC_fnc_L), str _cash], [("STR_ADVSEC_bank" call ADVSEC_fnc_L), str _bank]]]];
            private _money = [("STR_ADVSEC_add_subtract_money" call ADVSEC_fnc_L), "money", "", false, [("STR_ADVSEC_add_or_subtract_money" call ADVSEC_fnc_L), [[("STR_ADVSEC_where" call ADVSEC_fnc_L), "bank", [[("STR_ADVSEC_bank" call ADVSEC_fnc_L), "bank"], [("STR_ADVSEC_cash" call ADVSEC_fnc_L), "cash"]]], [("STR_ADVSEC_amount_negative_to_subtract" call ADVSEC_fnc_L), "1000"]]]];
            private _wanted = [("STR_ADVSEC_declare_edit_wanted" call ADVSEC_fnc_L), "wantedSet", "", false, [format [("STR_ADVSEC_warrant" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_reason" call ADVSEC_fnc_L), "", "text"], [("STR_ADVSEC_danger_level" call ADVSEC_fnc_L), "Media", ["Baja", "Media", "Alta", "Extrema"]]]]];
            private _fineNew = [("STR_ADVSEC_issue_fine" call ADVSEC_fnc_L), "fineAdd", "", false, [format [("STR_ADVSEC_fine" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_amount" call ADVSEC_fnc_L), "100"], [("STR_ADVSEC_reason" call ADVSEC_fnc_L), ("STR_ADVSEC_administrative_sanction" call ADVSEC_fnc_L), "text"]]]];
            switch (ADVSEC_pdbTab) do {
                case 0: {
                    switch (_key param [1, ""]) do {
                        case "money": {_acts append [_moneySet, _money]};
                        case "admin": {_acts pushBack [[("STR_ADVSEC_grant_superadmin" call ADVSEC_fnc_L), ("STR_ADVSEC_remove_superadmin" call ADVSEC_fnc_L)] select _adm, "admin", [], true, []]};
                        case "wanted": {_acts pushBack _wanted};
                        case "fines": {_acts pushBack _fineNew};
                        case "locker": {
                            _acts pushBack [("STR_ADVSEC_free_locker" call ADVSEC_fnc_L), "lockerFree", [], true, []];
                            _acts pushBack [("STR_ADVSEC_empty_locker_deletes_its_gear" call ADVSEC_fnc_L), "lockerWipe", [], true, []];
                        };
                        default {_acts pushBack _profile};
                    };
                    {if !((_x select 1) in (_acts apply {_x select 1})) then {_acts pushBack _x}} forEach [_profile, _moneySet];
                    _acts pushBack [("STR_ADVSEC_delete_record" call ADVSEC_fnc_L), "delete", [], true, []];
                };
                case 1: {
                    if (_kt == "doc") then {
                        _key params ["", "_i", "_num", "_lvl", "_exp", "_t"];
                        _acts pushBack [("STR_ADVSEC_edit_document" call ADVSEC_fnc_L), "docEdit", _i, false, [format ["%1 · %2", toUpper _t, _who], [[("STR_ADVSEC_number" call ADVSEC_fnc_L), _num], [("STR_ADVSEC_access_level" call ADVSEC_fnc_L), str _lvl], [("STR_ADVSEC_expiry_empty_never" call ADVSEC_fnc_L), _exp]]]];
                        _acts pushBack [("STR_ADVSEC_revoke_this_document" call ADVSEC_fnc_L), "docDelOne", _i, true, []];
                    };
                    if (_kt == "plate") then {
                        _acts pushBack [[("STR_ADVSEC_report_as_stolen" call ADVSEC_fnc_L), ("STR_ADVSEC_withdraw_stolen_report" call ADVSEC_fnc_L)] select (_key select 2), "plateStolen", _key select 1, false, []];
                        _acts pushBack [("STR_ADVSEC_delete_plate" call ADVSEC_fnc_L), "plateDel", _key select 1, true, []];
                    };
                    if (_kt == "wpn") then {_acts pushBack [("STR_ADVSEC_delete_weapon_from_registry" call ADVSEC_fnc_L), "wpnDel", _key select 1, true, []]};
                    _acts pushBack [("STR_ADVSEC_issue_document" call ADVSEC_fnc_L), "docAdd", "", false, [format [("STR_ADVSEC_issue_document_2" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_type" call ADVSEC_fnc_L), "", [] call ADVSEC_fnc_docTypes], [("STR_ADVSEC_number_empty_automatic" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_level_empty_the_type_s" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_expiry_empty_never" call ADVSEC_fnc_L), ""]]]];
                    _acts pushBack [("STR_ADVSEC_revoke_all" call ADVSEC_fnc_L), "docsOff", [], true, []];
                };
                case 2: {
                    if (_kt == "fine") then {
                        _key params ["", "_id", "_st", "_amt", "_why"];
                        _acts pushBack [("STR_ADVSEC_edit_fine" call ADVSEC_fnc_L), "fineEdit", _id, false, [format [("STR_ADVSEC_fine_2" call ADVSEC_fnc_L), _id], [[("STR_ADVSEC_amount" call ADVSEC_fnc_L), str _amt], [("STR_ADVSEC_reason" call ADVSEC_fnc_L), _why, "text"], [("STR_ADVSEC_status" call ADVSEC_fnc_L), _st, ["Pendiente", "Pagada", "Anulada"]]]]];
                        _acts pushBack [("STR_ADVSEC_delete_fine" call ADVSEC_fnc_L), "fineDel", _id, true, []];
                    };
                    if (_kt == "wanted") then {
                        _key params ["", "_why", "_lvl"];
                        _acts pushBack [("STR_ADVSEC_edit_warrant" call ADVSEC_fnc_L), "wantedSet", "", false, [format [("STR_ADVSEC_warrant" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_reason" call ADVSEC_fnc_L), _why, "text"], [("STR_ADVSEC_danger_level" call ADVSEC_fnc_L), _lvl, ["Baja", "Media", "Alta", "Extrema"]]]]];
                        _acts pushBack [("STR_ADVSEC_withdraw_warrant" call ADVSEC_fnc_L), "wantedDel", [], true, []];
                    };
                    if (_kt == "jail") then {
                        _key params ["", "_min", "_why"];
                        _acts pushBack [("STR_ADVSEC_edit_detention" call ADVSEC_fnc_L), "jailEdit", "", false, [format [("STR_ADVSEC_detention" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_minutes_left_1_until_further" call ADVSEC_fnc_L), str _min], [("STR_ADVSEC_reason" call ADVSEC_fnc_L), _why, "text"]]]];
                        _acts pushBack [("STR_ADVSEC_release" call ADVSEC_fnc_L), "jailDel", [], true, []];
                    };
                    _acts pushBack _fineNew;
                    if (_kt != "wanted") then {_acts pushBack _wanted};
                };
                case 3: {
                    if (_kt == "rep") then {
                        _key params ["", "_id", "_t", "_st", "_g"];
                        _acts pushBack [("STR_ADVSEC_edit_report" call ADVSEC_fnc_L), "repEdit", _id, false, [format [("STR_ADVSEC_report" call ADVSEC_fnc_L), _id], [[("STR_ADVSEC_title" call ADVSEC_fnc_L), _t], [("STR_ADVSEC_status" call ADVSEC_fnc_L), _st, getArray (_lists >> "status")], [("STR_ADVSEC_severity" call ADVSEC_fnc_L), _g, getArray (_lists >> "gravity")]]]];
                        _acts pushBack [("STR_ADVSEC_delete_report" call ADVSEC_fnc_L), "repDel", _id, true, []];
                    };
                };
                case 4: {
                    _acts pushBack [("STR_ADVSEC_set_index" call ADVSEC_fnc_L), "heatSet", "", false, [format [("STR_ADVSEC_suspicion_2" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_points" call ADVSEC_fnc_L), str (_key param [1, 0])]]]];
                    if (_kt == "heat") then {_acts pushBack [("STR_ADVSEC_archive_index" call ADVSEC_fnc_L), "heatDel", [], true, []]};
                };
                case 5: {
                    if (_kt == "ev") then {
                        _key params ["", "_id", "_st", "_res"];
                        _acts pushBack [("STR_ADVSEC_edit_evidence" call ADVSEC_fnc_L), "evEdit", _id, false, [format [("STR_ADVSEC_evidence_2" call ADVSEC_fnc_L), _id], [[("STR_ADVSEC_status" call ADVSEC_fnc_L), _st, [[("STR_ADVSEC_at_the_scene" call ADVSEC_fnc_L), "field"], [("STR_ADVSEC_bagged" call ADVSEC_fnc_L), "bagged"], [("STR_ADVSEC_being_analysed" call ADVSEC_fnc_L), "analyzing"], [("STR_ADVSEC_analysed" call ADVSEC_fnc_L), "analyzed"]]], [("STR_ADVSEC_result" call ADVSEC_fnc_L), _res, "text"]]]];
                        _acts pushBack [("STR_ADVSEC_delete_evidence" call ADVSEC_fnc_L), "evDel", _id, true, []];
                    };
                };
                case 6: {_acts append [_moneySet, _money, [("STR_ADVSEC_reset_balance_to_zero" call ADVSEC_fnc_L), "zero", [], true, []]]};
                case 7: {
                    if (_kt == "spec") then {_acts pushBack [[("STR_ADVSEC_remove_from_specialty" call ADVSEC_fnc_L), ("STR_ADVSEC_remove_as_manager" call ADVSEC_fnc_L), ("STR_ADVSEC_reject_request" call ADVSEC_fnc_L)] select (_key select 2), "specDel", [_key select 1, _key select 2], true, []]};
                    private _sO = ("true" configClasses (configFile >> "ADVSEC_Specialties")) apply {[[configName _x] call ADVSEC_fnc_specName, configName _x]};
                    _acts pushBack [("STR_ADVSEC_add_to_specialty" call ADVSEC_fnc_L), "specAdd", "", false, [format [("STR_ADVSEC_specialty" call ADVSEC_fnc_L), _who], [[("STR_ADVSEC_specialty_2" call ADVSEC_fnc_L), (_sO param [0, ["", ""]]) select 1, _sO], [("STR_ADVSEC_as" call ADVSEC_fnc_L), 0, [[("STR_ADVSEC_member" call ADVSEC_fnc_L), 0], [("STR_ADVSEC_manager" call ADVSEC_fnc_L), 1]]]]]];
                };
                default {};
            };
        };
        ADVSEC_pdbActs = _acts;
        ADVSEC_pdbConfirm = [-1, 0];
        for "_i" from 0 to 4 do {
            private _b = _disp displayCtrl (87880 + _i);
            private _a = _acts param [_i, []];
            _b ctrlShow (_a isNotEqualTo []);
            if (_a isNotEqualTo []) then {_b ctrlSetText (_a select 0)};
        };
    };

    // Pulsación de un botón de acción. Lo destructivo pide una segunda pulsación en 4 s
    case "act": {
        private _a = (missionNamespace getVariable ["ADVSEC_pdbActs", []]) param [_arg, []];
        if (_a isEqualTo [] || {ADVSEC_pdbSel isEqualTo ""}) exitWith {};
        _a params ["_text", "_op", "_data", "_confirm", "_form"];
        private _b = _disp displayCtrl (87880 + _arg);
        if (_confirm && {(ADVSEC_pdbConfirm select 0) != _arg || {time - (ADVSEC_pdbConfirm select 1) > 4}}) exitWith {
            ADVSEC_pdbConfirm = [_arg, time];
            _b ctrlSetText ("STR_ADVSEC_sure_press_again" call ADVSEC_fnc_L);
            [_b, _arg, _text] spawn {
                params ["_b", "_i", "_text"];
                sleep 4;
                if (!isNull _b && {(ADVSEC_pdbConfirm select 0) == _i}) then {_b ctrlSetText _text; ADVSEC_pdbConfirm = [-1, 0]};
            };
        };
        ADVSEC_pdbConfirm = [-1, 0];
        _b ctrlSetText _text;
        private _uid = ADVSEC_pdbSel;
        if (_form isNotEqualTo []) exitWith {
            _form params ["_title", "_fields"];
            [_title, _fields, {
                params ["_v", "_ctx"];
                _ctx params ["_uid", "_op", "_d"];
                ["edit", player, [_uid, _op, [[_d, _v], _v] select (_d isEqualTo "")]] remoteExecCall ["ADVSEC_fnc_pdbViewServer", 2];
            }, [_uid, _op, _data]] call ADVSEC_fnc_zeusPrompt;
        };
        ["edit", player, [_uid, _op, _data]] remoteExecCall ["ADVSEC_fnc_pdbViewServer", 2];
    };
};
