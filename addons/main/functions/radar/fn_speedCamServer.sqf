/*
    [acción, llamador, args] (servidor) — radares fijos
    "start" (bucle único) · "set" [radar, valores] · "log" [radar]
*/
params ["_a", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
switch (_a) do {
    case "start": {
        if (!isNil "ADVSEC_speedCamLoop") exitWith {};
        ADVSEC_speedCamLoop = [] spawn {
            private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
            while {true} do {
                {
                    private _cam = _x;
                    (_cam getVariable ["ADVSEC_speedCam", []]) params [["_name", "Radar"], ["_lim", 90], ["_range", 40], ["_base", 100], ["_per", 5], ["_on", false]];
                    if (_on && {alive _cam}) then {
                        {
                            private _veh = _x;
                            private _drv = driver _veh;
                            private _s = round abs speed _veh;
                            private _key = "ADVSEC_sc_" + netId _cam;
                            // Un aviso por vehículo y radar cada minuto; la PM de servicio está exenta (setting speedCamExemptDuty)
                            if (_s > _lim && {!isNull _drv} && {isPlayer _drv} && {time > (_veh getVariable [_key, -1])}
                                && {!(((["speedCamExemptDuty", 1] call ADVSEC_fnc_setting) isEqualTo 1) && {_drv getVariable ["ADVSEC_onDuty", false]})}) then {
                                _veh setVariable [_key, time + 60];
                                private _amt = _base + (_s - _lim) * _per;
                                private _plate = getPlateNumber _veh;
                                [_drv, _amt, format ["Radar %1: %2 km/h (límite %3) · %4", _name, _s, _lim, _plate], "Radar automático " + _name, ""] call ADVSEC_fnc_fineAdd;
                                ["radarFine", _drv, [name _drv, _s, _amt, _name]] call ADVSEC_fnc_logEvent;
                                private _log = _cam getVariable ["ADVSEC_speedCamLog", []];
                                _log pushBack [[dayTime, "HH:MM"] call BIS_fnc_timeToString, _plate, _s, name _drv, _amt, typeOf _veh];
                                _cam setVariable ["ADVSEC_speedCamLog", _log select [((count _log) - 30) max 0]];
                                [_cam] remoteExecCall ["ADVSEC_fnc_speedCamFlash", (allPlayers select {(_x distance _cam) < 400}) - [_drv]];
                                [_cam, format ["<t size='1.3' font='RobotoCondensedBold' color='#FF4D4D'>RADAR %1</t><br/>%2 km/h · límite %3 km/h<br/>Multa: %4 %5", toUpper _name, _s, _lim, _amt, _cur]] remoteExecCall ["ADVSEC_fnc_speedCamFlash", _drv];
                            };
                        } forEach (_cam nearEntities [["LandVehicle"], _range]);
                    };
                } forEach ((missionNamespace getVariable ["ADVSEC_secObjects", []]) select {!isNull _x && {(_x getVariable ["ADVSEC_speedCam", []]) isNotEqualTo []}});
                sleep 0.5;
            };
        };
    };
    case "set": {
        _args params [["_cam", objNull], ["_v", []]];
        if !([_caller, "radar"] call ADVSEC_fnc_perm) exitWith {[_caller, "configurar radares"] call ADVSEC_fnc_deny};
        if (isNull _cam || {(_caller distance _cam) > 10} || {(_cam getVariable ["ADVSEC_speedCam", []]) isEqualTo []}) exitWith {};
        _v params [["_name", "Radar"], ["_lim", ""], ["_range", ""], ["_base", ""], ["_per", ""], ["_on", true]];
        private _num = {params ["_t", "_min", "_max"]; ((round parseNumber _t) max _min) min _max};
        private _cfg = [(_name select [0, 40]), [_lim, 10, 300] call _num, [_range, 10, 200] call _num, [_base, 0, 100000] call _num, [_per, 0, 10000] call _num, _on isEqualTo true];
        if ((_cfg select 0) isEqualTo "") then {_cfg set [0, "Radar"]};
        _cam setVariable ["ADVSEC_speedCam", _cfg, true];
        ["radarConfig", _caller, _cfg] call ADVSEC_fnc_logEvent;
        (format ["Radar «%1»: límite %2 km/h, alcance %3 m, %4.", _cfg select 0, _cfg select 1, _cfg select 2, ["desactivado", "activo"] select (_cfg select 5)]) call _say;
    };
    case "log": {
        _args params [["_cam", objNull]];
        if !([_caller, "radar"] call ADVSEC_fnc_perm) exitWith {[_caller, "ver capturas del radar"] call ADVSEC_fnc_deny};
        if (isNull _cam) exitWith {};
        (_cam getVariable ["ADVSEC_speedCam", []]) params [["_name", "Radar"], ["_lim", 90], ["_range", 40], "", "", ["_on", false]];
        private _rows = (_cam getVariable ["ADVSEC_speedCamLog", []]) apply {
            _x params ["_t", "_plate", "_s", "_who", "_amt", "_cls"];
            [format ["%1 · %2 · %3 km/h", _t, _plate, _s], [], format ["<t font='RobotoCondensedBold'>%1 km/h</t> (límite %2)<br/>Matrícula: %3<br/>Vehículo: %4<br/>Conductor: %5<br/>Multa: %6", _s, _lim, _plate, getText (configFile >> "CfgVehicles" >> _cls >> "displayName"), _who call ADVSEC_fnc_repEsc, _amt], [1, 0.45, 0.35, 1], ADVSEC_icCar]
        };
        reverse _rows;
        ["radarLog", format ["Radar «%1» · límite %2 km/h · alcance %3 m · %4", _name call ADVSEC_fnc_repEsc, _lim, _range, ["<t color='#FF6655'>DESACTIVADO</t>", "<t color='#66FF66'>ACTIVO</t>"] select _on], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
