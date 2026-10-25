// [unidad, "PM"|"AI"] -> nivel 0-5 según la placa/credencial válida de mayor nivel (0 = sin placa)
params ["_unit", "_dept"];
private _types = if (_dept == "AI") then {
    getMissionConfigValue ["ADVSEC_aiBadges", ["IABadge"]]
} else {
    getMissionConfigValue ["ADVSEC_pmBadges", ["MPBadge", "IABadge"]]
};
private _lvl = 0;
{
    if ((_x get "type") in _types) then {
        private _c = _x getOrDefault ["clearance", 1];
        if (_c isEqualType "") then {_c = parseNumber _c};
        _lvl = _lvl max ((_c max 1) min 5);
    };
} forEach ([_unit] call ADVSEC_fnc_docGetAll);
_lvl
