/*
    Editor de diálogos por nodos (Eden, 1.21). [acción, args]
    "open" [botón del atributo] · el resto son internos (ratón, panel, botones).
    Lienzo a la izquierda: nodos que se arrastran con el ratón; doble clic en vacío = nodo nuevo; las flechas son las respuestas.
    Panel a la derecha: hablante, nombre y texto del nodo; respuestas con destino, condición y acción.
*/
params ["_a", ["_p", []]];
private _st = uiNamespace getVariable ["ADVSEC_dlgEd", createHashMap];
private _L = {_this call ADVSEC_fnc_L};
// Geometría (pantalla completa, unidades de pantalla)
private _CX = safeZoneX + 0.01;
private _CY = safeZoneY + 0.065;
private _CW = safeZoneW * 0.68;
private _CH = safeZoneH - 0.075;
private _NW = 0.17;
private _NH = 0.085;
private _PX = _CX + _CW + 0.01;
private _PW = (safeZoneX + safeZoneW - 0.01) - _PX;
private _toScr = {params ["_fx", "_fy"]; [_CX + _fx * (_CW - _NW), _CY + _fy * (_CH - _NH)]};
private _data = _st getOrDefault ["data", ["", []]];
private _nodes = _data select 1;
private _find = {params ["_id"]; _nodes findIf {(_x select 0) == _id}};
private _mk = {
    params ["_cls", "_pos", ["_txt", ""]];
    private _c = (_st get "d") ctrlCreate [_cls, -1];
    _c ctrlSetPosition _pos;
    _c ctrlCommit 0;
    if (_txt isNotEqualTo "") then {_c ctrlSetText _txt};
    _c
};
private _short = {params ["_t", ["_n", 60]]; [_t, (_t select [0, _n]) + "…"] select (count _t > _n)};

switch (_a) do {
    case "open": {
        _p params [["_btn", controlNull], ["_ent", objNull], ["_parent", displayNull]];
        if (isNull _parent) then {_parent = ctrlParent _btn};
        private _d = _parent createDisplay "ADVSEC_DlgEditor";
        if (isNull _d) exitWith {};
        private _src = if (isNull _ent) then {_btn getVariable ["ADVSEC_val", ""]} else {(_ent get3DENAttribute "ADVSEC_Dialog") param [0, ""]};
        private _dt = ["parse", _src] call ADVSEC_fnc_dlgData;
        if (_dt isEqualTo []) then {_dt = ["new"] call ADVSEC_fnc_dlgData};
        _st = createHashMapFromArray [["d", _d], ["btn", _btn], ["ent", _ent], ["data", _dt], ["sel", (_dt select 0)], ["drag", []], ["nodeCtrls", createHashMap], ["lines", []], ["optSel", -1]];
        uiNamespace setVariable ["ADVSEC_dlgEd", _st];
        ["build"] call ADVSEC_fnc_dlgEditor;
    };
    case "build": {
        private _d = _st get "d";
        // Fondo del lienzo y del panel
        ["ADVSEC_Panel", [safeZoneX, safeZoneY, safeZoneW, safeZoneH]] call _mk;
        private _cv = ["ADVSEC_Panel", [_CX, _CY, _CW, _CH]] call _mk;
        _cv ctrlSetBackgroundColor [0.07, 0.07, 0.07, 1];
        ["ADVSEC_Border", [_CX, _CY, _CW, _CH]] call _mk;
        ["ADVSEC_Header", [_CX, safeZoneY + 0.012, 0.36, 0.045], "STR_ADVSEC_dlg_editor_title" call _L] call _mk;
        private _hint = ["ADVSEC_Label", [_CX + 0.37, safeZoneY + 0.012, _CW - 0.37, 0.045], "STR_ADVSEC_dlg_editor_hint" call _L] call _mk;
        _hint ctrlSetTextColor [0.55, 0.55, 0.55, 1];
        // Barra: nodos
        private _bx = _PX;
        {
            _x params ["_t", "_act", ["_cls", "ADVSEC_Btn"]];
            private _b = [_cls, [_bx, safeZoneY + 0.012, (_PW - 0.02) / 3, 0.045], _t call _L] call _mk;
            _b ctrlAddEventHandler ["ButtonClick", format ["['%1'] call ADVSEC_fnc_dlgEditor", _act]];
            _bx = _bx + (_PW - 0.02) / 3 + 0.01;
        } forEach [["STR_ADVSEC_dlg_new_node", "nodeNew", "ADVSEC_BtnPrimary"], ["STR_ADVSEC_dlg_del_node", "nodeDel", "ADVSEC_BtnDanger"], ["STR_ADVSEC_dlg_set_start", "setStart"]];
        // Panel del nodo (compacto: etiqueta y campo en la misma fila)
        private _y = _CY;
        private _row = {params ["_h"]; private _r = _y; _y = _y + _h + 0.008; _r};
        private _LW = _PW * 0.3;
        private _field = {
            // [etiqueta, clase, alto] -> control a la derecha de la etiqueta
            params ["_t", "_cls", ["_h", 0.04]];
            private _ry = [_h] call _row;
            ["ADVSEC_Label", [_PX, _ry, _LW, 0.04], _t call _L] call _mk;
            [_cls, [_PX + _LW, _ry, _PW - _LW, _h]] call _mk
        };
        private _acts = [
            ["", "STR_ADVSEC_dlg_ac_none", "STR_ADVSEC_dlg_ac_none"], ["code", "STR_ADVSEC_dlg_ac_code", "STR_ADVSEC_dlg_ac_code_tip"],
            ["setVar", "STR_ADVSEC_dlg_ac_setvar", "STR_ADVSEC_dlg_ac_setvar_tip"], ["giveItem", "STR_ADVSEC_dlg_ac_give", "STR_ADVSEC_dlg_ac_give_tip"],
            ["takeItem", "STR_ADVSEC_dlg_ac_take", "STR_ADVSEC_dlg_ac_take_tip"], ["join", "STR_ADVSEC_dlg_ac_join", "STR_ADVSEC_dlg_ac_join_tip"],
            ["contracts", "STR_ADVSEC_dlg_ac_contracts", "STR_ADVSEC_dlg_ac_contracts_tip"], ["hint", "STR_ADVSEC_dlg_ac_hint", "STR_ADVSEC_dlg_ac_hint_tip"]
        ];
        private _fillAct = {params ["_c"]; {private _i = _c lbAdd ((_x select 1) call _L); _c lbSetData [_i, _x select 0]; _c lbSetTooltip [_i, (_x select 2) call _L]} forEach _acts; _c lbSetCurSel 0};
        private _actRow = {
            // [etiqueta] -> [combo de acción, parámetro]
            params ["_t"];
            private _ry = [0.04] call _row;
            ["ADVSEC_Label", [_PX, _ry, _LW, 0.04], _t call _L] call _mk;
            private _c = ["ADVSEC_Combo", [_PX + _LW, _ry, (_PW - _LW) * 0.45, 0.04]] call _mk;
            [_c] call _fillAct;
            private _e = ["ADVSEC_Edit", [_PX + _LW + (_PW - _LW) * 0.47, _ry, (_PW - _LW) * 0.53, 0.04]] call _mk;
            _e ctrlSetTooltip ("STR_ADVSEC_dlg_opt_param" call _L);
            [_c, _e]
        };
        _st set ["pInfo", ["ADVSEC_Struct", [_PX, [0.045] call _row, _PW, 0.045]] call _mk];
        private _sp = ["STR_ADVSEC_dlg_speaker", "ADVSEC_Combo"] call _field;
        {private _i = _sp lbAdd ((_x select 1) call _L); _sp lbSetData [_i, _x select 0]} forEach [["npc", "STR_ADVSEC_dlg_sp_npc"], ["player", "STR_ADVSEC_dlg_sp_player"], ["narrator", "STR_ADVSEC_dlg_sp_narrator"]];
        _sp ctrlAddEventHandler ["LBSelChanged", "['apply'] call ADVSEC_fnc_dlgEditor"];
        _st set ["pSpeaker", _sp];
        private _nm = ["STR_ADVSEC_dlg_name_s", "ADVSEC_Edit"] call _field;
        _nm ctrlSetTooltip ("STR_ADVSEC_dlg_name" call _L);
        _nm ctrlAddEventHandler ["KeyUp", "['apply'] call ADVSEC_fnc_dlgEditor"];
        _st set ["pName", _nm];
        ["ADVSEC_Label", [_PX, [0.03] call _row, _PW, 0.03], "STR_ADVSEC_dlg_text" call _L] call _mk;
        private _tx = ["ADVSEC_EditMulti", [_PX, [0.12] call _row, _PW, 0.12]] call _mk;
        _tx ctrlAddEventHandler ["KeyUp", "['apply'] call ADVSEC_fnc_dlgEditor"];
        _st set ["pText", _tx];
        (["STR_ADVSEC_dlg_node_action"] call _actRow) params ["_na", "_np"];
        _na ctrlAddEventHandler ["LBSelChanged", "['apply'] call ADVSEC_fnc_dlgEditor"];
        _np ctrlAddEventHandler ["KeyUp", "['apply'] call ADVSEC_fnc_dlgEditor"];
        _st set ["pNAction", _na];
        _st set ["pNParam", _np];
        ["ADVSEC_Label", [_PX, [0.03] call _row, _PW, 0.03], "STR_ADVSEC_dlg_options" call _L] call _mk;
        private _ol = ["ADVSEC_List", [_PX, [0.12] call _row, _PW, 0.12]] call _mk;
        _ol ctrlAddEventHandler ["LBSelChanged", "['optSel', [_this select 1]] call ADVSEC_fnc_dlgEditor"];
        _st set ["pOpts", _ol];
        _st set ["pOText", ["STR_ADVSEC_dlg_opt_text_s", "ADVSEC_Edit"] call _field];
        _st set ["pOTarget", ["STR_ADVSEC_dlg_opt_target", "ADVSEC_Combo"] call _field];
        (["STR_ADVSEC_dlg_opt_action_s"] call _actRow) params ["_ac", "_pr"];
        _st set ["pOAction", _ac];
        _st set ["pOParam", _pr];
        private _cn = ["STR_ADVSEC_dlg_opt_cond", "ADVSEC_Edit"] call _field;
        _cn ctrlSetTooltip ("STR_ADVSEC_dlg_opt_cond_tip" call _L);
        _st set ["pOCond", _cn];
        private _by = [0.045] call _row;
        {
            _x params ["_t", "_act", "_cls", "_i"];
            private _b = [_cls, [_PX + _i * (_PW + 0.01) / 3, _by, (_PW - 0.02) / 3, 0.045], _t call _L] call _mk;
            _b ctrlAddEventHandler ["ButtonClick", format ["['%1'] call ADVSEC_fnc_dlgEditor", _act]];
        } forEach [["STR_ADVSEC_dlg_opt_add", "optAdd", "ADVSEC_Btn", 0], ["STR_ADVSEC_dlg_opt_apply", "optApply", "ADVSEC_BtnPrimary", 1], ["STR_ADVSEC_dlg_opt_del", "optDel", "ADVSEC_BtnDanger", 2]];
        // Guardar / cancelar
        private _fy = safeZoneY + safeZoneH - 0.055;
        private _ok = ["ADVSEC_BtnOk", [_PX, _fy, (_PW - 0.01) / 2, 0.045], "STR_ADVSEC_dlg_save" call _L] call _mk;
        _ok ctrlAddEventHandler ["ButtonClick", "['save'] call ADVSEC_fnc_dlgEditor"];
        private _cc = ["ADVSEC_BtnDanger", [_PX + (_PW + 0.01) / 2, _fy, (_PW - 0.01) / 2, 0.045], "STR_ADVSEC_cancel_2" call _L] call _mk;
        _cc ctrlAddEventHandler ["ButtonClick", "['cancel'] call ADVSEC_fnc_dlgEditor"];
        // Ratón en el lienzo
        _d displayAddEventHandler ["MouseButtonDown", "['mdown', _this] call ADVSEC_fnc_dlgEditor"];
        _d displayAddEventHandler ["MouseButtonUp", "['mup', _this] call ADVSEC_fnc_dlgEditor"];
        _d displayAddEventHandler ["MouseMoving", "['mmove', _this] call ADVSEC_fnc_dlgEditor"];
        _d displayAddEventHandler ["MouseButtonDblClick", "['dbl', _this] call ADVSEC_fnc_dlgEditor"];
        _d displayAddEventHandler ["Unload", "uiNamespace setVariable ['ADVSEC_dlgEd', nil]"];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        ["panel"] call ADVSEC_fnc_dlgEditor;
    };
    case "redraw": {
        // nodos
        private _nc = _st get "nodeCtrls";
        {ctrlDelete _y} forEach _nc;
        _nc = createHashMap;
        _st set ["nodeCtrls", _nc];
        private _sel = _st get "sel";
        {
            _x params ["_id", "_sp", "_nm", "_tx", "_fx", "_fy", "_op"];
            private _c = ["ADVSEC_Struct", ([_fx, _fy] call _toScr) + [_NW, _NH]] call _mk;
            private _start = _id == (_data select 0);
            _c ctrlSetBackgroundColor ([[0.16, 0.16, 0.16, 0.97], [0.36, 0.29, 0.09, 0.97]] select (_id == _sel));
            _c ctrlSetStructuredText parseText format [
                "<t size='0.82' color='#d0a330'>%1 · %2%3</t><br/><t size='0.8'>%4</t><br/><t size='0.72' color='#9a9a9a'>%5%6</t>",
                _id, ([("STR_ADVSEC_dlg_sp_npc" call _L), ("STR_ADVSEC_dlg_sp_player" call _L), ("STR_ADVSEC_dlg_sp_narrator" call _L)] select ((["npc", "player", "narrator"] find _sp) max 0)),
                ["", " ★"] select _start, [[_tx, 48] call _short] call ADVSEC_fnc_repEsc, format [("STR_ADVSEC_dlg_n_opts" call _L), count _op], ["", " · ⚙"] select ((_x param [7, ""]) isNotEqualTo "")
            ];
            _nc set [_id, _c];
        } forEach _nodes;
        ["lines"] call ADVSEC_fnc_dlgEditor;
    };
    case "lines": {
        {ctrlDelete _x} forEach (_st get "lines");
        private _ls = [];
        private _nc = _st get "nodeCtrls";
        {
            private _src = _nc getOrDefault [_x select 0, controlNull];
            if (!isNull _src) then {
                (ctrlPosition _src) params ["_sx", "_sy"];
                {
                    _x params ["", "_to"];
                    private _dst = _nc getOrDefault [_to, controlNull];
                    if (!isNull _dst) then {
                        (ctrlPosition _dst) params ["_dx", "_dy"];
                        private _ax = _sx + _NW; private _ay = _sy + _NH / 2 + (_forEachIndex - 1) * 0.012;
                        private _bx = _dx; private _by = _dy + _NH / 2;
                        if (_bx < _ax) then {_ax = _sx; _bx = _dx + _NW};
                        private _px = (_bx - _ax) / pixelW; private _py = (_by - _ay) / pixelH;
                        private _len = sqrt (_px ^ 2 + _py ^ 2);
                        private _w = _len * pixelW;
                        private _l = ["RscPicture", [(_ax + _bx) / 2 - _w / 2, (_ay + _by) / 2 - pixelH, _w, 2 * pixelH], "#(argb,8,8,3)color(1,1,1,1)"] call _mk;
                        _l ctrlSetTextColor [0.82, 0.64, 0.19, 0.85];
                        _l ctrlSetAngle [_py atan2 _px, 0.5, 0.5];
                        _ls pushBack _l;
                        private _n = ["ADVSEC_Label", [_bx - ([0.018, -0.002] select (_bx < _ax)), _by - 0.016, 0.02, 0.03], str (_forEachIndex + 1)] call _mk;
                        _n ctrlSetTextColor [0.82, 0.64, 0.19, 1];
                        _ls pushBack _n;
                    };
                } forEach (_x select 6);
            };
        } forEach _nodes;
        _st set ["lines", _ls];
    };
    case "panel": {
        // rellena el panel con el nodo seleccionado
        private _i = [_st get "sel"] call _find;
        private _ctrls = ["pSpeaker", "pName", "pText", "pNAction", "pNParam", "pOpts", "pOText", "pOTarget", "pOAction", "pOParam", "pOCond"] apply {_st get _x};
        {_x ctrlEnable (_i >= 0)} forEach _ctrls;
        if (_i < 0) exitWith {(_st get "pInfo") ctrlSetStructuredText parseText ("STR_ADVSEC_dlg_no_sel" call _L)};
        (_nodes select _i) params ["_id", "_sp", "_nm", "_tx", "", "", "_op", ["_nac", ""], ["_npr", ""]];
        (_st get "pInfo") ctrlSetStructuredText parseText format ["<t color='#d0a330'>%1</t>%2", _id, ["", " · " + ("STR_ADVSEC_dlg_is_start" call _L)] select (_id == (_data select 0))];
        _st set ["loading", true];
        (_st get "pSpeaker") lbSetCurSel ((["npc", "player", "narrator"] find _sp) max 0);
        (_st get "pName") ctrlSetText _nm;
        (_st get "pText") ctrlSetText _tx;
        private _naC = _st get "pNAction";
        for "_k" from 0 to (lbSize _naC - 1) do {if ((_naC lbData _k) == _nac) exitWith {_naC lbSetCurSel _k}};
        (_st get "pNParam") ctrlSetText _npr;
        _st set ["loading", false];
        private _ol = _st get "pOpts";
        lbClear _ol;
        {
            _x params ["_t", "_to", "_cn", "_ac"];
            private _r = _ol lbAdd format ["%1. %2  →  %3", _forEachIndex + 1, [_t, 40] call _short, [_to, "STR_ADVSEC_dlg_end" call _L] select (_to isEqualTo "")];
            if (_cn isNotEqualTo "" || {_ac isNotEqualTo ""}) then {_ol lbSetTextRight [_r, ([["", "?"] select (_cn isNotEqualTo ""), ["", "⚙"] select (_ac isNotEqualTo "")]) joinString " "]};
        } forEach _op;
        // destinos posibles
        private _tg = _st get "pOTarget";
        lbClear _tg;
        private _r = _tg lbAdd ("STR_ADVSEC_dlg_end" call _L); _tg lbSetData [_r, ""];
        {private _k = _tg lbAdd format ["%1 · %2", _x select 0, [_x select 3, 34] call _short]; _tg lbSetData [_k, _x select 0]} forEach _nodes;
        _r = _tg lbAdd ("STR_ADVSEC_dlg_new_target" call _L); _tg lbSetData [_r, "__new"];
        private _os = (_st get "optSel") min (count _op - 1);
        _st set ["optSel", -1];
        if (_os >= 0) then {_ol lbSetCurSel _os} else {
            (_st get "pOText") ctrlSetText ""; _tg lbSetCurSel 0; (_st get "pOAction") lbSetCurSel 0; (_st get "pOParam") ctrlSetText ""; (_st get "pOCond") ctrlSetText "";
        };
    };
    case "apply": {
        // cambios del nodo (hablante, nombre, texto) al momento
        if (_st getOrDefault ["loading", false]) exitWith {};
        private _i = [_st get "sel"] call _find;
        if (_i < 0) exitWith {};
        private _n = _nodes select _i;
        private _sp = _st get "pSpeaker";
        _n set [1, _sp lbData (lbCurSel _sp max 0)];
        _n set [2, ctrlText (_st get "pName")];
        _n set [3, ctrlText (_st get "pText")];
        private _naC = _st get "pNAction";
        _n set [7, _naC lbData (lbCurSel _naC max 0)];
        _n set [8, ctrlText (_st get "pNParam")];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
    };
    case "optSel": {
        _p params ["_r"];
        private _i = [_st get "sel"] call _find;
        if (_i < 0 || {_r < 0}) exitWith {};
        private _o = ((_nodes select _i) select 6) param [_r, []];
        if (_o isEqualTo []) exitWith {};
        _st set ["optSel", _r];
        _o params ["_t", "_to", "_cn", "_ac", "_pr"];
        (_st get "pOText") ctrlSetText _t;
        private _tg = _st get "pOTarget";
        for "_k" from 0 to (lbSize _tg - 1) do {if ((_tg lbData _k) == _to) exitWith {_tg lbSetCurSel _k}};
        private _acC = _st get "pOAction";
        for "_k" from 0 to (lbSize _acC - 1) do {if ((_acC lbData _k) == _ac) exitWith {_acC lbSetCurSel _k}};
        (_st get "pOParam") ctrlSetText _pr;
        (_st get "pOCond") ctrlSetText _cn;
    };
    case "optAdd";
    case "optApply": {
        private _i = [_st get "sel"] call _find;
        if (_i < 0) exitWith {};
        private _n = _nodes select _i;
        private _tg = _st get "pOTarget";
        private _to = _tg lbData (lbCurSel _tg max 0);
        if (_to == "__new") then {
            // nodo nuevo a la derecha del actual, ya enlazado
            _to = ["nodeNew", [((_n select 4) + 0.22) min 1, ((_n select 5) + 0.05 * count (_n select 6)) min 1, false]] call ADVSEC_fnc_dlgEditor;
        };
        private _acC = _st get "pOAction";
        private _t = ctrlText (_st get "pOText");
        if (_t isEqualTo "") then {_t = "STR_ADVSEC_dlg_default_opt" call _L};
        private _o = [_t, _to, ctrlText (_st get "pOCond"), _acC lbData (lbCurSel _acC max 0), ctrlText (_st get "pOParam")];
        private _ops = _n select 6;
        private _r = _st getOrDefault ["optSel", -1];
        if (_a == "optAdd" || {_r < 0} || {_r >= count _ops}) then {_r = _ops pushBack _o} else {_ops set [_r, _o]};
        _st set ["optSel", _r];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        ["panel"] call ADVSEC_fnc_dlgEditor;
    };
    case "optDel": {
        private _i = [_st get "sel"] call _find;
        private _r = lbCurSel (_st get "pOpts");
        if (_i < 0 || {_r < 0}) exitWith {};
        ((_nodes select _i) select 6) deleteAt _r;
        _st set ["optSel", -1];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        ["panel"] call ADVSEC_fnc_dlgEditor;
    };
    case "nodeNew": {
        // [x, y, seleccionar] -> id
        _p params [["_fx", -1], ["_fy", -1], ["_select", true]];
        private _k = 1;
        while {([format ["n%1", _k]] call _find) >= 0} do {_k = _k + 1};
        private _id = format ["n%1", _k];
        if (_fx < 0) then {
            private _s = [_st get "sel"] call _find;
            if (_s >= 0) then {_fx = ((_nodes select _s) select 4) + 0.22; _fy = (_nodes select _s) select 5} else {_fx = random 0.6; _fy = random 0.6};
        };
        _nodes pushBack [_id, "npc", "", ("STR_ADVSEC_dlg_default_text" call _L), (_fx max 0) min 1, (_fy max 0) min 1, [], "", ""];
        if ((_data select 0) isEqualTo "") then {_data set [0, _id]};
        if (_select) then {_st set ["sel", _id]; _st set ["optSel", -1]};
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        if (_select) then {["panel"] call ADVSEC_fnc_dlgEditor};
        _id
    };
    case "nodeDel": {
        private _id = _st get "sel";
        private _i = [_id] call _find;
        if (_i < 0) exitWith {};
        _nodes deleteAt _i;
        {{if ((_x select 1) == _id) then {_x set [1, ""]}} forEach (_x select 6)} forEach _nodes;
        if ((_data select 0) == _id) then {_data set [0, (_nodes param [0, [""]]) select 0]};
        _st set ["sel", (_nodes param [0, [""]]) select 0];
        _st set ["optSel", -1];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        ["panel"] call ADVSEC_fnc_dlgEditor;
    };
    case "setStart": {
        if (([_st get "sel"] call _find) < 0) exitWith {};
        _data set [0, _st get "sel"];
        ["redraw"] call ADVSEC_fnc_dlgEditor;
        ["panel"] call ADVSEC_fnc_dlgEditor;
    };
    case "mdown": {
        _p params ["", "_b", "_mx", "_my"];
        if (_b != 0 || {_mx < _CX} || {_mx > _CX + _CW} || {_my < _CY} || {_my > _CY + _CH}) exitWith {};
        private _hit = "";
        {
            (ctrlPosition _y) params ["_x0", "_y0", "_w0", "_h0"];
            if (_mx >= _x0 && {_mx <= _x0 + _w0} && {_my >= _y0} && {_my <= _y0 + _h0}) then {_hit = _x};
        } forEach (_st get "nodeCtrls");
        if (_hit isEqualTo "") exitWith {};
        (ctrlPosition ((_st get "nodeCtrls") get _hit)) params ["_x0", "_y0"];
        _st set ["drag", [_hit, _mx - _x0, _my - _y0]];
        if (_hit != (_st get "sel")) then {
            _st set ["sel", _hit];
            _st set ["optSel", -1];
            ["redraw"] call ADVSEC_fnc_dlgEditor;
            ["panel"] call ADVSEC_fnc_dlgEditor;
        };
    };
    case "mmove": {
        private _dr = _st get "drag";
        if (_dr isEqualTo []) exitWith {};
        _dr params ["_id", "_ox", "_oy"];
        getMousePosition params ["_mx", "_my"];
        private _i = [_id] call _find;
        private _c = (_st get "nodeCtrls") getOrDefault [_id, controlNull];
        if (_i < 0 || {isNull _c}) exitWith {};
        private _nx = ((_mx - _ox) max _CX) min (_CX + _CW - _NW);
        private _ny = ((_my - _oy) max _CY) min (_CY + _CH - _NH);
        _c ctrlSetPosition [_nx, _ny];
        _c ctrlCommit 0;
        (_nodes select _i) set [4, (_nx - _CX) / ((_CW - _NW) max 0.001)];
        (_nodes select _i) set [5, (_ny - _CY) / ((_CH - _NH) max 0.001)];
        ["lines"] call ADVSEC_fnc_dlgEditor;
    };
    case "mup": {_st set ["drag", []]};
    case "dbl": {
        _p params ["", "_b", "_mx", "_my"];
        if (_b != 0 || {_mx < _CX} || {_mx > _CX + _CW - _NW / 2} || {_my < _CY} || {_my > _CY + _CH - _NH / 2}) exitWith {};
        private _over = false;
        {(ctrlPosition _y) params ["_x0", "_y0", "_w0", "_h0"]; if (_mx >= _x0 && {_mx <= _x0 + _w0} && {_my >= _y0} && {_my <= _y0 + _h0}) then {_over = true}} forEach (_st get "nodeCtrls");
        if (_over) exitWith {};
        ["nodeNew", [(_mx - _CX) / ((_CW - _NW) max 0.001), (_my - _CY) / ((_CH - _NH) max 0.001), true]] call ADVSEC_fnc_dlgEditor;
    };
    case "save": {
        private _btn = _st get "btn";
        private _ent = _st getOrDefault ["ent", objNull];
        private _v = ["str", _data] call ADVSEC_fnc_dlgData;
        if (!isNull _ent) then {
            // desde el gestor: se guarda en el atributo de la entidad (con deshacer de Eden)
            collect3DENHistory {_ent set3DENAttribute ["ADVSEC_Dialog", _v]};
            ["refresh"] call ADVSEC_fnc_dlgManager;
        } else {
            _btn setVariable ["ADVSEC_val", _v];
            ["label", _btn] call ADVSEC_fnc_dlgAttr;
        };
        (_st get "d") closeDisplay 1;
    };
    case "cancel": {(_st get "d") closeDisplay 2};
};
