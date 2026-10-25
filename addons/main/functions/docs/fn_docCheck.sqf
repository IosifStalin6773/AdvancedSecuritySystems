// [unidad, nivelMínimo, tipos, idLlave] -> bool (documento válido, no caducado y, si lleva SteamID, del propio portador)
params ["_unit", ["_minClr", -1], ["_types", []], ["_key", ""]];
date params ["_y", "_m", "_d"];
private _today = _y * 10000 + _m * 100 + _d;

([_unit] call ADVSEC_fnc_docGetAll) findIf {
    private _exp = _x getOrDefault ["expires", ""];
    (_exp isEqualTo "" || {parseNumber ((_exp splitString "-/.") joinString "") >= _today})
    && {_types isEqualTo [] || {(_x get "type") in _types}}
    && {_minClr < 0 || {(_x getOrDefault ["clearance", 0]) >= _minClr}}
    && {_key isEqualTo "" || {_key in (_x getOrDefault ["keys", []])}}
    && {private _uid = _x getOrDefault ["uid", ""]; _uid isEqualTo "" || {!isPlayer _unit} || {_uid isEqualTo getPlayerUID _unit}}
} > -1
