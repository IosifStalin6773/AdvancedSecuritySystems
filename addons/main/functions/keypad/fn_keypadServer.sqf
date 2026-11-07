// ["pin"|"card", keypad, llamador, pin] (servidor). El PIN nunca sale del servidor.
params ["_mode", "_kp", "_caller", ["_pin", ""]];
if (!isServer || {isNull _kp} || {isNull _caller}) exitWith {};
if !([_caller, _kp, 6] call ADVSEC_fnc_srvCaller) exitWith {};
if (_kp getVariable ["ADVSEC_kpLockout", 0] > time) exitWith {
    ["BLOQUEADO", false] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
};

private _ok = (_caller distance _kp < 6) && {
    switch (_mode) do {
        case "pin": {_pin != "" && {_pin isEqualTo (_kp getVariable ["ADVSEC_pin", ""])}};
        case "card": {[_caller, _kp getVariable ["ADVSEC_kpReq", []]] call ADVSEC_fnc_accessCheck};
        default {false};
    }
};
// Alerta roja: además del PIN o la tarjeta hace falta un documento de identidad válido
if (_ok && {(missionNamespace getVariable ["ADVSEC_alertLevel", 0]) >= 2} && {!([_caller] call ADVSEC_fnc_isZeus)} && {!([_caller, [0, ["alertRedIdTypes", []] call ADVSEC_fnc_setting, ""]] call ADVSEC_fnc_accessCheck)}) exitWith {
    [("STR_ADVSEC_red_alert_identify_yourself" call ADVSEC_fnc_L), false] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
};
private _alarm = _kp getVariable ["ADVSEC_kpAlarm", objNull];
if (_alarm isEqualType "") then {
    private _i = ADVSEC_alarms findIf {(_x getVariable ["ADVSEC_alarmZone", ""]) isEqualTo _alarm};
    _alarm = if (_alarm isNotEqualTo "" && {_i > -1}) then {ADVSEC_alarms select _i} else {objNull};
};

if (!_ok) exitWith {
    private _fails = (_kp getVariable ["ADVSEC_kpFails", 0]) + 1;
    _kp setVariable ["ADVSEC_kpFails", _fails];
    if (_fails >= 3) then {
        _kp setVariable ["ADVSEC_kpFails", 0];
        _kp setVariable ["ADVSEC_kpLockout", time + 30, true];
        if (!isNull _alarm) then {[_alarm, "trigger", format [("STR_ADVSEC_keypad_forced_by" call ADVSEC_fnc_L), name _caller]] call ADVSEC_fnc_alarmSet};
        ["alert", _caller, ["keypadForce", format [("STR_ADVSEC_pmc_cy_kp_force" call ADVSEC_fnc_L), _kp getVariable ["ADVSEC_kpLabel", typeOf _kp], mapGridPosition _kp]]] call ADVSEC_fnc_cyServer;
    };
    [("STR_ADVSEC_access_denied" call ADVSEC_fnc_L), false] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
};
_kp setVariable ["ADVSEC_kpFails", 0];

private _doors = _kp getVariable ["ADVSEC_kpDoors", []];
private _lock = if (_doors isNotEqualTo []) then {
    (_doors select 0) params ["_b", "_i"];
    !(_b getVariable [format ["ADVSEC_locked_%1", _i], false])
} else {
    !(_alarm getVariable ["ADVSEC_armed", false])
};
{_x params ["_b", "_i"]; [_b, _i, _lock] call ADVSEC_fnc_doorSet} forEach _doors;
["keypadUse", _caller, [_kp getVariable ["ADVSEC_kpLabel", typeOf _kp], _mode, ["open", "lock"] select _lock]] call ADVSEC_fnc_logEvent;
// Acceso fuera de servicio a una zona restringida de la PMC
if (!_lock && {[_caller, "PM"] call ADVSEC_fnc_repAccess} && {!(_caller getVariable ["ADVSEC_onDuty", false])} && {!([_caller] call ADVSEC_fnc_isZeus)}) then {
    ["alert", _caller, ["offDutyAccess", format [("STR_ADVSEC_pmc_cy_offduty" call ADVSEC_fnc_L), name _caller, _kp getVariable ["ADVSEC_kpLabel", typeOf _kp], mapGridPosition _kp]]] call ADVSEC_fnc_cyServer;
};

if (!isNull _alarm) then {
    if (_lock) then {
        _alarm spawn {sleep 3; [_this, "arm"] call ADVSEC_fnc_alarmSet};
    } else {
        [_alarm, "disarm"] call ADVSEC_fnc_alarmSet;
    };
};
[[("STR_ADVSEC_access_granted_unlocked" call ADVSEC_fnc_L), ("STR_ADVSEC_access_granted_locked" call ADVSEC_fnc_L)] select _lock, true] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
