// [unidad, clase] (servidor) -> nº de serie registrado a nombre de la unidad
params ["_u", "_w"];
private _s = [getPlayerUID _u, _w] call ADVSEC_fnc_wpnSerial;
([] call ADVSEC_fnc_wpnDB) set [_s, [_w, getPlayerUID _u, name _u, call ADVSEC_fnc_now]];
["weapons"] call ADVSEC_fnc_dbDirty;
_s
