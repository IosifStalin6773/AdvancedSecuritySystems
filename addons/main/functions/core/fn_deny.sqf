// [llamador, acción] (servidor): registra y avisa de una petición sin autorización
params ["_caller", "_what"];
diag_log format [("STR_ADVSEC_advsec_unauthorised_tried_to" call ADVSEC_fnc_L), name _caller, getPlayerUID _caller, _what];
if (!isNull _caller) then {("STR_ADVSEC_you_are_not_authorised_to" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller]};
