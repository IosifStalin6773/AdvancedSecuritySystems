// [unidad] -> bool: superadministrador (1.22.4) = Zeus asignado o administrador con #login admin.
// Ya no cuenta el modo un jugador / vista previa de Eden ni el voto de administrador.
// El jugador local se comprueba con serverCommandAvailable (#login admin; en partida alojada, el anfitrión).
// En el servidor, para otro jugador: administrador con sesión (admin = 2) o SteamID en la lista de superadministradores
// (la lista no le enseña el terminal: en su menú solo cuenta Zeus o #login).
params ["_unit"];
if (isNull _unit) exitWith {false};
if (!isNull getAssignedCuratorLogic _unit) exitWith {true};
if (hasInterface && {_unit isEqualTo player}) exitWith {isMultiplayer && {serverCommandAvailable "#exec"}};
if (!isServer || {!isMultiplayer}) exitWith {false};
if ((admin owner _unit) isEqualTo 2) exitWith {true};
private _uid = getPlayerUID _unit;
_uid isNotEqualTo "" && {
    _uid in (missionNamespace getVariable ["ADVSEC_superAdmins", []])
    || {_uid in (["superAdmins", []] call ADVSEC_fnc_setting)}
}
