// Carrera (cliente, 1.24): hoja de servicio, méritos, medallas, evaluación, escuela, revista, organigrama, estadísticas, prioridad de avisos
params [["_mode", ""], ["_arg", objNull]];
private _L = {_this call ADVSEC_fnc_L};
private _srv = {params ["_a", ["_args", []]]; [_a, player, _args] remoteExecCall ["ADVSEC_fnc_carServer", 2]};
private _pickUnit = {
    // [título, campos extra, código ([unidad, valores])]
    params ["_title", "_extra", "_code"];
    [_title, [[("STR_ADVSEC_car_f_who" call ADVSEC_fnc_L), objNull, "players"]] + _extra, {
        params ["_v", "_c"];
        private _u = _v select 0;
        if (isNull _u) exitWith {};
        [_u, _v select [1]] call _c;
    }, _code] call ADVSEC_fnc_zeusPrompt;
};
switch (_mode) do {
    case "": {
        private _rows = [[("STR_ADVSEC_car_b_record" call _L), "['record'] call ADVSEC_fnc_carOpen"]];
        if ([player, "hr"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_record_of" call _L), "['recordOf'] call ADVSEC_fnc_carOpen"]};
        _rows pushBack [("STR_ADVSEC_car_b_org" call _L), "['org'] call ADVSEC_fnc_carOpen"];
        _rows pushBack [("STR_ADVSEC_car_b_stats" call _L), "['stats'] call ADVSEC_fnc_carOpen"];
        if ([player, "merit"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_merit" call _L), "['merit'] call ADVSEC_fnc_carOpen"]};
        if ([player, "award"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_award" call _L), "['award'] call ADVSEC_fnc_carOpen"]};
        if ([player, "evaluate"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_eval" call _L), "['eval'] call ADVSEC_fnc_carOpen"]};
        if ([player, "school"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_school" call _L), "['school'] call ADVSEC_fnc_carOpen"]};
        if ([player, "inspect"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_inspect" call _L), "['inspect'] call ADVSEC_fnc_carOpen"]};
        if ([player, "supervisor"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_car_b_prio" call _L), "['prio'] call ADVSEC_fnc_carOpen"]};
        ["carMenu", ("STR_ADVSEC_car_menu" call _L), [[("STR_ADVSEC_car_open" call _L), {params ["_d"]; if (_d isEqualType "") then {closeDialog 0; [_d] spawn {sleep 0.1; call compile (_this select 0)}}}]], {}] call ADVSEC_fnc_panelOpen;
        ["carMenu", ("STR_ADVSEC_car_menu_info" call _L), _rows apply {[_x select 0, _x select 1, "", [], ""]}] call ADVSEC_fnc_panelSet;
    };
    case "record": {["record", [getPlayerUID player]] call _srv};
    case "recordOf": {[("STR_ADVSEC_car_b_record_of" call _L), [], {params ["_u"]; ["record", player, [getPlayerUID _u]] remoteExecCall ["ADVSEC_fnc_carServer", 2]}] call _pickUnit};
    case "org": {["org", ("STR_ADVSEC_car_b_org" call _L), [], {["org", player, []] remoteExecCall ["ADVSEC_fnc_carServer", 2]}] call ADVSEC_fnc_panelOpen};
    case "stats": {["stats", ("STR_ADVSEC_car_b_stats" call _L), [], {["stats", player, []] remoteExecCall ["ADVSEC_fnc_carServer", 2]}] call ADVSEC_fnc_panelOpen};
    case "merit": {
        [("STR_ADVSEC_car_b_merit" call _L), [[("STR_ADVSEC_car_f_pts" call _L), "5"], [("STR_ADVSEC_car_f_why" call _L), ""]], {
            params ["_u", "_v"];
            ["merit", player, [getPlayerUID _u, name _u, parseNumber (_v select 0), _v select 1]] remoteExecCall ["ADVSEC_fnc_carServer", 2];
        }] call _pickUnit;
    };
    case "award": {
        private _opts = (["medals", []] call ADVSEC_fnc_setting) apply {[_x select 1, _x select 0]};
        if (_opts isEqualTo []) exitWith {hint ("STR_ADVSEC_car_no_medals" call _L)};
        [("STR_ADVSEC_car_b_award" call _L), [[("STR_ADVSEC_car_f_medal" call _L), _opts select 0 select 1, _opts]], {
            params ["_u", "_v"];
            ["award", player, [getPlayerUID _u, name _u, _v select 0]] remoteExecCall ["ADVSEC_fnc_carServer", 2];
        }] call _pickUnit;
    };
    case "eval": {
        [("STR_ADVSEC_car_b_eval" call _L), [[("STR_ADVSEC_car_f_grade" call _L), "C", ["A", "B", "C", "D", "E"]], [("STR_ADVSEC_car_f_comment" call _L), ""]], {
            params ["_u", "_v"];
            ["evalSet", player, [getPlayerUID _u, name _u, _v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_carServer", 2];
        }] call _pickUnit;
    };
    case "school": {
        [("STR_ADVSEC_car_b_school" call _L), [[("STR_ADVSEC_car_f_passed" call _L), true, "bool"]], {
            params ["_u", "_v"];
            ["school", player, [getPlayerUID _u, name _u, _v select 0]] remoteExecCall ["ADVSEC_fnc_carServer", 2];
        }] call _pickUnit;
    };
    case "inspect": {
        private _u = [_arg, cursorTarget] select (isNull _arg);
        if (isNull _u || {!(_u isKindOf "CAManBase")} || {(player distance _u) > 6}) exitWith {
            [("STR_ADVSEC_car_b_inspect" call _L), [], {params ["_u"]; ["inspect", player, [_u]] remoteExecCall ["ADVSEC_fnc_carServer", 2]}] call _pickUnit;
        };
        ["inspect", [_u]] call _srv;
    };
    case "prio": {
        [("STR_ADVSEC_car_b_prio" call _L), [[("STR_ADVSEC_car_f_call" call _L), ""], [("STR_ADVSEC_car_f_prio" call _L), "Alta", ["Alta", "Media", "Baja"]]], {
            params ["_v"];
            ["priority", player, [_v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_carServer", 2];
        }] call ADVSEC_fnc_zeusPrompt;
    };
};
