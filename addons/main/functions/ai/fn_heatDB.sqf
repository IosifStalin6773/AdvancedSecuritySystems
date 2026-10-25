// -> HashMap SteamID -> [sospecha, minutoÚltimaActualización, eventos [[fecha, motivo, puntos], ...], nombre, expedienteAbierto] (servidor)
private _db = localNamespace getVariable "ADVSEC_heatDB";
if (isNil "_db") then {
    if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
    _db = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_heat", []]);
    localNamespace setVariable ["ADVSEC_heatDB", _db];
};
_db
