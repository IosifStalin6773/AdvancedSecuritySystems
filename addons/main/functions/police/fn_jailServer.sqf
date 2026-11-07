// ["jail"|"release"|"check", llamador, args] (servidor)
params ["_action", "_caller", ["_args", []]];
if (!isServer || {isNull _caller}) exitWith {};
if (isMultiplayer && {remoteExecutedOwner != 0} && {remoteExecutedOwner != owner _caller}) exitWith {};
if (isNil "ADVSEC_jailDB") then {[] call ADVSEC_fnc_policeDBLoad};
// Llamadas internas del servidor con una unidad IA como agente (checkpoint) no necesitan placa
private _sys = !(call ADVSEC_fnc_fromClient) && {!isPlayer _caller};
private _auth = {params ["_act"]; _sys || {[_caller, _act] call ADVSEC_fnc_perm}};
private _key = {params ["_u"]; private _uid = getPlayerUID _u; [_uid, "AI:" + netId _u] select (_uid isEqualTo "")};
private _say = {_this remoteExecCall ["hint", _caller]};
private _jailFor = {
    params ["_u", "_jail", "_secs", "_reason"];
    _u setVariable ["ADVSEC_jailUntil", serverTime + _secs, true];
    _u setVariable ["ADVSEC_jailObj", _jail, true];
    _u setVariable ["ADVSEC_jailReason", _reason, true];
    private _r = _jail getVariable ["ADVSEC_jailRadius", 6];
    private _pos = _jail getPos [random (_r * 0.5), random 360];
    _pos set [2, (getPosATL _jail) select 2];
    [_u, false] call ADVSEC_fnc_restrain;
    [_u, "teleport", [_pos]] call ADVSEC_fnc_policeLocal;
    if (isPlayer _u) then {[] remoteExecCall ["ADVSEC_fnc_jailClient", _u]};
};

switch (_action) do {
    case "jail": {
        if !(["arrest"] call _auth) exitWith {("STR_ADVSEC_you_have_no_authority_to" call ADVSEC_fnc_L) call _say};
        _args params ["_unit", ["_min", 10], ["_reason", ""], ["_jail", objNull], ["_report", true]];
        if (isNull _unit || {!alive _unit}) exitWith {};
        if (isNull _jail) then {
            _jail = ([ADVSEC_jails select {!isNull _x}, [], {_x distance _unit}, "ASCEND"] call BIS_fnc_sortBy) param [0, objNull];
        };
        if (isNull _jail) exitWith {("STR_ADVSEC_there_is_no_detention_centre_2" call ADVSEC_fnc_L) call _say};
        if (_reason isEqualTo "") then {_reason = ("STR_ADVSEC_unspecified" call ADVSEC_fnc_L)};
        private _secs = [_min * 60, 1e7] select (_min < 0);
        private _jname = _jail getVariable ["ADVSEC_jailName", ("STR_ADVSEC_cell" call ADVSEC_fnc_L)];
        ADVSEC_jailDB set [[_unit] call _key, [_secs, _reason, name _unit, name _caller, _jname]];
        ["jail"] call ADVSEC_fnc_policeDBSave;
        [_unit, _jail, _secs, _reason] call _jailFor;
        private _time = [("STR_ADVSEC_until_further_notice" call ADVSEC_fnc_L), format ["%1 min", _min]] select (_min > 0);
        (format [("STR_ADVSEC_is_taken_to" call ADVSEC_fnc_L), name _unit, _jname, _time]) call _say;
        ["jail", _caller, [name _unit, getPlayerUID _unit, _jname, _min, _reason]] call ADVSEC_fnc_logEvent;
        if (!_sys && {isPlayer _unit}) then {
            if !([getPlayerUID _unit] call ADVSEC_fnc_causeFor) then {[_caller, "arrestNoCause", name _unit] call ADVSEC_fnc_heatAdd};
            if (!_report) then {[_caller, "arrestNoReport", name _unit] call ADVSEC_fnc_heatAdd};
        };
        if (_report) then {
            ["create", _caller, [
                ["type", "FPM04"],
                ["gravity", "Grave"],
                ["confidential", false],
                ["subjects", [format ["%1 [%2]", name _unit, getPlayerUID _unit]]],
                ["title", format [("STR_ADVSEC_arrest_and_admission_to" call ADVSEC_fnc_L), _jname]],
                ["place", format [("STR_ADVSEC_grid_3" call ADVSEC_fnc_L), worldName, mapGridPosition _unit]],
                ["witnesses", ""],
                ["body", format [("STR_ADVSEC_arrested_by_reason_arrest_time" call ADVSEC_fnc_L), name _caller, getPlayerUID _caller, _reason, _time]],
                ["sanction", "Ninguna"]
            ]] call ADVSEC_fnc_repServer;
        };
    };
    case "release": {
        if !(["release"] call _auth) exitWith {("STR_ADVSEC_you_have_no_authority_to_2" call ADVSEC_fnc_L) call _say};
        _args params ["_unit"];
        if (isNull _unit) exitWith {};
        if (!_sys && {((_unit getVariable ["ADVSEC_jailUntil", 0]) - serverTime) > 60} && {(_unit getVariable ["ADVSEC_jailUntil", 0]) < 1e6} && {!([_caller] call ADVSEC_fnc_isZeus)}) then {
            [_caller, "earlyRelease", name _unit] call ADVSEC_fnc_heatAdd;
        };
        [_unit] call ADVSEC_fnc_jailRelease;
        ["release", _caller, [name _unit, getPlayerUID _unit]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_released" call ADVSEC_fnc_L), name _unit]) call _say;
    };
    case "check": {
        private _e = ADVSEC_jailDB getOrDefault [[_caller] call _key, []];
        if (_e isEqualTo []) exitWith {};
        _e params ["_secs", "_reason", "", "", "_jname"];
        if (_secs <= 0) exitWith {[_caller] call ADVSEC_fnc_jailRelease};
        private _jails = ADVSEC_jails select {!isNull _x};
        private _jail = (_jails select {(_x getVariable ["ADVSEC_jailName", ""]) isEqualTo _jname}) param [0, _jails param [0, objNull]];
        if (isNull _jail) exitWith {};
        [_caller, _jail, _secs, _reason] call _jailFor;
        ("STR_ADVSEC_you_have_a_pending_arrest" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
    };
};
