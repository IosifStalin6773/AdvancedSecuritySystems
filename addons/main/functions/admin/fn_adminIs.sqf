// [unidad] -> bool: superadministrador (Zeus/administrador, modo un jugador, o SteamID en la lista de superadministradores)
params ["_unit"];
if ([_unit] call ADVSEC_fnc_isZeus) exitWith {true};
private _uid = getPlayerUID _unit;
_uid isNotEqualTo "" && {
    _uid in (missionNamespace getVariable ["ADVSEC_superAdmins", []])
    || {_uid in (["superAdmins", []] call ADVSEC_fnc_setting)}
}
