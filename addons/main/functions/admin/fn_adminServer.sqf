/*
    [acción, llamador, [categoría, dato]] (servidor) — terminal de superadministrador.
    "list" devuelve la categoría; el resto modifica las bases de datos y vuelve a listar.
    Solo superadministradores (Zeus/admin o lista ADVSEC_superAdmins). Todo queda en el registro de eventos.
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller] call ADVSEC_fnc_adminIs) exitWith {[_caller, "usar la terminal de superadministrador"] call ADVSEC_fnc_deny};
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
    case "repDel": {if (!isNil {ADVSEC_repDB deleteAt _data}) then {["rep"] call ADVSEC_fnc_dbDirty; ["Informe borrado", _data] call _log}};
    case "repWipe": {
        private _n = count ADVSEC_repDB;
        {ADVSEC_repDB deleteAt _x} forEach (keys ADVSEC_repDB);
        ["rep"] call ADVSEC_fnc_dbDirty;
        [format ["TODOS los informes borrados (%1)", _n]] call _log;
    };
    // --- Jugadores y rangos
    case "pdbStrip": {[_data, 0, 0, 0, "Superadmin: retira todos los rangos"] call _setRanks; ["Rangos retirados", _data] call _log};
    case "pdbReset": {[_data, -1, -1, 0, "Superadmin: rangos según la lista de la misión"] call _setRanks; ["Rangos restablecidos", _data] call _log};
    case "pdbStripAll": {
        {[_x, 0, 0, 0, "Superadmin: retirada general de rangos"] call _setRanks} forEach (keys _pdb);
        [format ["Rangos retirados a TODOS (%1 fichas)", count _pdb]] call _log;
    };
    case "pdbDel": {
        if (!isNil {_pdb deleteAt _data}) then {["players"] call ADVSEC_fnc_dbDirty; ["Ficha de jugador borrada", _data] call _log};
    };
    // --- Superadministradores
    case "adminToggle": {
        private _l = call _admins;
        if (_data in _l) then {_l deleteAt (_l find _data); ["Superadmin retirado", _data] call _log} else {_l pushBack _data; ["Superadmin concedido", _data] call _log};
        call _saveAdmins;
    };
    case "adminDel": {
        private _l = call _admins;
        if (_data in _l) then {_l deleteAt (_l find _data); call _saveAdmins; ["Superadmin retirado", _data] call _log} else {
            "Ese SteamID viene de la misión (superAdmins en description.ext): quítalo allí." call _say;
        };
    };
    // --- Buscados
    case "wantedDel": {ADVSEC_wantedDB deleteAt _data; ["wanted"] call ADVSEC_fnc_policeDBSave; ["Requisitoria retirada", _data] call _log};
    case "wantedWipe": {
        {ADVSEC_wantedDB deleteAt _x} forEach (keys ADVSEC_wantedDB);
        ["wanted"] call ADVSEC_fnc_policeDBSave;
        ["Lista de buscados vaciada"] call _log;
    };
    // --- Detenidos
    case "jailDel": {[_data] call _releaseKey; ["Detenido liberado", _data] call _log};
    case "jailWipe": {{[_x] call _releaseKey} forEach (keys ADVSEC_jailDB); ["TODOS los detenidos liberados"] call _log};
    // --- Multas
    case "fineDel": {
        _data params ["_k", "_id"];
        private _db = [] call ADVSEC_fnc_fineDB;
        private _l = (_db getOrDefault [_k, []]) select {(_x select 0) isNotEqualTo _id};
        if (_l isEqualTo []) then {_db deleteAt _k} else {_db set [_k, _l]};
        ["fines"] call ADVSEC_fnc_dbDirty;
        ["Multa borrada", _id] call _log;
    };
    case "fineWipe": {
        private _db = [] call ADVSEC_fnc_fineDB;
        {_db deleteAt _x} forEach (keys _db);
        ["fines"] call ADVSEC_fnc_dbDirty;
        ["TODAS las multas borradas"] call _log;
    };
    // --- Pruebas
    case "evDel": {([] call ADVSEC_fnc_evDB) deleteAt _data; ["ev"] call ADVSEC_fnc_dbDirty; ["Prueba borrada", _data] call _log};
    case "evWipe": {
        private _db = [] call ADVSEC_fnc_evDB;
        {_db deleteAt _x} forEach (keys _db);
        ["ev"] call ADVSEC_fnc_dbDirty;
        ["TODAS las pruebas borradas"] call _log;
    };
    // --- Sospecha (AA.II.)
    case "heatDel": {([] call ADVSEC_fnc_heatDB) deleteAt _data; ["heat"] call ADVSEC_fnc_dbDirty; ["Índice de sospecha archivado", _data] call _log};
    case "heatWipe": {
        private _db = [] call ADVSEC_fnc_heatDB;
        {_db deleteAt _x} forEach (keys _db);
        ["heat"] call ADVSEC_fnc_dbDirty;
        ["TODOS los índices de sospecha archivados"] call _log;
    };
    // --- Documentos
    case "docDel": {[_data] call _docsOff; ["Documentos retirados", _data] call _log};
    case "docWipe": {{[_x] call _docsOff} forEach (keys ([] call ADVSEC_fnc_docStore)); ["TODOS los documentos retirados"] call _log};
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
        [_a, "Ajuste de la administración", _n] call ADVSEC_fnc_ecoHist;
        if (!isNull _u) then {[_u] call ADVSEC_fnc_ecoPush};
        [format ["Dinero %1 %2", ["banco", "efectivo"] select (_where == "cash"), _n], _uid] call _log;
    };
    case "ecoZero": {
        private _a = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_data, []];
        if (_a isEqualTo []) exitWith {};
        _a set [0, 0]; _a set [1, 0];
        [_a, "Saldo puesto a cero por la administración", 0] call ADVSEC_fnc_ecoHist;
        private _u = _online getOrDefault [_data, objNull];
        if (!isNull _u) then {[_u, 0] call ADVSEC_fnc_ecoSetCash; [_u] call ADVSEC_fnc_ecoPush};
        ["Cuenta puesta a cero", _data] call _log;
    };
    case "ecoDel": {
        ([] call ADVSEC_fnc_ecoDB) deleteAt _data;
        ["eco"] call ADVSEC_fnc_dbDirty;
        private _u = _online getOrDefault [_data, objNull];
        if (!isNull _u) then {[_u] call ADVSEC_fnc_ecoPush};
        ["Cuenta borrada", _data] call _log;
    };
    case "ecoWipe": {
        private _db = [] call ADVSEC_fnc_ecoDB;
        {(_db get _x) set [0, 0]; (_db get _x) set [1, 0]} forEach (keys _db);
        ["eco"] call ADVSEC_fnc_dbDirty;
        {[_x, 0] call ADVSEC_fnc_ecoSetCash; [_x] call ADVSEC_fnc_ecoPush} forEach (values _online);
        ["TODAS las cuentas puestas a cero"] call _log;
    };
    case "treasurySet": {
        _data params ["", "_v"];
        private _n = round parseNumber (_v param [0, "0"]);
        [] call ADVSEC_fnc_ecoDB;
        [_n - (localNamespace getVariable ["ADVSEC_treasury", 0]), "Ajuste de la administración"] call ADVSEC_fnc_ecoTreasury;
        [format ["Tesorería fijada en %1", _n]] call _log;
    };
    // --- Registro de eventos
    case "logWipe": {
        private _l = call _events;
        private _n = count _l;
        _l resize 0;
        ["log"] call ADVSEC_fnc_dbDirty;
        [format ["Registro de eventos vaciado (%1 entradas)", _n]] call _log;
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
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>%2<br/><t color='#8C8C8C'>Formato:</t> %3<br/><t color='#8C8C8C'>Estado:</t> %4 · %5<br/><t color='#8C8C8C'>Autor:</t> %6<br/><t color='#8C8C8C'>Fecha:</t> %7<br/><t color='#8C8C8C'>Implicados:</t> %8",
                    (_r getOrDefault ["title", ""]) call _esc, _r get "id", _r getOrDefault ["type", ""], _r getOrDefault ["status", ""], _r getOrDefault ["gravity", ""],
                    (_r getOrDefault ["author", ""]) call _esc, _r getOrDefault ["created", ""], ((_r getOrDefault ["subjects", []]) joinString ", ") call _esc], []];
        } forEach _l;
        _info = format ["Informes y expedientes archivados: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "players": {
        {
            _y params ["_name", "", "", "_last", "", "_pm", "_ai", "_glob"];
            private _adm = _x in (missionNamespace getVariable ["ADVSEC_superAdmins", []]);
            _rows pushBack [format ["%1%2 · PM %3 · AA.II. %4 · %5", ["", "★ "] select _adm, _name, [[5, _pm] call ADVSEC_fnc_pdbRankName, "—"] select (_pm == 0), [[6, _ai] call ADVSEC_fnc_pdbRankName, "—"] select (_ai == 0), [7, _glob] call ADVSEC_fnc_pdbRankName], _x,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t>%2<br/>SteamID: %3<br/>Última conexión: %4<br/>Rango PM: %5<br/>Rango AA.II.: %6<br/>Rango global: %7<br/>%8",
                    _name call _esc, ["", " <t color='#66FF66'>EN LÍNEA</t>"] select (_x in _online), _x, _last,
                    [5, _pm] call ADVSEC_fnc_pdbRankName, [6, _ai] call ADVSEC_fnc_pdbRankName, [7, _glob] call ADVSEC_fnc_pdbRankName,
                    ["", "<t color='#D0A330'>Superadministrador</t>"] select _adm], [[], [0.82, 0.64, 0.19, 1]] select _adm];
        } forEach _pdb;
        _info = format ["Jugadores registrados: <t font='RobotoCondensedBold'>%1</t> · ★ = superadministrador", count _rows];
    };
    case "admins": {
        private _mine = call _admins;
        {
            private _fromMission = !(_x in _mine);
            _rows pushBack [format ["%1 · %2%3", [_x] call _nameOf, _x, [" ", " · (misión)"] select _fromMission], _x,
                format ["SteamID: %1<br/>Origen: %2", _x, ["concedido desde esta terminal", "lista superAdmins de la misión"] select _fromMission], []];
        } forEach (missionNamespace getVariable ["ADVSEC_superAdmins", []]);
        _info = "Además de esta lista, Zeus y los administradores del servidor son siempre superadministradores. Para dar acceso: categoría Jugadores → «Dar / quitar superadmin».";
    };
    case "wanted": {
        {
            _y params ["_name", "_reason", "_level", "_by", "_date"];
            _rows pushBack [format ["%1 · %2", _name, _level], _x, format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Motivo: %3<br/>Peligrosidad: %4<br/>Declarado por: %5 · %6", _name call _esc, _x, _reason call _esc, _level, _by call _esc, _date], []];
        } forEach ADVSEC_wantedDB;
        _info = format ["Requisitorias en vigor: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "jail": {
        {
            _y params ["_secs", "_reason", "_name", "_by", "_jname"];
            _rows pushBack [format ["%1 · %2", _name, _jname], _x, format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Clave: %2<br/>Centro: %3<br/>Motivo: %4<br/>Detenido por: %5<br/>Condena: %6", _name call _esc, _x, _jname call _esc, _reason call _esc, _by call _esc, ["hasta nueva orden", format ["%1 min", round (_secs / 60)]] select (_secs < 1e6)], []];
        } forEach ADVSEC_jailDB;
        _info = format ["Detenidos: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "fines": {
        {
            private _k = _x;
            {
                _x params ["_id", "_date", "_amt", "_reason", "_off", "", "_state", ["_name", ""]];
                _rows pushBack [format ["%1 · %2 · %3 %4 · %5", _id, [_name, [_k] call _nameOf] select (_name isEqualTo ""), _amt, ["currency", "€"] call ADVSEC_fnc_setting, _state], [_k, _id],
                    format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Titular: %2<br/>Importe: %3<br/>Motivo: %4<br/>Agente: %5<br/>Fecha: %6<br/>Estado: %7", _id, _k, _amt, _reason call _esc, _off call _esc, _date, _state], []];
            } forEach _y;
        } forEach ([] call ADVSEC_fnc_fineDB);
        _info = format ["Multas registradas: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "evidence": {
        {
            _rows pushBack [format ["%1 · %2", [_y] call ADVSEC_fnc_evSummary, _y get "state"], _x,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Estado: %2<br/>Custodia: %3<br/>Cuadrícula: %4<br/>Fecha: %5<br/>Resultado: %6", [_y] call ADVSEC_fnc_evSummary, _y get "state", (_y getOrDefault ["holderName", ""]) call _esc, _y getOrDefault ["grid", ""], _y getOrDefault ["time", ""], (_y getOrDefault ["result", ""]) call _esc], []];
        } forEach ([] call ADVSEC_fnc_evDB);
        _info = format ["Pruebas en la base de datos: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "heat": {
        {
            _y params ["_heat", "", "", ["_name", ""], ["_case", ""]];
            _rows pushBack [format ["%1 · %2 pts%3", _name, round _heat, [" · " + _case, ""] select (_case isEqualTo "")], _x, format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Índice: %3<br/>Expediente: %4", _name call _esc, _x, round _heat, ["ninguno", _case] select (_case isNotEqualTo "")], []];
        } forEach ([] call ADVSEC_fnc_heatDB);
        _info = format ["Agentes con índice de sospecha: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "docs": {
        {
            _rows pushBack [format ["%1 · %2 documento(s)", [_x] call _nameOf, count _y], _x,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Clave: %2<br/><br/>%3", ([_x] call _nameOf) call _esc, _x, (_y apply {format ["%1 · %2", _x get "type", _x getOrDefault ["number", ""]]}) joinString "<br/>"], []];
        } forEach ([] call ADVSEC_fnc_docStore);
        _info = format ["Titulares con documentos: <t font='RobotoCondensedBold'>%1</t>", count _rows];
    };
    case "economy": {
        private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
        {
            _y params ["_cash", "_bank", "_name", "_hist"];
            private _u = _online getOrDefault [_x, objNull];
            if (!isNull _u) then {_cash = [_u] call ADVSEC_fnc_ecoCash};
            _rows pushBack [format ["%1 · efectivo %2 · banco %3", _name, _cash, _bank], _x,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t>%2<br/>SteamID: %3<br/>Efectivo: %4 %6<br/>Banco: %5 %6<br/><br/>%7", _name call _esc, ["", " <t color='#66FF66'>EN LÍNEA</t>"] select (!isNull _u), _x, _cash, _bank, _cur,
                    ((_hist select [((count _hist) - 10) max 0]) apply {format ["%1 · %2 · %3", _x select 0, (_x select 1) call _esc, _x select 2]}) joinString "<br/>"], []];
        } forEach ([] call ADVSEC_fnc_ecoDB);
        _info = format ["Cuentas: <t font='RobotoCondensedBold'>%1</t> · Tesorería de la PM: <t font='RobotoCondensedBold'>%2 %3</t>", count _rows, localNamespace getVariable ["ADVSEC_treasury", 0], _cur];
    };
    case "log": {
        private _l = call _events;
        private _from = (count _l - 300) max 0;
        for "_i" from (count _l - 1) to _from step -1 do {
            (_l select _i) params ["_date", "", "_type", "_name", "_uid", "_grid", "_d"];
            _rows pushBack [format ["%1 · %2 · %3", _date, _type, _name], _i, format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Autor: %3 %4<br/>Cuadrícula: %5<br/><br/>%6", _type, _date, _name call _esc, _uid, _grid, (str _d) call _esc], []];
        };
        _info = format ["Registro de eventos: <t font='RobotoCondensedBold'>%1</t> entradas (se muestran las 300 últimas)", count _l];
    };
};
[_cat, _info, _rows] remoteExecCall ["ADVSEC_fnc_adminSet", _caller];
