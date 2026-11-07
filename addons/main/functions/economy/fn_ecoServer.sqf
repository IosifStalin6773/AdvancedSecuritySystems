/*
    [acción, llamador, args] (servidor) — economía.
    "wallet" · "deposit" [importe] · "withdraw" [importe] · "transfer" [SteamID, importe] · "give" [unidad, importe]
    "shop" [tienda] · "shopData" [tienda] · "buy" [tienda, índice, cantidad] · "sell" [tienda, índice]
    "treasury" · "bonus" [unidad, importe, motivo]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([] call ADVSEC_fnc_ecoOn) exitWith {("STR_ADVSEC_the_advsec_economy_is_disabled" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _uid = getPlayerUID _caller;
if (_uid isEqualTo "") exitWith {};
private _a = [_uid, name _caller] call ADVSEC_fnc_ecoAcc;
private _amt = {
    params ["_v"];
    if !(_v isEqualType 0) exitWith {0};
    if (!finite _v) exitWith {0};
    round ((_v max 0) min 10000000)
};
private _fmt = {format ["%1 %2", (_this toFixed 0), _cur]};
private _nearKind = {
    params ["_var", ["_r", 6]];
    ((nearestObjects [_caller, [], _r, true]) findIf {_x getVariable [_var, false] isNotEqualTo false}) >= 0
};
private _atm = {
    ((["atmAnywhere", 0] call ADVSEC_fnc_setting) isEqualTo 1) || {["ADVSEC_atm"] call _nearKind}
};
private _shopOk = {
    params ["_s"];
    !isNull _s && {(_s getVariable ["ADVSEC_shop", []]) isNotEqualTo []} && {(_caller distance _s) < 8}
};
private _bankPush = {_caller setVariable ["ADVSEC_bank", _a select 1, true]};

switch (_action) do {
    case "wallet": {
        [_caller] call ADVSEC_fnc_ecoPush;
        private _cash = [_caller] call ADVSEC_fnc_ecoCash;
        private _rows = [];
        {
            _x params ["_d", "_t", "_v"];
            _rows pushBack [format ["%1 · %2%3", _d, ["", "+"] select (_v > 0), _v call _fmt], [], format [("STR_ADVSEC_amount_2" call ADVSEC_fnc_L), _t call ADVSEC_fnc_repEsc, _d, _v call _fmt], [[1, 0.45, 0.35, 1], [0.45, 1, 0.45, 1]] select (_v > 0), ""];
        } forEach (_a select 3);
        reverse _rows;
        ["wallet", format [("STR_ADVSEC_cash_bank_3" call ADVSEC_fnc_L),
            _cash call _fmt, (_a select 1) call _fmt, [("STR_ADVSEC_depositing_withdrawing_and_transferring_" call ADVSEC_fnc_L), ("STR_ADVSEC_atm_available" call ADVSEC_fnc_L)] select (call _atm)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "deposit";
    case "withdraw": {
        private _v = [_args param [0, 0]] call _amt;
        if (_v <= 0) exitWith {("STR_ADVSEC_invalid_amount" call ADVSEC_fnc_L) call _say};
        if !(call _atm) exitWith {("STR_ADVSEC_you_need_an_atm_nearby" call ADVSEC_fnc_L) call _say};
        if (_action == "withdraw" && {_a param [4, false]}) exitWith {("STR_ADVSEC_your_account_has_been_frozen" call ADVSEC_fnc_L) call _say};
        private _cash = [_caller] call ADVSEC_fnc_ecoCash;
        if (_action == "deposit") then {
            if (_cash < _v) exitWith {(format [("STR_ADVSEC_you_don_t_carry_that" call ADVSEC_fnc_L), _cash call _fmt]) call _say};
            [_caller, _cash - _v] call ADVSEC_fnc_ecoSetCash;
            _a set [1, (_a select 1) + _v];
            [_a, ("STR_ADVSEC_atm_deposit" call ADVSEC_fnc_L), _v] call ADVSEC_fnc_ecoHist;
        } else {
            if ((_a select 1) < _v) exitWith {(format [("STR_ADVSEC_insufficient_balance" call ADVSEC_fnc_L), (_a select 1) call _fmt]) call _say};
            _a set [1, (_a select 1) - _v];
            [_caller, _cash + _v] call ADVSEC_fnc_ecoSetCash;
            [_a, ("STR_ADVSEC_atm_withdrawal" call ADVSEC_fnc_L), -_v] call ADVSEC_fnc_ecoHist;
        };
        call _bankPush;
        ["wallet", _caller] call ADVSEC_fnc_ecoServer;
    };
    case "transfer": {
        _args params [["_to", ""], ["_v", 0]];
        _v = [_v] call _amt;
        if (_v <= 0 || {_to isEqualTo _uid}) exitWith {("STR_ADVSEC_invalid_transfer" call ADVSEC_fnc_L) call _say};
        if !(call _atm) exitWith {("STR_ADVSEC_you_need_an_atm_nearby" call ADVSEC_fnc_L) call _say};
        if (_a param [4, false]) exitWith {("STR_ADVSEC_your_account_has_been_frozen" call ADVSEC_fnc_L) call _say};
        private _b = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_to, []];
        if (_b isEqualTo []) exitWith {("STR_ADVSEC_that_account_does_not_exist" call ADVSEC_fnc_L) call _say};
        if ((_a select 1) < _v) exitWith {(format [("STR_ADVSEC_insufficient_balance" call ADVSEC_fnc_L), (_a select 1) call _fmt]) call _say};
        _a set [1, (_a select 1) - _v];
        _b set [1, (_b select 1) + _v];
        [_a, format [("STR_ADVSEC_transfer_to" call ADVSEC_fnc_L), _b select 2], -_v] call ADVSEC_fnc_ecoHist;
        [_b, format [("STR_ADVSEC_transfer_from" call ADVSEC_fnc_L), name _caller], _v] call ADVSEC_fnc_ecoHist;
        call _bankPush;
        private _u = allPlayers param [allPlayers findIf {getPlayerUID _x isEqualTo _to}, objNull];
        if (!isNull _u) then {
            _u setVariable ["ADVSEC_bank", _b select 1, true];
            (format [("STR_ADVSEC_has_transferred_you" call ADVSEC_fnc_L), name _caller, _v call _fmt]) remoteExecCall ["hint", _u];
        };
        ["economy", _caller, ["transfer", _to, _v]] call ADVSEC_fnc_logEvent;
        [[_uid, name _caller], [_to, _b select 2], _v, ("STR_ADVSEC_transfer" call ADVSEC_fnc_L)] call ADVSEC_fnc_ecoFlag;
        ["wallet", _caller] call ADVSEC_fnc_ecoServer;
    };
    case "give": {
        _args params [["_u", objNull], ["_v", 0]];
        _v = [_v] call _amt;
        if (isNull _u || {_u isEqualTo _caller} || {!alive _u} || {getPlayerUID _u isEqualTo ""} || {(_u distance _caller) > 5}) exitWith {("STR_ADVSEC_you_must_be_next_to" call ADVSEC_fnc_L) call _say};
        private _cash = [_caller] call ADVSEC_fnc_ecoCash;
        if (_v <= 0 || {_cash < _v}) exitWith {(format [("STR_ADVSEC_you_don_t_carry_that" call ADVSEC_fnc_L), _cash call _fmt]) call _say};
        [_caller, _cash - _v] call ADVSEC_fnc_ecoSetCash;
        [_u, ([_u] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [_a, format [("STR_ADVSEC_given_to" call ADVSEC_fnc_L), name _u], -_v] call ADVSEC_fnc_ecoHist;
        [[getPlayerUID _u, name _u] call ADVSEC_fnc_ecoAcc, format [("STR_ADVSEC_received_from" call ADVSEC_fnc_L), name _caller], _v] call ADVSEC_fnc_ecoHist;
        (format [("STR_ADVSEC_has_given_you_in_cash" call ADVSEC_fnc_L), name _caller, _v call _fmt]) remoteExecCall ["hint", _u];
        ["economy", _caller, ["give", getPlayerUID _u, _v]] call ADVSEC_fnc_logEvent;
        [[_uid, name _caller], [getPlayerUID _u, name _u], _v, ("STR_ADVSEC_cash_in_hand" call ADVSEC_fnc_L)] call ADVSEC_fnc_ecoFlag;
        ["wallet", _caller] call ADVSEC_fnc_ecoServer;
    };
    case "shop": {
        _args params [["_s", objNull]];
        if !([_s] call _shopOk) exitWith {};
        (_s getVariable "ADVSEC_shop") params ["_name", "_items"];
        private _sellF = ["sellFactor", 0.5] call ADVSEC_fnc_setting;
        private _rows = [];
        {
            _x params ["_c", "_p"];
            _rows pushBack [format ["%1 · %2", [_c] call ADVSEC_fnc_ecoItemName, _p call _fmt], _forEachIndex,
                format [("STR_ADVSEC_price_buy_back_price" call ADVSEC_fnc_L), ([_c] call ADVSEC_fnc_ecoItemName) call ADVSEC_fnc_repEsc, _p call _fmt, (round (_p * _sellF)) call _fmt, _c], [], [_c] call ADVSEC_fnc_ecoItemPic];
        } forEach _items;
        ["shop", format [("STR_ADVSEC_cash_bank_paid_in_cash" call ADVSEC_fnc_L), _name call ADVSEC_fnc_repEsc, ([_caller] call ADVSEC_fnc_ecoCash) call _fmt, (_a select 1) call _fmt], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "shopData": {
        _args params [["_s", objNull]];
        if !([_s] call _shopOk) exitWith {};
        (_s getVariable "ADVSEC_shop") params ["_name", "_items"];
        [_name, _items, ["sellFactor", 0.5] call ADVSEC_fnc_setting, [_caller] call ADVSEC_fnc_ecoCash, _a select 1, _cur, _s getVariable ["ADVSEC_shopIllegal", false]] remoteExecCall ["ADVSEC_fnc_shopSet", _caller];
    };
    case "buy": {
        _args params [["_s", objNull], ["_i", -1], ["_n", 1]];
        if !([_s] call _shopOk) exitWith {("STR_ADVSEC_you_must_be_at_the" call ADVSEC_fnc_L) call _say};
        private _it = ((_s getVariable "ADVSEC_shop") select 1) param [_i, []];
        if (_it isEqualTo [] || {!(_n in [1, 5])}) exitWith {};
        _it params ["_c", "_p"];
        private _total = _p * _n;
        private _illegal = _s getVariable ["ADVSEC_shopIllegal", false];
        if !([_caller, _total, format [("STR_ADVSEC_purchase" call ADVSEC_fnc_L), _n, [_c] call ADVSEC_fnc_ecoItemName], !_illegal && {(["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1}] call ADVSEC_fnc_ecoCharge) exitWith {
            (format [("STR_ADVSEC_not_enough_money_it_costs" call ADVSEC_fnc_L), _total call _fmt]) call _say;
        };
        [_c, _n] remoteExecCall ["ADVSEC_fnc_ecoGiveItem", _caller];
        // Armas de tienda legal: quedan registradas a nombre del comprador
        if (!_illegal && {(["shopRegistersWeapons", 1] call ADVSEC_fnc_setting) isEqualTo 1} && {getNumber (configFile >> "CfgWeapons" >> _c >> "type") in [1, 2, 4]}) then {[_caller, _c] call ADVSEC_fnc_wpnRegister};
        ["shopData", _caller, [_s]] call ADVSEC_fnc_ecoServer;
    };
    case "sell": {
        _args params [["_s", objNull], ["_i", -1]];
        if !([_s] call _shopOk) exitWith {("STR_ADVSEC_you_must_be_at_the" call ADVSEC_fnc_L) call _say};
        private _it = ((_s getVariable "ADVSEC_shop") select 1) param [_i, []];
        if (_it isEqualTo []) exitWith {};
        _it params ["_c", "_p"];
        private _has = _c in ((itemsWithMagazines _caller) + (weapons _caller) + (assignedItems _caller) + [uniform _caller, vest _caller, backpack _caller, headgear _caller, goggles _caller]);
        if (!_has) exitWith {("STR_ADVSEC_you_are_not_carrying_that" call ADVSEC_fnc_L) call _say};
        private _v = round (_p * (["sellFactor", 0.5] call ADVSEC_fnc_setting));
        [_c] remoteExecCall ["ADVSEC_fnc_ecoTakeItem", _caller];
        [_caller, ([_caller] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [_a, format [("STR_ADVSEC_sale" call ADVSEC_fnc_L), [_c] call ADVSEC_fnc_ecoItemName], _v] call ADVSEC_fnc_ecoHist;
        ["shopData", _caller, [_s]] call ADVSEC_fnc_ecoServer;
    };
    case "treasury": {
        if !([_caller, "treasury"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_view_the_treasury" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        [] call ADVSEC_fnc_ecoDB;
        private _rows = (localNamespace getVariable ["ADVSEC_treasuryHist", []]) apply {
            _x params ["_d", "_t", "_v"];
            [format ["%1 · %2%3 · %4", _d, ["", "+"] select (_v > 0), _v call _fmt, _t], [], format [("STR_ADVSEC_amount_2" call ADVSEC_fnc_L), _t call ADVSEC_fnc_repEsc, _d, _v call _fmt], [[1, 0.45, 0.35, 1], [0.45, 1, 0.45, 1]] select (_v > 0), ""]
        };
        reverse _rows;
        ["treasury", format [("STR_ADVSEC_mp_treasury_collected_fines_go" call ADVSEC_fnc_L), ([] call ADVSEC_fnc_ecoTreasuryNow) call _fmt, ["", ("STR_ADVSEC_and_purchases" call ADVSEC_fnc_L)] select ((["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "bonus": {
        _args params [["_u", objNull], ["_v", 0], ["_why", ""]];
        if !([_caller, "treasury"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pay_from_the_treasury" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _v = [_v] call _amt;
        if (isNull _u || {getPlayerUID _u isEqualTo ""} || {_v <= 0}) exitWith {("STR_ADVSEC_invalid_data" call ADVSEC_fnc_L) call _say};
        if (([] call ADVSEC_fnc_ecoTreasuryNow) < _v) exitWith {("STR_ADVSEC_the_treasury_does_not_have" call ADVSEC_fnc_L) call _say};
        _why = (_why select [0, 120]);
        if (_why isEqualTo "") then {_why = ("STR_ADVSEC_bonus" call ADVSEC_fnc_L)};
        [-_v, format [("STR_ADVSEC_authorised_by" call ADVSEC_fnc_L), _why, name _u, name _caller]] call ADVSEC_fnc_ecoTreasury;
        private _b = [getPlayerUID _u, name _u] call ADVSEC_fnc_ecoAcc;
        _b set [1, (_b select 1) + _v];
        _u setVariable ["ADVSEC_bank", _b select 1, true];
        [_b, format [("STR_ADVSEC_mp_treasury_2" call ADVSEC_fnc_L), _why], _v] call ADVSEC_fnc_ecoHist;
        (format [("STR_ADVSEC_you_have_received_from_the" call ADVSEC_fnc_L), _v call _fmt, _why]) remoteExecCall ["hint", _u];
        ["economy", _caller, ["bonus", getPlayerUID _u, _v, _why]] call ADVSEC_fnc_logEvent;
        ["treasury", _caller] call ADVSEC_fnc_ecoServer;
    };
};
