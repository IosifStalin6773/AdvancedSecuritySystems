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
private _pm = (allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PM"] call ADVSEC_fnc_repAccess}};
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
        if (_text isEqualTo "") then {_text = "Sin detalles"};
        private _last = _caller getVariable ["ADVSEC_dspLast", -1e6];
        if (serverTime - _last < (["callCooldown", 60] call ADVSEC_fnc_setting)) exitWith {"Espera antes de volver a llamar al 112." call _say};
        _caller setVariable ["ADVSEC_dspLast", serverTime];
        private _id = ["call", _text] call _new;
        private _to = if (_onDuty isNotEqualTo []) then {[([_onDuty, [], {_x distance _caller}, "ASCEND"] call BIS_fnc_sortBy) select 0]} else {_pm};
        [_id, format ["112 · %1", name _caller], _text, getPosATL _caller, false] remoteExecCall ["ADVSEC_fnc_dspNotify", _to];
        (format ["Llamada %1 registrada. %2", _id, ["No hay patrullas disponibles ahora mismo.", "Aviso enviado a la patrulla más cercana."] select (_to isNotEqualTo [])]) call _say;
        ["call112", _caller, [_id, _text]] call ADVSEC_fnc_logEvent;
    };
    case "panic": {
        if !([_caller, "PM"] call ADVSEC_fnc_repAccess) exitWith {};
        private _id = ["panic", "AGENTE EN PELIGRO"] call _new;
        [_id, format ["PÁNICO · %1", name _caller], format ["%1 necesita apoyo inmediato en %2.", name _caller, mapGridPosition _caller], getPosATL _caller, true] remoteExecCall ["ADVSEC_fnc_dspNotify", _pm];
        "Botón de pánico activado: toda la PM ha recibido tu posición." call _say;
        ["panic", _caller, [_id, mapGridPosition _caller]] call ADVSEC_fnc_logEvent;
    };
    case "accept";
    case "close": {
        if !([_caller, "dispatch"] call ADVSEC_fnc_perm) exitWith {[_caller, "atender avisos de la central"] call ADVSEC_fnc_deny};
        _args params [["_id", ""]];
        private _c = _calls getOrDefault [_id, []];
        if (_c isEqualTo []) exitWith {};
        if (_action == "accept") then {
            _c set [6, "En camino"];
            _c set [7, name _caller];
            private _u = [_c select 1] call ADVSEC_fnc_uidUnit;
            if (!isNull _u) then {(format ["Central: %1 va en camino (aviso %2).", name _caller, _id]) remoteExecCall ["hint", _u]};
            [_id, _c select 3] remoteExecCall ["ADVSEC_fnc_dspMark", _caller];
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
            _rows pushBack [format ["%1 · %2 · %3 · %4", _x, _name, mapGridPosition _pos, _state], _x,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1 · %2</t><br/>%3<br/>Cuadrícula: %4<br/>Hora: %5<br/>Estado: %6%7", ["Llamada 112", "PÁNICO"] select (_kind == "panic"), _x, _text call ADVSEC_fnc_repEsc, mapGridPosition _pos, _date, _state, ["", " (" + _who + ")"] select (_who isNotEqualTo "")],
                switch (true) do {case (_state == "Cerrado"): {[0.55, 0.55, 0.55, 1]}; case (_kind == "panic"): {[1, 0.3, 0.3, 1]}; case (_state == "Pendiente"): {[1, 0.75, 0.3, 1]}; default {[]}}, ""];
        } forEach _calls;
        reverse _rows;
        ["dispatch", format ["Avisos activos: %1 · Agentes de servicio: %2 / %3 PM conectados", {(_x select 6) != "Cerrado"} count (values _calls), count _onDuty, count _pm], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
