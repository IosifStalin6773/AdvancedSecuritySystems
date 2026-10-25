// -> [[id, nombre, descripción, categoría, [DIK, shift, ctrl, alt]], ...] (addon, con la misión por encima)
private _out = [];
{
    private _id = configName _x;
    private _key = getArray (_x >> "key");
    private _m = missionConfigFile >> "ADVSEC_Keys" >> _id >> "key";
    if (isArray _m) then {_key = getArray _m};
    if (_id == "pda" && {!isArray _m}) then {_key = getMissionConfigValue ["ADVSEC_pdaKey", _key]};
    _key params [["_k", 0], ["_s", 0], ["_c", 0], ["_a", 0]];
    _out pushBack [_id, getText (_x >> "name"), getText (_x >> "tooltip"), getText (_x >> "category"), [_k, _s isEqualTo 1, _c isEqualTo 1, _a isEqualTo 1]];
} forEach ("true" configClasses (configFile >> "ADVSEC_Keys"));
_out
