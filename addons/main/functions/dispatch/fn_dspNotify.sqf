// [id, título, texto, posición, pánico] (cliente PM): aviso en pantalla y marca en el mapa durante 10 min
params ["_id", "_title", "_text", "_pos", ["_panic", false]];
playSound (["FD_Finish_F", "FD_CP_Not_Clear_F"] select _panic);
hint parseText format ["<t size='1.2' color='%1' font='RobotoCondensedBold'>%2</t><br/>%3<br/><t color='#8C8C8C'>Aviso %4 · cuadrícula %5. Central de despacho: Ctrl + Alt + Insert.</t>", ["#D0A330", "#FF4D4D"] select _panic, _title, _text, _id, mapGridPosition _pos];
systemChat format ["[CENTRAL] %1: %2 (%3)", _title, _text, mapGridPosition _pos];
[_id, _pos, _panic] call ADVSEC_fnc_dspMark;
