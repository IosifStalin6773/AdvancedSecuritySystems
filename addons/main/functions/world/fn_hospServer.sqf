/*
    [acción, llamador, args] (servidor, 1.24) — hospital y evacuación aérea
    "surgery" [hospital, herido] · "triage" [herido] · "dustoff" (pide un helicóptero a la posición del llamador)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if (call ADVSEC_fnc_fromClient && {!([_caller, "medical"] call ADVSEC_fnc_perm)}) exitWith {[_caller, ("STR_ADVSEC_hosp_surgery" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _heal = {
    params ["_u"];
    _u setDamage 0;
    if (isClass (configFile >> "CfgPatches" >> "ace_medical_treatment") && {!isNil "CBA_fnc_targetEvent"}) then {["ace_medical_treatment_fullHealLocal", [_u], _u] call CBA_fnc_targetEvent};
    [_u, ""] remoteExecCall ["switchMove", 0];
    if (!isPlayer _u) then {_u setUnconscious false};
    _u setVariable ["ADVSEC_triage", nil, true];
};
switch (_action) do {
    case "surgery": {
        _args params [["_h", objNull], ["_u", objNull]];
        if (isNull _h || {isNull _u} || {_u distance _h > 10} || {_caller distance _h > 10}) exitWith {};
        [_u] call _heal;
        (format [("STR_ADVSEC_hosp_done" call ADVSEC_fnc_L), name _u]) remoteExecCall ["hint", _caller];
        ["surgery", _caller, [name _u]] call ADVSEC_fnc_logEvent;
    };
    case "triage": {
        _args params [["_u", objNull]];
        if (isNull _u || {_caller distance _u > 5}) exitWith {};
        private _dmg = damage _u;
        private _down = lifeState _u == "INCAPACITATED" || {_u getVariable ["ACE_isUnconscious", false]};
        private _cat = switch (true) do {
            case (!alive _u): {4};
            case (_down || {_dmg > 0.7}): {3};
            case (_dmg > 0.35): {2};
            case (_dmg > 0.05): {1};
            default {0};
        };
        _u setVariable ["ADVSEC_triage", [_cat, call ADVSEC_fnc_now, name _caller, round (_dmg * 100)], true];
        (format [("STR_ADVSEC_hosp_triage_done" call ADVSEC_fnc_L), name _u, format ["STR_ADVSEC_hosp_cat_%1", _cat] call ADVSEC_fnc_L, round (_dmg * 100), "%"]) remoteExecCall ["hint", _caller];
    };
    case "dustoff": {
        private _hs = (missionNamespace getVariable ["ADVSEC_hospitals", []]) select {!isNull _x};
        if (_hs isEqualTo []) exitWith {("STR_ADVSEC_hosp_none" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        if (!isNil "ADVSEC_dustoffH" && {!scriptDone ADVSEC_dustoffH}) exitWith {("STR_ADVSEC_hosp_busy" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        private _h = ([_hs, [], {_x distance2D _caller}, "ASCEND"] call BIS_fnc_sortBy) select 0;
        private _lz = getPosATL _caller;
        ["dustoff", _caller, [mapGridPosition _lz]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_hosp_dustoff_on" call ADVSEC_fnc_L), mapGridPosition _lz]) remoteExecCall ["hint", _caller];
        ADVSEC_dustoffH = [_h, _lz, _heal] spawn {
            params ["_h", "_lz", "_heal"];
            private _from = _h getPos [300, random 360];
            private _heli = createVehicle [["dustoffHeli", "B_Heli_Transport_01_F"] call ADVSEC_fnc_setting, [_from select 0, _from select 1, 120], [], 0, "FLY"];
            createVehicleCrew _heli;
            private _g = group driver _heli;
            _g setBehaviour "CARELESS";
            private _pad = createVehicle ["Land_HelipadEmpty_F", _lz, [], 0, "CAN_COLLIDE"];
            _heli doMove _lz;
            private _t = time;
            waitUntil {sleep 2; (_heli distance2D _lz < 150) || {!alive _heli} || {time - _t > 300}};
            if (!alive _heli) exitWith {deleteVehicle _pad};
            _heli land "GET IN";
            waitUntil {sleep 2; ((getPosATL _heli) select 2) < 2 || {!alive _heli} || {time - _t > 420}};
            // En tierra 60 s: sube a los heridos IA cercanos; los jugadores pueden subir por su cuenta
            private _wait = time + 60;
            private _loaded = [];
            while {time < _wait && {alive _heli}} do {
                {
                    if (!isPlayer _x && {alive _x} && {!(_x in _loaded)} && {(damage _x > 0.3 || {lifeState _x == "INCAPACITATED"} || {!isNil {_x getVariable "ADVSEC_triage"}})} && {!(_x in crew _heli)}) then {
                        _x moveInCargo _heli;
                        _loaded pushBack _x;
                    };
                } forEach (_heli nearEntities ["CAManBase", 40]);
                sleep 3;
            };
            deleteVehicle _pad;
            if (!alive _heli) exitWith {};
            private _pad2 = createVehicle ["Land_HelipadEmpty_F", _h getPos [25, random 360], [], 0, "NONE"];
            _heli doMove getPosATL _pad2;
            waitUntil {sleep 2; (_heli distance2D _pad2 < 120) || {!alive _heli}};
            _heli land "LAND";
            waitUntil {sleep 2; ((getPosATL _heli) select 2) < 2 || {!alive _heli}};
            sleep 5;
            {
                if (!isPlayer _x) then {moveOut _x; [_x] call _heal; _x setPosATL (_h getPos [6 + random 4, random 360])};
            } forEach (_loaded select {alive _x});
            sleep 20;
            if ((crew _heli) findIf {isPlayer _x} < 0) then {{deleteVehicle _x} forEach crew _heli; deleteVehicle _heli};
            deleteVehicle _pad2;
        };
    };
};
