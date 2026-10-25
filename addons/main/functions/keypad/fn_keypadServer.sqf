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
    ["ALERTA ROJA: IDENTIFÍQUESE", false] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
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
        if (!isNull _alarm) then {[_alarm, "trigger", format ["keypad forzado por %1", name _caller]] call ADVSEC_fnc_alarmSet};
    };
    ["ACCESO DENEGADO", false] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
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

if (!isNull _alarm) then {
    if (_lock) then {
        _alarm spawn {sleep 3; [_this, "arm"] call ADVSEC_fnc_alarmSet};
    } else {
        [_alarm, "disarm"] call ADVSEC_fnc_alarmSet;
    };
};
[["ACCESO CONCEDIDO - ABIERTO", "ACCESO CONCEDIDO - CERRADO"] select _lock, true] remoteExecCall ["ADVSEC_fnc_keypadFeedback", _caller];
