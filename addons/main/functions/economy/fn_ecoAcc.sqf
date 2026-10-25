// [SteamID, nombre] (servidor) -> cuenta (la crea con el saldo inicial si no existe)
params ["_uid", ["_name", ""]];
private _db = [] call ADVSEC_fnc_ecoDB;
private _a = _db getOrDefault [_uid, []];
if (_a isEqualTo []) then {
    _a = [["startCash", 500] call ADVSEC_fnc_setting, ["startBank", 2000] call ADVSEC_fnc_setting, _name, []];
    _db set [_uid, _a];
    ["eco"] call ADVSEC_fnc_dbDirty;
};
if (_name isNotEqualTo "") then {_a set [2, _name]};
_a
