// [categoría, info, filas] (cliente): respuesta del servidor. fila: [texto, dato, detalle, color]
params ["_cat", "_info", "_rows"];
private _disp = findDisplay 87800;
if (isNull _disp) exitWith {};
if (((ADVSEC_admCats param [lbCurSel (_disp displayCtrl 87802), []]) param [0, ""]) isNotEqualTo _cat) exitWith {};
private _lb = _disp displayCtrl 87803;
private _sel = lbCurSel _lb;
ADVSEC_admRows = _rows;
(_disp displayCtrl 87804) ctrlSetStructuredText parseText _info;
lbClear _lb;
{
    _x params ["_text", "", "", ["_col", []]];
    private _i = _lb lbAdd _text;
    if (_col isNotEqualTo []) then {_lb lbSetColor [_i, _col]};
} forEach _rows;
if (_rows isNotEqualTo []) then {_lb lbSetCurSel ((_sel max 0) min (count _rows - 1))} else {
    (_disp displayCtrl 87805) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Vacío.</t>";
};
