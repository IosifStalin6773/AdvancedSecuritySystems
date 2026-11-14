// [unidad, "PM"|"AI"] -> nivel 0-5 según la placa/credencial válida de mayor nivel (0 = sin placa)
params ["_unit", "_dept"];
// Compañía (perfil PMC, 1.20): nivel 1-5 según el rango del ORBAT (pmcRankLevels), o el de la placa PM si es mayor
if (_dept == "PMC") exitWith {
    private _g = _unit getVariable ["ADVSEC_globalRankIdx", 0];
    private _lg = 0;
    if (_g > 0 && {(["pmcProfile", 1] call ADVSEC_fnc_setting) isEqualTo 1}) then {
        _lg = ((["pmcRankLevels", [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5]] call ADVSEC_fnc_setting) param [_g - 1, 5]) max 1 min 5;
    };
    _lg max ([_unit, "PM"] call ADVSEC_fnc_rankLevel)
};
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
