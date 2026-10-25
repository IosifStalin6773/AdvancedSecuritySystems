// [unidad, "PM"|"AI"] -> bool. PM: placa PM o credencial AA.II.; AI: credencial AA.II. Admin y modo un jugador: siempre.
params ["_unit", "_dept"];
if (!isMultiplayer) exitWith {true};
if (!isNull getAssignedCuratorLogic _unit) exitWith {true};
if (_unit isEqualTo player && {(call BIS_fnc_admin) > 0}) exitWith {true};
if (isServer && {(admin owner _unit) > 0}) exitWith {true};
if (((["pdaGrantsAccess", 0] call ADVSEC_fnc_cfg)) isEqualTo 1 && {
    private _inv = items _unit + assignedItems _unit;
    ("ADVSEC_PDA_AI" in _inv) || {_dept != "AI" && {"ADVSEC_PDA_PM" in _inv}}
}) exitWith {true};
private _types = if (_dept == "AI") then {
    getMissionConfigValue ["ADVSEC_aiBadges", ["IABadge"]]
} else {
    getMissionConfigValue ["ADVSEC_pmBadges", ["MPBadge", "IABadge"]]
};
[_unit, -1, _types] call ADVSEC_fnc_docCheck
