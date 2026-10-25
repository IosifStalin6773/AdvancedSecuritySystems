// [alarma, "arm"|"disarm"|"silence"|"trigger", motivo, llamador] (servidor). Desde un cliente: Zeus, o requisito de la alarma para armar/desarmar/silenciar.
params ["_alarm", "_mode", ["_reason", ""], ["_caller", objNull]];
if (!isServer) exitWith {[_alarm, _mode, _reason, player] remoteExecCall ["ADVSEC_fnc_alarmSet", 2]};
if (isNull _alarm) exitWith {};
if (call ADVSEC_fnc_fromClient) then {
    if !([_caller, _alarm, 10] call ADVSEC_fnc_srvCaller) exitWith {_mode = ""};
    private _req = (_alarm getVariable ["ADVSEC_alarmCfg", [15, [], []]]) param [1, []];
    if !(
        [_caller] call ADVSEC_fnc_isZeus
        || {_mode in ["arm", "disarm", "silence"] && {_req isNotEqualTo []} && {[_caller, _req] call ADVSEC_fnc_accessCheck}}
    ) then {[_caller, format ["%1 la alarma %2", _mode, _alarm getVariable ["ADVSEC_alarmName", ""]]] call ADVSEC_fnc_deny; _mode = ""};
};

switch (_mode) do {
    case "arm": {_alarm setVariable ["ADVSEC_armed", true, true]};
    case "disarm": {
        _alarm setVariable ["ADVSEC_armed", false, true];
        _alarm setVariable ["ADVSEC_active", false, true];
    };
    case "silence": {_alarm setVariable ["ADVSEC_active", false, true]};
    case "trigger": {
        if (_alarm getVariable ["ADVSEC_active", false]) exitWith {};
        _alarm setVariable ["ADVSEC_active", true, true];
        _alarm setVariable ["ADVSEC_reason", _reason, true];
        (format ["ALARMA %1: %2", _alarm getVariable ["ADVSEC_alarmName", ""], _reason]) remoteExecCall ["systemChat", 0];
        _alarm spawn {
            while {alive _this && {_this getVariable ["ADVSEC_active", false]}} do {
                playSound3D [ADVSEC_alarmSound, _this, false, getPosASL _this, 5, 1, 400];
                sleep 2.5;
            };
        };
    };
};
