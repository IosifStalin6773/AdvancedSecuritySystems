// [clase] -> índice de pestaña en ADVSEC_shopTabs (misma clasificación que el arsenal)
params ["_c"];
private _cache = uiNamespace getVariable "ADVSEC_shopCatCache";
if (isNil "_cache") then {_cache = createHashMap; uiNamespace setVariable ["ADVSEC_shopCatCache", _cache]};
private _k = toLower _c;
if (_k in _cache) exitWith {_cache get _k};
private _r = 22;
private _w = configFile >> "CfgWeapons" >> _c;
switch (true) do {
    case (isClass _w): {
        private _t = getNumber (_w >> "type");
        private _it = getNumber (_w >> "ItemInfo" >> "type");
        private _sim = toLower getText (_w >> "simulation");
        _r = switch (true) do {
            case (_t == 1): {0};
            case (_t == 4): {1};
            case (_t == 2): {2};
            case (_it == 801): {3};
            case (_it == 701): {4};
            case (_it == 605): {6};
            case (_sim == "nvgoggles" || {_it == 616}): {8};
            case (_t == 4096): {9};
            case (_sim == "itemmap"): {10};
            case (_sim == "itemgps" || {_it == 621}): {11};
            case (_sim == "itemradio"): {12};
            case (_sim == "itemcompass"): {13};
            case (_sim == "itemwatch"): {14};
            case (_it == 201): {15};
            case (_it == 301): {16};
            case (_it == 101): {17};
            case (_it == 302): {18};
            default {22};
        };
    };
    case (isClass (configFile >> "CfgMagazines" >> _c)): {
        // Granadas y explosivos: cargadores de los "arma" Throw y Put
        private _tp = uiNamespace getVariable "ADVSEC_shopThrowPut";
        if (isNil "_tp") then {
            _tp = ["Throw", "Put"] apply {
                private _w2 = configFile >> "CfgWeapons" >> _x;
                private _m = [];
                {_m append (getArray (_w2 >> _x >> "magazines"))} forEach (getArray (_w2 >> "muzzles"));
                _m apply {toLower _x}
            };
            uiNamespace setVariable ["ADVSEC_shopThrowPut", _tp];
        };
        _r = switch (true) do {case (_k in (_tp select 0)): {20}; case (_k in (_tp select 1)): {21}; default {19}};
    };
    case (isClass (configFile >> "CfgVehicles" >> _c)): {_r = [22, 5] select (getNumber (configFile >> "CfgVehicles" >> _c >> "isBackpack") == 1)};
    case (isClass (configFile >> "CfgGlasses" >> _c)): {_r = 7};
};
_cache set [_k, _r];
_r
