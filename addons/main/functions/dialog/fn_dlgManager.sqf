/*
    Gestor de la misión (Eden, barra superior › ADVSEC, 1.21.1). [acción, args]
    Lista todo lo que hay en la misión (unidades, vehículos, objetos, módulos, disparadores y marcadores), con filtro
    y búsqueda, y deja elegir qué editar: el diálogo por nodos, los atributos de Eden o ir hasta ello con la cámara.
*/
params ["_a", ["_p", []]];
private _st = uiNamespace getVariable ["ADVSEC_dlgMan", createHashMap];
private _L = {_this call ADVSEC_fnc_L};
private _X = safeZoneX + safeZoneW * 0.22;
private _W = safeZoneW * 0.56;
private _Y = safeZoneY + 0.08;
private _H = safeZoneH - 0.16;
private _mk = {
    params ["_cls", "_pos", ["_txt", ""]];
    private _c = (_st get "d") ctrlCreate [_cls, -1];
    _c ctrlSetPosition _pos;
    _c ctrlCommit 0;
    if (_txt isNotEqualTo "") then {_c ctrlSetText _txt};
    _c
};
// Entidad -> [texto, categoría (0 unidad, 1 vehículo, 2 objeto, 3 módulo, 4 disparador, 5 marcador), tieneDiálogo, nodos]
private _info = {
    params ["_e"];
    if (_e isEqualType "") exitWith {[format ["%1 · %2", _e, getText (configFile >> "CfgMarkers" >> getMarkerType _e >> "name")], 5, false, 0]};
    private _cls = typeOf _e;
    private _dn = getText (configOf _e >> "displayName");
    private _nm = (_e get3DENAttribute "name") param [0, ""];
    private _cat = switch (true) do {
        case (_e isKindOf "Logic"): {3};
        case (_e isKindOf "EmptyDetector"): {4};
        case (_e isKindOf "CAManBase"): {0};
        case (_e isKindOf "AllVehicles"): {1};
        default {2};
    };
    private _dl = ["parse", (_e get3DENAttribute "ADVSEC_Dialog") param [0, ""]] call ADVSEC_fnc_dlgData;
    private _n = count (_dl param [1, []]);
    [format ["%1%2", [_nm + " · ", ""] select (_nm isEqualTo ""), [_dn, _cls] select (_dn isEqualTo "")], _cat, _n > 0, _n]
};

switch (_a) do {
    case "open": {
        private _e3 = findDisplay 313;
        if (isNull _e3) exitWith {};
        private _d = _e3 createDisplay "ADVSEC_DlgEditor";
        if (isNull _d) exitWith {};
        _st = createHashMapFromArray [["d", _d], ["rows", []]];
        uiNamespace setVariable ["ADVSEC_dlgMan", _st];
        ["ADVSEC_Panel", [_X, _Y, _W, _H]] call _mk;
        ["ADVSEC_Border", [_X, _Y, _W, _H]] call _mk;
        ["ADVSEC_Header", [_X + 0.01, _Y, _W - 0.06, 0.045], "STR_ADVSEC_man_title" call _L] call _mk;
        private _bx = ["ADVSEC_BtnX", [_X + _W - 0.045, _Y + 0.005, 0.035, 0.035]] call _mk;
        _bx ctrlSetEventHandler ["ButtonClick", "['close'] call ADVSEC_fnc_dlgManager; true"];
        ["ADVSEC_Line", [_X, _Y + 0.045, _W, 0.003]] call _mk;
        private _cb = ["ADVSEC_Combo", [_X + 0.01, _Y + 0.06, _W * 0.4, 0.04]] call _mk;
        {_cb lbAdd (_x call _L)} forEach ["STR_ADVSEC_man_f_all", "STR_ADVSEC_man_f_units", "STR_ADVSEC_man_f_vehicles", "STR_ADVSEC_man_f_objects", "STR_ADVSEC_man_f_modules", "STR_ADVSEC_man_f_triggers", "STR_ADVSEC_man_f_markers", "STR_ADVSEC_man_f_dialog", "STR_ADVSEC_man_f_advsec"];
        _cb lbSetCurSel 0;
        _cb ctrlAddEventHandler ["LBSelChanged", "['refresh'] call ADVSEC_fnc_dlgManager"];
        _st set ["filter", _cb];
        private _q = ["ADVSEC_Edit", [_X + 0.02 + _W * 0.4, _Y + 0.06, _W * 0.6 - 0.03, 0.04]] call _mk;
        _q ctrlSetTooltip ("STR_ADVSEC_filter_by_name_or_class" call _L);
        _q ctrlAddEventHandler ["KeyUp", "['refresh'] call ADVSEC_fnc_dlgManager"];
        _st set ["search", _q];
        private _lb = ["ADVSEC_List", [_X + 0.01, _Y + 0.11, _W - 0.02, _H - 0.24]] call _mk;
        _lb ctrlAddEventHandler ["LBDblClick", "['edit'] call ADVSEC_fnc_dlgManager"];
        _lb ctrlAddEventHandler ["LBSelChanged", "['sel'] call ADVSEC_fnc_dlgManager"];
        _st set ["list", _lb];
        _st set ["info", ["ADVSEC_Struct", [_X + 0.01, _Y + _H - 0.125, _W - 0.02, 0.06]] call _mk];
        private _bw = (_W - 0.06) / 5;
        {
            _x params ["_t", "_act", "_cls"];
            private _b = [_cls, [_X + 0.01 + _forEachIndex * (_bw + 0.01), _Y + _H - 0.055, _bw, 0.045], _t call _L] call _mk;
            _b ctrlAddEventHandler ["ButtonClick", format ["['%1'] call ADVSEC_fnc_dlgManager", _act]];
            _st set ["b_" + _act, _b];
        } forEach [["STR_ADVSEC_man_edit_dlg", "edit", "ADVSEC_BtnPrimary"], ["STR_ADVSEC_man_del_dlg", "del", "ADVSEC_BtnDanger"], ["STR_ADVSEC_man_attrs", "attrs", "ADVSEC_Btn"], ["STR_ADVSEC_man_goto", "goto", "ADVSEC_Btn"], ["STR_ADVSEC_man_close", "close", "ADVSEC_Btn"]];
        _d displayAddEventHandler ["Unload", "uiNamespace setVariable ['ADVSEC_dlgMan', nil]"];
        ["refresh"] call ADVSEC_fnc_dlgManager;
    };
    case "refresh": {
        if (isNull (_st getOrDefault ["d", displayNull])) exitWith {};
        private _f = lbCurSel (_st get "filter");
        private _q = toLower ctrlText (_st get "search");
        all3DENEntities params [["_objs", []], "", ["_trg", []], ["_sys", []], "", ["_mrk", []]];
        private _rows = [];
        {
            private _e = _x;
            (_e call _info) params ["_t", "_cat", "_hasD", "_n"];
            private _cls = [typeOf _e, _e] select (_e isEqualType "");
            private _ok = switch (_f) do {
                case 1: {_cat == 0}; case 2: {_cat == 1}; case 3: {_cat == 2}; case 4: {_cat == 3}; case 5: {_cat == 4}; case 6: {_cat == 5};
                case 7: {_hasD};
                case 8: {(_cls select [0, 7]) == "ADVSEC_" || {_hasD}};
                default {true};
            };
            if (_ok && {_q isEqualTo "" || {(toLower _t) find _q >= 0} || {(toLower _cls) find _q >= 0}}) then {_rows pushBack [_e, _t, _cat, _hasD, _n, _cls]};
        } forEach (_objs + _sys + _trg + _mrk);
        _st set ["rows", _rows];
        private _lb = _st get "list";
        private _keep = lbCurSel _lb;
        lbClear _lb;
        private _icons = ["\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa", "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa", "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa",
            "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa", "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa", "\A3\ui_f\data\igui\cfg\simpleTasks\types\map_ca.paa"];
        {
            _x params ["", "_t", "_cat", "_hasD", "_n"];
            private _i = _lb lbAdd _t;
            _lb lbSetPicture [_i, _icons select _cat];
            _lb lbSetTooltip [_i, _x select 5];
            if (_hasD) then {_lb lbSetTextRight [_i, format [("STR_ADVSEC_man_n_nodes" call _L), _n]]; _lb lbSetColorRight [_i, [0.82, 0.64, 0.19, 1]]};
        } forEach _rows;
        _lb lbSetCurSel ((_keep min (count _rows - 1)) max 0);
        ["sel"] call ADVSEC_fnc_dlgManager;
    };
    case "sel": {
        private _r = (_st get "rows") param [lbCurSel (_st get "list"), []];
        private _canD = _r isNotEqualTo [] && {(_r select 2) in [0, 1, 2]};
        (_st get "b_edit") ctrlEnable _canD;
        (_st get "b_del") ctrlEnable (_canD && {_r select 3});
        (_st get "b_attrs") ctrlEnable (_r isNotEqualTo []);
        (_st get "b_goto") ctrlEnable (_r isNotEqualTo []);
        (_st get "info") ctrlSetStructuredText parseText (if (_r isEqualTo []) then {format ["<t color='#8C8C8C'>%1</t>", "STR_ADVSEC_man_empty" call _L]} else {
            format ["<t color='#d0a330'>%1</t> <t color='#8C8C8C'>(%2)</t><br/><t color='#8C8C8C' size='0.9'>%3</t>", [_r select 1] call ADVSEC_fnc_repEsc, _r select 5,
                ["STR_ADVSEC_man_hint_dlg" call _L, "STR_ADVSEC_man_hint_nodlg" call _L] select !_canD]
        });
    };
    case "edit": {
        private _r = (_st get "rows") param [lbCurSel (_st get "list"), []];
        if (_r isEqualTo [] || {!((_r select 2) in [0, 1, 2])}) exitWith {};
        ["open", [controlNull, _r select 0, _st get "d"]] call ADVSEC_fnc_dlgEditor;
    };
    case "del": {
        private _r = (_st get "rows") param [lbCurSel (_st get "list"), []];
        if (_r isEqualTo [] || {!(_r select 3)}) exitWith {};
        private _e = _r select 0;
        collect3DENHistory {_e set3DENAttribute ["ADVSEC_Dialog", ""]};
        ["refresh"] call ADVSEC_fnc_dlgManager;
    };
    case "attrs": {
        private _r = (_st get "rows") param [lbCurSel (_st get "list"), []];
        if (_r isEqualTo []) exitWith {};
        (_st get "d") closeDisplay 1;
        set3DENSelected [_r select 0];
        do3DENAction "OpenAttributes";
    };
    case "goto": {
        private _r = (_st get "rows") param [lbCurSel (_st get "list"), []];
        if (_r isEqualTo []) exitWith {};
        private _e = _r select 0;
        private _pos = [getPosATL _e, getMarkerPos _e] select (_e isEqualType "");
        (_st get "d") closeDisplay 1;
        set3DENSelected [_e];
        move3DENCamera [_pos, true];
    };
    case "close": {(_st get "d") closeDisplay 2};
};
