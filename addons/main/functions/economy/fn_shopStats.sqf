// [clase] -> hasta 3 estadísticas [texto, fracción 0-1] para las barras del arsenal
params ["_c"];
private _r = [];
private _w = configFile >> "CfgWeapons" >> _c;
private _m = configFile >> "CfgMagazines" >> _c;
private _v = configFile >> "CfgVehicles" >> _c;
private _g = configFile >> "CfgGlasses" >> _c;
private _cat = [_c] call ADVSEC_fnc_shopCat;
private _mass = switch (true) do {
    case (isClass _w): {getNumber (_w >> "WeaponSlotsInfo" >> "mass") max getNumber (_w >> "ItemInfo" >> "mass")};
    case (isClass _m): {getNumber (_m >> "mass")};
    case (isClass _v): {getNumber (_v >> "mass")};
    case (isClass _g): {getNumber (_g >> "mass")};
    default {0};
};
if (_mass > 0) then {_r pushBack [format ["Peso: %1 kg", (_mass * 0.045359) toFixed 1], _mass / 250]};
// Armas: cadencia del primer modo de fuego
if (_cat in [0, 1, 2]) then {
    private _modes = getArray (_w >> "modes");
    if (_modes isNotEqualTo []) then {
        private _mode = [_w >> (_modes select 0), _w] select ((_modes select 0) == "this");
        private _rt = getNumber (_mode >> "reloadTime");
        if (_rt > 0) then {_r pushBack [format ["Cadencia: %1 disparos/min", round (60 / _rt)], (60 / _rt) / 1200]};
    };
    private _mags = [_c] call BIS_fnc_compatibleMagazines;
    if (_mags isNotEqualTo []) then {
        private _n = getNumber (configFile >> "CfgMagazines" >> (_mags select 0) >> "count");
        _r pushBack [format ["Cargador: %1 cartuchos", _n], _n / 200];
    };
};
// Ropa y mochilas: capacidad y protección
private _cont = switch (true) do {
    case (_cat in [3, 4]): {getText (_w >> "ItemInfo" >> "containerClass")};
    case (_cat == 5): {_c};
    default {""};
};
if (_cont isNotEqualTo "") then {
    private _load = getNumber (configFile >> "CfgVehicles" >> _cont >> "maximumLoad");
    _r pushBack [format ["Capacidad: %1", _load], _load / 400];
};
if (_cat in [3, 4, 6]) then {
    private _arm = 0;
    {_arm = _arm max getNumber (_x >> "armor")} forEach ("true" configClasses (_w >> "ItemInfo" >> "HitpointsProtectionInfo"));
    if (_arm > 0) then {_r pushBack [format ["Protección: %1", _arm], _arm / 30]};
};
if (_cat >= 19 && {isClass _m}) then {
    private _n = getNumber (_m >> "count");
    if (_n > 1) then {_r pushBack [format ["Munición: %1", _n], _n / 200]};
};
(_r select [0, 3]) apply {[_x select 0, ((_x select 1) max 0.02) min 1]}
