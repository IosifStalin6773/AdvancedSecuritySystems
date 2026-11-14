/*
    [acción, llamador, args] (servidor) — custodia en el calabozo (1.22)
    "treat" [detenido]: atención médica (quita el daño) · "feed" [detenido]: comida registrada
    "register" [celda]: registro de custodia (informe F-PM con los detenidos actuales)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _detained = {params ["_u"]; (_u getVariable ["ADVSEC_jailUntil", 0]) > serverTime};
switch (_action) do {
    case "treat": {
        if !([_caller, "restrain"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_care_do" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_u", objNull]];
        if (isNull _u || {!([_u] call _detained)} || {(_caller distance _u) > 6}) exitWith {};
        [_u, 0] remoteExec ["setDamage", _u];
        _u setVariable ["ADVSEC_treated", serverTime, true];
        ["jailTreat", _caller, [name _u]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_care_done" call ADVSEC_fnc_L), name _u]) call _say;
        if (isPlayer _u) then {("STR_ADVSEC_m_care_you" call ADVSEC_fnc_L) remoteExecCall ["hint", _u]};
    };
    case "feed": {
        if !([_caller, "restrain"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_care_do" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_u", objNull]];
        if (isNull _u || {!([_u] call _detained)} || {(_caller distance _u) > 6}) exitWith {};
        _u setVariable ["ADVSEC_fedAt", serverTime, true];
        ["jailFeed", _caller, [name _u]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_care_fed" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "register": {
        if !([_caller, "restrain"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_care_do" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _rows = [];
        {
            if (_x isEqualType objNull && {[_x] call _detained}) then {
                _rows pushBack format ["- %1 · %2 · %3", name _x, _x getVariable ["ADVSEC_jailReason", ""], [("STR_ADVSEC_m_care_fed_no" call ADVSEC_fnc_L), ("STR_ADVSEC_m_care_fed_yes" call ADVSEC_fnc_L)] select (_x getVariable ["ADVSEC_fedAt", -1] > 0)];
            };
        } forEach (allPlayers + (allUnits select {!isPlayer _x && {[_x] call _detained}}));
        if (_rows isEqualTo []) exitWith {("STR_ADVSEC_m_care_none" call ADVSEC_fnc_L) call _say};
        private _id = ["FPM03", ("STR_ADVSEC_m_care_reg_title" call ADVSEC_fnc_L), [], format [("STR_ADVSEC_m_care_reg_body" call ADVSEC_fnc_L), name _caller, _rows joinString toString [10]], "Leve", false] call ADVSEC_fnc_repSystem;
        (format [("STR_ADVSEC_m_care_reg_done" call ADVSEC_fnc_L), _id]) call _say;
    };
};
