/*
    -> HashMap SteamID -> ficha (servidor)
    ficha: [nombre, alias[], primeraVez, últimaVez, visitas, rangoPM, rangoAI, rangoGlobal, notas, historial[], minutos]
    rangoPM / rangoAI: -1 = según la lista de la misión (ADVSEC_pmUIDs / ADVSEC_iaUIDs), 0 = sin rango, 1-5 = nivel
    rangoGlobal: índice en ranksGlobal (0 = el primero, sin rango)
*/
private _db = localNamespace getVariable "ADVSEC_pdbDB";
if (isNil "_db") then {
    if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
    _db = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_players", []]);
    localNamespace setVariable ["ADVSEC_pdbDB", _db];
};
_db
