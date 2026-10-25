// [unidad] (servidor): aplica a la unidad los rangos guardados en la base de datos (placas PM / AA.II., rango global)
params ["_unit"];
if (!isServer || {isNull _unit}) exitWith {};
private _uid = getPlayerUID _unit;
private _e = [_uid, name _unit] call ADVSEC_fnc_pdbSeen;
if (_e isEqualTo []) exitWith {};
_e params ["", "", "", "", "", "_pm", "_ai", "_glob"];
private _short = _uid select [(count _uid - 8) max 0];
{
    _x params ["_lvl", "_type", "_prefix"];
    if (_lvl == 0) then {
        {
            if ((_x get "type") == _type) then {[_unit, _x get "id"] call ADVSEC_fnc_docRevoke};
        } forEach +(([] call ADVSEC_fnc_docStore) getOrDefault [[_unit] call ADVSEC_fnc_docKey, []]);
    };
    if (_lvl > 0) then {
        [_unit, _type, [["name", name _unit], ["uid", _uid], ["number", _prefix + _short], ["clearance", _lvl], ["issuer", "Estado Mayor"]], true, true, true] call ADVSEC_fnc_docCreate;
    };
} forEach [[_pm, "MPBadge", "PM-"], [_ai, "IABadge", "AI-"]];

private _names = ["ranksGlobal", []] call ADVSEC_fnc_setting;
private _title = ["", _names param [_glob, ""]] select (_glob > 0);
_unit setVariable ["ADVSEC_globalRank", _title, true];
if (_glob > 0 && {(["globalRankSetUnit", 1] call ADVSEC_fnc_setting) isEqualTo 1}) then {
    private _arma = (["ranksGlobalArma", []] call ADVSEC_fnc_setting) param [_glob, ""];
    if (_arma in ["PRIVATE", "CORPORAL", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR", "COLONEL"]) then {_unit setUnitRank _arma};
};
// El ID militar automático lleva el rango global
private _mid = (([] call ADVSEC_fnc_docStore) getOrDefault [[_unit] call ADVSEC_fnc_docKey, []]) select {(_x get "type") == "MilitaryID"};
if (_mid isNotEqualTo [] && {((_mid select 0) getOrDefault ["rank", ""]) isNotEqualTo ([_unit] call ADVSEC_fnc_rankName)}) then {
    (_mid select 0) set ["rank", [_unit] call ADVSEC_fnc_rankName];
    ["docs"] call ADVSEC_fnc_dbDirty;
    [_unit] call ADVSEC_fnc_docPublish;
};
