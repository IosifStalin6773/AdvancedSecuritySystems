/*
    [acción, args] — selector de la tienda estilo arsenal (cliente)
    "init" · "refresh" · "tab" [i] · "list" · "select" · "compat" · "buy" [n] · "sell"
*/
params ["_a", ["_v", 0]];
private _d = findDisplay 87900;
if (isNull _d || {isNil "ADVSEC_shopData"}) exitWith {};
ADVSEC_shopData params ["_name", "_items", "_sellF", "_cash", "_bank", "_cur", "_ill"];
private _fmt = {format ["%1 %2", (_this toFixed 0), _cur]};
private _list = _d displayCtrl 87903;
// Cuántos lleva el jugador de una clase
private _carry = {
    params ["_c"];
    private _k = toLower _c;
    private _n = {toLower _x == _k} count ((items player) + (magazines player));
    if (_n == 0 && {_k in (((weapons player) + (assignedItems player) + (primaryWeaponItems player) + (secondaryWeaponItems player) + (handgunItems player) + [uniform player, vest player, backpack player, headgear player, goggles player, hmd player]) apply {toLower _x})}) then {_n = 1};
    _n
};
private _tabSel = {
    {
        _x params ["_bg", "_p"];
        private _on = _forEachIndex == ADVSEC_shopTab;
        _bg ctrlSetBackgroundColor ([[0.157, 0.157, 0.157, 1], [0.816, 0.639, 0.188, 1]] select _on);
        _p ctrlSetTextColor ([[0.85, 0.85, 0.85, 1], [0.078, 0.078, 0.078, 1]] select _on);
    } forEach ADVSEC_shopTabCtrls;
};

switch (_a) do {
    case "init": {
        if (isNil "ADVSEC_shopTabs") then {
            ADVSEC_shopTabs = [
                [("STR_ADVSEC_primary_weapon" call ADVSEC_fnc_L), "primaryWeapon"], [("STR_ADVSEC_launcher" call ADVSEC_fnc_L), "secondaryWeapon"], [("STR_ADVSEC_handgun" call ADVSEC_fnc_L), "handgun"], [("STR_ADVSEC_uniform" call ADVSEC_fnc_L), "uniform"], [("STR_ADVSEC_vest" call ADVSEC_fnc_L), "vest"], [("STR_ADVSEC_backpack" call ADVSEC_fnc_L), "backpack"],
                [("STR_ADVSEC_helmet_and_cap" call ADVSEC_fnc_L), "headgear"], [("STR_ADVSEC_glasses" call ADVSEC_fnc_L), "goggles"], [("STR_ADVSEC_night_vision" call ADVSEC_fnc_L), "nvgs"], [("STR_ADVSEC_binoculars" call ADVSEC_fnc_L), "binoculars"], [("STR_ADVSEC_map" call ADVSEC_fnc_L), "map"], [("STR_ADVSEC_gps_and_terminal" call ADVSEC_fnc_L), "gps"],
                [("STR_ADVSEC_radius" call ADVSEC_fnc_L), "radio"], [("STR_ADVSEC_compass" call ADVSEC_fnc_L), "compass"], [("STR_ADVSEC_watch" call ADVSEC_fnc_L), "watch"], [("STR_ADVSEC_optic" call ADVSEC_fnc_L), "itemOptic"], [("STR_ADVSEC_rail_attachment" call ADVSEC_fnc_L), "itemAcc"], [("STR_ADVSEC_muzzle" call ADVSEC_fnc_L), "itemMuzzle"],
                [("STR_ADVSEC_bipod" call ADVSEC_fnc_L), "itemBipod"], [("STR_ADVSEC_magazines" call ADVSEC_fnc_L), "cargoMag"], [("STR_ADVSEC_grenades" call ADVSEC_fnc_L), "cargoThrow"], [("STR_ADVSEC_explosives" call ADVSEC_fnc_L), "cargoPut"], [("STR_ADVSEC_miscellaneous" call ADVSEC_fnc_L), "cargoMisc"]
            ];
        };
        // Solo las pestañas que tienen algo a la venta, en el orden del arsenal
        private _cats = [];
        {_cats pushBackUnique ([_x select 0] call ADVSEC_fnc_shopCat)} forEach _items;
        _cats sort true;
        ADVSEC_shopCats = _cats;
        private _grp = _d displayCtrl 87904;
        private _ctrls = [];
        private _h = 0.055;
        {
            private _t = ADVSEC_shopTabs select _x;
            private _y = _forEachIndex * (_h + 0.005);
            private _bg = _d ctrlCreate ["RscText", -1, _grp];
            _bg ctrlSetPosition ([[0, _y, 0.055, _h], 3] call ADVSEC_fnc_uiRect);
            _bg ctrlCommit 0;
            private _p = _d ctrlCreate ["RscPictureKeepAspect", -1, _grp];
            _p ctrlSetPosition ([[0.006, _y + 0.006, 0.043, _h - 0.012], 3] call ADVSEC_fnc_uiRect);
            _p ctrlSetText format ["\A3\ui_f\data\gui\Rsc\RscDisplayArsenal\%1_ca.paa", _t select 1];
            _p ctrlCommit 0;
            private _b = _d ctrlCreate ["ADVSEC_ShopTab", -1, _grp];
            _b ctrlSetPosition ([[0, _y, 0.055, _h], 3] call ADVSEC_fnc_uiRect);
            _b ctrlSetTooltip (_t select 0);
            _b setVariable ["ADVSEC_i", _forEachIndex];
            _b ctrlAddEventHandler ["ButtonClick", {["tab", (_this select 0) getVariable ["ADVSEC_i", 0]] call ADVSEC_fnc_shopUI}];
            _b ctrlCommit 0;
            _ctrls pushBack [_bg, _p, _b];
        } forEach _cats;
        ADVSEC_shopTabCtrls = _ctrls;
        if (_ill) then {(_d displayCtrl 87901) ctrlSetTextColor [1, 0.45, 0.35, 1]};
        ["tab", 0] call ADVSEC_fnc_shopUI;
    };
    case "refresh": {["list"] call ADVSEC_fnc_shopUI};
    case "tab": {
        ADVSEC_shopTab = (_v max 0) min ((count ADVSEC_shopCats - 1) max 0);
        call _tabSel;
        ["list"] call ADVSEC_fnc_shopUI;
    };
    case "list": {
        (_d displayCtrl 87930) ctrlSetStructuredText parseText format [("STR_ADVSEC_cash_bank_4" call ADVSEC_fnc_L),
            _cash call _fmt, _bank call _fmt, [("STR_ADVSEC_paid_in_cash_and_if" call ADVSEC_fnc_L), ("STR_ADVSEC_black_market_none_of_this" call ADVSEC_fnc_L)] select _ill];
        if (ADVSEC_shopCats isEqualTo []) exitWith {
            (_d displayCtrl 87902) ctrlSetText ("STR_ADVSEC_this_shop_has_no_items" call ADVSEC_fnc_L);
            lbClear _list;
            ["select"] call ADVSEC_fnc_shopUI;
        };
        private _cat = ADVSEC_shopCats select ADVSEC_shopTab;
        (_d displayCtrl 87902) ctrlSetText toUpper ((ADVSEC_shopTabs select _cat) select 0);
        private _q = toLower ctrlText (_d displayCtrl 87906);
        // Con texto de búsqueda se busca en todas las pestañas
        private _rows = [];
        {
            _x params ["_c", "_p"];
            private _n = [_c] call ADVSEC_fnc_ecoItemName;
            if ([([_c] call ADVSEC_fnc_shopCat) == _cat, (toLower _n) find _q >= 0 || {(toLower _c) find _q >= 0}] select (_q isNotEqualTo "")) then {_rows pushBack [_n, _p, _c, _forEachIndex]};
        } forEach _items;
        if (_q isNotEqualTo "") then {(_d displayCtrl 87902) ctrlSetText format [("STR_ADVSEC_search_result_s" call ADVSEC_fnc_L), count _rows]};
        private _s = lbCurSel (_d displayCtrl 87905);
        private _keyed = _rows apply {[[toLower (_x select 0), _x select 1, -(_x select 1)] select (_s max 0), _x]};
        _keyed sort true;
        _rows = _keyed apply {_x select 1};
        lbClear _list;
        private _sel = 0;
        {
            _x params ["_n", "_p", "_c", "_i"];
            private _carried = [_c] call _carry;
            private _r = _list lbAdd _n;
            _list lbSetPicture [_r, [_c] call ADVSEC_fnc_ecoItemPic];
            _list lbSetTextRight [_r, _p call _fmt];
            _list lbSetData [_r, _c];
            _list lbSetValue [_r, _i];
            _list lbSetTooltip [_r, format ["%1 (%2)%3", _n, _c, ["", format [("STR_ADVSEC_you_carry" call ADVSEC_fnc_L), _carried]] select (_carried > 0)]];
            if (_carried > 0) then {_list lbSetColor [_r, [0.816, 0.639, 0.188, 1]]};
            if (_c == ADVSEC_shopSel) then {_sel = _r};
        } forEach _rows;
        _list lbSetCurSel ([_sel, -1] select (_rows isEqualTo []));
        if (_rows isEqualTo []) then {["select"] call ADVSEC_fnc_shopUI};
    };
    case "select": {
        private _r = lbCurSel _list;
        private _c = ["", _list lbData _r] select (_r >= 0);
        {(_d displayCtrl _x) ctrlEnable (_c isNotEqualTo "")} forEach [87931, 87932, 87933];
        private _compat = _d displayCtrl 87920;
        lbClear _compat;
        if (_c isEqualTo "") exitWith {
            (_d displayCtrl 87910) ctrlSetText "";
            (_d displayCtrl 87911) ctrlSetStructuredText parseText ("STR_ADVSEC_choose_an_item_from_the" call ADVSEC_fnc_L);
            {(_d displayCtrl (87940 + _x)) ctrlSetText ""; (_d displayCtrl (87950 + _x)) progressSetPosition 0} forEach [0, 1, 2];
        };
        ADVSEC_shopSel = _c;
        private _p = (_items select (_list lbValue _r)) select 1;
        private _carried = [_c] call _carry;
        private _cfg = configFile >> "CfgWeapons" >> _c;
        if (!isClass _cfg) then {_cfg = configFile >> "CfgMagazines" >> _c};
        if (!isClass _cfg) then {_cfg = configFile >> "CfgVehicles" >> _c};
        if (!isClass _cfg) then {_cfg = configFile >> "CfgGlasses" >> _c};
        private _desc = getText (_cfg >> "descriptionShort");
        (_d displayCtrl 87910) ctrlSetText ([_c] call ADVSEC_fnc_ecoItemPic);
        (_d displayCtrl 87911) ctrlSetStructuredText parseText format [("STR_ADVSEC_price_buy_back_price_2" call ADVSEC_fnc_L),
            ([_c] call ADVSEC_fnc_ecoItemName) call ADVSEC_fnc_repEsc, _p call _fmt, (round (_p * _sellF)) call _fmt,
            ["", format [("STR_ADVSEC_you_carry_2" call ADVSEC_fnc_L), _carried]] select (_carried > 0), _c, _desc];
        private _st = [_c] call ADVSEC_fnc_shopStats;
        {
            private _e = _st param [_x, []];
            (_d displayCtrl (87940 + _x)) ctrlSetText (_e param [0, ""]);
            (_d displayCtrl (87950 + _x)) progressSetPosition (_e param [1, 0]);
            (_d displayCtrl (87950 + _x)) ctrlShow (_e isNotEqualTo []);
        } forEach [0, 1, 2];
        // Como el panel derecho del arsenal: cargadores y accesorios de esta arma que vende la tienda
        if (([_c] call ADVSEC_fnc_shopCat) in [0, 1, 2]) then {
            private _ok = (([_c] call BIS_fnc_compatibleMagazines) + ([_c] call BIS_fnc_compatibleItems)) apply {toLower _x};
            {
                _x params ["_c2", "_p2"];
                if (toLower _c2 in _ok) then {
                    private _i = _compat lbAdd ([_c2] call ADVSEC_fnc_ecoItemName);
                    _compat lbSetPicture [_i, [_c2] call ADVSEC_fnc_ecoItemPic];
                    _compat lbSetTextRight [_i, _p2 call _fmt];
                    _compat lbSetData [_i, _c2];
                };
            } forEach _items;
        };
        (_d displayCtrl 87921) ctrlSetText (["", ("STR_ADVSEC_compatible_in_this_shop" call ADVSEC_fnc_L)] select (lbSize _compat > 0));
    };
    case "compat": {
        private _r = lbCurSel (_d displayCtrl 87920);
        if (_r < 0) exitWith {};
        ADVSEC_shopSel = (_d displayCtrl 87920) lbData _r;
        (_d displayCtrl 87906) ctrlSetText "";
        private _t = ADVSEC_shopCats find ([ADVSEC_shopSel] call ADVSEC_fnc_shopCat);
        if (_t >= 0) then {["tab", _t] call ADVSEC_fnc_shopUI};
    };
    case "buy": {
        private _r = lbCurSel _list;
        if (_r < 0 || {!(_v in [1, 5])}) exitWith {};
        ["buy", player, [ADVSEC_ecoShop, _list lbValue _r, _v]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    };
    case "sell": {
        private _r = lbCurSel _list;
        if (_r < 0) exitWith {};
        ["sell", player, [ADVSEC_ecoShop, _list lbValue _r]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    };
};
