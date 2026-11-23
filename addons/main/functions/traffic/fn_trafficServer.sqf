/*
    [acción, llamador, args] (servidor) — tráfico y vía pública
    "breath" [objetivo] · "setDrunk" [objetivo, tasa] (Zeus) · "tow" [vehículo] · "impound" · "impoundPay" [matrícula]
    "accident" [vehículo] · "convoy" [netIds, destino, nombre] · "divert" · "divertEnd" · "lane" · "laneEnd"
    "cpBook" · "itvRenew" [matrícula]
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _L = ADVSEC_fnc_L;
switch (_action) do {
    case "setDrunk": {
        if !([_caller] call ADVSEC_fnc_isZeus) exitWith {};
        _args params [["_t", objNull], ["_bac", 0.8]];
        if (isNull _t) exitWith {};
        _t setVariable ["ADVSEC_drunk", _bac, true];
        (format [("STR_ADVSEC_m_drunk_set" call _L), name _t, _bac]) call _say;
    };
    case "breath": {
        if !([_caller, "breath"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_breath_do" call _L)] call ADVSEC_fnc_deny};
        _args params [["_t", objNull]];
        if (isNull _t || {(_caller distance _t) > 6}) exitWith {};
        [_caller, _t, _cur] spawn {
            params ["_caller", "_t", "_cur"];
            [("STR_ADVSEC_m_breath_doing" call ADVSEC_fnc_L), 8] remoteExecCall ["ADVSEC_fnc_progress", _caller];
            sleep 8;
            if (isNull _t || {(_caller distance _t) > 8}) exitWith {};
            private _bac = _t getVariable ["ADVSEC_drunk", -1];
            if (_bac < 0) then {
                _bac = 0;
                if (!isPlayer _t && {random 1 < (["breathAIChance", 0.15] call ADVSEC_fnc_setting)}) then {_bac = 0.3 + random 0.9};
                _t setVariable ["ADVSEC_drunk", _bac, true];
            };
            _bac = round (_bac * 100) / 100;
            private _lim = ["breathLimit", 0.25] call ADVSEC_fnc_setting;
            ["breath", _caller, [name _t, _bac, _lim]] call ADVSEC_fnc_logEvent;
            if (_bac > _lim) then {
                private _amt = ["breathFine", 400] call ADVSEC_fnc_setting;
                private _fid = [_t, _amt, format [("STR_ADVSEC_m_breath_reason" call ADVSEC_fnc_L), _bac], name _caller, getPlayerUID _caller] call ADVSEC_fnc_fineAdd;
                [_t, -4, format [("STR_ADVSEC_m_breath_reason" call ADVSEC_fnc_L), _bac]] call ADVSEC_fnc_pointsAdd;
                ["FPM01", format [("STR_ADVSEC_m_breath_rep" call ADVSEC_fnc_L), name _t], [format ["%1 [%2]", name _t, getPlayerUID _t]],
                    format [("STR_ADVSEC_m_breath_body" call ADVSEC_fnc_L), _bac, _lim, mapGridPosition _t, name _caller, _fid], "Grave", false] call ADVSEC_fnc_repSystem;
                (format [("STR_ADVSEC_m_breath_pos" call ADVSEC_fnc_L), name _t, _bac, _lim, _amt, _cur]) remoteExecCall ["hint", _caller];
                if (isPlayer _t) then {(format [("STR_ADVSEC_m_breath_pos_you" call ADVSEC_fnc_L), _bac, _amt, _cur]) remoteExecCall ["hint", _t]};
            } else {
                (format [("STR_ADVSEC_m_breath_neg" call ADVSEC_fnc_L), name _t, _bac, _lim]) remoteExecCall ["hint", _caller];
            };
        };
    };
    case "tow": {
        if !([_caller, "traffic"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_tow_do" call _L)] call ADVSEC_fnc_deny};
        _args params [["_v", objNull]];
        if (isNull _v || {(_caller distance _v) > 15} || {(crew _v) findIf {isPlayer _x} >= 0}) exitWith {("STR_ADVSEC_m_tow_no" call _L) call _say};
        [_caller, _v] spawn {
            params ["_caller", "_v"];
            [("STR_ADVSEC_m_tow_doing" call ADVSEC_fnc_L), 15] remoteExecCall ["ADVSEC_fnc_progress", _caller];
            sleep 15;
            if (isNull _v || {(_caller distance _v) > 25}) exitWith {};
            private _plate = _v getVariable ["ADVSEC_plate", getPlateNumber _v];
            private _pdb = [] call ADVSEC_fnc_plateDB;
            private _owner = (_pdb getOrDefault [_plate, []]) param [1, ""];
            private _fee = round (["towFee", 300] call ADVSEC_fnc_setting);
            private _db = ["impound", "ADVSEC_impoundDB"] call ADVSEC_fnc_mapDB;
            private _m = markerPos ["advsec_impound", true];
            private _kept = _m isNotEqualTo [0, 0, 0];
            _db set [_plate, [typeOf _v, _owner, call ADVSEC_fnc_now, _fee, _kept, netId _v]];
            ["impound"] call ADVSEC_fnc_dbDirty;
            if (_kept) then {
                private _pos = _m findEmptyPosition [3, 60, typeOf _v];
                if (_pos isEqualTo []) then {_pos = _m};
                _v setPosATL _pos;
                _v lock 2;
                _v setVariable ["ADVSEC_impounded", true, true];
                _v engineOn false;
            } else {deleteVehicle _v};
            ["tow", _caller, [_plate, typeOf _v]] call ADVSEC_fnc_logEvent;
            (format [("STR_ADVSEC_m_tow_done" call ADVSEC_fnc_L), _plate]) remoteExecCall ["hint", _caller];
            private _u = [_owner] call ADVSEC_fnc_uidUnit;
            if (!isNull _u) then {(format [("STR_ADVSEC_m_tow_owner" call ADVSEC_fnc_L), _plate]) remoteExecCall ["hint", _u]};
        };
    };
    case "impound": {
        private _db = ["impound", "ADVSEC_impoundDB"] call ADVSEC_fnc_mapDB;
        private _pm = [_caller, "traffic"] call ADVSEC_fnc_perm;
        private _uid = getPlayerUID _caller;
        private _rows = [];
        {
            _y params ["_type", "_owner", "_when", "_fee", "_kept"];
            if (_pm || {_owner == _uid}) then {
                _rows pushBack [format ["%1 · %2", _x, getText (configFile >> "CfgVehicles" >> _type >> "displayName")], _x,
                    format [("STR_ADVSEC_m_imp_det" call ADVSEC_fnc_L), _x, getText (configFile >> "CfgVehicles" >> _type >> "displayName"), _when, _fee, _cur, [("STR_ADVSEC_m_imp_gone" call ADVSEC_fnc_L), ("STR_ADVSEC_m_imp_kept" call ADVSEC_fnc_L)] select _kept], [], ""];
            };
        } forEach _db;
        ["impound", format [("STR_ADVSEC_m_imp_head" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "impoundPay": {
        _args params [["_plate", ""]];
        private _db = ["impound", "ADVSEC_impoundDB"] call ADVSEC_fnc_mapDB;
        private _e = _db getOrDefault [_plate, []];
        if (_e isEqualTo []) exitWith {};
        _e params ["_type", "_owner", "_when", "_fee", "_kept", "_net"];
        if !([_caller, _fee, format [("STR_ADVSEC_m_imp_pay" call _L), _plate], true] call ADVSEC_fnc_ecoCharge) exitWith {(format [("STR_ADVSEC_not_enough_money_it_costs_2" call _L), _fee, _cur]) call _say};
        private _v = objectFromNetId _net;
        if (isNull _v || {!alive _v}) then {
            private _pos = (getPosATL _caller) findEmptyPosition [5, 50, _type];
            if (_pos isEqualTo []) then {_pos = _caller getPos [8, getDir _caller]};
            _v = createVehicle [_type, _pos, [], 0, "NONE"];
            _v setVariable ["ADVSEC_plate", _plate, true];
            if (isClass (configFile >> "CfgPatches" >> "A3_Characters_F")) then {_v setPlateNumber _plate};
        };
        _v lock 0;
        _v setVariable ["ADVSEC_impounded", nil, true];
        _db deleteAt _plate;
        ["impound"] call ADVSEC_fnc_dbDirty;
        ["impoundPay", _caller, [_plate, _fee]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_imp_paid" call _L), _plate, _fee, _cur]) call _say;
    };
    case "accident": {
        if !([_caller, "vehicleSearch"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_acc_do" call _L)] call ADVSEC_fnc_deny};
        private _vehs = ((getPosATL _caller) nearEntities [["Car", "Motorcycle", "Truck", "Tank", "Air", "Ship"], 30]) select {damage _x > 0.1 || {!alive _x}};
        if (_vehs isEqualTo []) exitWith {("STR_ADVSEC_m_acc_none" call _L) call _say};
        private _lines = [];
        {
            private _crewTxt = ((crew _x) apply {name _x}) joinString ", ";
            _lines pushBack format ["- %1 · %2 · %3 · %4%5 · %6", getText (configOf _x >> "displayName"), _x getVariable ["ADVSEC_plate", getPlateNumber _x],
                mapGridPosition _x, round (damage _x * 100), "%", [("STR_ADVSEC_m_acc_nocrew" call _L), _crewTxt] select (_crewTxt isNotEqualTo "")];
        } forEach _vehs;
        private _id = ["FPM01", format [("STR_ADVSEC_m_acc_title" call _L), mapGridPosition _caller], [],
            format [("STR_ADVSEC_m_acc_body" call _L), mapGridPosition _caller, name _caller, count _vehs, _lines joinString toString [10]], "Leve", false] call ADVSEC_fnc_repSystem;
        ["accident", _caller, [mapGridPosition _caller, count _vehs]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_acc_done" call _L), _id, count _vehs]) call _say;
    };
    case "convoy": {
        if !([_caller, "patrolPlan"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_convoy_do" call _L)] call ADVSEC_fnc_deny};
        _args params [["_nets", []], ["_dest", [0, 0, 0]], ["_name", ""]];
        _nets = _nets select [0, 8];
        private _vehs = (_nets apply {objectFromNetId _x}) select {!isNull _x && {alive _x}};
        if (_vehs isEqualTo [] || {_dest isEqualTo [0, 0, 0]}) exitWith {("STR_ADVSEC_m_convoy_bad" call _L) call _say};
        private _n = (missionNamespace getVariable ["ADVSEC_convoySeq", 0]) + 1;
        ADVSEC_convoySeq = _n;
        private _id = format ["C-%1", _n];
        if (_name isEqualTo "") then {_name = format [("STR_ADVSEC_m_convoy_name" call _L), _n]};
        private _cv = missionNamespace getVariable ["ADVSEC_convoys", createHashMap];
        ADVSEC_convoys = _cv;
        _cv set [_id, [_name, _vehs apply {netId _x}, _dest, "active", serverTime, getPlayerUID _caller]];
        // Conductores IA en columna tras el vehículo de cabeza
        {
            private _d = driver _x;
            if (!isNull _d && {!isPlayer _d}) then {
                [_d, _dest] remoteExecCall ["doMove", _d];
                [_x, 40] remoteExecCall ["limitSpeed", _x];
            };
        } forEach _vehs;
        private _m = createMarker ["advsec_conv_" + _id, _dest];
        _m setMarkerType "mil_end";
        _m setMarkerColor "ColorBlue";
        _m setMarkerText _name;
        ["convoyStart", _caller, [_id, _name, count _vehs]] call ADVSEC_fnc_logEvent;
        [] call ADVSEC_fnc_trafficLoop;
        (format [("STR_ADVSEC_m_convoy_ok" call _L), _id, count _vehs]) call _say;
    };
    case "divert": {
        if !([_caller, "traffic"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_div_do" call _L)] call ADVSEC_fnc_deny};
        private _pos = getPosATL _caller;
        private _b = createVehicle ["RoadBarrier_F", _caller getPos [3, getDir _caller], [], 0, "CAN_COLLIDE"];
        _b setDir (getDir _caller + 90);
        private _n = (missionNamespace getVariable ["ADVSEC_divertSeq", 0]) + 1;
        ADVSEC_divertSeq = _n;
        private _dv = missionNamespace getVariable ["ADVSEC_diverts", createHashMap];
        ADVSEC_diverts = _dv;
        _dv set [str _n, [_pos, ["divertRadius", 150] call ADVSEC_fnc_setting, netId _b]];
        ["divert", _caller, [mapGridPosition _pos]] call ADVSEC_fnc_logEvent;
        [] call ADVSEC_fnc_trafficLoop;
        ("STR_ADVSEC_m_div_ok" call _L) call _say;
    };
    case "divertEnd": {
        if !([_caller, "traffic"] call ADVSEC_fnc_perm) exitWith {};
        private _dv = missionNamespace getVariable ["ADVSEC_diverts", createHashMap];
        private _best = "";
        {if (_best isEqualTo "" || {(_caller distance2D ((_dv get _x) select 0)) < (_caller distance2D ((_dv get _best) select 0))}) then {_best = _x}} forEach (keys _dv);
        if (_best isEqualTo "") exitWith {("STR_ADVSEC_m_div_none" call _L) call _say};
        deleteVehicle (objectFromNetId ((_dv get _best) select 2));
        _dv deleteAt _best;
        ("STR_ADVSEC_m_div_off" call _L) call _say;
    };
    case "lane": {
        if !([_caller, "traffic"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_lane_do" call _L)] call ADVSEC_fnc_deny};
        private _dir = getDir _caller;
        private _objs = [];
        {
            private _c = createVehicle ["RoadCone_L_F", _caller modelToWorld _x, [], 0, "CAN_COLLIDE"];
            _c setDir _dir;
            _objs pushBack netId _c;
        } forEach [[-2.5, 2, 0], [-1.2, 2, 0], [0, 2, 0], [-2.5, 6, 0], [-1.2, 5, 0]];
        private _n = (missionNamespace getVariable ["ADVSEC_laneSeq", 0]) + 1;
        ADVSEC_laneSeq = _n;
        private _ln = missionNamespace getVariable ["ADVSEC_lanes", createHashMap];
        ADVSEC_lanes = _ln;
        _ln set [str _n, [getPosATL _caller, _objs]];
        ["lane", _caller, [mapGridPosition _caller]] call ADVSEC_fnc_logEvent;
        [] call ADVSEC_fnc_trafficLoop;
        ("STR_ADVSEC_m_lane_ok" call _L) call _say;
    };
    case "laneEnd": {
        if !([_caller, "traffic"] call ADVSEC_fnc_perm) exitWith {};
        private _ln = missionNamespace getVariable ["ADVSEC_lanes", createHashMap];
        private _best = "";
        {if (_best isEqualTo "" || {(_caller distance2D ((_ln get _x) select 0)) < (_caller distance2D ((_ln get _best) select 0))}) then {_best = _x}} forEach (keys _ln);
        if (_best isEqualTo "") exitWith {("STR_ADVSEC_m_lane_none" call _L) call _say};
        {deleteVehicle (objectFromNetId _x)} forEach ((_ln get _best) select 1);
        _ln deleteAt _best;
        ("STR_ADVSEC_m_lane_off" call _L) call _say;
    };
    case "cpBook": {
        if !([_caller, "PMC"] call ADVSEC_fnc_repAccess) exitWith {};
        private _cp = ((getPosATL _caller) nearObjects ["Land_HelipadEmpty_F", 120]) select {(_x getVariable ["ADVSEC_cpId", -1]) > 0};
        if (_cp isEqualTo []) exitWith {("STR_ADVSEC_m_book_none" call _L) call _say};
        private _a = _cp select 0;
        private _rows = (_a getVariable ["ADVSEC_cpBook", []]) apply {
            _x params ["_when", "_plate", "_type", "_names", "_result"];
            [format ["%1 · %2 · %3", _when, _plate, _type], _x, format [("STR_ADVSEC_m_book_det" call _L), _when, _plate, _type, _names, _result], [], ""]
        };
        reverse _rows;
        ["cpbook", format [("STR_ADVSEC_m_book_head" call _L), _a getVariable ["ADVSEC_cpName", ""], count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "itvRenew": {
        _args params [["_plate", ""]];
        private _days = ["itvDays", 30] call ADVSEC_fnc_setting;
        if (_days <= 0) exitWith {};
        private _fee = round (["itvFee", 120] call ADVSEC_fnc_setting);
        if !([_caller, _fee, format [("STR_ADVSEC_m_itv_pay" call _L), _plate], true] call ADVSEC_fnc_ecoCharge) exitWith {(format [("STR_ADVSEC_not_enough_money_it_costs_2" call _L), _fee, _cur]) call _say};
        private _db = ["itv", "ADVSEC_itvDB"] call ADVSEC_fnc_mapDB;
        _db set [_plate, (call ADVSEC_fnc_utcMin) + _days * 1440];
        ["itv"] call ADVSEC_fnc_dbDirty;
        ["itvRenew", _caller, [_plate]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_itv_ok" call _L), _plate, _days]) call _say;
    };
};
