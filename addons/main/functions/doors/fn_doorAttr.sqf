/*
    Atributo de Eden «Puertas (ADVSEC)»: rejilla con una casilla por puerta del edificio (como «Estados de las puertas»).
    Clic en una puerta -> ventana para ponerle cerradura o keypad con su requisito.
    ["load", grupo, valor] · ["draw", grupo] · ["edit", grupo, índice] · internos: "ok", "all", "clear", "type"
    Valor guardado (texto): [[índice, "lock"|"keypad", bloqueada, pin, zonaAlarma, nivel, "Doc1,Doc2", llave], ...]
*/
params ["_a", ["_g", controlNull], ["_p", nil]];
private _L = {_this call ADVSEC_fnc_L};
private _u = pixelW * pixelGrid * 0.5;
private _v = pixelH * pixelGrid * 0.5;
private _parse = {
    params ["_t"];
    if (!(_t isEqualType "") || {_t isEqualTo ""}) exitWith {[]};
    private _r = parseSimpleArray _t;
    [[], _r] select (_r isEqualType [])
};
private _types = [["", "STR_ADVSEC_dr_none"], ["lock", "STR_ADVSEC_dr_lock"], ["keypad", "STR_ADVSEC_dr_keypad"]];

switch (_a) do {
    case "load": {
        _g setVariable ["ADVSEC_val", [_p, ""] select !(_p isEqualType "")];
        _g setVariable ["ADVSEC_ent", (get3DENSelected "object") param [0, objNull]];
        ["draw", _g] call ADVSEC_fnc_doorAttr;
    };
    case "draw": {
        {ctrlDelete _x} forEach (_g getVariable ["ADVSEC_ctrls", []]);
        private _ctrls = [];
        private _d = ctrlParent _g;
        private _grid = _g controlsGroupCtrl 100;
        private _info = _g controlsGroupCtrl 101;
        private _ent = _g getVariable ["ADVSEC_ent", objNull];
        private _n = if ([_ent] call ADVSEC_fnc_hasDoors) then {count ([_ent, "all"] call ADVSEC_fnc_doorList)} else {0};
        if (_n == 0) exitWith {
            _info ctrlSetText ("STR_ADVSEC_dr_no_doors" call _L);
            _g setVariable ["ADVSEC_ctrls", []];
        };
        private _cfg = [_g getVariable ["ADVSEC_val", ""]] call _parse;
        private _cw = 10 * _u;
        private _ch = 10 * _v;
        for "_i" from 1 to _n do {
            private _e = _cfg param [_cfg findIf {(_x select 0) == _i}, []];
            private _t = _e param [1, ""];
            private _b = _d ctrlCreate ["ctrlButton", -1, _grid];
            _b ctrlSetPosition [((_i - 1) % 8) * _cw + 0.3 * _u, floor ((_i - 1) / 8) * _ch + 0.3 * _v, _cw - 0.6 * _u, _ch - 0.6 * _v];
            _b ctrlCommit 0;
            _b ctrlSetText (str _i + (switch (_t) do {case "lock": {" C"}; case "keypad": {" K"}; default {""}}));
            _b ctrlSetBackgroundColor (switch (_t) do {
                case "lock": {[0.75, 0.45, 0.1, 1]};
                case "keypad": {[0.15, 0.4, 0.75, 1]};
                default {[0.2, 0.2, 0.2, 1]};
            });
            _b ctrlSetTooltip (if (_t isEqualTo "") then {format ["STR_ADVSEC_dr_tip_free" call _L, _i]} else {
                _e params ["", "", "_lk", "_pin", "_zone", "_clr", "_docs", "_key"];
                format ["STR_ADVSEC_dr_tip_set" call _L, _i, ("STR_ADVSEC_dr_" + _t) call _L,
                    ["STR_ADVSEC_dr_open" call _L, "STR_ADVSEC_dr_closed" call _L] select _lk,
                    [_clr, "-"] select (_clr < 0), [_docs, "-"] select (_docs isEqualTo ""), [_key, "-"] select (_key isEqualTo "")]
            });
            _b setVariable ["ADVSEC_i", _i];
            _b ctrlAddEventHandler ["ButtonClick", {
                params ["_b"];
                ["edit", (ctrlParentControlsGroup ctrlParentControlsGroup _b), _b getVariable "ADVSEC_i"] call ADVSEC_fnc_doorAttr;
            }];
            _ctrls pushBack _b;
        };
        _info ctrlSetText format ["STR_ADVSEC_dr_info" call _L, _n, count (_cfg select {(_x select 0) <= _n})];
        _g setVariable ["ADVSEC_ctrls", _ctrls];
    };
    case "edit": {
        private _i = _p;
        private _d = (ctrlParent _g) createDisplay "ADVSEC_DoorEditor";
        if (isNull _d) exitWith {};
        private _cfg = [_g getVariable ["ADVSEC_val", ""]] call _parse;
        private _e = _cfg param [_cfg findIf {(_x select 0) == _i}, [_i, "", true, "1234", "", -1, "", ""]];
        _e params ["", "_t", ["_lk", true], ["_pin", "1234"], ["_zone", ""], ["_clr", -1], ["_docs", ""], ["_key", ""]];
        private _ent = _g getVariable ["ADVSEC_ent", objNull];
        private _pw = 0.56;
        private _px = 0.5 - _pw / 2;
        private _ph = 0.62;
        private _py = 0.5 - _ph / 2;
        private _lw = 0.2;
        private _mk = {
            params ["_cls", "_pos", ["_txt", ""]];
            private _c = _d ctrlCreate [_cls, -1];
            _c ctrlSetPosition _pos;
            _c ctrlCommit 0;
            if (_txt isNotEqualTo "") then {_c ctrlSetText _txt};
            _c
        };
        ["ADVSEC_Panel", [_px, _py, _pw, _ph]] call _mk;
        ["ADVSEC_Border", [_px, _py, _pw, _ph]] call _mk;
        ["ADVSEC_Header", [_px, _py, _pw, 0.05], format ["STR_ADVSEC_dr_title" call _L, _i, getText (configOf _ent >> "displayName")]] call _mk;
        private _y = _py + 0.07;
        private _st = createHashMapFromArray [["g", _g], ["i", _i], ["d", _d]];
        {
            _x params ["_k", "_lbl", "_cls", "_tip"];
            private _lab = ["ADVSEC_Label", [_px + 0.015, _y, _lw, 0.042], _lbl call _L] call _mk;
            private _c = [_cls, [_px + 0.015 + _lw, _y, _pw - _lw - 0.03, 0.042]] call _mk;
            if (_tip isNotEqualTo "") then {_c ctrlSetTooltip (_tip call _L); _lab ctrlSetTooltip (_tip call _L)};
            _st set [_k, _c];
            _st set [_k + "L", _lab];
            _y = _y + 0.052;
        } forEach [
            ["type", "STR_ADVSEC_dr_f_type", "ADVSEC_Combo", ""],
            ["lk", "STR_ADVSEC_dr_f_state", "ADVSEC_Combo", ""],
            ["pin", "STR_ADVSEC_dr_f_pin", "ADVSEC_Edit", ""],
            ["zone", "STR_ADVSEC_dr_f_zone", "ADVSEC_Edit", "STR_ADVSEC_zone_of_the_linked_alarm"],
            ["clr", "STR_ADVSEC_minimum_level", "ADVSEC_Combo", ""],
            ["docs", "STR_ADVSEC_dr_f_docs", "ADVSEC_Edit", "STR_ADVSEC_dr_f_docs_tip"],
            ["key", "STR_ADVSEC_dr_f_key", "ADVSEC_Edit", "STR_ADVSEC_dr_f_key_tip"]
        ];
        private _c = _st get "type";
        {_c lbAdd ((_x select 1) call _L); _c lbSetData [_forEachIndex, _x select 0]} forEach _types;
        _c lbSetCurSel ((_types findIf {(_x select 0) == _t}) max 0);
        _c ctrlAddEventHandler ["LBSelChanged", {["type"] call ADVSEC_fnc_doorAttr}];
        _c = _st get "lk";
        _c lbAdd ("STR_ADVSEC_dr_closed" call _L);
        _c lbAdd ("STR_ADVSEC_dr_open" call _L);
        _c lbSetCurSel ([1, 0] select _lk);
        (_st get "pin") ctrlSetText _pin;
        (_st get "zone") ctrlSetText _zone;
        _c = _st get "clr";
        _c lbAdd ("STR_ADVSEC_no_minimum_level" call _L);
        _c lbSetValue [0, -1];
        for "_lv" from 0 to 5 do {private _r = _c lbAdd format ["STR_ADVSEC_level_or_higher" call _L, _lv]; _c lbSetValue [_r, _lv]};
        _c lbSetCurSel ((_clr + 1) max 0);
        (_st get "docs") ctrlSetText _docs;
        (_st get "key") ctrlSetText _key;
        private _hint = ["ADVSEC_Label", [_px + 0.015, _y, _pw - 0.03, 0.08]] call _mk;
        _st set ["hint", _hint];
        _hint ctrlSetTextColor [0.6, 0.6, 0.6, 1];
        private _bw = (_pw - 0.03 - 0.03) / 4;
        private _bx = _px + 0.015;
        {
            _x params ["_txt", "_act", "_cls"];
            private _b = [_cls, [_bx, _py + _ph - 0.06, _bw, 0.045], _txt call _L] call _mk;
            _b ctrlAddEventHandler ["ButtonClick", format ["['%1'] call ADVSEC_fnc_doorAttr", _act]];
            _bx = _bx + _bw + 0.01;
        } forEach [
            ["STR_ADVSEC_dr_ok", "ok", "ADVSEC_BtnPrimary"],
            ["STR_ADVSEC_dr_all", "all", "ADVSEC_Btn"],
            ["STR_ADVSEC_dr_clear", "clear", "ADVSEC_BtnDanger"],
            ["STR_ADVSEC_dr_cancel", "cancel", "ADVSEC_Btn"]
        ];
        uiNamespace setVariable ["ADVSEC_drEd", _st];
        ["type"] call ADVSEC_fnc_doorAttr;
    };
    case "type": {
        private _st = uiNamespace getVariable ["ADVSEC_drEd", createHashMap];
        private _c = _st get "type";
        private _t = _c lbData (lbCurSel _c);
        {
            _x params ["_k", "_on"];
            (_st get _k) ctrlEnable _on;
            (_st get (_k + "L")) ctrlSetTextColor ([[0.4, 0.4, 0.4, 1], [1, 1, 1, 1]] select _on);
        } forEach [
            ["lk", _t != ""], ["pin", _t == "keypad"], ["zone", _t == "keypad"],
            ["clr", _t != ""], ["docs", _t != ""], ["key", _t != ""]
        ];
        (_st get "hint") ctrlSetText (("STR_ADVSEC_dr_hint_" + ([_t, "none"] select (_t isEqualTo ""))) call _L);
    };
    case "ok";
    case "all";
    case "clear": {
        private _st = uiNamespace getVariable ["ADVSEC_drEd", createHashMap];
        _g = _st get "g";
        private _i = _st get "i";
        private _cfg = [_g getVariable ["ADVSEC_val", ""]] call _parse;
        private _c = _st get "type";
        private _t = [_c lbData (lbCurSel _c), ""] select (_a == "clear");
        private _cl = _st get "clr";
        private _mkE = {
            params ["_idx"];
            [_idx, _t, lbCurSel (_st get "lk") != 1, ctrlText (_st get "pin"), ctrlText (_st get "zone"),
                _cl lbValue (lbCurSel _cl), ctrlText (_st get "docs"), ctrlText (_st get "key")]
        };
        private _idxs = if (_a == "all") then {
            private _ent = _g getVariable ["ADVSEC_ent", objNull];
            [_ent, "all"] call ADVSEC_fnc_doorList
        } else {[_i]};
        _cfg = _cfg select {!((_x select 0) in _idxs)};
        if (_t != "") then {{_cfg pushBack ([_x] call _mkE)} forEach _idxs};
        _cfg sort true;
        _g setVariable ["ADVSEC_val", [str _cfg, ""] select (_cfg isEqualTo [])];
        (_st get "d") closeDisplay 1;
        ["draw", _g] call ADVSEC_fnc_doorAttr;
    };
    case "cancel": {((uiNamespace getVariable ["ADVSEC_drEd", createHashMap]) getOrDefault ["d", displayNull]) closeDisplay 2};
};
