// [clase] -> icono del objeto ("" si no tiene)
params ["_c"];
private _r = "";
{
    private _p = configFile >> _x >> _c;
    if (isClass _p) exitWith {_r = getText (_p >> "picture")};
} forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
if (_r isNotEqualTo "" && {(_r select [0, 1]) != "\"}) then {_r = "\" + _r};
_r
