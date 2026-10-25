// [clase] -> nombre visible (arma, objeto, cargador o mochila); "" si la clase no existe
params ["_c"];
private _r = "";
{
    private _p = configFile >> _x >> _c;
    if (isClass _p) exitWith {_r = getText (_p >> "displayName"); if (_r isEqualTo "") then {_r = _c}};
} forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
_r
