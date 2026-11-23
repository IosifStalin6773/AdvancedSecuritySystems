/*
    [aviso] (servidor, 1.24) -> "" (en curso) · "ok" (resuelto) · "fail" (fallido)
    Se llama cada 5 s desde fn_callServer.
*/
params ["_e"];
private _type = _e get "type";
private _d = _e get "data";
private _units = _e get "units";
private _pos = _e get "pos";
private _age = serverTime - (_e get "t0");
private _over = _age > (_e get "limit");
private _duty = (allPlayers - entities "HeadlessClient_F") select {alive _x && {_x getVariable ["ADVSEC_onDuty", false]}};
private _near = {params ["_p", "_r"]; (_duty findIf {_x distance _p < _r}) >= 0};
private _caught = {params ["_u"]; isNull _u || {!alive _u} || {[_u] call ADVSEC_fnc_isRestrained} || {(_u getVariable ["ADVSEC_jailUntil", 0]) > serverTime}};
private _allDown = {_units findIf {!([_x] call _caught)} < 0};
switch (_type) do {
    case "awol": {
        private _u = _units select 0;
        if (!alive _u) exitWith {"fail"};
        if ([_u] call _caught) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "speeding": {
        private _v = _d get "veh";
        private _u = _units select 0;
        if (isNull _v || {!alive _v}) exitWith {"fail"};
        if ([_u] call _caught || {vehicle _u == _u}) exitWith {"ok"};
        // Si un agente se acerca: o se detiene en el arcén o huye (según tensión)
        if ([_v, 40] call _near && {!(_d getOrDefault ["reacted", false])}) then {
            _d set ["reacted", true];
            if (_d get "flee") then {
                private _g = group _u;
                while {count waypoints _g > 0} do {deleteWaypoint [_g, 0]};
                private _to = _v getPos [2500, random 360];
                _g addWaypoint [_to, 0];
                _g setSpeedMode "FULL";
                _d set ["dest", _to];
            } else {
                _v forceSpeed 0;
                doStop _u;
            };
        };
        if (speed _v < 1 && {[_v, 10] call _near}) then {_d set ["stopN", (_d getOrDefault ["stopN", 0]) + 1]} else {_d set ["stopN", 0]};
        if ((_d get "stopN") >= 2) exitWith {"ok"};
        if (_over || {_v distance2D (_d get "dest") < 30}) exitWith {"fail"};
        ""
    };
    case "blackmarket": {
        private _u = _units select 0;
        if (alive _u && {!([_u] call _caught)} && {_d get "flee"} && {!(_d getOrDefault ["ran", false])} && {[_u, 15] call _near}) then {
            _d set ["ran", true];
            _u enableAI "PATH";
            (group _u) addWaypoint [_u getPos [500, random 360], 0];
        };
        if (_d getOrDefault ["seized", false]) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "apo";
    case "boq": {
        if (_d getOrDefault ["inspected", false] && {!(_d get "contra") || {[_units select 0] call _caught}}) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "sapper";
    case "ambush";
    case "raid": {
        if (call _allDown) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "barricade": {
        private _u = _units select 0;
        if ([_u] call _caught) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "convoy": {
        private _l = _d get "lead";
        if (isNull _l || {!alive _l}) exitWith {"fail"};
        if (!(_d get "go") && {[_l, 50] call _near}) then {
            _d set ["go", true];
            private _g = group driver _l;
            (_g addWaypoint [_d get "dest", 0]) setWaypointType "MOVE";
            {_x limitSpeed 50} forEach (_e get "objs");
        };
        if ((_d get "go") && {_l distance2D (_d get "dest") < 60} && {[_l, 250] call _near}) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "transfer": {
        private _u = _units select 0;
        private _j = _d get "jail";
        if (!alive _u) exitWith {"fail"};
        if ((_u getVariable ["ADVSEC_jailUntil", 0]) > serverTime || {!isNull _j && {_u distance _j < ((_j getVariable ["ADVSEC_jailRadius", 6]) + 5)}}) exitWith {"ok"};
        if (!([_u] call ADVSEC_fnc_isRestrained) && {_u distance _pos > 150}) exitWith {"fail"};
        ["", "fail"] select _over
    };
    case "accident": {
        if (count (_d get "stmts") >= 2 && {_d getOrDefault ["sketch", false]} && {_d getOrDefault ["healed", false]}) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "pow";
    case "refugees";
    case "wake";
    case "asp";
    case "port";
    case "perimeter";
    case "hospguard": {
        if ([_pos, 40] call _near) then {_d set ["done", (_d get "done") + 5]};
        if ((_d get "done") >= (_d get "need")) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "amnesty": {
        if (_d getOrDefault ["collected", false]) exitWith {"ok"};
        ["", "fail"] select (_over || {!alive (_units select 0)})
    };
    case "trophy": {
        private _u = _units select 0;
        if (!alive _u) exitWith {"fail"};
        if (primaryWeapon _u == "" || {[_u] call _caught}) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "follow": {
        private _u = _units select 0;
        if ([_u] call _caught) exitWith {"ok"};
        if (!alive _u) exitWith {"fail"};
        // Seguir sin perderle (más de 200 m) ni dejarse ver (menos de 12 m)
        if ([_u, 12] call _near && {!(_d get "seen")}) then {
            _d set ["seen", true];
            _u setSpeedMode "FULL";
            (group _u) setSpeedMode "FULL";
        };
        if ([_u, 200] call _near) then {} else {_d set ["lost", (_d get "lost") + 5]};
        if ((_d get "lost") > 90) exitWith {"fail"};
        if (_u distance2D (_d get "dest") < 25) exitWith {"ok"};
        ["", "fail"] select _over
    };
    case "press": {
        private _j = _units select 0;
        private _o = _d get "officer";
        if (alive _j && {!isNull _o}) then {_j doMove (_o getPos [6, random 360])};
        if (_over) exitWith {
            // Buena noticia si la tensión es baja y no ha muerto ningún civil mientras miraba
            ["fail", "ok"] select ((missionNamespace getVariable ["ADVSEC_unrest", 0]) < 40 && {(missionNamespace getVariable ["ADVSEC_civKills", 0]) == (_d get "kills")})
        };
        ""
    };
    case "down": {
        private _u = _units select 0;
        if (_d getOrDefault ["healed", false]) exitWith {"ok"};
        if (_over) exitWith {_u setDamage 1; "fail"};
        ""
    };
    case "mortar";
    case "tire": {["", "ok"] select _over};
    case "server": {
        if (_over) exitWith {
            {[_x, "ON"] remoteExecCall ["switchLight", 0]} forEach (_d getOrDefault ["lamps", []]);
            "ok"
        };
        ""
    };
    default {"fail"};
};
