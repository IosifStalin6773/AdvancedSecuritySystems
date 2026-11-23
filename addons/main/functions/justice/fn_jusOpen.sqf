// Justicia militar (cliente, 1.24): Artículo 15, consejo de guerra y juicios
params [["_mode", ""]];
private _L = {_this call ADVSEC_fnc_L};
private _send = {params ["_a", "_args"]; [_a, player, _args] remoteExecCall ["ADVSEC_fnc_jusServer", 2]};
switch (_mode) do {
    case "": {
        private _rows = [];
        if ([player, "article15"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_jus_b_art15" call _L), "['art15'] call ADVSEC_fnc_jusOpen"]};
        if ([player, "courtMartial"] call ADVSEC_fnc_perm) then {_rows pushBack [("STR_ADVSEC_jus_b_court" call _L), "['court'] call ADVSEC_fnc_jusOpen"]};
        if ([player, "trial"] call ADVSEC_fnc_perm) then {
            _rows pushBack [("STR_ADVSEC_jus_b_trial" call _L), "['trial'] call ADVSEC_fnc_jusOpen"];
            _rows pushBack [("STR_ADVSEC_jus_b_trials" call _L), "['trials'] call ADVSEC_fnc_jusOpen"];
        };
        if (_rows isEqualTo []) exitWith {hint ("STR_ADVSEC_jus_no_any" call _L)};
        ["jusMenu", ("STR_ADVSEC_jus_menu" call _L), [[("STR_ADVSEC_car_open" call _L), {params ["_d"]; if (_d isEqualType "") then {closeDialog 0; [_d] spawn {sleep 0.1; call compile (_this select 0)}}}]], {}] call ADVSEC_fnc_panelOpen;
        ["jusMenu", ("STR_ADVSEC_jus_menu_info" call _L), _rows apply {[_x select 0, _x select 1, "", [], ""]}] call ADVSEC_fnc_panelSet;
    };
    case "art15": {
        [("STR_ADVSEC_jus_b_art15" call _L), [[("STR_ADVSEC_car_f_who" call _L), objNull, "players"], [("STR_ADVSEC_car_f_why" call _L), ""]], {
            params ["_v"];
            ["art15", player, [_v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_jusServer", 2];
        }] call ADVSEC_fnc_zeusPrompt;
    };
    case "court": {
        [("STR_ADVSEC_jus_b_court" call _L), [
            [("STR_ADVSEC_car_f_who" call _L), objNull, "players"],
            [("STR_ADVSEC_jus_f_charge" call _L), ""],
            [("STR_ADVSEC_jus_f_sev" call _L), 1, [["1", 1], ["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6]]],
            [("STR_ADVSEC_jus_f_verdict" call _L), "acquit", [[("STR_ADVSEC_jus_v_acquit" call _L), "acquit"], [("STR_ADVSEC_jus_v_fine" call _L), "fine"], [("STR_ADVSEC_jus_v_reduce" call _L), "reduce"]]],
            [("STR_ADVSEC_jus_f_amount" call _L), "0"]
        ], {
            params ["_v"];
            ["court", player, [_v select 0, _v select 1, _v select 2, _v select 3, parseNumber (_v select 4)]] remoteExecCall ["ADVSEC_fnc_jusServer", 2];
        }] call ADVSEC_fnc_zeusPrompt;
    };
    case "trial": {
        // El acusado: la persona a la que apuntas, o un jugador de la lista
        private _t = cursorTarget;
        private _fields = [[("STR_ADVSEC_jus_f_charge" call _L), ""], [("STR_ADVSEC_jus_f_sev" call _L), 2, [["1", 1], ["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6]]]];
        if (isNull _t || {!(_t isKindOf "CAManBase")} || {(player distance _t) > 15}) then {
            [("STR_ADVSEC_jus_b_trial" call _L), [[("STR_ADVSEC_car_f_who" call _L), objNull, "players"]] + _fields, {
                params ["_v"];
                ["trialStart", player, [_v select 0, _v select 1, _v select 2]] remoteExecCall ["ADVSEC_fnc_jusServer", 2];
            }] call ADVSEC_fnc_zeusPrompt;
        } else {
            [format ["%1 · %2", ("STR_ADVSEC_jus_b_trial" call _L), name _t], _fields, {
                params ["_v", "_t"];
                ["trialStart", player, [_t, _v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_jusServer", 2];
            }, _t] call ADVSEC_fnc_zeusPrompt;
        };
    };
    case "trials": {
        ["trials", ("STR_ADVSEC_jus_b_trials" call _L), [
            [("STR_ADVSEC_jus_b_exhibit" call _L), {params ["_id"]; if (isNil "_id") exitWith {}; [("STR_ADVSEC_jus_b_exhibit" call ADVSEC_fnc_L), [[("STR_ADVSEC_jus_f_exhibit" call ADVSEC_fnc_L), "", "text"]], {params ["_v", "_id"]; ["trialExhibit", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_jusServer", 2]}, _id] call ADVSEC_fnc_zeusPrompt}],
            [("STR_ADVSEC_jus_b_plea_ai" call _L), {params ["_id"]; if (isNil "_id") exitWith {}; ["trialPlea", player, [_id, false]] remoteExecCall ["ADVSEC_fnc_jusServer", 2]; [] spawn {sleep 0.5; ["refresh"] call ADVSEC_fnc_panelAction}}],
            [("STR_ADVSEC_jus_b_rest" call _L), {params ["_id"]; if (isNil "_id") exitWith {}; ["trialRest", player, [_id]] remoteExecCall ["ADVSEC_fnc_jusServer", 2]; [] spawn {sleep 0.5; ["refresh"] call ADVSEC_fnc_panelAction}}],
            [("STR_ADVSEC_refresh" call _L), {["refresh"] call ADVSEC_fnc_panelAction}]
        ], {["trialList", player, []] remoteExecCall ["ADVSEC_fnc_jusServer", 2]}] call ADVSEC_fnc_panelOpen;
    };
};
