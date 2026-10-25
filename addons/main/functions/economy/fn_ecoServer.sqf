/*
    [acción, llamador, args] (servidor) — economía.
    "wallet" · "deposit" [importe] · "withdraw" [importe] · "transfer" [SteamID, importe] · "give" [unidad, importe]
    "shop" [tienda] · "buy" [tienda, índice, cantidad] · "sell" [tienda, índice]
    "treasury" · "bonus" [unidad, importe, motivo]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([] call ADVSEC_fnc_ecoOn) exitWith {"La economía de ADVSEC está desactivada en esta misión." remoteExecCall ["hint", _caller]};
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
            _rows pushBack [format ["%1 · %2%3", _d, ["", "+"] select (_v > 0), _v call _fmt], [], format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Importe: %3", _t call ADVSEC_fnc_repEsc, _d, _v call _fmt], [[1, 0.45, 0.35, 1], [0.45, 1, 0.45, 1]] select (_v > 0), ""];
        } forEach (_a select 3);
        reverse _rows;
        ["wallet", format ["<t size='1.1'>Efectivo: <t font='RobotoCondensedBold'>%1</t> · Banco: <t font='RobotoCondensedBold'>%2</t></t><br/><t color='#8C8C8C'>%3</t>",
            _cash call _fmt, (_a select 1) call _fmt, ["Ingresar, retirar y transferir requiere un cajero cerca.", "Cajero disponible."] select (call _atm)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "deposit";
    case "withdraw": {
        private _v = [_args param [0, 0]] call _amt;
        if (_v <= 0) exitWith {"Importe no válido." call _say};
        if !(call _atm) exitWith {"Necesitas un cajero cerca." call _say};
        private _cash = [_caller] call ADVSEC_fnc_ecoCash;
        if (_action == "deposit") then {
            if (_cash < _v) exitWith {(format ["No llevas tanto efectivo (%1).", _cash call _fmt]) call _say};
            [_caller, _cash - _v] call ADVSEC_fnc_ecoSetCash;
            _a set [1, (_a select 1) + _v];
            [_a, "Ingreso en cajero", _v] call ADVSEC_fnc_ecoHist;
        } else {
            if ((_a select 1) < _v) exitWith {(format ["Saldo insuficiente (%1).", (_a select 1) call _fmt]) call _say};
            _a set [1, (_a select 1) - _v];
            [_caller, _cash + _v] call ADVSEC_fnc_ecoSetCash;
            [_a, "Retirada en cajero", -_v] call ADVSEC_fnc_ecoHist;
        };
        call _bankPush;
        ["wallet", _caller] call ADVSEC_fnc_ecoServer;
    };
    case "transfer": {
        _args params [["_to", ""], ["_v", 0]];
        _v = [_v] call _amt;
        if (_v <= 0 || {_to isEqualTo _uid}) exitWith {"Transferencia no válida." call _say};
        if !(call _atm) exitWith {"Necesitas un cajero cerca." call _say};
        private _b = ([] call ADVSEC_fnc_ecoDB) getOrDefault [_to, []];
        if (_b isEqualTo []) exitWith {"Esa cuenta no existe." call _say};
        if ((_a select 1) < _v) exitWith {(format ["Saldo insuficiente (%1).", (_a select 1) call _fmt]) call _say};
        _a set [1, (_a select 1) - _v];
        _b set [1, (_b select 1) + _v];
        [_a, format ["Transferencia a %1", _b select 2], -_v] call ADVSEC_fnc_ecoHist;
        [_b, format ["Transferencia de %1", name _caller], _v] call ADVSEC_fnc_ecoHist;
        call _bankPush;
        private _u = allPlayers param [allPlayers findIf {getPlayerUID _x isEqualTo _to}, objNull];
        if (!isNull _u) then {
            _u setVariable ["ADVSEC_bank", _b select 1, true];
            (format ["%1 te ha transferido %2.", name _caller, _v call _fmt]) remoteExecCall ["hint", _u];
        };
        ["economy", _caller, ["transfer", _to, _v]] call ADVSEC_fnc_logEvent;
        ["wallet", _caller] call ADVSEC_fnc_ecoServer;
    };
    case "give": {
        _args params [["_u", objNull], ["_v", 0]];
        _v = [_v] call _amt;
        if (isNull _u || {_u isEqualTo _caller} || {!alive _u} || {getPlayerUID _u isEqualTo ""} || {(_u distance _caller) > 5}) exitWith {"Tienes que estar junto a la otra persona." call _say};
        private _cash = [_caller] call ADVSEC_fnc_ecoCash;
        if (_v <= 0 || {_cash < _v}) exitWith {(format ["No llevas tanto efectivo (%1).", _cash call _fmt]) call _say};
        [_caller, _cash - _v] call ADVSEC_fnc_ecoSetCash;
        [_u, ([_u] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [_a, format ["Entregado a %1", name _u], -_v] call ADVSEC_fnc_ecoHist;
        [[getPlayerUID _u, name _u] call ADVSEC_fnc_ecoAcc, format ["Recibido de %1", name _caller], _v] call ADVSEC_fnc_ecoHist;
        (format ["%1 te ha dado %2 en efectivo.", name _caller, _v call _fmt]) remoteExecCall ["hint", _u];
        ["economy", _caller, ["give", getPlayerUID _u, _v]] call ADVSEC_fnc_logEvent;
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
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Precio: %2<br/>Se recompra por: %3<br/><t color='#8C8C8C'>%4</t>", ([_c] call ADVSEC_fnc_ecoItemName) call ADVSEC_fnc_repEsc, _p call _fmt, (round (_p * _sellF)) call _fmt, _c], [], [_c] call ADVSEC_fnc_ecoItemPic];
        } forEach _items;
        ["shop", format ["<t size='1.1'>%1</t> · Efectivo: <t font='RobotoCondensedBold'>%2</t> · Banco: %3<br/><t color='#8C8C8C'>Se paga en efectivo y, si no llega, con el banco.</t>", _name call ADVSEC_fnc_repEsc, ([_caller] call ADVSEC_fnc_ecoCash) call _fmt, (_a select 1) call _fmt], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "buy": {
        _args params [["_s", objNull], ["_i", -1], ["_n", 1]];
        if !([_s] call _shopOk) exitWith {"Tienes que estar en la tienda." call _say};
        private _it = ((_s getVariable "ADVSEC_shop") select 1) param [_i, []];
        if (_it isEqualTo [] || {!(_n in [1, 5])}) exitWith {};
        _it params ["_c", "_p"];
        private _total = _p * _n;
        if !([_caller, _total, format ["Compra: %1 × %2", _n, [_c] call ADVSEC_fnc_ecoItemName], (["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {
            (format ["No te llega: cuesta %1.", _total call _fmt]) call _say;
        };
        [_c, _n] remoteExecCall ["ADVSEC_fnc_ecoGiveItem", _caller];
        ["shop", _caller, [_s]] call ADVSEC_fnc_ecoServer;
    };
    case "sell": {
        _args params [["_s", objNull], ["_i", -1]];
        if !([_s] call _shopOk) exitWith {"Tienes que estar en la tienda." call _say};
        private _it = ((_s getVariable "ADVSEC_shop") select 1) param [_i, []];
        if (_it isEqualTo []) exitWith {};
        _it params ["_c", "_p"];
        private _has = _c in ((itemsWithMagazines _caller) + (weapons _caller) + (assignedItems _caller) + [uniform _caller, vest _caller, backpack _caller, headgear _caller, goggles _caller]);
        if (!_has) exitWith {"No llevas ese objeto encima." call _say};
        private _v = round (_p * (["sellFactor", 0.5] call ADVSEC_fnc_setting));
        [_c] remoteExecCall ["ADVSEC_fnc_ecoTakeItem", _caller];
        [_caller, ([_caller] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [_a, format ["Venta: %1", [_c] call ADVSEC_fnc_ecoItemName], _v] call ADVSEC_fnc_ecoHist;
        ["shop", _caller, [_s]] call ADVSEC_fnc_ecoServer;
    };
    case "treasury": {
        if !([_caller, "treasury"] call ADVSEC_fnc_perm) exitWith {[_caller, "consultar la tesorería"] call ADVSEC_fnc_deny};
        [] call ADVSEC_fnc_ecoDB;
        private _rows = (localNamespace getVariable ["ADVSEC_treasuryHist", []]) apply {
            _x params ["_d", "_t", "_v"];
            [format ["%1 · %2%3 · %4", _d, ["", "+"] select (_v > 0), _v call _fmt, _t], [], format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Importe: %3", _t call ADVSEC_fnc_repEsc, _d, _v call _fmt], [[1, 0.45, 0.35, 1], [0.45, 1, 0.45, 1]] select (_v > 0), ""]
        };
        reverse _rows;
        ["treasury", format ["<t size='1.1'>Tesorería de la PM: <t font='RobotoCondensedBold'>%1</t></t><br/><t color='#8C8C8C'>Ingresan las multas cobradas%2.</t>", (localNamespace getVariable ["ADVSEC_treasury", 0]) call _fmt, ["", " y las compras"] select ((["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "bonus": {
        _args params [["_u", objNull], ["_v", 0], ["_why", ""]];
        if !([_caller, "treasury"] call ADVSEC_fnc_perm) exitWith {[_caller, "pagar desde la tesorería"] call ADVSEC_fnc_deny};
        _v = [_v] call _amt;
        if (isNull _u || {getPlayerUID _u isEqualTo ""} || {_v <= 0}) exitWith {"Datos no válidos." call _say};
        if ((localNamespace getVariable ["ADVSEC_treasury", 0]) < _v) exitWith {"La tesorería no tiene fondos suficientes." call _say};
        _why = (_why select [0, 120]);
        if (_why isEqualTo "") then {_why = "Prima"};
        [-_v, format ["%1 · %2 (autoriza %3)", _why, name _u, name _caller]] call ADVSEC_fnc_ecoTreasury;
        private _b = [getPlayerUID _u, name _u] call ADVSEC_fnc_ecoAcc;
        _b set [1, (_b select 1) + _v];
        _u setVariable ["ADVSEC_bank", _b select 1, true];
        [_b, format ["%1 (tesorería PM)", _why], _v] call ADVSEC_fnc_ecoHist;
        (format ["Has recibido %1 de la tesorería: %2.", _v call _fmt, _why]) remoteExecCall ["hint", _u];
        ["economy", _caller, ["bonus", getPlayerUID _u, _v, _why]] call ADVSEC_fnc_logEvent;
        ["treasury", _caller] call ADVSEC_fnc_ecoServer;
    };
};
