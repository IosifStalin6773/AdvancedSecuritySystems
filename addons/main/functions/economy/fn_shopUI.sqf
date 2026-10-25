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
                ["Arma principal", "primaryWeapon"], ["Lanzador", "secondaryWeapon"], ["Pistola", "handgun"], ["Uniforme", "uniform"], ["Chaleco", "vest"], ["Mochila", "backpack"],
                ["Casco y gorra", "headgear"], ["Gafas", "goggles"], ["Visión nocturna", "nvgs"], ["Prismáticos", "binoculars"], ["Mapa", "map"], ["GPS y terminal", "gps"],
                ["Radio", "radio"], ["Brújula", "compass"], ["Reloj", "watch"], ["Mira", "itemOptic"], ["Accesorio de raíl", "itemAcc"], ["Bocacha", "itemMuzzle"],
                ["Bípode", "itemBipod"], ["Cargadores", "cargoMag"], ["Granadas", "cargoThrow"], ["Explosivos", "cargoPut"], ["Varios", "cargoMisc"]
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
            _bg ctrlSetPosition [0, _y, 0.055, _h];
            _bg ctrlCommit 0;
            private _p = _d ctrlCreate ["RscPictureKeepAspect", -1, _grp];
            _p ctrlSetPosition [0.006, _y + 0.006, 0.043, _h - 0.012];
            _p ctrlSetText format ["\A3\ui_f\data\gui\Rsc\RscDisplayArsenal\%1_ca.paa", _t select 1];
            _p ctrlCommit 0;
            private _b = _d ctrlCreate ["ADVSEC_ShopTab", -1, _grp];
            _b ctrlSetPosition [0, _y, 0.055, _h];
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
        (_d displayCtrl 87930) ctrlSetStructuredText parseText format ["Efectivo: <t font='RobotoCondensedBold' color='#D0A330'>%1</t>   ·   Banco: <t font='RobotoCondensedBold'>%2</t><br/><t color='#8C8C8C'>%3</t>",
            _cash call _fmt, _bank call _fmt, ["Se paga en efectivo y, si no llega, con el banco. Doble clic en un artículo para comprarlo.", "Mercado negro: nada de esto queda registrado a tu nombre."] select _ill];
        if (ADVSEC_shopCats isEqualTo []) exitWith {
            (_d displayCtrl 87902) ctrlSetText "ESTA TIENDA NO TIENE ARTÍCULOS";
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
        if (_q isNotEqualTo "") then {(_d displayCtrl 87902) ctrlSetText format ["BÚSQUEDA: %1 RESULTADO(S)", count _rows]};
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
            _list lbSetTooltip [_r, format ["%1 (%2)%3", _n, _c, ["", format [" · llevas %1", _carried]] select (_carried > 0)]];
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
            (_d displayCtrl 87911) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Elige un artículo de la lista.</t>";
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
        (_d displayCtrl 87911) ctrlSetStructuredText parseText format ["<t size='1.25' font='RobotoCondensedBold'>%1</t><br/>Precio: <t color='#D0A330' font='RobotoCondensedBold'>%2</t>   ·   Se recompra por: %3<br/>%4<t color='#8C8C8C'>%5</t><br/>%6",
            ([_c] call ADVSEC_fnc_ecoItemName) call ADVSEC_fnc_repEsc, _p call _fmt, (round (_p * _sellF)) call _fmt,
            ["", format ["<t color='#D0A330'>Llevas %1 encima.</t><br/>", _carried]] select (_carried > 0), _c, _desc];
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
        (_d displayCtrl 87921) ctrlSetText (["", "COMPATIBLE EN ESTA TIENDA"] select (lbSize _compat > 0));
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
