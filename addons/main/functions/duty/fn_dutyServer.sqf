// [acción, llamador, args] (servidor) — "toggle" [terminal] · "list" · "bodycam" (alternar)
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
switch (_action) do {
    case "toggle": {
        _args params [["_term", objNull]];
        if !([_caller, "PM"] call ADVSEC_fnc_repAccess || {[_caller, "AI"] call ADVSEC_fnc_repAccess}) exitWith {("STR_ADVSEC_you_need_an_mp_badge" call ADVSEC_fnc_L) call _say};
        if ((["dutyAnywhere", 1] call ADVSEC_fnc_setting) isNotEqualTo 1 && {isNull _term || {!(_term getVariable ["ADVSEC_dutyTerm", false])} || {(_caller distance _term) > 6}}) exitWith {("STR_ADVSEC_clock_in_at_a_duty" call ADVSEC_fnc_L) call _say};
        private _on = !(_caller getVariable ["ADVSEC_onDuty", false]);
        [_caller, _on] call ADVSEC_fnc_dutySet;
        private _h = (([] call ADVSEC_fnc_dutyDB) getOrDefault [getPlayerUID _caller, [0]]) select 0;
        (format [("STR_ADVSEC_accumulated_duty_hours_h_min" call ADVSEC_fnc_L), [("STR_ADVSEC_end_of_duty" call ADVSEC_fnc_L), ("STR_ADVSEC_on_duty" call ADVSEC_fnc_L)] select _on, floor (_h / 60), _h mod 60, ["", ("STR_ADVSEC_body_camera_on" call ADVSEC_fnc_L)] select _on]) call _say;
    };
    case "bodycam": {
        if !(_caller getVariable ["ADVSEC_onDuty", false]) exitWith {("STR_ADVSEC_the_body_camera_can_only" call ADVSEC_fnc_L) call _say};
        private _on = !(_caller getVariable ["ADVSEC_bodycam", false]);
        _caller setVariable ["ADVSEC_bodycam", _on, true];
        [["bodycamOff", "bodycamOn"] select _on, _caller, []] call ADVSEC_fnc_logEvent;
        if (!_on) then {[_caller, "bodycamOff", ("STR_ADVSEC_turned_off_the_duty_camera" call ADVSEC_fnc_L)] call ADVSEC_fnc_heatAdd};
        ([("STR_ADVSEC_body_camera_off_this_is" call ADVSEC_fnc_L), ("STR_ADVSEC_body_camera_on_2" call ADVSEC_fnc_L)] select _on) call _say;
    };
    case "list": {
        if !([_caller, "dutyView"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_view_duty_control" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _rows = [];
        {
            _y params ["_min", "_name", "_shifts"];
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            private _on = !isNull _u && {_u getVariable ["ADVSEC_onDuty", false]};
            if (_on) then {_min = _min + round ((serverTime - (_u getVariable ["ADVSEC_dutyStart", serverTime])) / 60)};
            _rows pushBack [format ["%1%2 · %3 h %4 min", ["", "● "] select _on, _name, floor (_min / 60), _min mod 60], _x,
                format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Total: %3 h %4 min<br/><br/>%5", _name call ADVSEC_fnc_repEsc, [("STR_ADVSEC_off_duty" call ADVSEC_fnc_L), ("STR_ADVSEC_on_duty_2" call ADVSEC_fnc_L)] select _on, floor (_min / 60), _min mod 60,
                    ((_shifts select [((count _shifts) - 12) max 0]) apply {format ["%1 -> %2 · %3 min", _x select 0, _x select 1, _x select 2]}) joinString "<br/>"], [[], [0.45, 1, 0.45, 1]] select _on, ""];
        } forEach ([] call ADVSEC_fnc_dutyDB);
        ["duty", format [("STR_ADVSEC_officers_with_recorded_shifts_on" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
