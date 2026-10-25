/*
    [clave, info (texto estructurado), filas] — rellena el panel si sigue abierto con esa clave.
    fila: [texto, datos, detalle (texto estructurado), color ([] = normal), icono ("" = ninguno)]
*/
params ["_key", "_info", ["_rows", []]];
private _disp = findDisplay 87500;
if (isNull _disp || {(missionNamespace getVariable ["ADVSEC_panelKey", ""]) isNotEqualTo _key}) exitWith {};
(_disp displayCtrl 87502) ctrlSetStructuredText parseText _info;
private _lb = _disp displayCtrl 87503;
private _sel = lbCurSel _lb;
lbClear _lb;
ADVSEC_panelRows = _rows;
{
    _x params ["_text", "", "", ["_col", []], ["_pic", ""]];
    private _i = _lb lbAdd _text;
    if (_col isNotEqualTo []) then {_lb lbSetColor [_i, _col]};
    if (_pic isNotEqualTo "") then {_lb lbSetPicture [_i, _pic]};
} forEach _rows;
if (_rows isNotEqualTo []) then {_lb lbSetCurSel ((_sel max 0) min (count _rows - 1))} else {
    (_disp displayCtrl 87505) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Sin resultados.</t>";
};
