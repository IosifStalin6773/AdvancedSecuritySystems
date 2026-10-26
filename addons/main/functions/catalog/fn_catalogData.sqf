// ["items"|"vehicles"] -> [[categoría, [[clase, nombre, icono], ...]], ...] de todo lo que hay cargado (se cachea)
params [["_kind", "items"]];
private _key = "ADVSEC_catalog_" + _kind;
private _cached = uiNamespace getVariable _key;
if (!isNil "_cached") exitWith {_cached};
private _pic = {
    params ["_p"];
    if (_p isNotEqualTo "" && {(_p select [0, 1]) != "\"}) then {_p = "\" + _p};
    _p
};
private _out = [];
if (_kind == "vehicles") then {
    private _cats = [["Motocicletas", []], ["Coches", []], ["Camiones", []], ["Blindados de ruedas", []], ["Orugas y carros de combate", []], ["Helicópteros", []], ["Aviones", []], ["Barcos", []], ["Drones", []]];
    {
        private _c = configName _x;
        private _i = switch (true) do {
            case (getNumber (_x >> "isUav") == 1): {8};
            case (_c isKindOf "Motorcycle"): {0};
            case (_c isKindOf "Wheeled_APC_F"): {3};
            case (_c isKindOf "Tank"): {4};
            case (_c isKindOf "Truck_F"): {2};
            case (_c isKindOf "Car"): {1};
            case (_c isKindOf "Helicopter"): {5};
            case (_c isKindOf "Plane"): {6};
            case (_c isKindOf "Ship"): {7};
            default {-1};
        };
        if (_i >= 0) then {
            private _fac = getText (configFile >> "CfgFactionClasses" >> getText (_x >> "faction") >> "displayName");
            ((_cats select _i) select 1) pushBack [_c, format ["%1%2", getText (_x >> "displayName"), ["", " · " + _fac] select (_fac isNotEqualTo "")], [getText (_x >> "picture")] call _pic];
        };
    } forEach ("getNumber (_x >> 'scope') == 2 && {getText (_x >> 'displayName') != ''} && {configName _x isKindOf 'AllVehicles'} && {!(configName _x isKindOf 'Man')} && {!(configName _x isKindOf 'StaticWeapon')} && {!(configName _x isKindOf 'ParachuteBase')}" configClasses (configFile >> "CfgVehicles"));
    _out = _cats;
} else {
    if (isNil "ADVSEC_shopTabs") then {
        ADVSEC_shopTabs = [
            ["Arma principal", "primaryWeapon"], ["Lanzador", "secondaryWeapon"], ["Pistola", "handgun"], ["Uniforme", "uniform"], ["Chaleco", "vest"], ["Mochila", "backpack"],
            ["Casco y gorra", "headgear"], ["Gafas", "goggles"], ["Visión nocturna", "nvgs"], ["Prismáticos", "binoculars"], ["Mapa", "map"], ["GPS y terminal", "gps"],
            ["Radio", "radio"], ["Brújula", "compass"], ["Reloj", "watch"], ["Mira", "itemOptic"], ["Accesorio de raíl", "itemAcc"], ["Bocacha", "itemMuzzle"],
            ["Bípode", "itemBipod"], ["Cargadores", "cargoMag"], ["Granadas", "cargoThrow"], ["Explosivos", "cargoPut"], ["Varios", "cargoMisc"]
        ];
    };
    _out = ADVSEC_shopTabs apply {[_x select 0, []]};
    private _push = {
        params ["_cfg"];
        private _c = configName _cfg;
        ((_out select ([_c] call ADVSEC_fnc_shopCat)) select 1) pushBack [_c, getText (_cfg >> "displayName"), [getText (_cfg >> "picture")] call _pic];
    };
    // Armas sin accesorios montados (como el arsenal: baseWeapon propia o vacía)
    {
        private _b = getText (_x >> "baseWeapon");
        if (_b isEqualTo "" || {_b == configName _x}) then {[_x] call _push};
    } forEach ("getNumber (_x >> 'scope') == 2 && {getText (_x >> 'displayName') != ''} && {getText (_x >> 'picture') != ''}" configClasses (configFile >> "CfgWeapons"));
    {[_x] call _push} forEach ("getNumber (_x >> 'scope') == 2 && {getText (_x >> 'displayName') != ''} && {getText (_x >> 'picture') != ''}" configClasses (configFile >> "CfgMagazines"));
    {[_x] call _push} forEach ("getNumber (_x >> 'scope') == 2 && {getNumber (_x >> 'isBackpack') == 1} && {getText (_x >> 'displayName') != ''}" configClasses (configFile >> "CfgVehicles"));
    {[_x] call _push} forEach ("getNumber (_x >> 'scope') == 2 && {getText (_x >> 'displayName') != ''}" configClasses (configFile >> "CfgGlasses"));
};
// Orden alfabético y fuera las categorías vacías
_out = _out select {(_x select 1) isNotEqualTo []};
{
    private _l = (_x select 1) apply {[toLower (_x select 1), _x]};
    _l sort true;
    _x set [1, _l apply {_x select 1}];
} forEach _out;
uiNamespace setVariable [_key, _out];
_out
