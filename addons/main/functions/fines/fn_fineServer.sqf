/*
    [acción, llamador, args] (servidor)
    "issue" [unidad, importe, motivo] · "list" [clave] · "pay" [id] · "markPaid" [clave, id] · "cancel" [clave, id, nota]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
private _db = [] call ADVSEC_fnc_fineDB;
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _find = {
    params ["_key", "_id"];
    private _l = _db getOrDefault [_key, []];
    _l param [_l findIf {(_x select 0) isEqualTo _id}, []]
};
switch (_action) do {
    case "issue": {
        _args params ["_unit", ["_amount", 0], ["_reason", ""]];
        if (isNull _unit || {(_caller distance _unit) > 15}) exitWith {};
        if !([_caller, "fine"] call ADVSEC_fnc_perm) exitWith {[_caller, "imponer una multa"] call ADVSEC_fnc_deny};
        _amount = round (_amount max 1);
        if (_reason isEqualTo "") then {_reason = "Sin especificar"};
        private _id = [_unit, _amount, _reason, name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
        (format ["Multa %1 impuesta a %2: %3 %4.", _id, name _unit, _amount, _cur]) call _say;
    };
    case "list": {
        _args params [["_key", ""]];
        private _own = _key isEqualTo ([_caller] call ADVSEC_fnc_docKey);
        if (!_own && {!([_caller, "query"] call ADVSEC_fnc_perm)}) exitWith {[_caller, "consultar multas ajenas"] call ADVSEC_fnc_deny};
        private _l = _db getOrDefault [_key, []];
        private _due = 0;
        private _rows = _l apply {
            _x params ["_id", "_date", "_amt", "_reason", "_by", "", "_state", "_name", "_note"];
            if (_state == "Pendiente") then {_due = _due + _amt};
            [format ["%1 · %2 %3 · %4", _id, _amt, _cur, _state], [_key, _id],
                format ["<t size='1.2' font='RobotoCondensedBold'>Multa %1</t><br/>Fecha: %2<br/>Sancionado: %3<br/>Importe: %4 %5<br/>Motivo: %6<br/>Agente: %7<br/>Estado: %8%9",
                    _id, _date, [_name] call ADVSEC_fnc_repEsc, _amt, _cur, [_reason] call ADVSEC_fnc_repEsc, [_by] call ADVSEC_fnc_repEsc, _state, ["", "<br/>Nota: " + ([_note] call ADVSEC_fnc_repEsc)] select (_note isNotEqualTo "")],
                switch (_state) do {case "Pendiente": {[1, 0.6, 0.2, 1]}; case "Anulada": {[0.55, 0.55, 0.55, 1]}; default {[]}},
                ADVSEC_icDoc]
        };
        reverse _rows;
        ["fines", format ["Multas registradas: %1 · pendiente de pago: <t color='#FF8040'>%2 %3</t>", count _l, _due, _cur], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "pay": {
        _args params ["_id"];
        private _key = [_caller] call ADVSEC_fnc_docKey;
        private _f = [_key, _id] call _find;
        if (_f isEqualTo [] || {(_f select 6) != "Pendiente"}) exitWith {"Esa multa no está pendiente." call _say};
        if ([] call ADVSEC_fnc_ecoOn) then {
            if !([_caller, _f select 2, format ["Multa %1", _id], (["fineToTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {
                (format ["Fondos insuficientes: la multa es de %1 %2 (efectivo + banco).", _f select 2, _cur]) call _say;
                _f = [];
            };
        } else {
            private _var = ["moneyVar", ""] call ADVSEC_fnc_setting;
            if (_var isEqualTo "") exitWith {"El pago se hace ante un agente: pídele que la marque como pagada." call _say; _f = []};
            private _cash = _caller getVariable [_var, 0];
            if (!(_cash isEqualType 0) || {_cash < (_f select 2)}) exitWith {(format ["Fondos insuficientes (%1 %2).", _cash, _cur]) call _say; _f = []};
            _caller setVariable [_var, _cash - (_f select 2), true];
        };
        if (_f isEqualTo []) exitWith {};
        _f set [6, "Pagada"];
        _f set [8, format ["Pagada por el sancionado el %1", call ADVSEC_fnc_now]];
        ["fines"] call ADVSEC_fnc_dbDirty;
        ["finePaid", _caller, [_id, _f select 2]] call ADVSEC_fnc_logEvent;
        (format ["Multa %1 pagada.", _id]) call _say;
        ["list", _caller, [_key]] call ADVSEC_fnc_fineServer;
    };
    case "markPaid";
    case "cancel": {
        _args params ["_key", "_id", ["_note", ""]];
        private _cancel = _action == "cancel";
        if !([_caller, ["fine", "fineCancel"] select _cancel] call ADVSEC_fnc_perm) exitWith {"Tu rango no lo permite." call _say};
        private _f = [_key, _id] call _find;
        if (_f isEqualTo [] || {(_f select 6) != "Pendiente"}) exitWith {"Esa multa no está pendiente." call _say};
        // Con economía, «Marcar pagada» cobra al sancionado (efectivo y banco) si está conectado
        if (!_cancel && {[] call ADVSEC_fnc_ecoOn}) then {
            private _u = allPlayers param [allPlayers findIf {getPlayerUID _x isEqualTo _key}, objNull];
            if (isNull _u) exitWith {"El sancionado no está conectado: no se le puede cobrar." call _say; _f = []};
            if !([_u, _f select 2, format ["Multa %1 (cobrada por %2)", _id, name _caller], (["fineToTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {
                (format ["%1 no tiene fondos para pagar %2 %3.", name _u, _f select 2, _cur]) call _say; _f = [];
            };
        };
        if (_f isEqualTo []) exitWith {};
        _f set [6, ["Pagada", "Anulada"] select _cancel];
        _f set [8, format ["%1 por %2 el %3%4", ["Cobrada", "Anulada"] select _cancel, name _caller, call ADVSEC_fnc_now, ["", ". " + _note] select (_note isNotEqualTo "")]];
        if (_cancel && {(_f select 5) isNotEqualTo getPlayerUID _caller}) then {[_caller, "fineCancelled", _id] call ADVSEC_fnc_heatAdd};
        ["fines"] call ADVSEC_fnc_dbDirty;
        [["fineCollected", "fineCancel"] select _cancel, _caller, [_id, _key]] call ADVSEC_fnc_logEvent;
        ["list", _caller, [_key]] call ADVSEC_fnc_fineServer;
    };
};
