// -> minutos UTC desde el 1/1/2026 (reloj real del servidor; para plazos que corren aunque el servidor se apague)
systemTimeUTC params ["_y", "_m", "_d", "_h", "_mi"];
if (_m <= 2) then {_y = _y - 1};
private _era = floor (_y / 400);
private _yoe = _y - _era * 400;
private _doy = floor ((153 * (_m + ([-3, 9] select (_m <= 2))) + 2) / 5) + _d - 1;
private _doe = _yoe * 365 + floor (_yoe / 4) - floor (_yoe / 100) + _doy;
private _days = _era * 146097 + _doe - 719468 - 20454;
_days * 1440 + _h * 60 + _mi
