// [título, texto] — aviso de ALTO en pantalla (cliente, enviado por el checkpoint). El cartel crece con el texto.
params [["_title", "ALTO"], ["_text", ""]];
if (!hasInterface) exitWith {};
"ADVSEC_stop" cutRsc ["ADVSEC_RscStop", "PLAIN", 0.2, false];
private _d = uiNamespace getVariable ["ADVSEC_stopDisplay", displayNull];
if (isNull _d) exitWith {};
private _big = _d displayCtrl 86461;
_big ctrlSetText toUpper _title;
// Título largo: letra más pequeña hasta que quepa
private _fh = (ctrlPosition _big) select 3;
private _w = (ctrlPosition _big) select 2;
_big ctrlSetFontHeight (_fh * 0.85);
while {(ctrlTextWidth _big) > _w && {_fh > 0.02 * safezoneH}} do {_fh = _fh * 0.9; _big ctrlSetFontHeight (_fh * 0.85)};
private _sub = _d displayCtrl 86462;
_sub ctrlSetStructuredText parseText _text;
private _p = ctrlPosition _sub;
private _h = (ctrlTextHeight _sub) + 0.01 * safezoneH;
_sub ctrlSetPosition [_p select 0, _p select 1, _p select 2, _h];
_sub ctrlCommit 0;
private _bg = _d displayCtrl 86463;
private _bp = ctrlPosition _bg;
private _total = (((_p select 1) + _h + 0.02 * safezoneH) - (_bp select 1)) max (_bp select 3);
_bg ctrlSetPosition [_bp select 0, _bp select 1, _bp select 2, _total];
_bg ctrlCommit 0;
private _f2 = _d displayCtrl 86465;
private _fp = ctrlPosition _f2;
_f2 ctrlSetPosition [_fp select 0, (_bp select 1) + _total - (_fp select 3), _fp select 2, _fp select 3];
_f2 ctrlCommit 0;
playSound "FD_CP_Not_Clear_F";
