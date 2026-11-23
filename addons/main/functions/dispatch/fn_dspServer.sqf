/*
    [acción, llamador, args] (servidor) — central de despacho
    "call" [texto] (112, cualquiera) · "panic" (agente) · "accept" [id] · "close" [id] · "list"
    Aviso: a la patrulla de servicio más cercana; si no hay nadie de servicio, a toda la PM.
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _calls = localNamespace getVariable ["ADVSEC_dspCalls", createHashMap];
localNamespace setVariable ["ADVSEC_dspCalls", _calls];
private _pm = (allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PMC"] call ADVSEC_fnc_repAccess}};
private _onDuty = _pm select {_x getVariable ["ADVSEC_onDuty", false]};
private _new = {
    params ["_kind", "_text"];
    private _n = (localNamespace getVariable ["ADVSEC_dspSeq", 0]) + 1;
    localNamespace setVariable ["ADVSEC_dspSeq", _n];
    private _id = format ["%1-%2", ["112", "PAN"] select (_kind == "panic"), _n];
    _calls set [_id, [_kind, getPlayerUID _caller, name _caller, getPosATL _caller, _text, call ADVSEC_fnc_now, "Pendiente", "", serverTime]];
    _id
};
switch (_action) do {
    case "call": {
        _args params [["_text", ""]];
        _text = _text select [0, 200];
        if (_text isEqualTo "") then {_text = ("STR_ADVSEC_no_details" call ADVSEC_fnc_L)};
        private _last = _caller getVariable ["ADVSEC_dspLast", -1e6];
        if (serverTime - _last < (["callCooldown", 60] call ADVSEC_fnc_setting)) exitWith {("STR_ADVSEC_wait_before_calling_112_again" call ADVSEC_fnc_L) call _say};
        _caller setVariable ["ADVSEC_dspLast", serverTime];
        private _id = ["call", _text] call _new;
        private _to = if (_onDuty isNotEqualTo []) then {[([_onDuty, [], {_x distance _caller}, "ASCEND"] call BIS_fnc_sortBy) select 0]} else {_pm};
        [_id, format ["112 · %1", name _caller], _text, getPosATL _caller, false] remoteExecCall ["ADVSEC_fnc_dspNotify", _to];
        (format [("STR_ADVSEC_call_logged" call ADVSEC_fnc_L), _id, [("STR_ADVSEC_no_patrols_available_right_now" call ADVSEC_fnc_L), ("STR_ADVSEC_alert_sent_to_the_nearest" call ADVSEC_fnc_L)] select (_to isNotEqualTo [])]) call _say;
        ["call112", _caller, [_id, _text]] call ADVSEC_fnc_logEvent;
        // Aviso dentro de la zona de un contrato en curso: también a la QRF de la PMC
        if ((values ([] call ADVSEC_fnc_ctrDB)) findIf {(_x get "state") == "En curso" && {(_x get "pos") distance2D _caller <= ((_x get "radius") + 300)}} >= 0) then {["panic", _caller, [_id]] call ADVSEC_fnc_cellServer};
    };
    case "panic": {
        if !([_caller, "PMC"] call ADVSEC_fnc_repAccess) exitWith {};
        private _id = ["panic", ("STR_ADVSEC_officer_in_danger" call ADVSEC_fnc_L)] call _new;
        [_id, format [("STR_ADVSEC_panic" call ADVSEC_fnc_L), name _caller], format [("STR_ADVSEC_needs_immediate_backup_at" call ADVSEC_fnc_L), name _caller, mapGridPosition _caller], getPosATL _caller, true] remoteExecCall ["ADVSEC_fnc_dspNotify", _pm];
        ("STR_ADVSEC_panic_button_activated_the_whole" call ADVSEC_fnc_L) call _say;
        ["panic", _caller, [_id, mapGridPosition _caller]] call ADVSEC_fnc_logEvent;
        ["panic", _caller, [_id]] call ADVSEC_fnc_cellServer;
    };
    case "accept";
    case "close": {
        if !([_caller, "dispatch"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_handle_dispatch_alerts" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_id", ""]];
        private _c = _calls getOrDefault [_id, []];
        if (_c isEqualTo []) exitWith {};
        if (_action == "accept") then {
            _c set [6, "En camino"];
            _c set [7, name _caller];
            private _u = [_c select 1] call ADVSEC_fnc_uidUnit;
            if (!isNull _u) then {(format [("STR_ADVSEC_dispatch_is_on_the_way" call ADVSEC_fnc_L), name _caller, _id]) remoteExecCall ["hint", _u]};
            [_id, _c select 3] remoteExecCall ["ADVSEC_fnc_dspMark", _caller];
            ["accept", _caller, [_id]] call ADVSEC_fnc_cellServer;
        } else {
            _c set [6, "Cerrado"];
        };
        ["dispatch", _caller, [_id, _c select 6]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_dspServer;
    };
    case "list": {
        {if (serverTime - (_y select 8) > 3600 && {(_y select 6) == "Cerrado"}) then {_calls deleteAt _x}} forEach +_calls;
        private _rows = [];
        {
            _y params ["_kind", "", "_name", "_pos", "_text", "_date", "_state", "_who"];
            private _stL = _state call ADVSEC_fnc_Lv;
            _rows pushBack [format ["%1 · %2 · %3 · %4", _x, _name, mapGridPosition _pos, _stL], _x,
                format [("STR_ADVSEC_grid_time_status" call ADVSEC_fnc_L), [("STR_ADVSEC_112_call" call ADVSEC_fnc_L), ("STR_ADVSEC_panic_2" call ADVSEC_fnc_L)] select (_kind == "panic"), _x, _text call ADVSEC_fnc_repEsc, mapGridPosition _pos, _date, _stL, ["", " (" + _who + ")"] select (_who isNotEqualTo "")],
                switch (true) do {case (_state == "Cerrado"): {[0.55, 0.55, 0.55, 1]}; case (_kind == "panic"): {[1, 0.3, 0.3, 1]}; case (_state == "Pendiente"): {[1, 0.75, 0.3, 1]}; default {[]}}, ""];
        } forEach _calls;
        reverse _rows;
        ["dispatch", format [("STR_ADVSEC_active_alerts_officers_on_duty" call ADVSEC_fnc_L), {(_x select 6) != "Cerrado"} count (values _calls), count _onDuty, count _pm], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
