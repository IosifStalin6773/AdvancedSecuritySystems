params [["_dept", "PM"], ["_subject", ""], ["_title", ""], ["_body", ""], ["_type", ""]];
if (!createDialog "ADVSEC_ReportEditor") exitWith {};
private _disp = findDisplay 86700;
private _lists = configFile >> "ADVSEC_ReportLists";
private _canAI = [player, "AI"] call ADVSEC_fnc_repAccess;

private _cb = _disp displayCtrl 86710;
private _sel = -1;
{
    _x params ["_class", "_cfg"];
    private _d = getText (_cfg >> "dept");
    if (_d == "PM" || {_canAI}) then {
        private _i = _cb lbAdd format ["%1 · %2", getText (_cfg >> "code"), getText (_cfg >> "displayName")];
        _cb lbSetData [_i, _class];
        if ((_type isEqualTo "" && {_d == _dept} && {_sel < 0}) || {_class isEqualTo _type}) then {_sel = _i};
    };
} forEach ([] call ADVSEC_fnc_repTypes);
_cb lbSetCurSel (_sel max 0);

{
    _x params ["_idc", "_items"];
    private _c = _disp displayCtrl _idc;
    {_c lbAdd _x} forEach _items;
    _c lbSetCurSel 0;
} forEach [
    [86711, getArray (_lists >> "gravity")],
    [86712, ["No", "Sí (solo AA.II.)"]],
    [86720, getArray (_lists >> "sanction")]
];

private _sc = _disp displayCtrl 86713;
{
    private _i = _sc lbAdd format ["%1 [%2]", name _x, getPlayerUID _x];
    _sc lbSetData [_i, format ["%1 [%2]", name _x, getPlayerUID _x]];
} forEach ([allPlayers - entities "HeadlessClient_F", [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy);
_sc lbSetCurSel 0;

date params ["_y", "_m", "_d", "_h", "_mi"];
(_disp displayCtrl 86716) ctrlSetText format ["%1-%2-%3 %4:%5 (hora de misión) · %6 · cuadrícula %7", _y, _m, _d, _h, _mi, worldName, mapGridPosition player];
(_disp displayCtrl 86714) ctrlSetText _subject;
(_disp displayCtrl 86715) ctrlSetText _title;
(_disp displayCtrl 86718) ctrlSetText _body;
["format"] call ADVSEC_fnc_repEditorAction;
