/*
    [acción, llamador, args] (servidor, 1.24) — teléfono de comisaría
    "answer" [teléfono]: deja de sonar · "msg" [teléfono, texto]: deja un mensaje que entra en la central como aviso
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_obj", objNull]];
if !([_caller, _obj, 6] call ADVSEC_fnc_srvCaller) exitWith {};
switch (_action) do {
    case "answer": {
        if !([_caller, "PMC"] call ADVSEC_fnc_repAccess) exitWith {};
        ADVSEC_phoneRing = 0;
    };
    case "msg": {
        private _text = (_args param [1, ""]) select [0, 200];
        if (_text isEqualTo "") exitWith {};
        private _last = _caller getVariable ["ADVSEC_dspLast", -1e6];
        if (serverTime - _last < (["callCooldown", 60] call ADVSEC_fnc_setting)) exitWith {("STR_ADVSEC_wait_before_calling_112_again" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
        _caller setVariable ["ADVSEC_dspLast", serverTime];
        localNamespace setVariable ["ADVSEC_tipOK", true];
        ["tip", _caller, [_text, getPosATL _obj, name _caller]] call ADVSEC_fnc_dspServer;
        ("STR_ADVSEC_phone_left" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
    };
};
