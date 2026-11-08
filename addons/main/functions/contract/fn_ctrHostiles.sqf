/*
    [acción, id, contrato] (servidor) — enemigos de los contratos
    "start": localiza los enemigos ya colocados en la zona (o junto a la ruta) y genera los que falten según contractHostiles
             (0 ninguno, 1 solo generados, 2 solo los ya colocados, 3 ambos). El contrato puede llevar hostileMode/hostileN propios.
    "tick":  oleadas pendientes (guardia y QRF) y recuento -> [vivos, abatidos, total]
    "end":   retira los generados cuando no queda ningún jugador cerca (máx. 10 min)
    Una unidad con  this setVariable ["ADVSEC_ctrHostile", true]  (o el id/tipo del contrato) cuenta como enemiga del contrato esté donde esté.
*/
params ["_action", "_id", ["_c", createHashMap]];
if (!isServer) exitWith {[0, 0, 0]};
private _reg = localNamespace getVariable "ADVSEC_ctrHost";
if (isNil "_reg") then {_reg = createHashMap; localNamespace setVariable ["ADVSEC_ctrHost", _reg]};

private _sideOf = {
    switch (toLower (["contractHostileSide", "east"] call ADVSEC_fnc_setting)) do {
        case "west": {west}; case "independent"; case "resistance"; case "guer": {independent}; default {east};
    }
};
private _inZone = {
    params ["_p"];
    private _r = _c get "route";
    if (_r isNotEqualTo []) exitWith {(_r findIf {(_x distance2D _p) < 400}) >= 0};
    (_p distance2D (_c get "pos")) <= (((_c get "radius") * 1.5) max 150)
};
private _spawnGroup = {
    // [posición, tamaño, comportamiento ("ambush" | "patrol" | "attack")] -> grupo
    params ["_p", "_n", "_how"];
    private _cls = ["contractHostileClasses", ["O_Soldier_F"]] call ADVSEC_fnc_setting;
    _cls = _cls select {isClass (configFile >> "CfgVehicles" >> _x)};
    if (_cls isEqualTo []) exitWith {grpNull};
    private _safe = [_p, 0, 60, 2, 0, 0.6, 0, [], [_p, _p]] call BIS_fnc_findSafePos;
    if ((_safe distance2D _p) > 200) then {_safe = _p};
    private _g = createGroup [call _sideOf, true];
    for "_i" from 1 to _n do {
        private _u = _g createUnit [selectRandom _cls, _safe, [], 8, "FORM"];
        _u setVariable ["ADVSEC_ctrHostile", _id, true];
        _u setVariable ["ADVSEC_ctrSpawned", true];
    };
    {_x addCuratorEditableObjects [units _g, true]} forEach allCurators;
    _g setCombatMode "RED";
    switch (_how) do {
        case "ambush": {
            _g setBehaviour "STEALTH";
            {_x setUnitPos "MIDDLE"} forEach units _g;
            private _wp = _g addWaypoint [_safe, 0];
            _wp setWaypointType "HOLD";
        };
        case "attack": {
            _g setBehaviour "AWARE";
            private _wp = _g addWaypoint [_c get "pos", 30];
            _wp setWaypointType "SAD";
            _wp setWaypointSpeed "FULL";
        };
        default {
            _g setBehaviour "SAFE";
            [_g, _safe, 80 + random 80] call BIS_fnc_taskPatrol;
        };
    };
    _g
};
private _wave = {
    // grupo que llega desde fuera de la zona
    params ["_n"];
    private _p = (_c get "pos") getPos [((_c get "radius") max 100) + 450 + random 350, random 360];
    private _g = [_p, _n, "attack"] call _spawnGroup;
    if (!isNull _g) then {((_reg getOrDefault [_id, [[], [], []]]) select 0) append units _g};
};

switch (_action) do {
    case "start": {
        private _mode = _c getOrDefault ["hostileMode", -1];
        if (_mode < 0) then {_mode = ["contractHostiles", 3] call ADVSEC_fnc_setting};
        private _type = _c get "type";
        private _tc = configNull;
        {if (configName _x == _type) exitWith {_tc = _x}} forEach (["ContractTypes"] call ADVSEC_fnc_pmcClasses);
        private _risk = _c getOrDefault ["risk", 1];
        private _groups = _c getOrDefault ["hostileN", -1];
        if (_groups < 0) then {_groups = round (([_tc, "hostiles", 0] call ADVSEC_fnc_pmcVal) * (["contractHostileScale", 1] call ADVSEC_fnc_setting))};
        private _size = (3 + _risk) min 8;
        private _units = [];
        // 1. Enemigos ya colocados (editor o Zeus)
        if (_mode in [2, 3]) then {
            private _lead = ((_c get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x};
            private _own = west;
            if (_lead isNotEqualTo []) then {_own = side group (_lead select 0)};
            {
                private _tag = _x getVariable ["ADVSEC_ctrHostile", false];
                private _tagged = _tag isEqualTo true || {_tag isEqualTo _id} || {_tag isEqualTo _type};
                if (alive _x && {!isPlayer _x} && {_tagged || {[_own, side group _x] call BIS_fnc_sideIsEnemy && {side group _x != civilian} && {[getPosATL _x] call _inZone}}}) then {
                    _units pushBack _x;
                };
            } forEach allUnits;
        };
        // 2. Generados: los grupos que falten
        private _waves = [];
        if (_mode in [1, 3]) then {
            private _have = count ((_units apply {group _x}) arrayIntersect (_units apply {group _x}));
            private _need = [_groups, (_groups - _have) max 0] select (_mode == 3);
            private _route = _c get "route";
            for "_i" from 1 to _need do {
                private _g = grpNull;
                switch (_type) do {
                    case "escort";
                    case "vip": {
                        // emboscadas entre el 30 % y el 85 % del recorrido, a un lado de la carretera
                        if (_route isEqualTo []) exitWith {_g = [(_c get "pos") getPos [random (_c get "radius"), random 360], _size, "patrol"] call _spawnGroup};
                        private _k = floor ((count _route - 1) * (0.3 + random 0.55));
                        private _pt = _route select (_k max 1 min (count _route - 1));
                        _g = [_pt getPos [40 + random 60, random 360], _size, "ambush"] call _spawnGroup;
                    };
                    case "guard";
                    case "qrf": {
                        // oleadas repartidas durante el contrato
                        private _min = (_c get "minutes") max 20;
                        _waves pushBack [serverTime + 60 * _min * (_i / (_need + 1)), _size];
                    };
                    case "recovery": {
                        private _box = objectFromNetId (_c getOrDefault ["cargoNet", ""]);
                        private _p = [getPosATL _box, _c get "pos"] select (isNull _box);
                        _g = [_p getPos [30 + random 70, random 360], _size, "patrol"] call _spawnGroup;
                    };
                    case "checkpoint": {
                        _waves pushBack [serverTime + 60 * ((_c get "minutes") max 20) * (_i / (_need + 1)), (_size - 1) max 2];
                    };
                    default {
                        _g = [(_c get "pos") getPos [random ((_c get "radius") * 0.8), random 360], _size, "patrol"] call _spawnGroup;
                    };
                };
                if (!isNull _g) then {_units append units _g};
            };
        };
        // 4. Tráfico y civiles para guardia y control: sin ellos no hay nada que registrar ni con quién actuar
        private _civ = [];
        if (_type in ["guard", "checkpoint"]) then {
            private _rd = (_c get "pos") nearRoads ((_c get "radius") max 100);
            private _nv = [0, 2 + _risk] select (_type == "checkpoint" && {_rd isNotEqualTo []});
            private _np = [0, 3 + _risk] select (_type == "guard");
            for "_v" from 1 to _nv do {
                private _p = getPos selectRandom _rd;
                private _veh = createVehicle [selectRandom ["C_Offroad_01_F", "C_Hatchback_01_F", "C_SUV_01_F"], _p, [], 0, "NONE"];
                private _g = createGroup [civilian, true];
                private _dr = _g createUnit ["C_man_1", _p, [], 0, "NONE"];
                _dr moveInDriver _veh;
                _g setBehaviour "SAFE";
                _g setSpeedMode "LIMITED";
                for "_w" from 1 to 4 do {
                    private _wp = _g addWaypoint [getPos selectRandom _rd, 0];
                    _wp setWaypointType "MOVE";
                };
                (waypoints _g select (count waypoints _g - 1)) setWaypointType "CYCLE";
                _veh setVariable ["ADVSEC_ctrSpawned", true];
                _civ pushBack _veh;
                { _x setVariable ["ADVSEC_ctrSpawned", true]; _civ pushBack _x } forEach units _g;
            };
            for "_i" from 1 to _np do {
                private _p = (_c get "pos") getPos [random ((_c get "radius") max 30), random 360];
                private _g = createGroup [civilian, true];
                _g createUnit ["C_man_1", _p, [], 0, "NONE"];
                _g setBehaviour "SAFE";
                [_g, _p, (_c get "radius") max 30] call BIS_fnc_taskPatrol;
                { _x setVariable ["ADVSEC_ctrSpawned", true]; _civ pushBack _x } forEach units _g;
            };
        };
        {if (isNil {_x getVariable "ADVSEC_ctrHostile"}) then {_x setVariable ["ADVSEC_ctrHostile", _id, true]}} forEach _units;
        _reg set [_id, [_units, _waves, _civ]];
        private _m = _c get "metrics";
        _m set ["host", count _units];
        _m set ["hostDown", 0];
        if (_units isNotEqualTo [] || {_waves isNotEqualTo []}) then {
            ["contractHostiles", objNull, [_id, count _units, count _waves, _mode]] call ADVSEC_fnc_logEvent;
        };
        [count _units, 0, count _units]
    };
    case "tick": {
        private _e = _reg getOrDefault [_id, []];
        if (_e isEqualTo []) exitWith {[0, 0, 0]};
        _e params ["_units", "_waves"];
        {
            _x params ["_t", "_n"];
            if (serverTime >= _t) then {
                _waves set [_forEachIndex, []];
                [_n] call _wave;
                if (!isNil "_notify") then {[_c, format [("STR_ADVSEC_pmc_host_wave" call ADVSEC_fnc_L), _id]] call _notify};
            };
        } forEach +_waves;
        _e set [1, _waves select {_x isNotEqualTo []}];
        private _alive = {alive _x} count _units;
        private _m = _c get "metrics";
        _m set ["host", count _units];
        _m set ["hostDown", count _units - _alive];
        [_alive, count _units - _alive, count _units, count (_e select 1)]
    };
    case "end": {
        private _e = _reg getOrDefault [_id, []];
        _reg deleteAt _id;
        if (_e isEqualTo []) exitWith {};
        private _spawned = ((_e select 0) + (_e select 2)) select {_x getVariable ["ADVSEC_ctrSpawned", false]};
        if (_spawned isEqualTo []) exitWith {};
        [_spawned] spawn {
            params ["_us"];
            private _t = serverTime + 600;
            waitUntil {
                sleep 15;
                _us = _us select {!isNull _x};
                serverTime > _t || {_us isEqualTo []} || {(_us findIf {private _u = _x; (allPlayers findIf {(_x distance _u) < 300}) >= 0}) < 0}
            };
            private _gs = [];
            {_gs pushBackUnique group _x; deleteVehicle _x} forEach (_us select {!isNull _x});
            {if (!isNull _x && {units _x isEqualTo []}) then {deleteGroup _x}} forEach _gs;
        };
    };
};
