// [clase] -> valor de reposición (catálogo de la armería, tiendas, mercado negro o armoryDefaultValue)
params ["_c"];
private _v = -1;
{
    private _i = _x findIf {(_x select 0) == _c};
    if (_i >= 0) exitWith {_v = (_x select _i) select 1};
} forEach [["armoryItems", []] call ADVSEC_fnc_setting, ["shopItems", []] call ADVSEC_fnc_setting, ["blackMarketItems", []] call ADVSEC_fnc_setting];
if (_v < 0) then {_v = [["armoryDefaultValue", 1000], ["armoryMagValue", 25]] select (isClass (configFile >> "CfgMagazines" >> _c)) call ADVSEC_fnc_setting};
_v
