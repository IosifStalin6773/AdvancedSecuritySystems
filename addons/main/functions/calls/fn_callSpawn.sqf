/*
    [tipo, posición opcional] (servidor, 1.24) -> aviso creado (hashmap) o nil si no se puede montar aquí
    Crea las unidades y objetos de un aviso generado por IA. fn_callCheck decide cuándo se resuelve.
    Claves: type, pos, objs, units, data, t0, limit, text
*/
params ["_type", ["_where", []]];
if (!isServer) exitWith {nil};
private _base = call ADVSEC_fnc_callBase;
private _rad = ["callRadius", 3000] call ADVSEC_fnc_setting;
private _civs = ["callCivs", ["C_man_1"]] call ADVSEC_fnc_setting;
private _hostiles = ["callHostiles", ["O_G_Soldier_F"]] call ADVSEC_fnc_setting;
private _soldier = ["callSoldier", "B_Soldier_unarmed_F"] call ADVSEC_fnc_setting;
private _cars = ["callCars", ["C_Offroad_01_F"]] call ADVSEC_fnc_setting;
private _unrest = missionNamespace getVariable ["ADVSEC_unrest", 0];

private _town = {
    params [["_near", _base], ["_r", _rad]];
    private _l = nearestLocations [_near, ["NameVillage", "NameCity", "NameCityCapital"], _r];
    if (_l isEqualTo []) exitWith {+_near};
    locationPosition selectRandom _l
};
private _roadAt = {
    params ["_p", ["_r", 250]];
    private _rs = _p nearRoads _r;
    if (_rs isEqualTo []) exitWith {+_p};
    getPosATL selectRandom _rs
};
private _houseAt = {
    params ["_p", ["_min", 3]];
    private _h = (nearestObjects [_p, ["House"], 250]) select {count (_x buildingPos -1) >= _min};
    if (_h isEqualTo []) exitWith {objNull};
    selectRandom _h
};
private _mk = {
    params ["_c", "_p", ["_side", civilian]];
    private _g = createGroup [_side, true];
    private _u = _g createUnit [_c, _p, [], 0, "CAN_COLLIDE"];
    _u setPosATL _p;
    _u setVariable ["ADVSEC_callUnit", true, true];
    _u
};
private _car = {
    params ["_c", "_p", ["_dir", random 360]];
    private _v = createVehicle [_c, _p, [], 5, "NONE"];
    _v setDir _dir;
    _v
};
private _act = {
    // Acción en todos los clientes (también JIP); el servidor la valida en fn_callAction
    params ["_o", "_id", "_k", "_a", ["_dist", 3]];
    [_o, _id, _k call ADVSEC_fnc_L, ADVSEC_icSearch,
        compile format ['["%1", _player, [_target]] remoteExecCall ["ADVSEC_fnc_callAction", 2]', _a],
        {alive _target && {[_player, "PMC"] call ADVSEC_fnc_repAccess}},
        "main", [], _dist
    ] remoteExecCall ["ADVSEC_fnc_addInteraction", 0, _o];
};
private _fillStolen = {
    params ["_box"];
    clearItemCargoGlobal _box; clearMagazineCargoGlobal _box; clearWeaponCargoGlobal _box; clearBackpackCargoGlobal _box;
    {
        _x params ["_c", ["_n", 1]];
        if (isClass (configFile >> "CfgMagazines" >> _c)) then {_box addMagazineCargoGlobal [_c, _n]} else {
            if (isClass (configFile >> "CfgWeapons" >> _c)) then {_box addItemCargoGlobal [_c, _n]};
        };
    } forEach (["blackMarketStolen", []] call ADVSEC_fnc_setting);
};
private _armed = {
    // [posiciones, bando] -> unidades hostiles en un grupo
    params ["_ps", ["_side", east]];
    private _g = createGroup [_side, true];
    _ps apply {
        private _u = _g createUnit [selectRandom _hostiles, _x, [], 0, "CAN_COLLIDE"];
        _u setPosATL _x;
        _u setVariable ["ADVSEC_callUnit", true, true];
        _u
    }
};

private _pos = if (_where isEqualTo []) then {[] call _town} else {+_where};
private _objs = [];
private _units = [];
private _data = createHashMap;
private _limit = 1800;
private _ok = true;

switch (_type) do {
    case "awol": {
        _pos = [_pos] call _roadAt;
        private _u = [_soldier, _pos, west] call _mk;
        _u disableAI "PATH";
        _u action ["SitDown", _u];
        _units = [_u];
    };
    case "speeding": {
        _pos = [_pos] call _roadAt;
        private _v = [selectRandom _cars, _pos] call _car;
        private _d = [selectRandom _civs, _pos, civilian] call _mk;
        _d moveInDriver _v;
        private _g = group _d;
        _g setBehaviour "CARELESS";
        _g setSpeedMode "FULL";
        private _dest = [_pos getPos [1500, random 360]] call _roadAt;
        private _w = _g addWaypoint [_dest, 0];
        _w setWaypointType "MOVE";
        _objs = [_v];
        _units = [_d];
        _data set ["veh", _v];
        _data set ["dest", _dest];
        _data set ["drunk", random 1 < 0.4];
        _data set ["flee", random 1 < (0.2 + _unrest / 200)];
        _limit = 900;
    };
    case "blackmarket": {
        _pos = [_pos, 150] call _roadAt;
        _pos = _pos getPos [6, random 360];
        private _st = createVehicle ["Land_MarketShelter_F", _pos, [], 0, "CAN_COLLIDE"];
        private _box = createVehicle ["Box_Syndicate_Ammo_F", _pos getPos [1.5, 0], [], 0, "CAN_COLLIDE"];
        [_box] call _fillStolen;
        private _s = [selectRandom _civs, _pos getPos [2, 180], civilian] call _mk;
        _s disableAI "PATH";
        [_box, "advsec_call_seize", "STR_ADVSEC_call_a_seize", "seize"] call _act;
        _objs = [_st, _box];
        _units = [_s];
        _data set ["box", _box];
        _data set ["flee", random 1 < (0.3 + _unrest / 200)];
    };
    case "apo";
    case "boq": {
        if (_type == "boq") then {_pos = _base getPos [80 + random 70, random 360]} else {
            private _h = [_pos] call _houseAt;
            if (!isNull _h) then {_pos = _h getPos [((boundingBoxReal _h) select 2) + 3, random 360]};
        };
        private _fe = _pos findEmptyPosition [0, 30, "C_man_1"];
        if (_fe isNotEqualTo []) then {_pos = _fe};
        private _u = [selectRandom _civs, _pos, civilian] call _mk;
        private _pk = createVehicle ["Land_PaperBox_01_small_closed_brown_F", _pos getPos [1, random 360], [], 0, "CAN_COLLIDE"];
        if (_type == "boq") then {
            private _g = group _u;
            for "_i" from 1 to 4 do {private _w = _g addWaypoint [_pos getPos [30, _i * 90], 0]; _w setWaypointSpeed "LIMITED"};
            (_g addWaypoint [_pos, 0]) setWaypointType "CYCLE";
        } else {_u disableAI "PATH"};
        [_pk, "advsec_call_pkg", "STR_ADVSEC_call_a_inspect", "inspect"] call _act;
        _objs = [_pk];
        _units = [_u];
        _data set ["pkg", _pk];
        _data set ["contra", random 1 < (([0.4, 0.6] select (_type == "boq")) + _unrest / 300)];
        _limit = 1200;
    };
    case "sapper": {
        private _from = _base getPos [400, random 360];
        _units = [[0, 1, 2, 3] apply {_from getPos [5, _x * 90]}, east] call _armed;
        private _g = group (_units select 0);
        _g setBehaviour "STEALTH";
        (_g addWaypoint [_base, 0]) setWaypointType "SAD";
        _pos = _from;
        _limit = 1200;
    };
    case "convoy": {
        private _a = [_base, 400] call _roadAt;
        private _dest = [[_base, _rad] call _town] call _roadAt;
        if (_a distance2D _dest < 500) exitWith {_ok = false};
        private _g = createGroup [west, true];
        private _vs = [];
        {
            private _v = [_x, _a getPos [_forEachIndex * 15, 0]] call _car;
            createVehicleCrew _v;
            (crew _v) joinSilent _g;
            {_x setVariable ["ADVSEC_callUnit", true, true]} forEach crew _v;
            _vs pushBack _v;
        } forEach ((["callConvoy", ["B_Truck_01_transport_F", "B_MRAP_01_F"]] call ADVSEC_fnc_setting) select [0, 3]);
        _g setBehaviour "SAFE";
        _g setSpeedMode "LIMITED";
        _objs = _vs;
        _units = units _g;
        _data set ["lead", _vs select 0];
        _data set ["dest", _dest];
        _data set ["go", false];
        _pos = _a;
        _limit = 2400;
    };
    case "ambush": {
        private _mid = [(_base vectorAdd ([_base, _rad] call _town)) vectorMultiply 0.5, 400] call _roadAt;
        _units = [[0, 1, 2, 3] apply {_mid getPos [25 + random 15, _x * 90]}, east] call _armed;
        private _g = group (_units select 0);
        _g setBehaviour "STEALTH";
        _g setCombatMode "RED";
        {_x disableAI "PATH"; _x setUnitPos "MIDDLE"} forEach _units;
        _pos = _mid;
        _limit = 2400;
    };
    case "transfer": {
        private _jails = (missionNamespace getVariable ["ADVSEC_jails", []]) select {!isNull _x};
        if (_jails isEqualTo []) exitWith {_ok = false};
        private _j = ([_jails, [], {_x distance2D _base}, "DESCEND"] call BIS_fnc_sortBy) select 0;
        _pos = (_base getPos [15, random 360]) findEmptyPosition [0, 40, "C_man_1"];
        if (_pos isEqualTo []) then {_pos = _base getPos [15, 0]};
        private _u = [selectRandom _civs, _pos, civilian] call _mk;
        [_u, true, objNull] call ADVSEC_fnc_restrain;
        _units = [_u];
        _data set ["jail", _j];
        _limit = 2400;
    };
    case "accident": {
        _pos = [_pos] call _roadAt;
        private _dir = random 360;
        private _v1 = [selectRandom _cars, _pos, _dir] call _car;
        private _v2 = [selectRandom _cars, _pos getPos [4, _dir + 70], _dir + 160] call _car;
        {_x setDamage 0.6; _x setFuel 0; _x lock 2} forEach [_v1, _v2];
        private _hurt = [selectRandom _civs, _pos getPos [5, _dir - 90], civilian] call _mk;
        _hurt disableAI "ALL";
        _hurt setDamage 0.5;
        [_hurt, "AinjPpneMstpSnonWnonDnon"] remoteExecCall ["switchMove", 0, _hurt];
        private _w1 = [selectRandom _civs, _pos getPos [10, _dir + 20], civilian] call _mk;
        private _w2 = [selectRandom _civs, _pos getPos [11, _dir - 30], civilian] call _mk;
        {_x disableAI "PATH"} forEach [_w1, _w2];
        [_hurt, "advsec_call_treat", "STR_ADVSEC_call_a_treat", "treat"] call _act;
        {[_x, "advsec_call_stmt", "STR_ADVSEC_call_a_statement", "statement"] call _act} forEach [_w1, _w2];
        [_v1, "advsec_call_sketch", "STR_ADVSEC_call_a_sketch", "sketch", 5] call _act;
        _objs = [_v1, _v2];
        _units = [_hurt, _w1, _w2];
        _data set ["fault", selectRandom [1, 2]];
        _data set ["liar", selectRandom [_w1, _w2, objNull]];
        _data set ["stmts", []];
    };
    case "raid";
    case "barricade": {
        private _h = [_pos, [3, 2] select (_type == "barricade")] call _houseAt;
        if (isNull _h) exitWith {_ok = false};
        private _bp = (_h buildingPos -1) call BIS_fnc_arrayShuffle;
        _units = [_bp select [0, [3, 1] select (_type == "barricade")], east] call _armed;
        {_x disableAI "PATH"; _x setUnitPos "UP"} forEach _units;
        _pos = getPosATL _h;
        if (_type == "barricade") then {
            [_units select 0, "advsec_call_talk", "STR_ADVSEC_call_a_negotiate", "negotiate", 15] call _act;
            _data set ["tries", 0];
        };
        _limit = 2700;
    };
    case "pow";
    case "refugees";
    case "wake";
    case "asp";
    case "port";
    case "perimeter";
    case "hospguard": {
        // Servicios de guardia: un agente de servicio tiene que pasar callGuardMin minutos en el sitio
        _pos = switch (_type) do {
            case "asp": {_base getPos [200, random 360]};
            case "perimeter": {_base getPos [120, random 360]};
            case "hospguard": {_base getPos [40, random 360]};
            case "port": {
                private _m = nearestLocations [_base, ["NameMarine"], _rad * 2];
                if (_m isEqualTo []) then {[_base, _rad] call _town} else {locationPosition (_m select 0)};
            };
            default {_pos};
        };
        private _n = switch (_type) do {case "pow": {3}; case "refugees": {5}; case "wake": {5}; default {0}};
        for "_i" from 1 to _n do {
            private _u = [selectRandom _civs, _pos getPos [3 + random 4, random 360], civilian] call _mk;
            _u disableAI "PATH";
            if (_type == "pow") then {[_u, true, objNull] call ADVSEC_fnc_restrain} else {_u action ["SitDown", _u]};
            _units pushBack _u;
        };
        _data set ["need", 60 * (["callGuardMin", 10] call ADVSEC_fnc_setting)];
        _data set ["done", 0];
        _limit = 2400;
    };
    case "amnesty": {
        _pos = [_pos] call _roadAt;
        private _u = [selectRandom _civs, _pos, civilian] call _mk;
        _u disableAI "PATH";
        _u addWeapon "hgun_Pistol_heavy_01_F";
        _u action ["SitDown", _u];
        [_u, "advsec_call_collect", "STR_ADVSEC_call_a_collect", "collect"] call _act;
        _units = [_u];
    };
    case "trophy": {
        _pos = [_pos] call _roadAt;
        private _u = [_soldier, _pos, west] call _mk;
        _u disableAI "PATH";
        _u addWeapon (["callTrophyWeapon", "arifle_AKM_F"] call ADVSEC_fnc_setting);
        _units = [_u];
    };
    case "follow": {
        _pos = [_pos] call _roadAt;
        private _u = [selectRandom _civs, _pos, civilian] call _mk;
        private _dest = [_pos getPos [800 + random 400, random 360]] call _roadAt;
        private _w = (group _u) addWaypoint [_dest, 0];
        _w setWaypointSpeed "LIMITED";
        _units = [_u];
        _data set ["dest", _dest];
        _data set ["lost", 0];
        _data set ["seen", false];
        _limit = 2400;
    };
    case "mortar": {
        _pos = +_base;
        _limit = 120;
        [_base] spawn {
            params ["_b"];
            private _near = (missionNamespace getVariable ["ADVSEC_sirens", []]) select {!isNull _x && {_x distance2D _b < 2000}};
            if (_near isNotEqualTo [] && {!((_near select 0) getVariable ["ADVSEC_sirenOn", false])}) then {["alarm", objNull, [_b]] call ADVSEC_fnc_sirenServer};
            sleep 8;
            for "_i" from 1 to 6 do {
                private _p = _b getPos [150 + random 200, random 360];
                if ((allPlayers findIf {_x distance2D _p < 60}) < 0) then {
                    private _s = createVehicle ["Sh_82mm_AMOS", [_p select 0, _p select 1, 150], [], 0, "CAN_COLLIDE"];
                    _s setVelocity [0, 0, -100];
                };
                sleep (3 + random 4);
            };
        };
    };
    case "press": {
        private _pm = (allPlayers - entities "HeadlessClient_F") select {_x getVariable ["ADVSEC_onDuty", false]};
        if (_pm isEqualTo []) exitWith {_ok = false};
        private _o = selectRandom _pm;
        _pos = (getPosATL _o) getPos [25, random 360];
        private _j = ["C_journalist_F", _pos, civilian] call _mk;
        _units = [_j];
        _data set ["officer", _o];
        _data set ["kills", missionNamespace getVariable ["ADVSEC_civKills", 0]];
        _limit = 300;
    };
    case "down": {
        _pos = [_pos] call _roadAt;
        private _u = [selectRandom _civs, _pos getPos [4, random 360], civilian] call _mk;
        _u disableAI "ALL";
        _u setDamage 0.6;
        [_u, "AinjPpneMstpSnonWnonDnon"] remoteExecCall ["switchMove", 0, _u];
        [_u, "advsec_call_treat", "STR_ADVSEC_call_a_treat", "treat", 3] call _act;
        _units = [_u];
        _limit = 900;
    };
    case "tire": {
        private _vs = ((allPlayers - entities "HeadlessClient_F") select {_x getVariable ["ADVSEC_onDuty", false] && {driver vehicle _x == _x} && {vehicle _x isKindOf "Car"}}) apply {vehicle _x};
        if (_vs isEqualTo []) exitWith {_ok = false};
        private _v = selectRandom _vs;
        [_v, [selectRandom ["HitLFWheel", "HitRFWheel", "HitLF2Wheel", "HitRF2Wheel"], 1]] remoteExecCall ["setHitPointDamage", _v];
        _pos = getPosATL _v;
        _limit = 5;
    };
    case "server": {
        _pos = +_base;
        _limit = 300;
        private _lamps = nearestObjects [_base, ["Lamps_base_F"], 700];
        {[_x, "OFF"] remoteExecCall ["switchLight", 0]} forEach _lamps;
        _data set ["lamps", _lamps];
    };
    default {_ok = false};
};
if (!_ok) exitWith {
    {deleteVehicle _x} forEach (_units + _objs);
    nil
};
// Civiles y unidades del aviso: muertes por jugadores cuentan para la tensión social (fn_callServer)
createHashMapFromArray [["type", _type], ["pos", _pos], ["objs", _objs], ["units", _units], ["data", _data], ["t0", serverTime], ["limit", _limit]]
