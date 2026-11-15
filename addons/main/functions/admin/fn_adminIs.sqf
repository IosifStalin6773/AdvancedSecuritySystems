// [unidad] -> bool: superadministrador = Zeus, o el jugador local que ha entrado con #login admin (1.22.3).
// En el servidor (llamadas con _caller) se mantiene la lista de superadministradores, porque un cliente remoto no puede comprobar #login.
params ["_unit"];
if ([_unit] call ADVSEC_fnc_isZeus) exitWith {true};
if (hasInterface && {_unit isEqualTo player}) exitWith {serverCommandAvailable "#exec"};
private _uid = getPlayerUID _unit;
_uid isNotEqualTo "" && {
    _uid in (missionNamespace getVariable ["ADVSEC_superAdmins", []])
    || {_uid in (["superAdmins", []] call ADVSEC_fnc_setting)}
}
