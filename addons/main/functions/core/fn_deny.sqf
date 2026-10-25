// [llamador, acción] (servidor): registra y avisa de una petición sin autorización
params ["_caller", "_what"];
diag_log format ["[ADVSEC] Sin autorización: %1 (%2) intentó %3", name _caller, getPlayerUID _caller, _what];
if (!isNull _caller) then {"No tienes autorización para eso." remoteExecCall ["hint", _caller]};
