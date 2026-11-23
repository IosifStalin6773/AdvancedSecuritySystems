/*
    [acción, llamador, args] (servidor) — comunicaciones de la PDA (1.22)
    "mark" [posición, texto, canal] — marca táctica compartida con las unidades del canal
    "msg" [texto, canal, clave] — mensaje del canal; con clave va cifrado (solo lo leen quienes tienen la clave)
    canal: "PM" (policía militar) o "PMC" (compañía)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _members = {
    params ["_cuerpo"];
    (allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, _cuerpo] call ADVSEC_fnc_repAccess}}
};
switch (_action) do {
    case "mark": {
        _args params [["_pos", [0, 0, 0]], ["_txt", ""], ["_ch", "PM"]];
        if (!([_caller, _ch] call ADVSEC_fnc_repAccess)) exitWith {};
        private _id = format ["advsec_tac_%1", floor serverTime];
        [_id, _pos, _txt select [0, 24]] remoteExecCall ["ADVSEC_fnc_pdaMarkShow", ["PM"] call _members];
        ["tacMark", _caller, [mapGridPosition _pos, _txt]] call ADVSEC_fnc_logEvent;
    };
    case "msg": {
        _args params [["_txt", ""], ["_ch", "PM"], ["_key", ""]];
        if (!([_caller, _ch] call ADVSEC_fnc_repAccess)) exitWith {};
        private _body = _txt select [0, 200];
        // Cifrado simple: cada carácter se desplaza según la clave (solo lo leen quienes tienen la misma clave)
        private _enc = _key isNotEqualTo "";
        if (_enc) then {
            private _k = toArray _key;
            private _codes = toArray _body;
            for "_i" from 0 to (count _codes - 1) do {
                _codes set [_i, (_codes select _i) + ((_k select (_i mod count _k)) % 26)];
            };
            _body = toString _codes;
        };
        private _online = [_ch] call _members;
        [_body, _enc] remoteExecCall ["ADVSEC_fnc_pdaMsgShow", _online];
        // 1.22: cola sin conexión: el mensaje queda guardado (máx. 50) para quien no estaba conectado
        private _q = localNamespace getVariable ["ADVSEC_pdaQueue", []];
        _q pushBack [_ch, _body, _enc, _online apply {getPlayerUID _x}];
        if (count _q > 50) then {_q deleteAt 0};
        localNamespace setVariable ["ADVSEC_pdaQueue", _q];
        ["pdaMsg", _caller, [_ch, _enc]] call ADVSEC_fnc_logEvent;
    };
    case "pull": {
        // 1.22: entrega los mensajes de la cola a quien abre la PDA (si tiene acceso al canal y aún no los recibió)
        private _q = localNamespace getVariable ["ADVSEC_pdaQueue", []];
        private _uid = getPlayerUID _caller;
        {
            _x params ["_ch", "_body", "_enc", "_seen"];
            if (!(_uid in _seen) && {[_caller, _ch] call ADVSEC_fnc_repAccess}) then {
                [_body, _enc] remoteExecCall ["ADVSEC_fnc_pdaMsgShow", _caller];
                _seen pushBack _uid;
            };
        } forEach _q;
    };
    case "clear": {
        // 1.22: borra las marcas tácticas de todo el canal (solo quien tiene acceso al canal)
        _args params [["_ch", "PM"]];
        if (!([_caller, _ch] call ADVSEC_fnc_repAccess)) exitWith {};
        ["clear", [0, 0, 0], ""] remoteExecCall ["ADVSEC_fnc_pdaMarkShow", [_ch] call _members];
        ["pdaMarkClear", _caller, [_ch]] call ADVSEC_fnc_logEvent;
    };
};
