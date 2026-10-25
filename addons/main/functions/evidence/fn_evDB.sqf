// -> HashMap id -> prueba (servidor, localNamespace). Se cargan del perfil las pruebas ya recogidas.
private _db = localNamespace getVariable "ADVSEC_evDB";
if (isNil "_db") then {
    if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
    _db = createHashMap;
    {
        private _e = createHashMapFromArray _x;
        _db set [_e get "id", _e];
    } forEach (profileNamespace getVariable [ADVSEC_repKey + "_evidence", []]);
    localNamespace setVariable ["ADVSEC_evDB", _db];
    localNamespace setVariable ["ADVSEC_evSeq", profileNamespace getVariable [ADVSEC_repKey + "_evseq", 0]];
};
_db
