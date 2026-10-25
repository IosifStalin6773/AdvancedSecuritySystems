// ["query", llamador, [unidad, texto]] (servidor) — ficha de antecedentes: documentos, requisitorias, multas, arrestos, informes y (AA.II.) expedientes
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "query"] call ADVSEC_fnc_perm) exitWith {[_caller, "consultar la base central"] call ADVSEC_fnc_deny};
if (!isClass (configFile >> "CfgPatches" >> "tfar_core") && {!isClass (configFile >> "CfgPatches" >> "acre_main")} && {!([_caller] call ADVSEC_fnc_hasRadio)}) exitWith {
    ["query", "<t color='#FF4D4D'>Sin enlace con la central: necesitas una radio.</t>", []] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
};
if (_caller getVariable ["ADVSEC_queryBusy", false]) exitWith {};
_caller setVariable ["ADVSEC_queryBusy", true];
_args params [["_unit", objNull], ["_text", ""]];
[_caller, _unit, _text] spawn {
    params ["_caller", "_unit", "_text"];
    sleep (["queryDelay", 3] call ADVSEC_fnc_setting);
    _caller setVariable ["ADVSEC_queryBusy", false];
    if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
    if (isNil "ADVSEC_repDB") then {[] call ADVSEC_fnc_repLoad};
    private _store = [] call ADVSEC_fnc_docStore;
    private _fines = [] call ADVSEC_fnc_fineDB;
    private _esc = {[_this] call ADVSEC_fnc_repEsc};

    // Resolver la persona
    private _key = ""; private _name = "";
    if (!isNull _unit) then {_key = [_unit] call ADVSEC_fnc_docKey; _name = name _unit} else {
        private _t = toLower _text;
        if (_text in _store || {_text in ADVSEC_wantedDB} || {_text in _fines}) then {_key = _text} else {
            {
                private _k = _x;
                {if (toLower (_x getOrDefault ["name", ""]) find _t > -1) exitWith {_key = _k; _name = _x get "name"}} forEach _y;
                if (_key isNotEqualTo "") exitWith {};
            } forEach _store;
            if (_key isEqualTo "") then {{if (toLower (_y select 0) find _t > -1) exitWith {_key = _x; _name = _y select 0}} forEach ADVSEC_wantedDB};
            if (_key isEqualTo "") then {{if (_y isNotEqualTo [] && {toLower ((_y select -1) select 7) find _t > -1}) exitWith {_key = _x; _name = (_y select -1) select 7}} forEach _fines};
        };
        if (_name isEqualTo "" && {_key isNotEqualTo ""}) then {
            private _o = allPlayers select {getPlayerUID _x == _key};
            _name = [_key, name (_o select 0)] select (_o isNotEqualTo []);
        };
    };
    if (_key isEqualTo "") exitWith {
        ["query", format ["Sin coincidencias para «%1».", _text call _esc], []] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };

    private _rows = [];
    private _h = {params ["_t"]; _rows pushBack [_t, [], "", [0.4, 0.8, 1, 1], ""]};
    private _ai = [_caller, "AI"] call ADVSEC_fnc_repAccess;

    // Requisitoria
    ["REQUISITORIAS"] call _h;
    private _w = ADVSEC_wantedDB getOrDefault [_key, []];
    if (_w isEqualTo []) then {_rows pushBack ["    Sin requisitorias", [], "", [0.4, 1, 0.4, 1], ""]} else {
        _w params ["", "_reason", "_level", "_by", "_date"];
        _rows pushBack [format ["    BUSCADO · %1 · %2", _level, _reason], [], format ["<t color='#FF4D4D' font='RobotoCondensedBold'>BUSCADO</t><br/>Motivo: %1<br/>Peligrosidad: %2<br/>Emitida por: %3<br/>Fecha: %4", _reason call _esc, _level, _by call _esc, _date], [1, 0.3, 0.3, 1], ADVSEC_icPol];
    };
    // Arresto
    private _j = ADVSEC_jailDB getOrDefault [_key, []];
    if (_j isNotEqualTo []) then {
        _j params ["_secs", "_reason", "", "_by", "_jname"];
        _rows pushBack [format ["    ARRESTO PENDIENTE · %1 · %2 min", _jname, round (_secs / 60)], [], format ["Centro: %1<br/>Motivo: %2<br/>Agente: %3", _jname call _esc, _reason call _esc, _by call _esc], [1, 0.6, 0.2, 1], ADVSEC_icJail];
    };
    // Documentos
    ["DOCUMENTOS EN REGISTRO"] call _h;
    private _docs = _store getOrDefault [_key, []];
    if (_docs isEqualTo []) then {_rows pushBack ["    Ninguno", [], "", [], ""]};
    {
        private _cfg = [_x get "type"] call ADVSEC_fnc_docTypeCfg;
        _rows pushBack [format ["    %1 · %2", getText (_cfg >> "displayName"), _x getOrDefault ["expires", "sin caducidad"]], [], [_x] call ADVSEC_fnc_docFormat, [], getText (_cfg >> "icon")];
    } forEach _docs;
    // Multas
    private _fl = _fines getOrDefault [_key, []];
    private _due = 0;
    {if ((_x select 6) == "Pendiente") then {_due = _due + (_x select 2)}} forEach _fl;
    ["MULTAS"] call _h;
    private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
    _rows pushBack [format ["    %1 multas · pendiente %2 %3", count _fl, _due, _cur], ["K", _key, _name],
        ((_fl select [(count _fl - 10) max 0]) apply {format ["%1 · %2 · %3 %4 · %5 · %6", _x select 0, _x select 1, _x select 2, _cur, (_x select 3) call _esc, _x select 6]}) joinString "<br/>",
        [[], [1, 0.6, 0.2, 1]] select (_due > 0), ADVSEC_icDoc];
    // Informes que le nombran
    ["INFORMES"] call _h;
    private _n = 0;
    {
        if (((_y getOrDefault ["subjects", []]) joinString " ") find _key > -1 || {_name isNotEqualTo "" && {((_y getOrDefault ["subjects", []]) joinString " ") find _name > -1}}) then {
            private _secret = (_y get "dept") == "AI" || {_y getOrDefault ["confidential", false]};
            if (_secret && !_ai) then {continue};
            _n = _n + 1;
            _rows pushBack [format ["    %1 · %2 · %3", _x, _y get "status", _y get "title"], [], format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Estado: %3 · Gravedad: %4<br/>Autor: %5 · %6", _x, (_y get "title") call _esc, _y get "status", _y get "gravity", (_y get "author") call _esc, _y get "created"],
                [[], [1, 0.5, 0.9, 1]] select _secret, ADVSEC_icDoc];
        };
    } forEach ADVSEC_repDB;
    if (_n == 0) then {_rows pushBack ["    Ninguno", [], "", [], ""]};
    // Sospecha (AA.II.)
    if ([_caller, "suspicionView"] call ADVSEC_fnc_perm && {(_key select [0, 3]) != "AI:"}) then {
        private _e = [_key] call ADVSEC_fnc_heatGet;
        if ((_e select 0) > 0) then {
            ["ASUNTOS INTERNOS"] call _h;
            _rows pushBack [format ["    Índice de sospecha: %1", round (_e select 0)], [], ((_e select 2) apply {format ["%1 · %2 (+%3)", _x select 0, (_x select 1) call _esc, _x select 2]}) joinString "<br/>", [1, 0.5, 0.9, 1], ADVSEC_icPol];
        };
    };
    ["queryRun", _caller, [_key, _name]] call ADVSEC_fnc_logEvent;
    ["query", format ["<t size='1.15' font='RobotoCondensedBold'>%1</t> · %2%3", _name call _esc, _key, ["", " · <t color='#FF4D4D'>BUSCADO</t>"] select (_w isNotEqualTo [])], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
};
