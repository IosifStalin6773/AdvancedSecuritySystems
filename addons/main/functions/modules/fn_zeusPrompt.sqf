/*
    [título, campos, código ([valores, args]), args]
    campo: [etiqueta, valorPorDefecto, tipo]
      tipo omitido/[]          -> texto
      "text"                   -> texto largo (multilínea)
      "bool"                   -> Sí/No (devuelve bool)
      "players"                -> jugador, ordenado por distancia (devuelve objeto)
      ["a", "b"]               -> desplegable (devuelve el texto)
      [["texto", valor], ...]  -> desplegable (devuelve el valor)
      ["multi", [[texto, valor], ...]] -> selección múltiple (devuelve array de valores)
*/
params ["_title", "_fields", "_code", ["_args", []]];
if (!createDialog "ADVSEC_ZeusPrompt") exitWith {};
private _disp = findDisplay 86500;
(_disp displayCtrl 86501) ctrlSetText (" " + _title);

private _rows = _fields apply {
    _x params ["_label", ["_default", ""], ["_type", []]];
    private _kind = "edit";
    private _opts = [];
    private _h = 0.045;
    switch (true) do {
        case (_type isEqualTo "text"): {_kind = "text"; _h = 0.13};
        case (_type isEqualTo "bool"): {_kind = "combo"; _opts = [["Sí", true], ["No", false]]};
        case (_type isEqualTo "players"): {
            _kind = "combo";
            private _ref = [player, curatorCamera] select (!isNull findDisplay 312 && {!isNull curatorCamera});
            private _pl = (allPlayers - entities "HeadlessClient_F") select {alive _x};
            _pl = [_pl, [], {_x distance _ref}, "ASCEND"] call BIS_fnc_sortBy;
            _opts = _pl apply {[format ["%1 · %2 m", name _x, round (_x distance _ref)], _x]};
            if !(_default isEqualType objNull) then {_default = objNull};
            if (isNull _default) then {_default = _pl param [0, objNull]};
        };
        case (_type isEqualType [] && {_type isNotEqualTo []} && {(_type select 0) isEqualTo "multi"}): {
            _kind = "multi"; _opts = _type select 1; _h = 0.16;
        };
        case (_type isEqualType [] && {_type isNotEqualTo []} && {(_type select 0) isEqualType []}): {_kind = "combo"; _opts = _type};
        case (_type isEqualType [] && {_type isNotEqualTo []}): {_kind = "combo"; _opts = _type apply {[_x, _x]}};
    };
    [_label, _default, _kind, _opts, _h]
};

private _total = 0;
{_total = _total + (_x select 4) + 0.012} forEach _rows;
private _h = 0.045 + 0.02 + _total + 0.065;
private _top = (0.5 - _h / 2) max 0.01;
{
    _x params ["_idc", "_y", "_hh"];
    private _c = _disp displayCtrl _idc;
    private _p = ctrlPosition _c;
    _c ctrlSetPosition [_p select 0, _top + _y, _p select 2, [_p select 3, _hh] select (_hh > 0)];
    _c ctrlCommit 0;
} forEach [[86502, 0, _h], [86506, 0, _h], [86501, 0, 0], [86505, 0.045, 0], [86503, _h - 0.058, 0], [86504, _h - 0.058, 0], [86507, 0, 0]];

private _y = _top + 0.065;
private _ctrls = [];
{
    _x params ["_label", "_default", "_kind", "_opts", "_hh"];
    private _lbl = _disp ctrlCreate ["ADVSEC_Label", -1];
    _lbl ctrlSetPosition [0.28, _y, 0.16, 0.045];
    _lbl ctrlSetText _label;
    _lbl ctrlCommit 0;

    private _c = controlNull;
    switch (_kind) do {
        case "edit": {
            _c = _disp ctrlCreate ["ADVSEC_Edit", -1];
            _c ctrlSetText (if (_default isEqualType "") then {_default} else {str _default});
        };
        case "text": {
            _c = _disp ctrlCreate ["ADVSEC_EditMulti", -1];
            _c ctrlSetText _default;
        };
        case "combo": {
            _c = _disp ctrlCreate ["ADVSEC_Combo", -1];
            {_c lbAdd (_x select 0)} forEach _opts;
            _c lbSetCurSel ((_opts findIf {(_x select 1) isEqualTo _default}) max 0);
        };
        case "multi": {
            _c = _disp ctrlCreate ["ADVSEC_ListMulti", -1];
            {
                private _i = _c lbAdd (_x select 0);
                if ((_x select 1) in _default) then {_c lbSetSelected [_i, true]};
            } forEach _opts;
            _c ctrlSetTooltip "Ctrl + clic para seleccionar varios (ninguno = cualquiera)";
        };
    };
    _c ctrlSetPosition [0.45, _y, 0.27, _hh];
    _c ctrlCommit 0;
    _ctrls pushBack [_c, _kind, _opts apply {_x select 1}, _default];
    _y = _y + _hh + 0.012;
} forEach _rows;
ADVSEC_zeusPromptData = [_code, _args, _ctrls];
