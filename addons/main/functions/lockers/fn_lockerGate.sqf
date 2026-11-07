/*
    [taquilla, jugador, operación] -> bool (servidor y cliente)
    Puerta de ADVSEC para las taquillas TS_Lockers: quién puede reclamar una, bloqueo a detenidos y registro de eventos.
    Los superadministradores pasan siempre.
*/
params ["_l", "_p", ["_op", ""]];
if (isNull _p) exitWith {false};
private _why = "";
if !([_p] call ADVSEC_fnc_adminIs) then {
    if ((["lockerJailBlock", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {(_p getVariable ["ADVSEC_jailUntil", 0]) > serverTime}) then {
        _why = "Estás detenido: no puedes usar tu taquilla.";
    };
    if (_why isEqualTo "" && {_op in ["claim", "open"]} && {(_l getVariable ["TSL_owner", ""]) isEqualTo ""}) then {
        private _acc = ["lockerAccess", 0] call ADVSEC_fnc_setting;
        private _pm = [_p, "PM"] call ADVSEC_fnc_rankLevel;
        private _ai = [_p, "AI"] call ADVSEC_fnc_rankLevel;
        if (_acc isEqualTo 1 && {_pm < 1}) then {_why = "Solo la Policía Militar puede tener taquilla."};
        if (_acc isEqualTo 2 && {_pm < 1} && {_ai < 1}) then {_why = "Solo la Policía Militar o Asuntos Internos pueden tener taquilla."};
        private _req = _l getVariable ["ADVSEC_req", []];
        if (_why isEqualTo "" && {_req isNotEqualTo []} && {!([_p, _req] call ADVSEC_fnc_accessCheck)}) then {_why = "No tienes la autorización que pide esta taquilla."};
    };
};
if (_why isNotEqualTo "") exitWith {
    if (local _p) then {hint _why} else {[_why] remoteExecCall ["TSL_fnc_notice", owner _p]};
    false
};
if (isServer && {_op in ["claim", "release", "reset"]}) then {
    [["lockerClaim", "lockerRelease", "lockerReset"] select (["claim", "release", "reset"] find _op), _p, [mapGridPosition _l, typeOf _l]] call ADVSEC_fnc_logEvent;
};
true
