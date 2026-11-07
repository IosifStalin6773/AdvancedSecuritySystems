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
    private _cats = [[("STR_ADVSEC_motorcycles" call ADVSEC_fnc_L), []], [("STR_ADVSEC_cars" call ADVSEC_fnc_L), []], [("STR_ADVSEC_trucks" call ADVSEC_fnc_L), []], [("STR_ADVSEC_wheeled_armour" call ADVSEC_fnc_L), []], [("STR_ADVSEC_tracked_vehicles_and_tanks" call ADVSEC_fnc_L), []], [("STR_ADVSEC_helicopters" call ADVSEC_fnc_L), []], [("STR_ADVSEC_planes" call ADVSEC_fnc_L), []], [("STR_ADVSEC_boats" call ADVSEC_fnc_L), []], ["Drones", []]];
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
            [("STR_ADVSEC_primary_weapon" call ADVSEC_fnc_L), "primaryWeapon"], [("STR_ADVSEC_launcher" call ADVSEC_fnc_L), "secondaryWeapon"], [("STR_ADVSEC_handgun" call ADVSEC_fnc_L), "handgun"], [("STR_ADVSEC_uniform" call ADVSEC_fnc_L), "uniform"], [("STR_ADVSEC_vest" call ADVSEC_fnc_L), "vest"], [("STR_ADVSEC_backpack" call ADVSEC_fnc_L), "backpack"],
            [("STR_ADVSEC_helmet_and_cap" call ADVSEC_fnc_L), "headgear"], [("STR_ADVSEC_glasses" call ADVSEC_fnc_L), "goggles"], [("STR_ADVSEC_night_vision" call ADVSEC_fnc_L), "nvgs"], [("STR_ADVSEC_binoculars" call ADVSEC_fnc_L), "binoculars"], [("STR_ADVSEC_map" call ADVSEC_fnc_L), "map"], [("STR_ADVSEC_gps_and_terminal" call ADVSEC_fnc_L), "gps"],
            [("STR_ADVSEC_radius" call ADVSEC_fnc_L), "radio"], [("STR_ADVSEC_compass" call ADVSEC_fnc_L), "compass"], [("STR_ADVSEC_watch" call ADVSEC_fnc_L), "watch"], [("STR_ADVSEC_optic" call ADVSEC_fnc_L), "itemOptic"], [("STR_ADVSEC_rail_attachment" call ADVSEC_fnc_L), "itemAcc"], [("STR_ADVSEC_muzzle" call ADVSEC_fnc_L), "itemMuzzle"],
            [("STR_ADVSEC_bipod" call ADVSEC_fnc_L), "itemBipod"], [("STR_ADVSEC_magazines" call ADVSEC_fnc_L), "cargoMag"], [("STR_ADVSEC_grenades" call ADVSEC_fnc_L), "cargoThrow"], [("STR_ADVSEC_explosives" call ADVSEC_fnc_L), "cargoPut"], [("STR_ADVSEC_miscellaneous" call ADVSEC_fnc_L), "cargoMisc"]
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
