// [título, texto] — aviso de ALTO en pantalla (cliente, enviado por el checkpoint)
params [["_title", "ALTO"], ["_text", ""]];
if (!hasInterface) exitWith {};
"ADVSEC_stop" cutRsc ["ADVSEC_RscStop", "PLAIN", 0.2, false];
private _d = uiNamespace getVariable ["ADVSEC_stopDisplay", displayNull];
(_d displayCtrl 86461) ctrlSetText toUpper _title;
(_d displayCtrl 86462) ctrlSetStructuredText parseText _text;
playSound "FD_CP_Not_Clear_F";
