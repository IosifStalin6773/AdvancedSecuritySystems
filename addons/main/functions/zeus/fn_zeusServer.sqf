// ["pin", llamador, [keypad, pin]] (servidor). Solo Zeus/admin.
params ["_action", "_caller", ["_args", []]];
if (!isServer || {isNull _caller}) exitWith {};
if (isMultiplayer && {remoteExecutedOwner != 0} && {remoteExecutedOwner != owner _caller}) exitWith {};
if !([_caller] call ADVSEC_fnc_isZeus) exitWith {"Solo Zeus o administradores." remoteExecCall ["hint", _caller]};

switch (_action) do {
    case "pin": {
        _args params ["_kp", "_pin"];
        _kp setVariable ["ADVSEC_pin", _pin];
        _kp setVariable ["ADVSEC_kpFails", 0];
        _kp setVariable ["ADVSEC_kpLockout", 0, true];
        (format ["PIN actualizado (%1).", _pin]) remoteExecCall ["hint", _caller];
    };
};
