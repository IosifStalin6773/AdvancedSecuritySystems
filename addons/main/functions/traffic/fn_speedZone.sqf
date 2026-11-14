// [posición] -> límite de velocidad de zona (km/h) o -1. Zonas: marcadores "advsec_speed_<kmh>" (área del marcador).
params ["_pos"];
private _lim = -1;
{
    if ((_x select [0, 13]) == "advsec_speed_" && {_pos inArea _x}) then {
        private _l = parseNumber ((_x splitString "_") param [2, "0"]);
        if (_l > 0 && {_lim < 0 || {_l < _lim}}) then {_lim = _l};
    };
} forEach allMapMarkers;
_lim
