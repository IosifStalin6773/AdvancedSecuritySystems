/*
    [[x, y, w, h], modo] -> [x, y, w, h]. Las coordenadas van en la misma escala que las macros UIX/UIY/UIW/UIH de ui\defines.hpp,
    que ya no escalan por safezoneH: devuelve el rectángulo tal cual. Se conserva la firma para no cambiar las llamadas.
*/
params ["_r", ["_mode", 0]];
_r params [["_x", 0], ["_y", 0], ["_w", 0], ["_h", 0]];
[_x, _y, _w, _h]
