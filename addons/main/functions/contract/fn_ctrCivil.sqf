/*
    [acción, id, contrato] (servidor) — vida en los encargos (1.19.5): civiles con documentación y sospechosos
    "start": control de acceso -> vehículos civiles que llegan al punto de control, paran y esperan a que los revisen;
             vigilancia -> trabajadores que pasean por la instalación y visitantes que llegan a pie y esperan;
             escolta -> camión de carga del cliente al inicio de la ruta (es lo que hay que llevar al destino).
    "tick":  avanza a cada civil (llegar, esperar, revisado/no revisado, marcharse) y repone; en QRF, si nadie ha
             avisado aún, un civil de la zona llama al 112 para que la QRF tenga una respuesta que medir.
    "end":   retira lo generado cuando no queda ningún jugador cerca (máx. 10 min) y borra las requisitorias de prueba.
    Un civil queda «revisado» cuando un agente pasa 9 s a menos de 6 m y luego se aleja; si lo esposan o lo bajan
    del vehículo se queda retenido. Ajustes: contractCivilians, contractCivSuspect, contractCivEvery.
*/
params ["_action", "_id", ["_c", createHashMap]];
if (!isServer) exitWith {};
private _reg = localNamespace getVariable "ADVSEC_ctrCiv";
if (isNil "_reg") then {_reg = createHashMap; localNamespace setVariable ["ADVSEC_ctrCiv", _reg]};
if (_action != "end" && {(["contractCivilians", 1] call ADVSEC_fnc_setting) isNotEqualTo 1}) exitWith {};

private _men = ["C_man_1", "C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_4_F", "C_man_shorts_1_F", "C_Man_casual_1_F", "C_Man_casual_4_F"] select {isClass (configFile >> "CfgVehicles" >> _x)};
if (_men isEqualTo []) then {_men = ["C_man_1"]};
// Encargo a medida con bando civil: los civiles usan las clases elegidas en el módulo
if ((_c getOrDefault ["hostileSide", ""]) == "civilian" && {(_c getOrDefault ["hostileClasses", []]) isNotEqualTo []}) then {_men = _c get "hostileClasses"};
private _cars = ["C_Offroad_01_F", "C_Hatchback_01_F", "C_SUV_01_F", "C_Van_01_transport_F"] select {isClass (configFile >> "CfgVehicles" >> _x)};
private _units = {((_c get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x && {alive _x}}};
private _say = {
    params ["_msg"];
    private _to = call _units;
    if (_to isNotEqualTo []) then {_msg remoteExecCall ["systemChat", _to]};
};
private _tag = {
    params ["_o"];
    _o setVariable ["ADVSEC_ctrSpawned", true];
    _o setVariable ["ADVSEC_ctrCiv", _id, true];
    {_x addCuratorEditableObjects [[_o], true]} forEach allCurators;
};
private _person = {
    // [grupo, posición] -> civil con documentación; ~contractCivSuspect son sospechosos
    params ["_g", "_p"];
    private _u = _g createUnit [selectRandom _men, _p, [], 3, "NONE"];
    [_u] call _tag;
    _u allowFleeing 0;
    _u setBehaviour "CARELESS";
    private _sus = random 1 < (["contractCivSuspect", 0.3] call ADVSEC_fnc_setting);
    private _kind = ["", selectRandom ["nodocs", "wanted", "contraband", "contraband"]] select _sus;
    _u setVariable ["ADVSEC_civKind", _kind];
    if (_kind != "nodocs") then {
        private _y = 1960 + floor random 45;
        [_u, "IDCard", [["name", name _u], ["dob", format ["%1/%2/%3", 1 + floor random 28, 1 + floor random 12, _y]],
            ["issuer", ("STR_ADVSEC_pmc_civ_issuer" call ADVSEC_fnc_L)], ["clearance", 0], ["notes", ("STR_ADVSEC_pmc_civ_notes" call ADVSEC_fnc_L)]], true, true, true] call ADVSEC_fnc_docCreate;
    };
    if (_kind == "wanted") then {
        if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
        private _k = [_u] call ADVSEC_fnc_docKey;
        ADVSEC_wantedDB set [_k, [name _u, selectRandom [("STR_ADVSEC_pmc_civ_w1" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_civ_w2" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_civ_w3" call ADVSEC_fnc_L)], selectRandom ["Baja", "Media", "Alta"], ("STR_ADVSEC_advsec_system" call ADVSEC_fnc_L), call ADVSEC_fnc_now, ""]];
        _u setVariable ["ADVSEC_civWantedKey", _k];
    };
    if (_kind == "contraband") then {
        private _bm = ["blackMarketItems", []] call ADVSEC_fnc_setting;
        private _mag = (_bm apply {_x select 0}) select {isClass (configFile >> "CfgMagazines" >> _x)};
        if (_mag isNotEqualTo []) then {for "_i" from 1 to 2 do {_u addItemToUniform selectRandom _mag}};
    };
    _u
};
private _farRoad = {
    // [centro, mín, máx] -> posición en una carretera a esa distancia (o un punto cualquiera)
    params ["_ctr", "_a", "_b"];
    private _rd = (_ctr nearRoads _b) select {(_x distance2D _ctr) > _a};
    [_ctr getPos [(_a + _b) / 2, random 360], getPosATL selectRandom _rd] select (_rd isNotEqualTo [])
};
private _leave = {
    // el civil (y su vehículo) se marcha y se borra lejos
    params ["_e"];
    _e params ["_u", "_veh"];
    _e set [2, "leave"];
    if (isNull _u || {!alive _u}) exitWith {};
    _u enableAI "MOVE";
    private _g = group _u;
    for "_i" from (count waypoints _g - 1) to 0 step -1 do {deleteWaypoint [_g, _i]};
    private _st = _c getOrDefault ["civStop", _c get "pos"];
    private _dst = [_st, 700, 1100] call _farRoad;
    private _wp = _g addWaypoint [_dst, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed (["LIMITED", "NORMAL"] select (!isNull _veh));
};
private _spawnOne = {
    params ["_st"];
    private _type = _c get "type";
    private _g = createGroup [civilian, true];
    if (_type == "checkpoint" && {_cars isNotEqualTo []}) exitWith {
        private _from = [_st, 350, 650] call _farRoad;
        private _veh = createVehicle [selectRandom _cars, _from, [], 0, "NONE"];
        [_veh] call _tag;
        private _u = [_g, _from] call _person;
        _u moveInDriver _veh;
        if ((_u getVariable ["ADVSEC_civKind", ""]) == "contraband") then {
            // también algo en el vehículo: un arma del mercado negro en el maletero o en el doble fondo
            private _bm = (["blackMarketItems", []] call ADVSEC_fnc_setting) apply {_x select 0};
            private _w = _bm select {isClass (configFile >> "CfgWeapons" >> _x)};
            if (_w isNotEqualTo []) then {
                if (random 1 < 0.5) then {_veh addWeaponCargoGlobal [selectRandom _w, 1]} else {_veh setVariable ["ADVSEC_stash", [["W", selectRandom _w, 1]]]};
            };
        };
        _g setBehaviour "CARELESS";
        _g setSpeedMode "LIMITED";
        private _wp = _g addWaypoint [_st, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointCompletionRadius 12;
        [_u, _veh, "approach", serverTime, 0, 0]
    };
    // a pie: visitante que llega hasta la puerta (centro) y espera
    private _from = _st getPos [((_c get "radius") max 60) + 120 + random 120, random 360];
    private _u = [_g, _from] call _person;
    _g setSpeedMode "LIMITED";
    private _wp = _g addWaypoint [_st, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 6;
    [_u, objNull, "approach", serverTime, 0, 0]
};

switch (_action) do {
    case "start": {
        private _type = _c get "type";
        private _e = createHashMapFromArray [["list", []], ["objs", []], ["next", serverTime + 20], ["max", 0], ["sim", false]];
        private _st = _c get "pos";
        switch (_type) do {
            case "checkpoint": {
                private _r = [_st, 150] call BIS_fnc_nearestRoad;
                if (!isNull _r) then {_st = getPosATL _r};
                {
                    private _cone = createVehicle ["Land_RoadCone_01_F", _st getPos [6, _x], [], 0, "CAN_COLLIDE"];
                    [_cone] call _tag;
                    (_e get "objs") pushBack _cone;
                } forEach [0, 60, 180, 240];
                _e set ["max", (2 + (_c getOrDefault ["risk", 0])) min 4];
                _e set ["next", serverTime + 5];
            };
            case "guard": {
                _e set ["max", 2];
                _e set ["next", serverTime + 90];
                // trabajadores de la instalación: ambiente, también con documentación
                for "_i" from 1 to (2 + (_c getOrDefault ["risk", 0])) do {
                    private _g = createGroup [civilian, true];
                    private _p = _st getPos [random (((_c get "radius") max 40) * 0.6), random 360];
                    private _u = [_g, _p] call _person;
                    _u setVariable ["ADVSEC_civKind", ""];
                    _g setSpeedMode "LIMITED";
                    [_g, _p, ((_c get "radius") max 40) * 0.6] call BIS_fnc_taskPatrol;
                    (_e get "objs") pushBack _u;
                };
            };
            case "escort": {
                private _cls = ["C_Truck_02_box_F", "C_Van_01_box_F", "C_Van_01_transport_F"] select {isClass (configFile >> "CfgVehicles" >> _x)};
                private _r = _c get "route";
                if (_cls isNotEqualTo [] && {_r isNotEqualTo []}) then {
                    private _p = _r select 0;
                    private _rd = [_p, 100] call BIS_fnc_nearestRoad;
                    if (!isNull _rd) then {_p = getPosATL _rd};
                    private _truck = createVehicle [_cls select 0, _p, [], 5, "NONE"];
                    [_truck] call _tag;
                    _truck setVariable ["ADVSEC_ctrCargo", _id, true];
                    _c set ["truckNet", (_truck call BIS_fnc_netId)];
                    (_e get "objs") pushBack _truck;
                    [format [("STR_ADVSEC_pmc_civ_truck" call ADVSEC_fnc_L), _id, mapGridPosition _truck]] call _say;
                };
            };
        };
        _c set ["civStop", _st];
        _reg set [_id, _e];
        (_c get "metrics") set ["civChecked", 0];
        (_c get "metrics") set ["civMissed", 0];
        (_c get "metrics") set ["civCaught", 0];
    };
    case "tick": {
        private _e = _reg getOrDefault [_id, createHashMap];
        if (count _e == 0) exitWith {};
        private _m = _c get "metrics";
        private _st = _c getOrDefault ["civStop", _c get "pos"];
        private _pm = (call _units) + ((allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PMC"] call ADVSEC_fnc_repAccess}});
        _pm = _pm arrayIntersect _pm;
        private _list = _e get "list";
        {
            private _en = _x;
            _en params ["_u", "_veh", "_state", "_t", "_near"];
            if (isNull _u || {!alive _u}) then {_en set [2, "gone"]} else {
                private _obj = [_u, _veh] select (!isNull _veh && {alive _veh});
                switch (_state) do {
                    case "approach": {
                        if ((_obj distance2D _st) < 14 || {serverTime - _t > 240}) then {
                            doStop _u;
                            _u disableAI "MOVE";
                            if (!isNull _veh) then {_veh setVelocity [0, 0, 0]};
                            _en set [2, "wait"];
                            _en set [3, serverTime];
                        };
                    };
                    case "wait": {
                        if ([_u] call ADVSEC_fnc_isRestrained || {!isNull _veh && {vehicle _u == _u}}) exitWith {
                            _en set [2, "held"];
                            if ((_u getVariable ["ADVSEC_civKind", ""]) != "") then {
                                _m set ["civCaught", (_m getOrDefault ["civCaught", 0]) + 1];
                                [format [("STR_ADVSEC_pmc_civ_caught" call ADVSEC_fnc_L), _id, name _u]] call _say;
                            };
                        };
                        private _close = (_pm findIf {(_x distance _obj) < 6}) >= 0;
                        if (_close) then {_en set [4, _near + 3]};
                        if (_near >= 9 && {!_close} && {(_pm findIf {(_x distance _obj) < 10}) < 0}) exitWith {
                            _m set ["civChecked", (_m getOrDefault ["civChecked", 0]) + 1];
                            [_en] call _leave;
                        };
                        if (_near < 9 && {serverTime - (_en select 3) > 180}) exitWith {
                            _m set ["civMissed", (_m getOrDefault ["civMissed", 0]) + 1];
                            [_en] call _leave;
                        };
                    };
                    case "held": {
                        // retenido: si lo sueltan y nadie le vigila en 60 s, se marcha
                        if !([_u] call ADVSEC_fnc_isRestrained) then {
                            if ((_pm findIf {(_x distance _u) < 25}) < 0) then {_en set [5, (_en select 5) + 3]} else {_en set [5, 0]};
                            if ((_en select 5) >= 60) then {
                                if (!isNull _veh && {alive _veh} && {vehicle _u == _u}) then {_u moveInDriver _veh};
                                [_en] call _leave;
                            };
                        };
                    };
                    case "leave": {
                        if ((_obj distance2D _st) > 600 || {(_pm findIf {(_x distance _obj) < 300}) < 0 && {(_obj distance2D _st) > 250}}) then {
                            private _k = _u getVariable ["ADVSEC_civWantedKey", ""];
                            if (_k isNotEqualTo "" && {!isNil "ADVSEC_wantedDB"}) then {ADVSEC_wantedDB deleteAt _k};
                            private _g = group _u;
                            ([] call ADVSEC_fnc_docStore) deleteAt ([_u] call ADVSEC_fnc_docKey);
                            if (!isNull _veh) then {deleteVehicle _veh};
                            deleteVehicle _u;
                            if (!isNull _g && {units _g isEqualTo []}) then {deleteGroup _g};
                            _en set [2, "gone"];
                        };
                    };
                };
            };
        } forEach _list;
        _list = _list select {(_x select 2) != "gone"};
        _e set ["list", _list];
        // reponer
        if ((_e get "max") > 0 && {serverTime >= (_e get "next")} && {({(_x select 2) in ["approach", "wait"]} count _list) < (_e get "max")}) then {
            _list pushBack ([_st] call _spawnOne);
            _e set ["next", serverTime + (["contractCivEvery", 45] call ADVSEC_fnc_setting) * ([1, 2] select ((_c get "type") == "guard"))];
        };
        // QRF sin avisos: un civil de la zona llama al 112 a partir de un tercio del tiempo
        if ((_c get "type") == "qrf" && {!(_e get "sim")} && {(_m get "responses") isEqualTo []}) then {
            private _el = (serverTime - (_c get "t0")) / 60;
            if (_el >= (((_c get "minutes") max 15) / 3)) then {
                _e set ["sim", true];
                private _g = createGroup [civilian, true];
                private _u = [_g, (_c get "pos") getPos [random (((_c get "radius") max 50) * 0.6), random 360]] call _person;
                _u disableAI "MOVE";
                (_e get "objs") pushBack _u;
                ["call", _u, [selectRandom [("STR_ADVSEC_pmc_civ_call1" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_civ_call2" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_civ_call3" call ADVSEC_fnc_L)]]] call ADVSEC_fnc_dspServer;
            };
        };
    };
    case "end": {
        private _e = _reg getOrDefault [_id, createHashMap];
        _reg deleteAt _id;
        if (count _e == 0) exitWith {};
        private _all = (_e get "objs") + ((_e get "list") apply {_x select 0}) + ((_e get "list") apply {_x select 1});
        _all = _all select {!isNull _x};
        {
            private _k = _x getVariable ["ADVSEC_civWantedKey", ""];
            if (_k isNotEqualTo "" && {!isNil "ADVSEC_wantedDB"}) then {ADVSEC_wantedDB deleteAt _k};
            if (_x isKindOf "CAManBase") then {([] call ADVSEC_fnc_docStore) deleteAt ([_x] call ADVSEC_fnc_docKey)};
        } forEach _all;
        if (_all isEqualTo []) exitWith {};
        [_all] spawn {
            params ["_os"];
            private _t = serverTime + 600;
            waitUntil {
                sleep 15;
                _os = _os select {!isNull _x};
                serverTime > _t || {_os isEqualTo []} || {(_os findIf {private _o = _x; (allPlayers findIf {(_x distance _o) < 300}) >= 0}) < 0}
            };
            private _gs = [];
            {
                if (_x isKindOf "CAManBase") then {_gs pushBackUnique group _x} else {{if (!isPlayer _x) then {_gs pushBackUnique group _x; deleteVehicle _x}} forEach crew _x};
                if (!isPlayer _x) then {deleteVehicle _x};
            } forEach (_os select {!isNull _x});
            {if (!isNull _x && {units _x isEqualTo []}) then {deleteGroup _x}} forEach _gs;
        };
    };
};
