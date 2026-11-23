/*
    [acción, llamador, args] (servidor, 1.24) — sirenas de la base
    "alarm" [cerca de]: activa o apaga la alarma de base (las sirenas a menos de 2 km; si no hay ninguna, todas)
    "curfew" [inicio (bool)]: hace sonar el toque de queda en las sirenas y en las ciudades cercanas
    "loop": vigila la hora del toque de queda (curfewStart / curfewEnd)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (isNil "ADVSEC_sirens") then {ADVSEC_sirens = []};
ADVSEC_sirens = ADVSEC_sirens select {!isNull _x};
private _snd = ["sirenSound", "A3\Sounds_F\sfx\alarm_independent.wss"] call ADVSEC_fnc_setting;
private _staff = (allPlayers - entities "HeadlessClient_F") select {[_x, "PMC"] call ADVSEC_fnc_repAccess};
switch (_action) do {
    case "alarm": {
        if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
        if (call ADVSEC_fnc_fromClient && {!([_caller, "baseAlarm"] call ADVSEC_fnc_perm)}) exitWith {[_caller, ("STR_ADVSEC_siren_alarm" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _near = _args param [0, _caller];
        private _set = ADVSEC_sirens select {_x distance2D _near < 2000};
        if (_set isEqualTo []) then {_set = +ADVSEC_sirens};
        if (_set isEqualTo []) exitWith {("STR_ADVSEC_siren_none" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        private _on = !((_set select 0) getVariable ["ADVSEC_sirenOn", false]);
        {_x setVariable ["ADVSEC_sirenOn", _on, true]} forEach _set;
        (format [(["STR_ADVSEC_siren_off", "STR_ADVSEC_siren_on"] select _on) call ADVSEC_fnc_L, name _caller, mapGridPosition (_set select 0)]) remoteExecCall ["systemChat", 0];
        ["baseAlarm", _caller, [_on, mapGridPosition (_set select 0)]] call ADVSEC_fnc_logEvent;
        if (_on) then {
            {
                [_x, _snd] spawn {
                    params ["_s", "_snd"];
                    while {!isNull _s && {_s getVariable ["ADVSEC_sirenOn", false]}} do {
                        playSound3D [_snd, _s, false, getPosASL _s, 5, 1, 1200];
                        sleep 2.5;
                    };
                };
            } forEach _set;
        };
    };
    case "curfew": {
        // A mano desde el menú: solo con permiso de alarma de base
        if (call ADVSEC_fnc_fromClient && {!([_caller] call ADVSEC_fnc_srvCaller) || {!([_caller, "baseAlarm"] call ADVSEC_fnc_perm)}}) exitWith {};
        _args params [["_start", true]];
        // Fuentes: cada sirena y las ciudades más cercanas a ella (sin sirenas: el centro del mapa)
        private _centers = ADVSEC_sirens apply {getPosATL _x};
        if (_centers isEqualTo []) then {_centers = [[worldSize / 2, worldSize / 2, 0]]};
        private _spots = [];
        {
            _spots pushBack _x;
            {_spots pushBackUnique locationPosition _x} forEach ((nearestLocations [_x, ["NameCity", "NameCityCapital", "NameVillage"], ["curfewTownRadius", 4000] call ADVSEC_fnc_setting]) select [0, ["curfewTowns", 3] call ADVSEC_fnc_setting]);
        } forEach _centers;
        [_spots, _snd, _start] spawn {
            params ["_spots", "_snd", "_start"];
            for "_i" from 1 to ([3, 8] select _start) do {
                {
                    private _p = +_x;
                    _p set [2, 15];
                    playSound3D [_snd, objNull, false, AGLToASL _p, 5, 0.6, 2000];
                } forEach _spots;
                sleep 2.5;
            };
        };
        private _msg = (["STR_ADVSEC_curfew_end", "STR_ADVSEC_curfew_start"] select _start) call ADVSEC_fnc_L;
        _msg remoteExecCall ["systemChat", 0];
        if (_staff isNotEqualTo []) then {_msg remoteExecCall ["hint", _staff]};
        missionNamespace setVariable ["ADVSEC_curfew", _start, true];
        ["curfew", _caller, [_start]] call ADVSEC_fnc_logEvent;
    };
    case "loop": {
        if (call ADVSEC_fnc_fromClient) exitWith {};
        private _in = {
            private _s = ["curfewStart", -1] call ADVSEC_fnc_setting;
            private _e = ["curfewEnd", 5] call ADVSEC_fnc_setting;
            if (_s < 0) exitWith {false};
            [dayTime >= _s && {dayTime < _e}, dayTime >= _s || {dayTime < _e}] select (_s > _e)
        };
        sleep 30;
        private _was = call _in;
        missionNamespace setVariable ["ADVSEC_curfew", _was, true];
        while {true} do {
            sleep 20;
            private _now = call _in;
            if (_now isNotEqualTo _was) then {["curfew", objNull, [_now]] call ADVSEC_fnc_sirenServer};
            _was = _now;
        };
    };
};
