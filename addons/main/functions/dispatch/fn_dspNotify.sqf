// [id, título, texto, posición, pánico] (cliente PM): aviso en pantalla y marca en el mapa durante 10 min
params ["_id", "_title", "_text", "_pos", ["_panic", false]];
playSound (["FD_Finish_F", "FD_CP_Not_Clear_F"] select _panic);
hint parseText format [("STR_ADVSEC_alert_grid_dispatch_centre_ctrl" call ADVSEC_fnc_L), ["#D0A330", "#FF4D4D"] select _panic, _title, _text, _id, mapGridPosition _pos];
systemChat format [("STR_ADVSEC_dispatch" call ADVSEC_fnc_L), _title, _text, mapGridPosition _pos];
[_id, _pos, _panic] call ADVSEC_fnc_dspMark;
