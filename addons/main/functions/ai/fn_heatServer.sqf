// ["list"|"reset", llamador, args] (servidor) — índice de sospecha para AA.II.
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "suspicionView"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_view_the_suspicion_index" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _db = [] call ADVSEC_fnc_heatDB;
switch (_action) do {
    case "list": {
        private _thr = ["heatThreshold", 30] call ADVSEC_fnc_setting;
        private _rows = [];
        {
            private _e = [_x] call ADVSEC_fnc_heatGet;
            _e params ["_heat", "", "_events", "_name", "_case"];
            if (_heat > 0 || {_case isNotEqualTo ""}) then {
                private _ev = (_events select [(count _events - 15) max 0]) apply {
                    format ["<t color='#8C8C8C'>%1</t> · %2 <t color='#FF8040'>+%3</t>", _x select 0, [_x select 1] call ADVSEC_fnc_repEsc, _x select 2]
                };
                reverse _ev;
                private _detail = format [("STR_ADVSEC_steamid_current_index_threshold_case" call ADVSEC_fnc_L),
                    [_name] call ADVSEC_fnc_repEsc, _x, round _heat, _thr, ["ninguno", _case] select (_case isNotEqualTo ""), _ev joinString "<br/>"];
                private _col = switch (true) do {
                    case (_heat >= _thr): {[1, 0.3, 0.3, 1]};
                    case (_heat >= _thr / 2): {[1, 0.6, 0.2, 1]};
                    default {[]};
                };
                _rows pushBack [round _heat, [format ["%1 · %2 pts%3", _name, round _heat, [("STR_ADVSEC_case_file" call ADVSEC_fnc_L) + _case, ""] select (_case isEqualTo "")], _x, _detail, _col, ADVSEC_icPol]];
            };
        } forEach (keys _db);
        _rows sort false;
        ["heat", format [("STR_ADVSEC_officers_with_indications_automatic_case" call ADVSEC_fnc_L), count _rows, _thr], _rows apply {_x select 1}] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "reset": {
        if !([_caller, "caseClose"] call ADVSEC_fnc_perm) exitWith {("STR_ADVSEC_your_rank_does_not_allow" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        _args params [["_uid", ""]];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {};
        _e set [0, 0];
        _e set [4, ""];
        (_e select 2) pushBack [call ADVSEC_fnc_now, format [("STR_ADVSEC_index_archived_by" call ADVSEC_fnc_L), name _caller], 0];
        ["heat"] call ADVSEC_fnc_dbDirty;
        ["heatReset", _caller, [_uid, _e select 3]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_heatServer;
    };
};
