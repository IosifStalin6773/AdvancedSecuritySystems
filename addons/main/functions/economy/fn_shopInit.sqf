/*
    [objeto, nombre, artículos, oculta, cliente, reputaciónMínima] — tienda (init del objeto, todas las máquinas)
    artículos: "clase:precio, clase:precio" o [[clase, precio], ...]; vacío = shopItems de ADVSEC_Settings.
    cliente/reputaciónMínima (PMC): proveedor de un cliente de contratos; solo vende con reputación >= mínima.
*/
params ["_obj", ["_name", ("STR_ADVSEC_shop" call ADVSEC_fnc_L)], ["_items", ""], ["_hidden", false], ["_client", ""], ["_repMin", 0]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (_items isEqualType "") then {
    _items = ((_items splitString ",") apply {(_x splitString ":") apply {_x trim [" ", 0]}}) select {count _x == 2} apply {[_x select 0, parseNumber (_x select 1)]};
};
if (_items isEqualTo []) then {_items = [["shopItems", "blackMarketItems"] select _hidden, []] call ADVSEC_fnc_setting};
_items = _items select {_x isEqualType [] && {count _x == 2} && {([_x select 0] call ADVSEC_fnc_ecoItemName) isNotEqualTo ""} && {(_x select 1) isEqualType 0} && {(_x select 1) > 0}};
_obj setVariable ["ADVSEC_shop", [_name, _items]];
_obj setVariable ["ADVSEC_shopIllegal", _hidden];
_obj setVariable ["ADVSEC_shopClient", [_client, _repMin]];
if (isServer) then {[_obj, "shop", _name] call ADVSEC_fnc_register};
// Mercado negro: sin nombre y solo a menos de 2,5 m
[_obj, "advsec_shop", [format [("STR_ADVSEC_buy_sell" call ADVSEC_fnc_L), _name], ("STR_ADVSEC_speak_quietly" call ADVSEC_fnc_L)] select _hidden, ADVSEC_icSearch,
    {
        (_target getVariable ["ADVSEC_shopClient", ["", 0]]) params ["_cl", "_min"];
        private _rep = ((missionNamespace getVariable ["ADVSEC_clientRep", []]) select {(_x select 0) == _cl}) param [0, ["", 0]] select 1;
        if (_cl isNotEqualTo "" && {_rep < _min}) exitWith {hint format [("STR_ADVSEC_pmc_shop_rep" call ADVSEC_fnc_L), _rep, _min]};
        [_target] call ADVSEC_fnc_ecoShopOpen
    },
    [{[] call ADVSEC_fnc_ecoOn}, {[] call ADVSEC_fnc_ecoOn && {(_player distance _target) < 2.5}}] select _hidden,
    "main", [], [3, 2.5] select _hidden
] call ADVSEC_fnc_addInteraction;
// Mercado negro: vender el arma corporativa que se lleva en la mano (deja rastro según blackMarketTrace)
if (_hidden) then {
    [_obj, "advsec_sellcorp", ("STR_ADVSEC_pmc_sell_corp" call ADVSEC_fnc_L), ADVSEC_icSearch,
        {["sellCorp", _player, [_target, [currentWeapon _player] call BIS_fnc_baseWeapon]] remoteExecCall ["ADVSEC_fnc_armServer", 2]},
        {(_player distance _target) < 2.5 && {((_player getVariable ["ADVSEC_corpArms", []]) findIf {(_x select 0) == ([currentWeapon _player] call BIS_fnc_baseWeapon)}) >= 0}},
        "main", [], 2.5
    ] call ADVSEC_fnc_addInteraction;
};
