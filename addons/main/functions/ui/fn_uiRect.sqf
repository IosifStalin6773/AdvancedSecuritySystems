/*
    [[x, y, w, h], modo] -> [x, y, w, h] en pantalla. Misma escala que las macros UIX/UIY/UIW/UIH de ui\defines.hpp.
    modo 0: diálogo centrado (estirado a lo ancho) · 1: dentro de un grupo (solo escala) · 2: centrado sin estirar · 3: dentro de un grupo sin estirar
*/
params ["_r", ["_mode", 0]];
_r params [["_x", 0], ["_y", 0], ["_w", 0], ["_h", 0]];
private _ky = safezoneH;
private _kx = [safezoneH * (1.25 min ((safezoneW / safezoneH) * 0.98)), _ky] select (_mode in [2, 3]);
if (_mode in [1, 3]) exitWith {[_x * _kx, _y * _ky, _w * _kx, _h * _ky]};
[0.5 + (_x - 0.5) * _kx, 0.5 + (_y - 0.5) * _ky, _w * _kx, _h * _ky]
