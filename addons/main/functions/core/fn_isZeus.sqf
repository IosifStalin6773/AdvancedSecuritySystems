// [unidad] -> bool: Zeus asignado, administrador o un jugador
params ["_unit"];
if (!isMultiplayer) exitWith {true};
if (isNull _unit) exitWith {false};
if (!isNull getAssignedCuratorLogic _unit) exitWith {true};
if (isServer && {(admin owner _unit) > 0}) exitWith {true};
_unit isEqualTo player && {(call BIS_fnc_admin) > 0}
