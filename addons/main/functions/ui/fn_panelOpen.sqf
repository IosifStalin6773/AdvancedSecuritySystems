/*
    [clave, título, botones, alRefrescar] — abre el panel genérico.
    botones: [[texto, código], ...] (máx. 5). El código recibe [datosFila, índice, clave].
    alRefrescar: código que pide los datos (normalmente un remoteExecCall al servidor); se llama al abrir y con ['refresh'].
*/
params ["_key", "_title", ["_buttons", []], ["_refresh", {}]];
if (isNull findDisplay 87500 && {!createDialog "ADVSEC_PanelDlg"}) exitWith {};
private _disp = findDisplay 87500;
ADVSEC_panelKey = _key;
ADVSEC_panelButtons = _buttons;
ADVSEC_panelRefresh = _refresh;
ADVSEC_panelRows = [];
(_disp displayCtrl 87501) ctrlSetText (" " + toUpper _title);
(_disp displayCtrl 87502) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Consultando el archivo central...</t>";
(_disp displayCtrl 87505) ctrlSetStructuredText parseText "";
lbClear (_disp displayCtrl 87503);
for "_i" from 0 to 4 do {
    private _b = _disp displayCtrl (87510 + _i);
    private _def = _buttons param [_i, []];
    _b ctrlShow (_def isNotEqualTo []);
    if (_def isNotEqualTo []) then {_b ctrlSetText (_def select 0)};
};
call _refresh;
