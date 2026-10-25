params ["_owner"];
if (!createDialog "ADVSEC_DocList") exitWith {};
private _disp = findDisplay 86300;
ADVSEC_listOwner = _owner;
ADVSEC_listDocs = [_owner] call ADVSEC_fnc_docGetAll;

(_disp displayCtrl 3000) ctrlSetText format [" DOCUMENTACIÓN · %1", toUpper name _owner];
private _lb = _disp displayCtrl 3001;
{
    private _cfg = [_x get "type"] call ADVSEC_fnc_docTypeCfg;
    private _i = _lb lbAdd getText (_cfg >> "displayName");
    _lb lbSetTooltip [_i, _x getOrDefault ["name", _x get "number"]];
    _lb lbSetPicture [_i, getText (_cfg >> "icon")];
} forEach ADVSEC_listDocs;
if (ADVSEC_listDocs isEqualTo []) then {
    (_disp displayCtrl 3002) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Sin documentos.</t>";
};
_lb lbSetCurSel 0;
(_disp displayCtrl 3102) ctrlShow (_owner isEqualTo player);
