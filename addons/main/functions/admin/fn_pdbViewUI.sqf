// ["filter"|"select"|"tab"|"row"|"refresh"|"header"|"render", dato] (cliente) — base de datos de jugadores
params ["_action", ["_arg", 0]];
private _disp = findDisplay 87850;
if (isNull _disp) exitWith {};

private _tabNames = ["Resumen", "Documentos", "Sanciones", "Informes", "Sospecha", "Evidencias", "Economía", "Especialidades", "Registro"];
private _tabPos = [
    [0, 0.3], [0, 0.3, 0.55, 0.75], [0, 0.2, 0.4, 0.62, 0.84], [0, 0.2, 0.42, 0.8], [0, 0.35, 0.9],
    [0, 0.16, 0.34, 0.56, 0.78], [0, 0.34, 0.8], [0, 0.4, 0.7], [0, 0.3, 0.6]
];
private _esc = {[_this] call ADVSEC_fnc_repEsc};

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
        _c lnbSetColumnsPos [0, 0.5, 0.68, 0.84];
        _c lnbAddRow ["NOMBRE", "PM", "AA.II.", "GLOBAL"];
        {
            private _r = _c lnbAddRow (_x select 1);
            _c lnbSetData [[_r, 0], _x select 0];
        } forEach _shown;
        private _at = _shown findIf {(_x select 0) == ADVSEC_pdbSel};
        if (_at >= 0) then {_c lnbSetCurSelRow (_at + 1)};
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText format ["<t color='#8C8C8C'>%1 jugadores · %2 mostrados</t>", count ADVSEC_pdbList, count _shown];
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
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Cargando ficha...</t>";
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
        [87861, "TIEMPO JUGADO", _play] call _tile;
        [87862, "EFECTIVO", _cash] call _tile;
        [87863, "BANCO", _bank] call _tile;
        private _flags = [];
        if (_on) then {_flags pushBack "<t color='#66FF66'>EN LÍNEA</t>"};
        if (_adm) then {_flags pushBack "<t color='#D0A330'>SUPERADMINISTRADOR</t>"};
        (_disp displayCtrl 87864) ctrlSetStructuredText parseText format [
            "<t size='1.25' font='RobotoCondensedBold'>%1</t>  %2<br/><t color='#8C8C8C'>SteamID</t> %3",
            [_name] call _esc, _flags joinString " · ", [_uid] call _esc];
    };

    // Pinta la tabla de la pestaña activa y las etiquetas de las pestañas con su número de filas
    case "render": {
        for "_i" from 0 to 8 do {
            private _sec = ADVSEC_pdbSections param [_i, [[], []]];
            private _n = count (_sec select 1);
            private _b = _disp displayCtrl (87870 + _i);
            _b ctrlSetText format ["%1%2", _tabNames select _i, [format [" (%1)", _n], ""] select (_n == 0)];
            if (_i == ADVSEC_pdbTab) then {
                _b ctrlSetBackgroundColor ADVSEC_COL_ACCENT;
                _b ctrlSetTextColor ADVSEC_COL_DARK;
            } else {
                _b ctrlSetBackgroundColor ADVSEC_COL_BTN;
                _b ctrlSetTextColor ADVSEC_COL_TEXTD;
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
            _c lnbSetText [[_e, 0], "Sin registros en esta sección"];
        };
        {
            _x params ["_cells", "_det"];
            private _r = _c lnbAddRow _cells;
            _c lnbSetData [[_r, 0], _det];
        } forEach _rows;
        (_disp displayCtrl 87891) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Selecciona una fila para ver su detalle.</t>";
    };

    // Detalle de la fila seleccionada
    case "row": {
        private _c = _disp displayCtrl 87890;
        private _r = lnbCurSelRow _c;
        private _txt = if (_r < 1) then {"<t color='#8C8C8C'>Selecciona una fila para ver su detalle.</t>"} else {[_c lnbData [_r, 0]] call _esc};
        (_disp displayCtrl 87891) ctrlSetStructuredText parseText _txt;
    };
};
