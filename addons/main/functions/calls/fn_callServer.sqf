/*
    [acción, llamador, args] (servidor, 1.24) — motor de avisos generados por IA
    "start" (interno): programador, comprobación cada 5 s y tensión social
    "launch" [tipo, posición] (Zeus o permiso callLaunch) · "cancel" [id] · "list" (panel de la PM)
    Avisos activos: missionNamespace ADVSEC_aiCalls (id -> hashmap de fn_callSpawn + "dsp")
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if (isNil "ADVSEC_aiCalls") then {ADVSEC_aiCalls = createHashMap};
private _types = ["awol", "speeding", "blackmarket", "apo", "boq", "sapper", "convoy", "ambush", "transfer", "accident", "raid", "barricade",
    "pow", "refugees", "asp", "port", "perimeter", "hospguard", "amnesty", "trophy", "follow", "wake", "mortar", "press", "down", "tire", "server"];
private _events = ["mortar", "press", "tire", "server"];
private _pmAll = {(allPlayers - entities "HeadlessClient_F") select {[_x, "PMC"] call ADVSEC_fnc_repAccess}};
private _create = {
    params ["_type", ["_pos", []], ["_by", objNull]];
    private _e = [_type, _pos] call ADVSEC_fnc_callSpawn;
    if (isNil "_e") exitWith {""};
    private _n = (missionNamespace getVariable ["ADVSEC_aiSeq", 0]) + 1;
    ADVSEC_aiSeq = _n;
    private _id = format ["IA-%1", _n];
    private _p = _e get "pos";
    private _title = format ["STR_ADVSEC_call_t_%1", _type] call ADVSEC_fnc_L;
    private _desc = format [format ["STR_ADVSEC_call_d_%1", _type] call ADVSEC_fnc_L, mapGridPosition _p];
    if (_type in _events) then {
        // Los eventos no van a la central: aviso directo a la PM
        (format ["%1: %2", _title, _desc]) remoteExecCall ["systemChat", call _pmAll];
        _e set ["dsp", ""];
    } else {
        // Desde un cliente (Zeus) la central lo acepta porque lo valida antes este servidor
        localNamespace setVariable ["ADVSEC_tipOK", true];
        private _r = ["tip", _by, [_desc, _p, _title]] call ADVSEC_fnc_dspServer;
        if (isNil "_r" || {!(_r isEqualType "")}) then {_r = ""};
        _e set ["dsp", _r];
        localNamespace setVariable ["ADVSEC_tipOK", false];
    };
    _e set ["id", _id];
    ADVSEC_aiCalls set [_id, _e];
    ["aiCall", objNull, [_id, _type, mapGridPosition _p]] call ADVSEC_fnc_logEvent;
    _id
};
private _cleanup = {
    params ["_e"];
    [_e] spawn {
        params ["_e"];
        sleep 60;
        {
            // No borra a los presos, lo que tiene a un jugador cerca (escoltando o registrando) ni vehículos con jugadores dentro
            private _o = _x;
            if (!isNull _o && {(_o getVariable ["ADVSEC_jailUntil", 0]) < serverTime} && {(allPlayers findIf {_x distance _o < 30 || {vehicle _x == _o}}) < 0}) then {
                if (!(_o isKindOf "CAManBase")) then {{if (!isPlayer _x) then {deleteVehicle _x}} forEach crew _o};
                deleteVehicle _o;
            };
        } forEach ((_e get "units") + (_e get "objs"));
    };
};
private _finish = {
    params ["_id", "_res"];
    private _e = ADVSEC_aiCalls get _id;
    ADVSEC_aiCalls deleteAt _id;
    private _type = _e get "type";
    private _p = _e get "pos";
    private _title = format ["STR_ADVSEC_call_t_%1", _type] call ADVSEC_fnc_L;
    private _dsp = _e getOrDefault ["dsp", ""];
    if (_dsp isNotEqualTo "") then {
        private _c = (localNamespace getVariable ["ADVSEC_dspCalls", createHashMap]) getOrDefault [_dsp, []];
        if (_c isNotEqualTo []) then {_c set [6, "Cerrado"]};
    };
    private _d = _e get "data";
    if (_res == "ok") then {
        [-4, _title] call ADVSEC_fnc_callUnrest;
        // Mérito para los agentes de servicio que estaban cerca (o el que actuó)
        private _who = ((allPlayers - entities "HeadlessClient_F") select {_x getVariable ["ADVSEC_onDuty", false] && {_x distance _p < 300}});
        private _by = _d getOrDefault ["by", objNull];
        if (!isNull _by) then {_who pushBackUnique _by};
        private _m = ["callMerit", 3] call ADVSEC_fnc_setting;
        {["merit", objNull, [getPlayerUID _x, name _x, _m, format [("STR_ADVSEC_call_merit" call ADVSEC_fnc_L), _id, _title]]] call ADVSEC_fnc_carServer} forEach (_who select {getPlayerUID _x != ""});
        private _extra = "";
        if (_type == "accident") then {_extra = format [("STR_ADVSEC_call_fault" call ADVSEC_fnc_L), _d get "fault"]};
        if (_type == "press") then {_extra = "STR_ADVSEC_call_press_good" call ADVSEC_fnc_L; _extra remoteExecCall ["systemChat", 0]};
        (format [("STR_ADVSEC_call_done" call ADVSEC_fnc_L), _id, _title, _extra]) remoteExecCall ["systemChat", call _pmAll];
    } else {
        [8, _title] call ADVSEC_fnc_callUnrest;
        if (_type == "press") then {("STR_ADVSEC_call_press_bad" call ADVSEC_fnc_L) remoteExecCall ["systemChat", 0]};
        (format [("STR_ADVSEC_call_failed" call ADVSEC_fnc_L), _id, _title]) remoteExecCall ["systemChat", call _pmAll];
    };
    ["aiCallEnd", objNull, [_id, _type, _res]] call ADVSEC_fnc_logEvent;
    [_e] call _cleanup;
};
switch (_action) do {
    case "start": {
        if (call ADVSEC_fnc_fromClient) exitWith {};
        if (!isNil "ADVSEC_callLoopH") exitWith {};
        addMissionEventHandler ["EntityKilled", {
            params ["_u", "_k", "_i"];
            if (_u isKindOf "CAManBase" && {getNumber (configOf _u >> "side") == 3} && {isPlayer _i || {isPlayer _k}}) then {
                ADVSEC_civKills = (missionNamespace getVariable ["ADVSEC_civKills", 0]) + 1;
                [5, "STR_ADVSEC_call_civ_killed" call ADVSEC_fnc_L] call ADVSEC_fnc_callUnrest;
            };
        }];
        ADVSEC_callLoopH = [_types, _create, _finish] spawn {
            params ["_types", "_create", "_finish"];
            private _next = serverTime + 300;
            private _decay = serverTime + 600;
            while {true} do {
                sleep 5;
                {
                    private _r = [_y] call ADVSEC_fnc_callCheck;
                    if (_r isNotEqualTo "") then {[_x, _r] call _finish};
                } forEach +ADVSEC_aiCalls;
                if (serverTime > _decay) then {_decay = serverTime + 600; [-1, ""] call ADVSEC_fnc_callUnrest};
                if ((["aiCalls", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {serverTime > _next}) then {
                    private _unrest = missionNamespace getVariable ["ADVSEC_unrest", 0];
                    _next = serverTime + 60 * (["callInterval", 12] call ADVSEC_fnc_setting) * (1 - _unrest / 200) * (0.75 + random 0.5);
                    private _duty = {_x getVariable ["ADVSEC_onDuty", false]} count allPlayers;
                    if (_duty >= (["callMinDuty", 1] call ADVSEC_fnc_setting) && {count ADVSEC_aiCalls < (["callMax", 2] call ADVSEC_fnc_setting)}) then {
                        private _pool = (["callTypes", _types] call ADVSEC_fnc_setting) select {_x in _types};
                        if ((["callSpecial", 0] call ADVSEC_fnc_setting) isNotEqualTo 1) then {_pool = _pool - ["raid", "barricade"]};
                        if (sunOrMoon >= 0.5) then {_pool = _pool - ["sapper", "ambush"]};
                        // Tres intentos por si un tipo no se puede montar en este mapa
                        for "_i" from 1 to 3 do {
                            if (_pool isEqualTo []) exitWith {};
                            private _t = selectRandom _pool;
                            if (([_t] call _create) isNotEqualTo "") exitWith {};
                            _pool = _pool - [_t];
                        };
                    };
                };
            };
        };
    };
    case "launch": {
        if (call ADVSEC_fnc_fromClient && {!([_caller] call ADVSEC_fnc_isZeus) && {!([_caller, "callLaunch"] call ADVSEC_fnc_perm)}}) exitWith {[_caller, ("STR_ADVSEC_call_launch" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_type", ""], ["_pos", []]];
        if !(_type in _types) exitWith {};
        private _id = [_type, _pos, _caller] call _create;
        (["STR_ADVSEC_call_launch_fail", "STR_ADVSEC_call_launch_ok"] select (_id isNotEqualTo "")) call ADVSEC_fnc_L remoteExecCall ["hint", _caller];
        if (_id isNotEqualTo "") then {["aiCallZeus", _caller, [_id, _type]] call ADVSEC_fnc_logEvent};
    };
    case "cancel": {
        if (call ADVSEC_fnc_fromClient && {!([_caller] call ADVSEC_fnc_isZeus) && {!([_caller, "callLaunch"] call ADVSEC_fnc_perm)}}) exitWith {};
        _args params [["_id", ""]];
        private _e = ADVSEC_aiCalls getOrDefault [_id, createHashMap];
        if (count _e == 0) exitWith {};
        ADVSEC_aiCalls deleteAt _id;
        {[_x, "ON"] remoteExecCall ["switchLight", 0]} forEach ((_e get "data") getOrDefault ["lamps", []]);
        [_e] call _cleanup;
        ["list", _caller] call ADVSEC_fnc_callServer;
    };
    case "list": {
        if !([_caller, "PMC"] call ADVSEC_fnc_repAccess) exitWith {};
        private _rows = [];
        {
            private _t = _y get "type";
            private _p = _y get "pos";
            _rows pushBack [format ["%1 · %2 · %3 · %4 min", _x, format ["STR_ADVSEC_call_t_%1", _t] call ADVSEC_fnc_L, mapGridPosition _p, round ((serverTime - (_y get "t0")) / 60)], _x,
                format [format ["STR_ADVSEC_call_d_%1", _t] call ADVSEC_fnc_L, mapGridPosition _p], [], ""];
        } forEach ADVSEC_aiCalls;
        ["aicalls", format [("STR_ADVSEC_call_list_info" call ADVSEC_fnc_L), count ADVSEC_aiCalls, round (missionNamespace getVariable ["ADVSEC_unrest", 0])], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
