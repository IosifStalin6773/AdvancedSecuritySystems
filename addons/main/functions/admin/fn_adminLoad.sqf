// (servidor): carga la lista persistente de superadministradores y la publica (mision + perfil del servidor)
if (!isServer) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _list = +(profileNamespace getVariable [ADVSEC_repKey + "_admins", []]);
localNamespace setVariable ["ADVSEC_adminList", _list];
ADVSEC_superAdmins = _list + (["superAdmins", []] call ADVSEC_fnc_setting);
publicVariable "ADVSEC_superAdmins";
