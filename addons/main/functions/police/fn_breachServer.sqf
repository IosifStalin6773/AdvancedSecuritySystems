// ["start"|"done", llamador, edificio, puerta] (servidor). El servidor cronometra el forzado y comprueba herramienta y distancia.
params ["_action", "_caller", "_b", "_i"];
if (!isServer || {isNull _b}) exitWith {};
if !([_caller, _b, ((boundingBoxReal _b) select 2) + 5] call ADVSEC_fnc_srvCaller) exitWith {};
private _item = (["breachItem", "ToolKit"] call ADVSEC_fnc_cfg);
if !(_item in (items _caller)) exitWith {[_caller, ("STR_ADVSEC_pick_a_lock_without_a" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _runs = localNamespace getVariable ["ADVSEC_breachRuns", createHashMap];
localNamespace setVariable ["ADVSEC_breachRuns", _runs];
private _key = netId _caller;

switch (_action) do {
    case "start": {
        if !(_b getVariable [format ["ADVSEC_locked_%1", _i], false]) exitWith {};
        _runs set [_key, [_b, _i, time]];
    };
    case "done": {
        private _run = _runs deleteAt _key;
        if (isNil "_run") exitWith {[_caller, ("STR_ADVSEC_complete_a_lockpick_that_was" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _run params ["_rb", "_ri", "_t0"];
        if (_rb isNotEqualTo _b || {_ri != _i} || {(time - _t0) < (((["breachTime", 20] call ADVSEC_fnc_cfg)) - 2)}) exitWith {
            [_caller, ("STR_ADVSEC_shorten_a_lockpick" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny;
        };
        [_b, _i, false] call ADVSEC_fnc_doorSet;
        ["breach", _caller, [typeOf _b, _i, mapGridPosition _b]] call ADVSEC_fnc_logEvent;
        {
            private _cfg = _x getVariable ["ADVSEC_alarmCfg", []];
            if ((_x getVariable ["ADVSEC_armed", false]) && {([_b, _i] in (_cfg param [2, []])) || {(_x distance _b) < ((_cfg param [0, 15]) max 30)}}) then {
                [_x, "trigger", format [("STR_ADVSEC_lock_forced" call ADVSEC_fnc_L), name _caller]] call ADVSEC_fnc_alarmSet;
            };
        } forEach (ADVSEC_alarms select {!isNull _x});
        ("STR_ADVSEC_lock_forced_2" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
    };
};
