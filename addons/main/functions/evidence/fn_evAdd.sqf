// [tipo ("casing"|"print"|"blood"), posiciónATL, datos (HashMap)] -> id (servidor). Prueba en el suelo, caduca si nadie la recoge.
params ["_type", "_pos", "_data"];
private _db = [] call ADVSEC_fnc_evDB;
private _n = (localNamespace getVariable ["ADVSEC_evSeq", 0]) + 1;
localNamespace setVariable ["ADVSEC_evSeq", _n];
private _id = format ["EV-%1", _n];
private _e = createHashMapFromArray [
    ["id", _id], ["type", _type], ["pos", _pos], ["grid", mapGridPosition _pos], ["time", call ADVSEC_fnc_now], ["t", serverTime],
    ["state", "field"], ["holder", ""], ["holderName", ""], ["chain", []], ["result", ""], ["tamper", []], ["fake", []]
];
_e merge [_data, true];
_db set [_id, _e];
_id
