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
        if !([_caller, "fine"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_issue_a_fine" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _amount = round (_amount max 1);
        if (_reason isEqualTo "") then {_reason = ("STR_ADVSEC_unspecified" call ADVSEC_fnc_L)};
        private _id = [_unit, _amount, _reason, name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
        (format [("STR_ADVSEC_fine_issued_to" call ADVSEC_fnc_L), _id, name _unit, _amount, _cur]) call _say;
    };
    case "radar": {
        // Multa directa por radar: el servidor vuelve a medir la velocidad
        _args params [["_veh", objNull]];
        if !([_caller, "radar"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_use_the_speed_gun" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (isNull _veh || {(_caller distance _veh) > 400}) exitWith {};
        private _drv = driver _veh;
        private _s = round abs speed _veh;
        private _lim = ["speedLimit", 90] call ADVSEC_fnc_setting;
        if (isNull _drv || {!isPlayer _drv}) exitWith {("STR_ADVSEC_there_is_no_identifiable_driver" call ADVSEC_fnc_L) call _say};
        if (_s <= _lim) exitWith {(format [("STR_ADVSEC_already_driving_at_km_h" call ADVSEC_fnc_L), _s]) call _say};
        private _amt = (["speedFineBase", 100] call ADVSEC_fnc_setting) + (_s - _lim) * (["speedFinePerKmh", 5] call ADVSEC_fnc_setting);
        private _id = [_drv, _amt, format [("STR_ADVSEC_speeding_km_h_limit" call ADVSEC_fnc_L), _s, _lim, getPlateNumber _veh], name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
        ["radarFine", _caller, [name _drv, _s, _amt]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_speed_camera_fine_to" call ADVSEC_fnc_L), _id, name _drv, _amt, _cur]) call _say;
    };
    case "list": {
        _args params [["_key", ""]];
        private _own = _key isEqualTo ([_caller] call ADVSEC_fnc_docKey);
        if (!_own && {!([_caller, "query"] call ADVSEC_fnc_perm)}) exitWith {[_caller, ("STR_ADVSEC_view_other_people_s_fines" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _l = _db getOrDefault [_key, []];
        private _due = 0;
        private _rows = _l apply {
            _x params ["_id", "_date", "_amt", "_reason", "_by", "", "_state", "_name", "_note"];
            private _stL = _state call ADVSEC_fnc_Lv;
            if (_state == "Pendiente") then {_due = _due + _amt};
            [format ["%1 · %2 %3 · %4", _id, _amt, _cur, _stL], [_key, _id],
                format [("STR_ADVSEC_fine_date_fined_amount_reason" call ADVSEC_fnc_L),
                    _id, _date, [_name] call ADVSEC_fnc_repEsc, _amt, _cur, [_reason] call ADVSEC_fnc_repEsc, [_by] call ADVSEC_fnc_repEsc, _stL, ["", ("STR_ADVSEC_note" call ADVSEC_fnc_L) + ([_note] call ADVSEC_fnc_repEsc)] select (_note isNotEqualTo "")],
                switch (_state) do {case "Pendiente": {[1, 0.6, 0.2, 1]}; case "Anulada": {[0.55, 0.55, 0.55, 1]}; default {[]}},
                ADVSEC_icDoc]
        };
        reverse _rows;
        ["fines", format [("STR_ADVSEC_registered_fines_pending_payment" call ADVSEC_fnc_L), count _l, _due, _cur], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "pay": {
        _args params ["_id"];
        private _key = [_caller] call ADVSEC_fnc_docKey;
        private _f = [_key, _id] call _find;
        if (_f isEqualTo [] || {(_f select 6) != "Pendiente"}) exitWith {("STR_ADVSEC_that_fine_is_not_pending" call ADVSEC_fnc_L) call _say};
        if ([] call ADVSEC_fnc_ecoOn) then {
            if !([_caller, _f select 2, format [("STR_ADVSEC_fine_4" call ADVSEC_fnc_L), _id], (["fineToTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {
                (format [("STR_ADVSEC_insufficient_funds_the_fine_is" call ADVSEC_fnc_L), _f select 2, _cur]) call _say;
                _f = [];
            };
        } else {
            private _var = ["moneyVar", ""] call ADVSEC_fnc_setting;
            if (_var isEqualTo "") exitWith {("STR_ADVSEC_payment_is_made_before_an" call ADVSEC_fnc_L) call _say; _f = []};
            private _cash = _caller getVariable [_var, 0];
            if (!(_cash isEqualType 0) || {_cash < (_f select 2)}) exitWith {(format [("STR_ADVSEC_insufficient_funds" call ADVSEC_fnc_L), _cash, _cur]) call _say; _f = []};
            _caller setVariable [_var, _cash - (_f select 2), true];
        };
        if (_f isEqualTo []) exitWith {};
        _f set [6, "Pagada"];
        _f set [8, format [("STR_ADVSEC_paid_by_the_fined_person" call ADVSEC_fnc_L), call ADVSEC_fnc_now]];
        ["fines"] call ADVSEC_fnc_dbDirty;
        ["finePaid", _caller, [_id, _f select 2]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_fine_paid" call ADVSEC_fnc_L), _id]) call _say;
        ["list", _caller, [_key]] call ADVSEC_fnc_fineServer;
    };
    case "markPaid";
    case "cancel": {
        _args params ["_key", "_id", ["_note", ""]];
        private _cancel = _action == "cancel";
        if !([_caller, ["fine", "fineCancel"] select _cancel] call ADVSEC_fnc_perm) exitWith {("STR_ADVSEC_your_rank_does_not_allow_2" call ADVSEC_fnc_L) call _say};
        private _f = [_key, _id] call _find;
        if (_f isEqualTo [] || {(_f select 6) != "Pendiente"}) exitWith {("STR_ADVSEC_that_fine_is_not_pending" call ADVSEC_fnc_L) call _say};
        // Con economía, «Marcar pagada» cobra al sancionado (efectivo y banco) si está conectado
        if (!_cancel && {[] call ADVSEC_fnc_ecoOn}) then {
            private _u = allPlayers param [allPlayers findIf {getPlayerUID _x isEqualTo _key}, objNull];
            if (isNull _u) exitWith {("STR_ADVSEC_the_fined_person_is_not" call ADVSEC_fnc_L) call _say; _f = []};
            if !([_u, _f select 2, format [("STR_ADVSEC_fine_collected_by" call ADVSEC_fnc_L), _id, name _caller], (["fineToTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {
                (format [("STR_ADVSEC_has_no_funds_to_pay" call ADVSEC_fnc_L), name _u, _f select 2, _cur]) call _say; _f = [];
            };
        };
        if (_f isEqualTo []) exitWith {};
        _f set [6, ["Pagada", "Anulada"] select _cancel];
        _f set [8, format [("STR_ADVSEC_by_on" call ADVSEC_fnc_L), [("STR_ADVSEC_collected" call ADVSEC_fnc_L), "Anulada"] select _cancel, name _caller, call ADVSEC_fnc_now, ["", ". " + _note] select (_note isNotEqualTo "")]];
        if (_cancel && {(_f select 5) isNotEqualTo getPlayerUID _caller}) then {[_caller, "fineCancelled", _id] call ADVSEC_fnc_heatAdd};
        ["fines"] call ADVSEC_fnc_dbDirty;
        [["fineCollected", "fineCancel"] select _cancel, _caller, [_id, _key]] call ADVSEC_fnc_logEvent;
        ["list", _caller, [_key]] call ADVSEC_fnc_fineServer;
    };
};
