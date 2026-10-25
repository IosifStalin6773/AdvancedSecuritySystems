/*
    [acción, llamador, args] (servidor) — corrupción y AA.II.
    "bribe" [agente, importe] (ofrecer) · "bribeAccept" [sobornador, importe] (el agente acepta)
    "flags" · "audit" [SteamID] · "freeze" [SteamID] (alternar)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _db = [] call ADVSEC_fnc_ecoDB;
switch (_action) do {
    case "bribe": {
        _args params [["_ag", objNull], ["_v", 0]];
        _v = round ((_v max 0) min 1000000);
        if (isNull _ag || {_ag isEqualTo _caller} || {(_ag distance _caller) > 6} || {_v <= 0}) exitWith {"Tienes que estar junto al agente." call _say};
        if (([_caller] call ADVSEC_fnc_ecoCash) < _v) exitWith {"No llevas tanto efectivo." call _say};
        _caller setVariable ["ADVSEC_bribeOffer", [_ag, _v, serverTime]];
        [_caller, _v] remoteExecCall ["ADVSEC_fnc_bribeAsk", _ag];
        "Ofreces el dinero discretamente..." call _say;
    };
    case "bribeAccept": {
        _args params [["_b", objNull], ["_v", 0]];
        if (isNull _b) exitWith {};
        (_b getVariable ["ADVSEC_bribeOffer", [objNull, 0, -1e6]]) params ["_ag", "_offer", "_t"];
        if !(_ag isEqualTo _caller && {_offer == _v} && {serverTime - _t < 90} && {(_b distance _caller) < 8}) exitWith {"La oferta ya no es válida." call _say};
        _b setVariable ["ADVSEC_bribeOffer", nil];
        private _cash = [_b] call ADVSEC_fnc_ecoCash;
        if (_cash < _v) exitWith {"Ya no tiene ese dinero." call _say};
        [_b, _cash - _v] call ADVSEC_fnc_ecoSetCash;
        [_caller, ([_caller] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [[getPlayerUID _b, name _b] call ADVSEC_fnc_ecoAcc, format ["Efectivo entregado a %1", name _caller], -_v] call ADVSEC_fnc_ecoHist;
        [[getPlayerUID _caller, name _caller] call ADVSEC_fnc_ecoAcc, format ["Efectivo recibido de %1", name _b], _v] call ADVSEC_fnc_ecoHist;
        [[getPlayerUID _b, name _b], [getPlayerUID _caller, name _caller], _v, "Soborno", true] call ADVSEC_fnc_ecoFlag;
        ["bribe", _caller, [name _b, getPlayerUID _b, _v]] call ADVSEC_fnc_logEvent;
        (format ["%1 acepta el dinero.", name _caller]) remoteExecCall ["hint", _b];
        (format ["Aceptas %1 %2.", _v, _cur]) call _say;
    };
    case "flags": {
        if !([_caller, "bankAudit"] call ADVSEC_fnc_perm) exitWith {[_caller, "auditar cuentas"] call ADVSEC_fnc_deny};
        private _rows = (localNamespace getVariable ["ADVSEC_ecoFlags", []]) apply {
            _x params ["_d", "_fu", "_fn", "_tu", "_tn", "_a", "_k"];
            [format ["%1 · %2 · %3 → %4 · %5 %6", _d, _k, _fn, _tn, _a, _cur], [_fu, _tu],
                format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>De: %3 [%4]<br/>A: %5 [%6]<br/>Importe: %7 %8<br/><t color='#8C8C8C'>«Auditar» abre la cuenta del que paga; «Congelar» la bloquea.</t>", _k, _d, _fn call ADVSEC_fnc_repEsc, _fu, _tn call ADVSEC_fnc_repEsc, _tu, _a, _cur], [[1, 0.75, 0.3, 1], [1, 0.4, 0.3, 1]] select (_k == "Soborno"), ""]
        };
        reverse _rows;
        ["flags", format ["Movimientos sospechosos: %1 (agentes implicados o importes ≥ %2 %3)", count _rows, ["suspiciousAmount", 2000] call ADVSEC_fnc_setting, _cur], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "audit": {
        if !([_caller, "bankAudit"] call ADVSEC_fnc_perm) exitWith {[_caller, "auditar cuentas"] call ADVSEC_fnc_deny};
        _args params [["_uid", ""]];
        private _a = _db getOrDefault [_uid, []];
        if (_a isEqualTo []) exitWith {"Esa cuenta no existe." call _say};
        private _rows = (_a select 3) apply {[format ["%1 · %2 · %3", _x select 0, _x select 1, _x select 2], _uid, format ["%1<br/>%2<br/>%3 %4", _x select 0, (_x select 1) call ADVSEC_fnc_repEsc, _x select 2, _cur], [[1, 0.45, 0.35, 1], [0.45, 1, 0.45, 1]] select ((_x select 2) > 0), ""]};
        reverse _rows;
        ["bankAudit", _caller, [_uid]] call ADVSEC_fnc_logEvent;
        ["flags", format ["<t font='RobotoCondensedBold'>AUDITORÍA · %1</t> [%2]<br/>Efectivo %3 · Banco %4 %5 · %6", (_a select 2) call ADVSEC_fnc_repEsc, _uid, _a select 0, _a select 1, _cur, ["Cuenta activa", "<t color='#FF4D4D'>CUENTA CONGELADA</t>"] select (_a param [4, false])], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "freeze": {
        if !([_caller, "bankFreeze"] call ADVSEC_fnc_perm) exitWith {[_caller, "congelar cuentas"] call ADVSEC_fnc_deny};
        _args params [["_uid", ""]];
        private _a = _db getOrDefault [_uid, []];
        if (_a isEqualTo []) exitWith {};
        private _f = !(_a param [4, false]);
        _a set [4, _f];
        ["eco"] call ADVSEC_fnc_dbDirty;
        [["bankUnfreeze", "bankFreeze"] select _f, _caller, [_uid, _a select 2]] call ADVSEC_fnc_logEvent;
        private _u = [_uid] call ADVSEC_fnc_uidUnit;
        if (!isNull _u) then {(["Tu cuenta bancaria ha sido descongelada.", "AA.II. ha CONGELADO tu cuenta bancaria."] select _f) remoteExecCall ["hint", _u]};
        (format ["Cuenta de %1 %2.", _a select 2, ["descongelada", "congelada"] select _f]) call _say;
    };
};
