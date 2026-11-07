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
if !([_caller] call ADVSEC_fnc_adminIs) exitWith {[_caller, "consultar la base de datos de jugadores"] call ADVSEC_fnc_deny};
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
        private _res = [
            ["Nombre", _name],
            ["Nombres anteriores", _alias joinString ", "],
            ["SteamID", _uid],
            ["Estado", ["Desconectado", "En línea"] select _on],
            ["Superadministrador", ["No", "Sí"] select _adm],
            ["Rango PM", [5, _pm] call _rank],
            ["Rango AA.II.", [6, _ai] call _rank],
            ["Rango global", [7, _glob] call _rank],
            ["Primera conexión", _first],
            ["Última conexión", _seen],
            ["Conexiones", str _visits],
            ["Tiempo jugado", format ["%1 h %2 min", floor (_mins / 60), _mins mod 60]],
            ["Multas pendientes", format ["%1 %2", _debt, _currency]],
            ["Buscado", ["No", format ["Sí (%1)", _wanted select 2]] select (_wanted isNotEqualTo [])],
            ["Detenido", ["No", "Sí"] select (_jail isNotEqualTo [])],
            ["Vehículos matriculados", str (count _myPlates)],
            ["Armas registradas", str (count _myWpns)],
            ["Notas", _notes]
        ];
        private _resRows = _res apply {[[_x select 0, _x select 1], _x select 1]};

        // 2. Documentos (documentos, matrículas y armas)
        private _docRows = [];
        {
            private _d = _x;
            _docRows pushBack [[_d getOrDefault ["type", ""], _d getOrDefault ["number", ""], str (_d getOrDefault ["clearance", ""]), _d getOrDefault ["expires", "sin caducidad"]],
                format ["Tipo: %1 · Número: %2 · Nivel: %3 · Caduca: %4", _d getOrDefault ["type", ""], _d getOrDefault ["number", ""], _d getOrDefault ["clearance", ""], _d getOrDefault ["expires", "sin caducidad"]], ["doc"]];
        } forEach (([] call ADVSEC_fnc_docStore) getOrDefault [_uid, []]);
        {
            private _p = _plates get _x;
            _docRows pushBack [["Vehículo", _x, "—", _p select 0], format ["Matrícula %1 · %2 · titular %3 desde %4%5", _x, _p select 0, _p select 2, _p select 3, ["", " · DENUNCIADO ROBO"] select (_p select 4)], ["plate", _x]];
        } forEach _myPlates;
        {
            private _w = _wpns get _x;
            _docRows pushBack [["Arma", _x, "—", _w select 0], format ["Arma %1 · %2 · registrada el %3", _x, _w select 0, _w select 3], ["wpn", _x]];
        } forEach _myWpns;

        // 3. Sanciones: multas, buscados y detenciones
        private _sanRows = [];
        {
            _x params ["_id", "_date", "_amt", "_reason", "_off", "", "_state"];
            _sanRows pushBack [["Multa", _date, format ["%1 %2", _amt, _currency], _reason, _state], format ["Multa %1 · agente %2 · %3", _id, _off, _reason], ["fine", _id, _state]];
        } forEach _fines;
        if (_wanted isNotEqualTo []) then {
            _wanted params ["_wn", "_wreason", "_wlevel", "_wby", "_wdate"];
            _sanRows pushBack [["Buscado", _wdate, format ["Nivel %1", _wlevel], _wreason, "Activo"], format ["Requisitoria · declarada por %1", _wby], ["wanted"]];
        };
        if (_jail isNotEqualTo []) then {
            _jail params ["_secs", "_jreason", "_jn", "_jby", "_jname"];
            private _cond = ["hasta nueva orden", format ["%1 min", round (_secs / 60)]] select (_secs < 1e6);
            _sanRows pushBack [["Detención", "—", _cond, _jreason, _jname], format ["Detenido en %1 por %2", _jname, _jby], ["jail"]];
        };

        // 4. Informes en los que aparece (autor o implicado)
        private _repRows = [];
        {
            private _r = _y;
            private _isAuthor = (_r getOrDefault ["authorUid", ""]) == _uid;
            if (_isAuthor || {_uid in (_r getOrDefault ["subjects", []])}) then {
                _repRows pushBack [[_r getOrDefault ["id", ""], _r getOrDefault ["created", ""], _r getOrDefault ["title", ""], ["Implicado", "Autor"] select _isAuthor],
                    format ["%1 · %2 · estado %3 · gravedad %4 · autor %5", _r getOrDefault ["id", ""], _r getOrDefault ["title", ""], _r getOrDefault ["status", ""], _r getOrDefault ["gravity", ""], _r getOrDefault ["author", ""]], ["rep", _r getOrDefault ["id", ""]]];
            };
        } forEach ADVSEC_repDB;

        // 5. Sospecha (AA.II.)
        private _heat = ([] call ADVSEC_fnc_heatDB) getOrDefault [_uid, []];
        private _heatRows = [];
        if (_heat isNotEqualTo []) then {
            _heat params ["_pts", "", "_evs", "", ["_case", ""]];
            {
                _x params ["_d", "_m", "_p"];
                _heatRows pushBack [[_d, _m, str _p], format ["Puntos: %1 · %2", _p, _m], ["heat"]];
            } forEach _evs;
            _heatRows = [[["—", format ["Índice actual · expediente %1", ["ninguno", _case] select (_case isNotEqualTo "")], str round _pts], format ["Índice actual %1 · expediente %2", round _pts, ["ninguno", _case] select (_case isNotEqualTo "")], ["heat"]]] + _heatRows;
        };

        // 6. Evidencias: recogidas por el jugador o en su custodia
        private _evRows = [];
        {
            private _ev = _y;
            if (((_ev getOrDefault ["uid", ""]) == _uid) || {(_ev getOrDefault ["holder", ""]) == _uid}) then {
                _evRows pushBack [[_x, _ev getOrDefault ["type", ""], _ev getOrDefault ["state", ""], _ev getOrDefault ["holderName", ""], _ev getOrDefault ["result", ""]],
                    format ["%1 · %2 · origen %3 · cuadrícula %4 · %5", _x, _ev getOrDefault ["type", ""], _ev getOrDefault ["name", ""], _ev getOrDefault ["grid", ""], _ev getOrDefault ["time", ""]], ["ev", _x]];
            };
        } forEach ([] call ADVSEC_fnc_evDB);

        // 7. Economía: últimos movimientos
        private _ecoRows = [];
        private _hist = _eco select 3;
        for "_i" from ((count _hist) - 1) to (((count _hist) - 60) max 0) step -1 do {
            (_hist select _i) params ["_hd", "_ht", "_ha"];
            _ecoRows pushBack [[_hd, _ht, str _ha], format ["%1 · %2 · %3 %4", _hd, _ht, _ha, _currency]];
        };
        _ecoRows = [[["—", "Saldo actual (efectivo / banco)", format ["%1 / %2", _cash, _eco select 1]], format ["Efectivo %1 %3 · banco %2 %3", _cash, _eco select 1, _currency]]] + _ecoRows;

        // 8. Especialidades
        private _specRows = [];
        private _specDB = [] call ADVSEC_fnc_specDB;
        {
            private _sid = _x;
            _y params ["_mem", "_man", "_req", ""];
            if (_uid in _mem) then {_specRows pushBack [[_sid, "Miembro", ""], format ["Especialidad %1 · miembro", _sid], ["spec", _sid, 0]]};
            if (_uid in _man) then {_specRows pushBack [[_sid, "Encargado", ""], format ["Especialidad %1 · encargado", _sid], ["spec", _sid, 1]]};
            {
                _x params ["_ru", "_rn", "_rd"];
                if (_ru == _uid) then {_specRows pushBack [[_sid, "Solicitud", _rd], format ["Solicitud para %1 desde %2 (%3)", _sid, _rd, _rn], ["spec", _sid, 2]]};
            } forEach _req;
        } forEach _specDB;

        // 9. Registro: eventos del servidor y visionados de bodycam
        private _logRows = [];
        private _log = localNamespace getVariable ["ADVSEC_eventLog", nil];
        if (isNil "_log") then {_log = +(profileNamespace getVariable [ADVSEC_repKey + "_log", []])};
        {
            _x params ["_ld", "", "_lt", "_ln", "_lu", "_lg", "_lx"];
            if (_lu == _uid || {(str _lx) find _uid > -1}) then {
                _logRows pushBack [[_ld, _lt, _ln], format ["%1 · %2 · %3 · cuadrícula %4 · %5", _ld, _lt, _ln, _lg, str _lx]];
            };
        } forEach _log;
        private _bodyRec = ([] call ADVSEC_fnc_bodyDB) getOrDefault [_uid, ["", []]];
        {
            _x params ["_bd", "_bt", "_bg", "_bx"];
            _logRows pushBack [[_bd, "Bodycam: " + _bt, _name], format ["%1 · bodycam · %2 · cuadrícula %3 · %4", _bd, _bt, _bg, str _bx]];
        } forEach (_bodyRec select 1);
        _logRows = [_logRows, [], {(_x select 0) select 0}, "DESCEND"] call BIS_fnc_sortBy;
        if (count _logRows > 150) then {_logRows resize 150};

        private _sections = [
            [["Campo", "Valor"], _resRows],
            [["Tipo", "Número", "Nivel", "Caducidad"], _docRows],
            [["Tipo", "Fecha", "Importe / condena", "Motivo", "Estado"], _sanRows],
            [["Número", "Fecha", "Título", "Rol"], _repRows],
            [["Fecha", "Motivo", "Puntos"], _heatRows],
            [["Id", "Tipo", "Estado", "Custodia", "Resultado"], _evRows],
            [["Fecha", "Concepto", "Importe"], _ecoRows],
            [["Especialidad", "Rol", "Fecha"], _specRows],
            [["Fecha", "Tipo", "Detalle"], _logRows]
        ];

        // Cabecera: nombre, estado, cuatro tarjetas (conexiones, tiempo, efectivo, banco)
        private _stats = [str _visits, format ["%1 h %2 min", floor (_mins / 60), _mins mod 60], format ["%1 %2", _cash, _currency], format ["%1 %2", _eco select 1, _currency]];
        ["player", [_uid, _name, _on, _adm, _stats, _sections, [_pm, _ai, _glob, _notes]]] remoteExecCall ["ADVSEC_fnc_pdbViewSet", _caller];
    };

    case "edit": {
        _args params [["_uid", ""], ["_op", ""], ["_data", []]];
        private _e = _pdb getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {"Ese jugador ya no tiene ficha." remoteExecCall ["hint", _caller]};
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
                            _changes pushBack format ["%1: %2 → %3", _label, [_i, _e select _i] call ADVSEC_fnc_pdbRankName, [_i, _v] call ADVSEC_fnc_pdbRankName];
                            _e set [_i, _v];
                        };
                    } forEach [[_pm, 5, "PM", 5], [_ai, 6, "AA.II.", 5], [_glob, 7, "global", _maxG]];
                    if (_notes isEqualType "" && {_notes isNotEqualTo (_e select 8)}) then {_e set [8, _notes select [0, 1000]]; _changes pushBack "Notas actualizadas"};
                    if (_changes isEqualTo []) exitWith {};
                    {format ["Superadmin: %1", _x] call _hist} forEach _changes;
                    ["players"] call ADVSEC_fnc_dbDirty;
                    ("Ficha editada: " + (_changes joinString ", ")) call _log;
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
                    _f set [8, format ["%1 por la administración (%2) el %3", _st, name _caller, call ADVSEC_fnc_now]];
                    ["fines"] call ADVSEC_fnc_dbDirty;
                    (format ["Multa %1 marcada como %2", _data, _st]) call _log;
                };
                // [importe, motivo]: solo con el jugador conectado (la multa se le notifica)
                case "fineAdd": {
                    if (isNull _u) exitWith {"El jugador no está conectado: solo se pueden poner multas a jugadores en línea." remoteExecCall ["hint", _caller]};
                    _data params [["_amt", "0"], ["_why", ""]];
                    _amt = round parseNumber _amt;
                    if (_amt <= 0) exitWith {"Importe no válido." remoteExecCall ["hint", _caller]};
                    private _id = [_u, _amt, _why, name _caller + " (administración)", getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
                    (format ["Multa %1 de %2 puesta", _id, _amt]) call _log;
                };
                case "plateDel": {
                    private _db = [] call ADVSEC_fnc_plateDB;
                    if (((_db getOrDefault [_data, ["", ""]]) select 1) isNotEqualTo _uid) exitWith {};
                    _db deleteAt _data;
                    ["plates"] call ADVSEC_fnc_dbDirty;
                    ("Matrícula borrada " + _data) call _log;
                };
                case "wpnDel": {
                    private _db = [] call ADVSEC_fnc_wpnDB;
                    if (((_db getOrDefault [_data, ["", ""]]) select 1) isNotEqualTo _uid) exitWith {};
                    _db deleteAt _data;
                    ["weapons"] call ADVSEC_fnc_dbDirty;
                    ("Arma borrada del registro " + _data) call _log;
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
                    (_s select 3) pushBack [call ADVSEC_fnc_now, name _caller, format ["Administración: retira a %1 (%2)", _e select 0, ["miembro", "encargado", "solicitud"] select _role]];
                    ["spec"] call ADVSEC_fnc_dbDirty;
                    if (!isNull _u) then {[_u] call ADVSEC_fnc_specApply};
                    (format ["Especialidad %1 retirada", _sid]) call _log;
                };
                default {};
            };
        };
        ["list", _caller] call ADVSEC_fnc_pdbViewServer;
        if (_op != "delete") then {["player", _caller, [_uid]] call ADVSEC_fnc_pdbViewServer};
    };

    default {};
};
