params ["_action"];
private _disp = findDisplay 86900;
if (isNull _disp) exitWith {};
private _lb = _disp displayCtrl 86901;
private _e = (missionNamespace getVariable ["ADVSEC_wantedRows", []]) param [lbCurSel _lb, []];
private _lvlCol = {
    switch (_this) do {
        case "Extrema": {[1, 0.302, 0.302, 1]};
        case "Alta": {[0.851, 0.4, 0, 1]};
        case "Media": {[0.851, 0.639, 0, 1]};
        default {[0.498, 0.851, 0, 1]};
    }
};

switch (_action) do {
    case "fill": {
        ADVSEC_wantedRows = missionNamespace getVariable ["ADVSEC_wanted", []];
        lbClear _lb;
        {
            _x params ["_uid", "_name", "_reason", "_level"];
            private _online = allPlayers findIf {getPlayerUID _x == _uid} > -1;
            private _i = _lb lbAdd format ["%1 · %2 · %3%4", toUpper _level, _name, _reason, ["", ("STR_ADVSEC_online_6" call ADVSEC_fnc_L)] select _online];
            _lb lbSetColor [_i, _level call _lvlCol];
        } forEach ADVSEC_wantedRows;
        if (ADVSEC_wantedRows isEqualTo []) then {
            (_disp displayCtrl 86902) ctrlSetStructuredText parseText ("STR_ADVSEC_there_is_nobody_on_the" call ADVSEC_fnc_L);
        } else {
            _lb lbSetCurSel 0;
        };
    };
    case "select": {
        if (_e isEqualTo []) exitWith {};
        _e params ["_uid", "_name", "_reason", "_level", "_by", "_date"];
        private _u = allPlayers select {getPlayerUID _x == _uid};
        (_disp displayCtrl 86902) ctrlSetStructuredText parseText format [
            ("STR_ADVSEC_reason_danger_level_added_by" call ADVSEC_fnc_L),
            [_name] call ADVSEC_fnc_repEsc, _uid, [_reason] call ADVSEC_fnc_repEsc, _level, _date, [_by] call ADVSEC_fnc_repEsc,
            if (_u isEqualTo []) then {("STR_ADVSEC_not_connected" call ADVSEC_fnc_L)} else {format [("STR_ADVSEC_connected_last_position_grid" call ADVSEC_fnc_L), mapGridPosition (_u select 0)]}
        ];
    };
    case "add": {[] call ADVSEC_fnc_wantedPrompt};
    case "del": {
        if (_e isEqualTo []) exitWith {hint ("STR_ADVSEC_select_an_entry" call ADVSEC_fnc_L)};
        ["del", player, [_e select 0]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2];
    };
    case "report": {
        if (_e isEqualTo []) exitWith {hint ("STR_ADVSEC_select_an_entry" call ADVSEC_fnc_L)};
        closeDialog 0;
        ["PM", format ["%1 [%2]", _e select 1, _e select 0], format [("STR_ADVSEC_warrant_3" call ADVSEC_fnc_L), _e select 1], format [("STR_ADVSEC_reason_for_the_warrant" call ADVSEC_fnc_L), _e select 2]] call ADVSEC_fnc_repEditorOpen;
    };
};
