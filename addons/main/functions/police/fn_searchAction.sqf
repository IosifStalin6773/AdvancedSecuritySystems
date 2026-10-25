params ["_action"];
private _disp = findDisplay 86800;
if (isNull _disp) exitWith {};
private _t = ADVSEC_searchTarget;
private _lb = _disp displayCtrl 86803;
private _cfgOf = {
    params ["_c"];
    private _r = configNull;
    {if (isClass (configFile >> _x >> _c)) exitWith {_r = configFile >> _x >> _c}} forEach ["CfgWeapons", "CfgMagazines", "CfgGlasses"];
    _r
};

private _zones = [
    ["hands", "Manos y armas al cuerpo", 2],
    ["torso", "Torso (chaleco)", 3],
    ["waist", "Cintura y bolsillos (uniforme)", 3],
    ["legs", "Piernas y escondites", 5],
    ["back", "Mochila", 4]
];
private _sub = {
    params ["_list", "_rm"];
    {private _i = _list find _x; if (_i > -1) then {_list deleteAt _i}} forEach _rm;
    _list
};

switch (_action) do {
    case "fill": {
        (_disp displayCtrl 86801) ctrlSetText format [" REGISTRO · %1", toUpper name _t];
        private _w = (missionNamespace getVariable ["ADVSEC_wanted", []]) select {(_x select 0) == getPlayerUID _t};
        private _info = format ["<t color='#8C8C8C'>SteamID:</t> %1 · <t color='#8C8C8C'>Unidad:</t> %2 · %3",
            getPlayerUID _t, groupId group _t,
            ["<t color='#66FF66'>sin esposar</t>", "<t color='#D96600'>esposado</t>"] select ([_t] call ADVSEC_fnc_isRestrained)];
        _info = _info + (if (_w isEqualTo []) then {"<br/><t color='#66FF66'>Sin requisitorias.</t>"} else {
            format ["<br/><t color='#FF4D4D' font='RobotoCondensedBold'>BUSCADO (%1): %2</t>", (_w select 0) select 3, [(_w select 0) select 2] call ADVSEC_fnc_repEsc]
        });
        _info = _info + "<br/><t color='#8C8C8C'>Selecciona una zona y pulsa Registrar zona (o doble clic).</t>";
        (_disp displayCtrl 86802) ctrlSetStructuredText parseText _info;

        lbClear _lb;
        ADVSEC_searchRows = [];
        private _row = {
            params ["_text", "_pic", "_data", ["_col", []]];
            private _i = _lb lbAdd _text;
            _lb lbSetPicture [_i, _pic];
            if (_col isNotEqualTo []) then {_lb lbSetColor [_i, _col]};
            ADVSEC_searchRows pushBack _data;
        };
        ADVSEC_searchDocs = [_t] call ADVSEC_fnc_docGetAll;
        private _docUsed = [];
        private _docItems = ([] call ADVSEC_fnc_docTypes) apply {getText (([_x] call ADVSEC_fnc_docTypeCfg) >> "item")};
        private _hidden = (_t getVariable ["ADVSEC_hidden", []]) select {_x in (uniformItems _t + vestItems _t)};
        private _count = {
            params ["_list"];
            private _h = createHashMap;
            {_h set [_x, (_h getOrDefault [_x, 0]) + 1]} forEach _list;
            _h
        };
        // Filas de objetos de una zona: documentos primero (con su índice), luego armas, munición y objetos
        private _items = {
            params ["_list"];
            {
                if (_forEachIndex in _docUsed) then {continue};
                private _cfg = [_x get "type"] call ADVSEC_fnc_docTypeCfg;
                private _it = getText (_cfg >> "item");
                private _i = _list find _it;
                if (_i > -1) then {
                    _list deleteAt _i;
                    _docUsed pushBack _forEachIndex;
                    ["    DOCUMENTO · " + getText (_cfg >> "displayName") + " · " + (_x getOrDefault ["name", ""]), getText (_cfg >> "icon"), ["D", _forEachIndex, _it], [0.816, 0.639, 0.188, 1]] call _row;
                };
            } forEach ADVSEC_searchDocs;
            {
                if (_x in _docItems) then {continue};
                private _c = [_x] call _cfgOf;
                if (isNull _c) then {continue};
                private _mag = isClass (configFile >> "CfgMagazines" >> _x);
                [format ["    %1 · %2 x%3", ["OBJETO", "MUNICIÓN"] select _mag, getText (_c >> "displayName"), _y], getText (_c >> "picture"), [["I", "M"] select _mag, _x]] call _row;
            } forEach ([_list] call _count);
        };
        {
            _x params ["_z", "_label"];
            private _done = _z in ADVSEC_searchZones;
            [format ["%1 %2", ["▸ REGISTRAR:", "▾"] select _done, toUpper _label], ADVSEC_icSearch, ["Z", _z], [[0.6, 0.6, 0.6, 1], [0.4, 0.8, 1, 1]] select _done] call _row;
            if (_done) then {
                switch (_z) do {
                    case "hands": {
                        {
                            private _c = configFile >> "CfgWeapons" >> _x;
                            [format ["    ARMA · %1", getText (_c >> "displayName")], getText (_c >> "picture"), ["W", _x], [0.851, 0.4, 0, 1]] call _row;
                        } forEach weapons _t;
                        [+(assignedItems _t)] call _items;
                    };
                    case "torso": {[[vestItems _t, _hidden] call _sub] call _items};
                    case "waist": {[[uniformItems _t, _hidden] call _sub] call _items};
                    case "back": {
                        if (backpack _t isEqualTo "") then {["    (sin mochila)", "", ["N"]] call _row} else {[backpackItems _t] call _items};
                    };
                    case "legs": {
                        private _found = ADVSEC_searchFound select {_x in _hidden};
                        if (_found isEqualTo []) then {["    Nada a la vista", "", ["N"]] call _row} else {[_found] call _items};
                    };
                };
            };
        } forEach _zones;
        if (lbSize _lb > 0) then {_lb lbSetCurSel 0};
    };
    case "zone": {
        private _r = ADVSEC_searchRows param [lbCurSel _lb, []];
        if (_r isEqualTo [] || {(_r select 0) != "Z"}) exitWith {};
        if (!isNil "ADVSEC_searchBusy") exitWith {hint "Ya estás registrando."};
        private _z = _r select 1;
        private _def = _zones select (_zones findIf {(_x select 0) == _z});
        ADVSEC_searchBusy = true;
        [_t, _z, _def] spawn {
            params ["_t", "_z", "_def"];
            private _secs = _def select 2;
            private _end = time + _secs;
            while {time < _end && {!isNull findDisplay 86800} && {(player distance _t) < 4}} do {
                hintSilent format ["Registrando: %1
%2 s", _def select 1, ceil (_end - time)];
                sleep 0.25;
            };
            ADVSEC_searchBusy = nil;
            hintSilent "";
            if (time < _end) exitWith {hint "Registro interrumpido."};
            if (_z == "legs") then {
                private _p = ["hiddenFindChance", 0.75] call ADVSEC_fnc_setting;
                {if (random 1 < _p) then {ADVSEC_searchFound pushBackUnique _x}} forEach (_t getVariable ["ADVSEC_hidden", []]);
            };
            ADVSEC_searchZones pushBackUnique _z;
            ["fill"] call ADVSEC_fnc_searchAction;
        };
    };
    case "view": {
        private _r = ADVSEC_searchRows param [lbCurSel _lb, []];
        if ((_r param [0, ""]) == "Z") exitWith {["zone"] call ADVSEC_fnc_searchAction};
        if (_r isEqualTo [] || {(_r select 0) != "D"}) exitWith {hint "Selecciona un documento o una zona."};
        [[ADVSEC_searchDocs select (_r select 1)] call ADVSEC_fnc_docPairs, name _t, _t] call ADVSEC_fnc_docView;
    };
    case "seize": {
        private _r = ADVSEC_searchRows param [lbCurSel _lb, []];
        if (_r isEqualTo [] || {(_r select 0) in ["Z", "N"]}) exitWith {};
        _r params ["_k", "_class", ["_item", ""]];
        if (_k == "D") then {_k = "I"; _class = _item};
        [_t, "seize", [_k, _class]] call ADVSEC_fnc_policeLocal;
        ADVSEC_searchSeized pushBack ((_lb lbText (lbCurSel _lb)) trim [" ", 1]);
        if (_class in ADVSEC_searchFound) then {ADVSEC_searchFound deleteAt (ADVSEC_searchFound find _class)};
        hint "Incautado: depositado en el suelo junto a ti.";
        [] spawn {sleep 0.7; ["fill"] call ADVSEC_fnc_searchAction};
    };
    case "report": {
        private _all = [];
        for "_i" from 0 to (lbSize _lb - 1) do {
            if !(((ADVSEC_searchRows select _i) select 0) in ["Z", "N"]) then {_all pushBack ((_lb lbText _i) trim [" ", 1])};
        };
        closeDialog 0;
        private _subject = format ["%1 [%2]", name _t, getPlayerUID _t];
        private _body = format ["Registro practicado por %1 a %2 (cuadrícula %3). Zonas registradas: %7.%4Inventario:%4- %5%4%4Incautado:%4- %6",
            name player, _subject, mapGridPosition _t, endl,
            _all joinString (endl + "- "),
            [ADVSEC_searchSeized joinString (endl + "- "), "nada"] select (ADVSEC_searchSeized isEqualTo []),
            [ADVSEC_searchZones joinString ", ", "ninguna"] select (ADVSEC_searchZones isEqualTo [])];
        ["PM", _subject, format ["Registro e incautación · %1", name _t], _body, "FPM03"] call ADVSEC_fnc_repEditorOpen;
    };
};
