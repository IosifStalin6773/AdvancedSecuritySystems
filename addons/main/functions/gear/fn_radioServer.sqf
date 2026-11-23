/*
    [acción, llamador, args] (servidor, 1.24) — radio de la PM
    "send" [red, código o texto]: red PM · PMC · CMD (mandos con permiso supervisor). También lo oyen quienes estén
          a menos de 15 m de un vehículo con alguien de la red dentro (altavoz del vehículo).
    "check" (respuesta a la comprobación de radio) · "loop" (interno: tráfico ambiental y comprobación periódica)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _all = allPlayers - entities "HeadlessClient_F";
private _netOf = {
    params ["_net"];
    switch (_net) do {
        case "CMD": {_all select {[_x, "supervisor"] call ADVSEC_fnc_perm}};
        case "PMC": {_all select {[_x, "PMC"] call ADVSEC_fnc_repAccess}};
        default {_all select {[_x, "PM"] call ADVSEC_fnc_repAccess || {[_x, "PMC"] call ADVSEC_fnc_repAccess}}};
    };
};
private _deliver = {
    params ["_net", "_line"];
    private _to = [_net] call _netOf;
    // Altavoz: jugadores junto a un vehículo ocupado por alguien de la red
    private _veh = (_to select {vehicle _x != _x}) apply {vehicle _x};
    private _near = _all select {private _p = _x; !(_p in _to) && {(_veh findIf {_p distance _x < 15}) >= 0}};
    _line remoteExecCall ["systemChat", _to + _near];
    "FD_CP_Clear_F" remoteExecCall ["playSound", _to];
};
switch (_action) do {
    case "send": {
        _args params [["_net", "PM"], ["_msg", ""]];
        if !(_caller in ([_net] call _netOf)) exitWith {[_caller, ("STR_ADVSEC_radio" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _key = format ["STR_ADVSEC_rc_%1", (_msg splitString "-") joinString ""];
        private _txt = if (_msg in (["radioCodes", []] call ADVSEC_fnc_setting)) then {
            format ["%1 (%2)", _msg, format [_key call ADVSEC_fnc_L, mapGridPosition _caller]]
        } else {_msg select [0, 150]};
        if (_txt isEqualTo "") exitWith {};
        [_net, format [("STR_ADVSEC_radio_line" call ADVSEC_fnc_L), _net, name _caller, _txt]] call _deliver;
        ["radio", _caller, [_net, _txt]] call ADVSEC_fnc_logEvent;
    };
    case "check": {
        private _pend = missionNamespace getVariable ["ADVSEC_radioPend", []];
        if !(getPlayerUID _caller in _pend) exitWith {};
        ADVSEC_radioPend = _pend - [getPlayerUID _caller]; publicVariable "ADVSEC_radioPend";
        ["PM", format [("STR_ADVSEC_radio_line" call ADVSEC_fnc_L), "PM", name _caller, ("STR_ADVSEC_radio_check_ok" call ADVSEC_fnc_L)]] call _deliver;
    };
    case "loop": {
        if (call ADVSEC_fnc_fromClient) exitWith {};
        if (!isNil "ADVSEC_radioLoopH") exitWith {};
        ADVSEC_radioLoopH = [_deliver] spawn {
            params ["_deliver"];
            private _chat = serverTime + 240;
            private _check = serverTime + 60 * (["radioCheckMin", 30] call ADVSEC_fnc_setting);
            while {true} do {
                sleep 10;
                private _duty = (allPlayers - entities "HeadlessClient_F") select {_x getVariable ["ADVSEC_onDuty", false]};
                if ((["radioChatter", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {serverTime > _chat} && {_duty isNotEqualTo []}) then {
                    _chat = serverTime + 180 + random 240;
                    (format [("STR_ADVSEC_radio_amb" call ADVSEC_fnc_L), format ["STR_ADVSEC_rch_%1", 1 + floor random 8] call ADVSEC_fnc_L]) remoteExecCall ["systemChat", _duty];
                };
                private _every = ["radioCheckMin", 30] call ADVSEC_fnc_setting;
                if (_every > 0 && {serverTime > _check} && {_duty isNotEqualTo []}) then {
                    _check = serverTime + 60 * _every;
                    ADVSEC_radioPend = _duty apply {getPlayerUID _x}; publicVariable "ADVSEC_radioPend";
                    ("STR_ADVSEC_radio_check" call ADVSEC_fnc_L) remoteExecCall ["hint", _duty];
                    ["PM", format [("STR_ADVSEC_radio_line" call ADVSEC_fnc_L), "PM", "STR_ADVSEC_radio_central" call ADVSEC_fnc_L, "STR_ADVSEC_radio_check_ask" call ADVSEC_fnc_L]] call _deliver;
                    [_deliver] spawn {
                        params ["_deliver"];
                        sleep 120;
                        private _miss = (missionNamespace getVariable ["ADVSEC_radioPend", []]) apply {[_x] call ADVSEC_fnc_uidUnit} select {!isNull _x};
                        ADVSEC_radioPend = []; publicVariable "ADVSEC_radioPend";
                        if (_miss isEqualTo []) exitWith {};
                        {["radioMiss", _x, []] call ADVSEC_fnc_logEvent} forEach _miss;
                        ["CMD", format [("STR_ADVSEC_radio_line" call ADVSEC_fnc_L), "CMD", "STR_ADVSEC_radio_central" call ADVSEC_fnc_L, format [("STR_ADVSEC_radio_check_miss" call ADVSEC_fnc_L), (_miss apply {name _x}) joinString ", "]]] call _deliver;
                    };
                };
            };
        };
    };
};
