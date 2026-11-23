// [detenido] (servidor) — intento de fuga: 50 % de éxito; si fracasa, daño y informe
params ["_u"];
private _veh = objectParent _u;
if (isNull _veh) exitWith {};
private _ok = random 1 < 0.5;
if (_ok) then {
    _u setVariable ["ADVSEC_jailUntil", serverTime, true];
    [_u, "unload"] remoteExecCall ["ADVSEC_fnc_policeLocal", _u];
    if (isPlayer _u) then {
        ("STR_ADVSEC_m_escape_ok_you" call ADVSEC_fnc_L) remoteExecCall ["hint", _u];
        [getPlayerUID _u, name _u, ("STR_ADVSEC_m_escape_ok_you" call ADVSEC_fnc_L), "Alta"] call ADVSEC_fnc_wantedSys;
    };
    ["escape", objNull, [name _u, mapGridPosition _u]] call ADVSEC_fnc_logEvent;
    ["FPM04", format [("STR_ADVSEC_m_escape_rep" call ADVSEC_fnc_L), name _u], [format ["%1 [%2]", name _u, getPlayerUID _u]],
        format [("STR_ADVSEC_m_escape_body" call ADVSEC_fnc_L), mapGridPosition _u, name _u], "Grave", false] call ADVSEC_fnc_repSystem;
} else {
    _u setDamage ((damage _u) + 0.35);
    ["escapeFail", objNull, [name _u, mapGridPosition _u]] call ADVSEC_fnc_logEvent;
    ["FPM04", format [("STR_ADVSEC_m_escape_fail_rep" call ADVSEC_fnc_L), name _u], [format ["%1 [%2]", name _u, getPlayerUID _u]],
        format [("STR_ADVSEC_m_escape_fail_body" call ADVSEC_fnc_L), mapGridPosition _u, name _u], "Leve", false] call ADVSEC_fnc_repSystem;
};
