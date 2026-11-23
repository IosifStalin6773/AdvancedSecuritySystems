/*
    [llamador] (servidor) — exporta el registro de auditoría (1.22): vuelca las últimas auditExportN entradas
    al registro de la partida (RPT) con marcas de inicio y fin, y avisa a quien lo pide con el número de líneas.
    Cada línea: fecha UTC, tiempo de servidor, tipo, nombre, SteamID, posición, datos.
*/
params [["_caller", objNull]];
if (!isServer) exitWith {};
if !([_caller, "bankAudit"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_audit_export_no" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _log = localNamespace getVariable ["ADVSEC_eventLog", []];
private _n = (["auditExportN", 200] call ADVSEC_fnc_setting) max 1;
private _from = (count _log - _n) max 0;
diag_log "[ADVSEC] AUDITORIA_INICIO";
for "_i" from _from to (count _log - 1) do {
    diag_log format ["[ADVSEC] AUDITORIA %1", (_log select _i) joinString " | "];
};
diag_log "[ADVSEC] AUDITORIA_FIN";
["auditExport", _caller, [count _log - _from]] call ADVSEC_fnc_logEvent;
(format [("STR_ADVSEC_m_audit_export_done" call ADVSEC_fnc_L), count _log - _from]) remoteExecCall ["hint", _caller];
