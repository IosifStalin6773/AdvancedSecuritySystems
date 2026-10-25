// -> HashMap clave -> [HashMap documento, ...] (servidor). Vive en localNamespace: ningún cliente puede sobrescribirlo por red.
private _db = localNamespace getVariable "ADVSEC_docStore";
if (isNil "_db") then {
    _db = createHashMap;
    if (ADVSEC_persist) then {
        if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
        {
            _x params ["_k", "_docs"];
            _db set [_k, _docs apply {createHashMapFromArray _x}];
        } forEach (profileNamespace getVariable [ADVSEC_repKey + "_docs", []]);
    };
    localNamespace setVariable ["ADVSEC_docStore", _db];
};
_db
