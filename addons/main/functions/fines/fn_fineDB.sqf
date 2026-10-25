// -> HashMap clave (SteamID o "AI:"netId) -> multas [[id, fecha, importe, motivo, agente, uidAgente, estado, nombre, nota], ...] (servidor)
private _db = localNamespace getVariable "ADVSEC_fineDB";
if (isNil "_db") then {
    if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
    _db = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_fines", []]);
    localNamespace setVariable ["ADVSEC_fineDB", _db];
    localNamespace setVariable ["ADVSEC_fineSeq", profileNamespace getVariable [ADVSEC_repKey + "_fineseq", 0]];
};
_db
