/*
    [objeto, radio, requisito de zona ([] = sin control de zona), [[edificio, puerta], ...], armada, nombre, zona]
    Armada: salta si hay un jugador sin documentación válida en el radio o se abre una puerta vigilada.
*/
params ["_alarm", ["_radius", 15], ["_req", []], ["_doors", []], ["_armed", true], ["_name", "Alarma"], ["_zone", ""]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _alarm) exitWith {};

if (isServer) then {
    [_alarm, "alarm", _name, _zone] call ADVSEC_fnc_register;
    _alarm setVariable ["ADVSEC_alarmCfg", [_radius, _req, _doors], true];
    _alarm setVariable ["ADVSEC_alarmName", _name, true];
    _alarm setVariable ["ADVSEC_alarmZone", _zone, true];
    _alarm setVariable ["ADVSEC_armed", _armed, true];
    _alarm setVariable ["ADVSEC_active", false, true];
    ADVSEC_alarms pushBackUnique _alarm;
    publicVariable "ADVSEC_alarms";
    if (isNil "ADVSEC_alarmLoopH") then {ADVSEC_alarmLoopH = [] spawn ADVSEC_fnc_alarmLoop};
};

if (_req isNotEqualTo []) then {
    [_alarm, "advsec_alarm_off", "Desarmar alarma", ADVSEC_icAlarm,
        {[_target, "disarm"] call ADVSEC_fnc_alarmSet},
        {(_target getVariable ["ADVSEC_armed", false]) && {[_player, _args] call ADVSEC_fnc_accessCheck}},
        "main", _req, 3
    ] call ADVSEC_fnc_addInteraction;
    [_alarm, "advsec_alarm_on", "Armar alarma", ADVSEC_icAlarm,
        {[_target, "arm"] call ADVSEC_fnc_alarmSet},
        {!(_target getVariable ["ADVSEC_armed", false]) && {[_player, _args] call ADVSEC_fnc_accessCheck}},
        "main", _req, 3
    ] call ADVSEC_fnc_addInteraction;
};
