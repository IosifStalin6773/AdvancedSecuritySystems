/*
    [keypad, PIN, [[edificio, puerta], ...], alarma (objeto o zona), requisitoTarjeta, etiqueta]
    PIN correcto o tarjeta válida: alterna bloqueo de puertas y arma/desarma la alarma.
*/
params ["_kp", "_pin", ["_doors", []], ["_alarm", objNull], ["_req", []], ["_label", "INTRODUZCA PIN"]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _kp) exitWith {};
if (_pin isEqualType 0) then {_pin = str _pin};
if (isServer) then {[_kp, "keypad", _label] call ADVSEC_fnc_register};
{_x params ["_b", "_i"]; [_b, [_i]] call ADVSEC_fnc_breachActions} forEach _doors;

if (isServer) then {
    _kp setVariable ["ADVSEC_pin", _pin];
    _kp setVariable ["ADVSEC_kpDoors", _doors, true];
    _kp setVariable ["ADVSEC_kpAlarm", _alarm, true];
    _kp setVariable ["ADVSEC_kpReq", _req, true];
    {_x params ["_b", "_i"]; [_b, _i, true] call ADVSEC_fnc_doorSet} forEach _doors;
};
_kp setVariable ["ADVSEC_kpLabel", _label];

[_kp, "advsec_kp_pin", "Usar keypad", ADVSEC_icPad,
    {[_target] call ADVSEC_fnc_keypadOpen},
    {true},
    "main", [], 2.5
] call ADVSEC_fnc_addInteraction;

if (_req isNotEqualTo []) then {
    [_kp, "advsec_kp_card", "Pasar tarjeta / documento", ADVSEC_icKey,
        {["card", _target, _player] remoteExecCall ["ADVSEC_fnc_keypadServer", 2]},
        {[_player, _args] call ADVSEC_fnc_accessCheck},
        "main", _req, 2.5
    ] call ADVSEC_fnc_addInteraction;
};
