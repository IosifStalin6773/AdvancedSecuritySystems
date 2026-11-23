/*
    [acción, llamador, args] (servidor, 1.24) — mercado negro en casas de pueblos
    "start" [centro, radio, número, artículos]: abre los puntos y su bucle (cambio de casa y soplos al teléfono)
    "seize" [alijo]: la PM incauta el material robado y el vendedor desaparece hasta el próximo cambio
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (isNil "ADVSEC_bmSpots") then {ADVSEC_bmSpots = []};
private _place = {
    // -> [vendedor, alijo] en una casa al azar de un pueblo al azar
    params ["_center", "_radius", "_items"];
    private _locs = nearestLocations [_center, ["NameVillage", "NameCity"], [worldSize, _radius] select (_radius > 0)];
    private _out = [objNull, objNull];
    private _used = ADVSEC_bmSpots apply {_x select 2};
    for "_try" from 1 to 10 do {
        if (_locs isEqualTo []) exitWith {};
        private _houses = (nearestObjects [locationPosition selectRandom _locs, ["House"], 250]) select {count (_x buildingPos -1) >= 2 && {!(_x in _used)}};
        if (_houses isNotEqualTo []) exitWith {
            private _h = selectRandom _houses;
            private _bp = _h buildingPos -1;
            private _p1 = selectRandom _bp;
            private _p2 = selectRandom (_bp - [_p1]);
            private _d = createAgent [selectRandom ["C_man_1", "C_man_polo_1_F", "C_man_polo_4_F"], _p1, [], 0, "CAN_COLLIDE"];
            _d setPosATL _p1;
            _d disableAI "ALL";
            _d setVariable ["ADVSEC_bmHouse", _h, true];
            [_d, ("STR_ADVSEC_bm_name" call ADVSEC_fnc_L), _items, true] remoteExecCall ["ADVSEC_fnc_shopInit", 0, _d];
            private _s = createVehicle ["Box_Syndicate_Wps_F", _p2, [], 0, "CAN_COLLIDE"];
            _s setPosATL _p2;
            clearItemCargoGlobal _s; clearMagazineCargoGlobal _s; clearWeaponCargoGlobal _s; clearBackpackCargoGlobal _s;
            {
                _x params ["_c", ["_n", 1]];
                if (isClass (configFile >> "CfgMagazines" >> _c)) then {_s addMagazineCargoGlobal [_c, _n]} else {
                    if (isClass (configFile >> "CfgWeapons" >> _c)) then {_s addItemCargoGlobal [_c, _n]};
                };
            } forEach (["blackMarketStolen", []] call ADVSEC_fnc_setting);
            [_s, "advsec_bm_seize", ("STR_ADVSEC_bm_seize" call ADVSEC_fnc_L), ADVSEC_icSearch,
                {["seize", _player, [_target]] remoteExecCall ["ADVSEC_fnc_bmServer", 2]},
                {[_player, "PMC"] call ADVSEC_fnc_repAccess},
                "main", [], 3
            ] remoteExecCall ["ADVSEC_fnc_addInteraction", 0, _s];
            _out = [_d, _s];
        };
    };
    _out
};
switch (_action) do {
    case "start": {
        if (call ADVSEC_fnc_fromClient) exitWith {};
        _args params [["_center", [worldSize / 2, worldSize / 2, 0]], ["_radius", 0], ["_count", 3], ["_items", []]];
        for "_i" from 1 to _count do {
            private _r = [_center, _radius, _items] call _place;
            if (!isNull (_r select 0)) then {ADVSEC_bmSpots pushBack [_r select 0, _r select 1, (_r select 0) getVariable ["ADVSEC_bmHouse", objNull], [_center, _radius, _items], serverTime]};
        };
        if (!isNil "ADVSEC_bmLoopH") exitWith {};
        ADVSEC_bmLoopH = [_place] spawn {
            params ["_place"];
            while {true} do {
                sleep 60;
                private _move = 60 * (["blackMarketMove", 60] call ADVSEC_fnc_setting);
                {
                    _x params ["_d", "_s", "_h", "_cfg", "_t"];
                    if (isNull _d || {!alive _d} || {_move > 0 && {serverTime - _t > _move}}) then {
                        if (!isNull _d) then {deleteVehicle _d};
                        if (!isNull _s) then {deleteVehicle _s};
                        private _r = _cfg call _place;
                        ADVSEC_bmSpots set [_forEachIndex, [_r select 0, _r select 1, (_r select 0) getVariable ["ADVSEC_bmHouse", objNull], _cfg, serverTime]];
                    };
                } forEach ADVSEC_bmSpots;
                // Soplo al teléfono de comisaría (probabilidad por hora)
                private _live = ADVSEC_bmSpots select {!isNull (_x select 0)};
                if (_live isNotEqualTo [] && {random 1 < ((["blackMarketTip", 0.3] call ADVSEC_fnc_setting) / 60)}) then {
                    private _p = ((selectRandom _live) select 0) getPos [50 + random 150, random 360];
                    ["tip", objNull, [format [("STR_ADVSEC_bm_tip" call ADVSEC_fnc_L), mapGridPosition _p], _p, ""]] call ADVSEC_fnc_dspServer;
                };
            };
        };
    };
    case "seize": {
        _args params [["_s", objNull]];
        if (!([_caller, _s, 6] call ADVSEC_fnc_srvCaller) || {!([_caller, "PMC"] call ADVSEC_fnc_repAccess)}) exitWith {};
        private _i = ADVSEC_bmSpots findIf {(_x select 1) == _s};
        if (_i < 0) exitWith {};
        private _e = ADVSEC_bmSpots select _i;
        private _n = count (itemCargo _s) + count (magazineCargo _s) + count (weaponCargo _s);
        if (!isNull (_e select 0)) then {deleteVehicle (_e select 0)};
        deleteVehicle _s;
        _e set [0, objNull];
        _e set [1, objNull];
        (format [("STR_ADVSEC_bm_seized" call ADVSEC_fnc_L), _n]) remoteExecCall ["hint", _caller];
        ["bmSeized", _caller, [mapGridPosition _caller, _n]] call ADVSEC_fnc_logEvent;
    };
};
