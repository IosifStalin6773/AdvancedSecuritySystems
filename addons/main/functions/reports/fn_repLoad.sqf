// Servidor: carga el archivo de informes desde profileNamespace (persiste entre misiones y reinicios)
if (!isServer) exitWith {};
ADVSEC_repKey = getMissionConfigValue ["ADVSEC_reportKey", "ADVSEC_reports"];
ADVSEC_repDB = createHashMap;
{
    private _r = createHashMapFromArray _x;
    ADVSEC_repDB set [_r get "id", _r];
} forEach (profileNamespace getVariable [ADVSEC_repKey, []]);
ADVSEC_repSeq = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_seq", []]);
diag_log format ["[ADVSEC] Archivo de informes '%1' cargado: %2 informes", ADVSEC_repKey, count ADVSEC_repDB];
