/*
    [acción, llamador, args] (servidor) — concesionario y registro de matrículas
    "dealer" [conc] · "buy" [conc, índice] · "mine" · "stolen" [matr] · "found" [matr] · "query" [matr] · "lock" [vehículo]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = [] call ADVSEC_fnc_plateDB;
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
private _say = {_this remoteExecCall ["hint", _caller]};
private _uid = getPlayerUID _caller;
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _vname = {params ["_c"]; getText (configFile >> "CfgVehicles" >> _c >> "displayName")};
private _vehOf = {params ["_p"]; private _v = objectFromNetId ((_db getOrDefault [_p, []]) param [5, ""]); [objNull, _v] select (alive _v && {(_v getVariable ["ADVSEC_plate", ""]) isEqualTo _p})};
switch (_action) do {
    case "dealer": {
        _args params [["_d", objNull]];
        if (isNull _d || {(_caller distance _d) > 10}) exitWith {};
        private _rows = [];
        {
            _x params ["_c", "_p"];
            _rows pushBack [format ["%1 · %2 %3", [_c] call _vname, _p, _cur], _forEachIndex, format [("STR_ADVSEC_price_delivered_registered_in_your" call ADVSEC_fnc_L), ([_c] call _vname) call ADVSEC_fnc_repEsc, _p, _cur, _c], [], getText (configFile >> "CfgVehicles" >> _c >> "picture")];
        } forEach (_d getVariable ["ADVSEC_dealer", ["", []]] select 1);
        ["dealer", format [("STR_ADVSEC_cash_and_bank" call ADVSEC_fnc_L), (_d getVariable ["ADVSEC_dealer", [("STR_ADVSEC_car_dealer" call ADVSEC_fnc_L)]]) select 0, ([_caller] call ADVSEC_fnc_ecoCash) + (([_uid, name _caller] call ADVSEC_fnc_ecoAcc) select 1), _cur], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "buy": {
        _args params [["_d", objNull], ["_i", -1]];
        if (isNull _d || {(_caller distance _d) > 10}) exitWith {};
        private _it = (_d getVariable ["ADVSEC_dealer", ["", []]] select 1) param [_i, []];
        if (_it isEqualTo []) exitWith {};
        _it params ["_c", "_p"];
        private _air = _c isKindOf "Air";
        private _pos = (getPosATL _d) findEmptyPosition [8, [60, 200] select _air, _c];
        if (_pos isEqualTo []) exitWith {("STR_ADVSEC_there_is_no_free_spot" call ADVSEC_fnc_L) call _say};
        if !([_caller, _p, format [("STR_ADVSEC_vehicle_purchase" call ADVSEC_fnc_L), [_c] call _vname], (["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {(format [("STR_ADVSEC_not_enough_money_it_costs_2" call ADVSEC_fnc_L), _p, _cur]) call _say};
        private _plate = "";
        while {_plate isEqualTo "" || {_plate in _db}} do {_plate = format ["%1-%2", ["platePrefix", "ET"] call ADVSEC_fnc_setting, 1000 + floor random 9000]};
        private _v = createVehicle [_c, _pos, [], 0, "NONE"];
        _v setDir getDir _d;
        _v setVariable ["ADVSEC_plate", _plate, true];
        _v setVariable ["ADVSEC_plateOwner", _uid, true];
        [_v, _plate] remoteExecCall ["setPlateNumber", 0, "ADVSEC_plate_" + netId _v];
        _v lock 2;
        _db set [_plate, [_c, _uid, name _caller, call ADVSEC_fnc_now, false, netId _v]];
        ["plates"] call ADVSEC_fnc_dbDirty;
        ["plateBuy", _caller, [_plate, _c, _p]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_vehicle_delivered_plate_it_is" call ADVSEC_fnc_L), [_c] call _vname, _plate]) call _say;
    };
    case "mine": {
        private _rows = [];
        {
            _y params ["_c", "_o", "", "_date", "_st"];
            if (_o isEqualTo _uid) then {
                private _v = [_x] call _vehOf;
                _rows pushBack [format ["%1 · %2%3", _x, [_c] call _vname, ["", ("STR_ADVSEC_stolen" call ADVSEC_fnc_L)] select _st], _x,
                    format [("STR_ADVSEC_registered_status" call ADVSEC_fnc_L), _x, ([_c] call _vname) call ADVSEC_fnc_repEsc, _date, [("STR_ADVSEC_in_order" call ADVSEC_fnc_L), ("STR_ADVSEC_reported_as_stolen" call ADVSEC_fnc_L)] select _st, [("STR_ADVSEC_vehicle_destroyed_or_not_in" call ADVSEC_fnc_L), format [("STR_ADVSEC_last_position" call ADVSEC_fnc_L), mapGridPosition _v]] select !isNull _v], [[], [1, 0.4, 0.3, 1]] select _st, ""];
            };
        } forEach _db;
        ["plates", format [("STR_ADVSEC_vehicles_in_your_name" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "stolen";
    case "found": {
        _args params [["_p", ""]];
        private _e = _db getOrDefault [_p, []];
        if (_e isEqualTo [] || {(_e select 1) isNotEqualTo _uid}) exitWith {};
        private _st = _action == "stolen";
        _e set [4, _st];
        ["plates"] call ADVSEC_fnc_dbDirty;
        if (_st) then {
            ["VEH:" + _p, format [("STR_ADVSEC_vehicle_2" call ADVSEC_fnc_L), [_e select 0] call _vname, _p], format [("STR_ADVSEC_reported_as_stolen_by" call ADVSEC_fnc_L), name _caller], "Media"] call ADVSEC_fnc_wantedSys;
            ["plateStolen", _caller, [_p, _e select 0]] call ADVSEC_fnc_logEvent;
        } else {
            ADVSEC_wantedDB deleteAt ("VEH:" + _p);
            ["wanted"] call ADVSEC_fnc_policeDBSave;
            ["plateFound", _caller, [_p]] call ADVSEC_fnc_logEvent;
        };
        ["mine", _caller] call ADVSEC_fnc_plateServer;
    };
    case "query": {
        if !([_caller, "plateQuery"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_check_plates" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_p", ""]];
        _p = toUpper (_p trim [" ", 0]);
        private _e = _db getOrDefault [_p, []];
        if (_e isEqualTo []) exitWith {(format [("STR_ADVSEC_plate_no_record_unregistered_vehicle" call ADVSEC_fnc_L), _p]) call _say};
        _e params ["_c", "_o", "_n", "_date", "_st"];
        private _w = _o in ADVSEC_wantedDB;
        ["plateQuery", _caller, [_p]] call ADVSEC_fnc_logEvent;
        (parseText format [("STR_ADVSEC_plate_owner_registered" call ADVSEC_fnc_L), _p, [_c] call _vname, _n, _date,
            [("STR_ADVSEC_no_theft_report" call ADVSEC_fnc_L), ("STR_ADVSEC_stolen_vehicle_2" call ADVSEC_fnc_L)] select _st,
            ["", ("STR_ADVSEC_owner_is_wanted" call ADVSEC_fnc_L)] select _w]) remoteExecCall ["hint", _caller];
    };
    case "lock": {
        _args params [["_v", objNull]];
        if (isNull _v || {(_caller distance _v) > 10} || {(_v getVariable ["ADVSEC_plateOwner", ""]) isNotEqualTo _uid}) exitWith {};
        private _l = [2, 0] select ((locked _v) >= 2);
        [_v, _l] remoteExecCall ["lock", _v];
        ([("STR_ADVSEC_vehicle_unlocked" call ADVSEC_fnc_L), ("STR_ADVSEC_vehicle_locked" call ADVSEC_fnc_L)] select (_l == 2)) call _say;
    };
};
