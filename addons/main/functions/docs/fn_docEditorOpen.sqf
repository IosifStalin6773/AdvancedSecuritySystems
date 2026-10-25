params ["_issuer"];
if (!createDialog "ADVSEC_DocEditor") exitWith {};
private _disp = findDisplay 86200;
ADVSEC_editorIssuer = _issuer;
private _issName = _issuer getVariable ["ADVSEC_issuerName", "Autoridad"];
(_disp displayCtrl 2000) ctrlSetText format [" EMISIÓN DE DOCUMENTO · %1", toUpper _issName];

private _types = _issuer getVariable ["ADVSEC_issueTypes", []];
if (_types isEqualTo []) then {_types = [] call ADVSEC_fnc_docTypes};
private _cb = _disp displayCtrl 2001;
{
    private _cfg = [_x] call ADVSEC_fnc_docTypeCfg;
    private _i = _cb lbAdd getText (_cfg >> "displayName");
    _cb lbSetData [_i, _x];
    _cb lbSetPicture [_i, getText (_cfg >> "icon")];
} forEach _types;

private _near = (player nearEntities ["CAManBase", 10]) select {_x != player && {alive _x}};
_near = [_near, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy;
ADVSEC_editorTargets = [player] + _near;
private _tg = _disp displayCtrl 2002;
{
    private _rk = [_x] call ADVSEC_fnc_rankName;
    _tg lbAdd (if (_x isEqualTo player) then {
        format ["Yo mismo (%1)", name _x]
    } else {
        format ["%1%2 · %3 m", [_rk + " ", ""] select (_rk isEqualTo ""), name _x, round (_x distance player)]
    });
} forEach ADVSEC_editorTargets;

private _max = _issuer getVariable ["ADVSEC_issueMaxClearance", 5];
private _clr = _disp displayCtrl 2107;
for "_n" from 0 to (_max max 0) do {
    private _i = _clr lbAdd format ["Nivel %1", _n];
    _clr lbSetValue [_i, _n];
};

date params ["_y", "_m", "_d"];
private _pad = {private _s = str _this; if (count _s < 2) then {"0" + _s} else {_s}};
private _exp = _disp displayCtrl 2106;
{
    _x params ["_label", "_years"];
    private _i = _exp lbAdd _label;
    _exp lbSetData [_i, ["", format ["%1-%2-%3", _y + _years, _m call _pad, _d call _pad]] select (_years > 0)];
} forEach [["Sin caducidad", 0], ["1 año", 1], ["2 años", 2], ["5 años", 5], ["10 años", 10]];
_exp lbSetCurSel 0;

(_disp displayCtrl 2105) ctrlSetText _issName;
_cb lbSetCurSel 0;
_tg lbSetCurSel 0;
["type"] call ADVSEC_fnc_docEditorRefresh;
