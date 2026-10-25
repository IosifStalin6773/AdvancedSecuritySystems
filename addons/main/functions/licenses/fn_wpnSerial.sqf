// [SteamID, clase de arma] -> número de serie (el mismo que llevan sus casquillos)
params ["_uid", "_w"];
private _h = 0;
{_h = (_h * 31 + _x) mod 9999991} forEach toArray (_uid + _w);
format ["%1-%2", toUpper (_w select [0, 3]), _h]
