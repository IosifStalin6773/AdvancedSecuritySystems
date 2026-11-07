/*
    [acción, llamador, args] (servidor) — patrullas con ruta
    "create" [nombre, puntos [[x,y],...], radio, minutos, [uid,...]] · "cancel" [id] · "show" [id] · "list" · "tick" (interno)
    Patrulla: [0 nombre, 1 uidMando, 2 nombreMando, 3 puntos, 4 radio, 5 límite (min, 0 = sin límite), 6 asignados [[uid, nombre]],
               7 creada, 8 estado ("assigned"|"active"|"done"|"failed"|"cancelled"), 9 puntos alcanzados [[hora, agente] | []],
               10 serverTime de inicio (-1), 11 inicio, 12 fin, 13 minutos empleados]
    El cronómetro arranca al llegar al primer punto. Con patrolOrdered = 1 los puntos se cumplen en orden.
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (_action != "tick" && {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _db = [] call ADVSEC_fnc_patrolDB;
private _say = {_this remoteExecCall ["hint", _caller]};
private _stateTxt = {
    switch (_this) do {
        case "assigned": {("STR_ADVSEC_assigned" call ADVSEC_fnc_L)};
        case "active": {("STR_ADVSEC_in_progress" call ADVSEC_fnc_L)};
        case "done": {("STR_ADVSEC_completed" call ADVSEC_fnc_L)};
        case "failed": {("STR_ADVSEC_incomplete" call ADVSEC_fnc_L)};
        default {("STR_ADVSEC_cancelled" call ADVSEC_fnc_L)};
    }
};
private _units = {
    // agentes asignados conectados y vivos (de servicio si patrolNeedDuty = 1)
    params ["_p"];
    private _duty = (["patrolNeedDuty", 1] call ADVSEC_fnc_setting) isEqualTo 1;
    ((_p select 6) apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x && {alive _x} && {!_duty || {_x getVariable ["ADVSEC_onDuty", false]}}}
};
private _all = {
    params ["_p"];
    ((_p select 6) apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x}
};
private _push = {
    // marcadores a los asignados (y al mando si está conectado)
    params ["_id", "_p"];
    private _to = ([_p] call _all) + [[_p select 1] call ADVSEC_fnc_uidUnit] select {!isNull _x};
    [_id, _p select 0, _p select 3, (_p select 9) apply {_x isNotEqualTo []}, _p select 4, _p select 8] remoteExecCall ["ADVSEC_fnc_patrolMarkers", _to arrayIntersect _to];
};
private _finish = {
    params ["_id", "_p", "_state"];
    _p set [8, _state];
    _p set [12, call ADVSEC_fnc_now];
    if ((_p select 10) >= 0) then {_p set [13, round ((serverTime - (_p select 10)) / 60)]};
    private _done = {_x isNotEqualTo []} count (_p select 9);
    private _msg = format [("STR_ADVSEC_patrol_of_points_min" call ADVSEC_fnc_L), _id, _p select 0, toUpper (_state call _stateTxt), _done, count (_p select 3), _p select 13];
    private _to = ([_p] call _all) + [[_p select 1] call ADVSEC_fnc_uidUnit] select {!isNull _x};
    _msg remoteExecCall ["hint", _to arrayIntersect _to];
    [_id, _p] call _push;
    ["patrol", objNull, [_id, _p select 0, _state, _done, count (_p select 3), _p select 13]] call ADVSEC_fnc_logEvent;
    // Prima a los agentes que pasaron por algún punto
    private _bonus = round (["patrolBonus", 0] call ADVSEC_fnc_setting);
    if (_state == "done" && {_bonus > 0} && {[] call ADVSEC_fnc_ecoOn}) then {
        private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
        private _who = (_p select 9) apply {_x param [1, ""]};
        {
            if ((_x select 1) in _who) then {
                private _u = [_x select 0] call ADVSEC_fnc_uidUnit;
                private _a = [_x select 0, _x select 1] call ADVSEC_fnc_ecoAcc;
                _a set [1, (_a select 1) + _bonus];
                if (!isNull _u) then {_u setVariable ["ADVSEC_bank", _a select 1, true]};
                [_a, format [("STR_ADVSEC_patrol_bonus" call ADVSEC_fnc_L), _id], _bonus] call ADVSEC_fnc_ecoHist;
                if (!isNull _u) then {(format [("STR_ADVSEC_patrol_bonus_paid_in" call ADVSEC_fnc_L), _bonus, _cur]) remoteExecCall ["hintSilent", _u]};
            };
        } forEach (_p select 6);
    };
    ["patrols"] call ADVSEC_fnc_dbDirty;
};
switch (_action) do {
    case "create": {
        if !([_caller, "patrolPlan"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_plan_patrols" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_name", ""], ["_pts", []], ["_rad", 50], ["_min", 0], ["_uids", []]];
        _pts = (_pts select {_x isEqualTypeArray [0, 0] || {_x isEqualTypeArray [0, 0, 0]}}) apply {[_x select 0, _x select 1]};
        _pts = _pts select [0, 30];
        if (_pts isEqualTo []) exitWith {("STR_ADVSEC_the_route_has_no_points" call ADVSEC_fnc_L) call _say};
        _name = (_name select [0, 40]);
        if (_name isEqualTo "") then {_name = ("STR_ADVSEC_patrol" call ADVSEC_fnc_L)};
        _rad = (_rad max 10) min 500;
        _min = (_min max 0) min 600;
        private _as = [];
        {
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            if (!isNull _u && {[_u, "PM"] call ADVSEC_fnc_repAccess}) then {_as pushBackUnique [_x, name _u]};
        } forEach (_uids select {_x isEqualType ""});
        if (_as isEqualTo []) exitWith {("STR_ADVSEC_assign_at_least_one_connected" call ADVSEC_fnc_L) call _say};
        private _n = (localNamespace getVariable ["ADVSEC_patrolSeq", 0]) + 1;
        localNamespace setVariable ["ADVSEC_patrolSeq", _n];
        private _id = format ["P-%1", _n];
        private _p = [_name, getPlayerUID _caller, name _caller, _pts, _rad, _min, _as, call ADVSEC_fnc_now, "assigned", _pts apply {[]}, -1, "", "", 0];
        _db set [_id, _p];
        // Solo se guardan las 60 últimas
        private _ids = keys _db;
        if (count _ids > 60) then {
            _ids = [_ids, [], {parseNumber (_x select [2])}, "ASCEND"] call BIS_fnc_sortBy;
            {_db deleteAt _x} forEach (_ids select [0, count _ids - 60]);
        };
        [_id, _p] call _push;
        private _to = [_p] call _all;
        (format [("STR_ADVSEC_new_patrol_assigned_by_points" call ADVSEC_fnc_L), _id, _name, name _caller, count _pts, ["", format [("STR_ADVSEC_time_limit_min" call ADVSEC_fnc_L), _min]] select (_min > 0)]) remoteExecCall ["hint", _to];
        (format [("STR_ADVSEC_patrol_created_and_sent_to" call ADVSEC_fnc_L), _id, count _as]) call _say;
        ["patrolCreate", _caller, [_id, _name, count _pts, _as apply {_x select 1}]] call ADVSEC_fnc_logEvent;
        ["patrols"] call ADVSEC_fnc_dbDirty;
        if (isNil {localNamespace getVariable "ADVSEC_patrolLoop"}) then {
            localNamespace setVariable ["ADVSEC_patrolLoop", true];
            [] spawn {
                while {(values ([] call ADVSEC_fnc_patrolDB)) findIf {(_x select 8) in ["assigned", "active"]} >= 0} do {
                    sleep 3;
                    ["tick"] call ADVSEC_fnc_patrolServer;
                };
                localNamespace setVariable ["ADVSEC_patrolLoop", nil];
            };
        };
    };
    case "cancel": {
        if !([_caller, "patrolPlan"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_cancel_patrols" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_id", ""]];
        private _p = _db getOrDefault [_id, []];
        if (_p isEqualTo [] || {!((_p select 8) in ["assigned", "active"])}) exitWith {("STR_ADVSEC_that_patrol_has_already_ended" call ADVSEC_fnc_L) call _say};
        [_id, _p, "cancelled"] call _finish;
        ["list", _caller] call ADVSEC_fnc_patrolServer;
    };
    case "show": {
        _args params [["_id", ""]];
        private _p = _db getOrDefault [_id, []];
        if (_p isEqualTo []) exitWith {};
        [_id, _p select 0, _p select 3, (_p select 9) apply {_x isNotEqualTo []}, _p select 4, _p select 8] remoteExecCall ["ADVSEC_fnc_patrolMarkers", _caller];
        ("STR_ADVSEC_route_marked_on_your_map" call ADVSEC_fnc_L) call _say;
    };
    case "tick": {
        private _ordered = (["patrolOrdered", 1] call ADVSEC_fnc_setting) isEqualTo 1;
        {
            private _id = _x;
            private _p = _db get _x;
            if ((_p select 8) in ["assigned", "active"]) then {
                private _us = [_p] call _units;
                private _reached = _p select 9;
                private _pts = _p select 3;
                private _todo = [];
                {if (_x isEqualTo []) then {_todo pushBack _forEachIndex}} forEach _reached;
                if (_ordered) then {_todo = _todo select [0, 1]};
                {
                    private _i = _x;
                    private _pt = _pts select _i;
                    private _near = _us select {(_x distance2D _pt) <= (_p select 4)};
                    if (_near isNotEqualTo []) then {
                        private _u = _near select 0;
                        _reached set [_i, [[daytime, "HH:MM"] call BIS_fnc_timeToString, name _u]];
                        if ((_p select 8) == "assigned") then {
                            _p set [8, "active"];
                            _p set [10, serverTime];
                            _p set [11, call ADVSEC_fnc_now];
                        };
                        private _done = {_x isNotEqualTo []} count _reached;
                        (format [("STR_ADVSEC_patrol_point_reached_by_of" call ADVSEC_fnc_L), _id, _i + 1, name _u, _done, count _pts]) remoteExecCall ["hintSilent", [_p] call _all];
                        [_id, _p] call _push;
                        ["patrols"] call ADVSEC_fnc_dbDirty;
                    };
                } forEach _todo;
                if ((_p select 8) == "active") then {
                    if (_reached findIf {_x isEqualTo []} < 0) then {[_id, _p, "done"] call _finish} else {
                        if ((_p select 5) > 0 && {(serverTime - (_p select 10)) / 60 > (_p select 5)}) then {[_id, _p, "failed"] call _finish};
                    };
                };
            };
        } forEach (keys _db);
    };
    case "list": {
        private _uid = getPlayerUID _caller;
        private _plan = [_caller, "patrolPlan"] call ADVSEC_fnc_perm;
        if !(_plan || {[_caller, "PM"] call ADVSEC_fnc_repAccess}) exitWith {("STR_ADVSEC_only_the_military_police_can" call ADVSEC_fnc_L) call _say};
        private _rows = [];
        private _ids = [keys _db, [], {parseNumber (_x select [2])}, "DESCEND"] call BIS_fnc_sortBy;
        {
            private _p = _db get _x;
            _p params ["_name", "_cUid", "_cName", "_pts", "_rad", "_min", "_as", "_created", "_state", "_reached", "_t0", "_start", "_end", "_mins"];
            if (_plan || {_cUid == _uid} || {(_as findIf {(_x select 0) == _uid}) >= 0}) then {
                private _done = {_x isNotEqualTo []} count _reached;
                private _run = if (_state == "active") then {round ((serverTime - _t0) / 60)} else {_mins};
                private _det = format [("STR_ADVSEC_status_ordered_by_officers_radius" call ADVSEC_fnc_L),
                    _x, _name call ADVSEC_fnc_repEsc, _state call _stateTxt, _cName call ADVSEC_fnc_repEsc, _created, ((_as apply {_x select 1}) joinString ", ") call ADVSEC_fnc_repEsc,
                    _rad, [format ["%1 min", _min], ("STR_ADVSEC_no_limit" call ADVSEC_fnc_L)] select (_min == 0), [_start, "-"] select (_start isEqualTo ""), [_end, "-"] select (_end isEqualTo ""), _run];
                {
                    private _r = _reached select _forEachIndex;
                    _det = _det + format [("STR_ADVSEC_grid_2" call ADVSEC_fnc_L), ["<t color='#8C8C8C'>○</t>", "<t color='#66FF66'>✓</t>"] select (_r isNotEqualTo []), _forEachIndex + 1, mapGridPosition _x,
                        ["", format [" · %1 · %2", _r select 0, (_r select 1) call ADVSEC_fnc_repEsc]] select (_r isNotEqualTo [])];
                } forEach _pts;
                _rows pushBack [format [("STR_ADVSEC_points_3" call ADVSEC_fnc_L), _x, _name, _state call _stateTxt, _done, count _pts], _x, _det,
                    switch (_state) do {case "done": {[0.45, 1, 0.45, 1]}; case "failed": {[1, 0.4, 0.4, 1]}; case "cancelled": {[0.55, 0.55, 0.55, 1]}; case "active": {[1, 0.75, 0.3, 1]}; default {[]}}, ""];
            };
        } forEach _ids;
        ["patrol", format [("STR_ADVSEC_patrols_in_progress_or_assigned" call ADVSEC_fnc_L), count _rows, {(_x select 8) in ["assigned", "active"]} count (values _db)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
