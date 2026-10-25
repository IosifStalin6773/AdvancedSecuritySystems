// [unidad] — cliente: genera indicios (casquillos, huellas, sangre) y denuncia agresiones a esposados
params ["_unit"];
if (!hasInterface || {isNull _unit} || {!isNil {_unit getVariable "ADVSEC_evEH"}}) exitWith {};
_unit setVariable ["ADVSEC_evEH", true];
_unit addEventHandler ["FiredMan", {
    params ["_u", "_weapon", "", "", "", "_mag"];
    if (_weapon in ["Throw", "Put"]) exitWith {};
    private _n = (_u getVariable ["ADVSEC_shots", 0]) + 1;
    _u setVariable ["ADVSEC_shots", _n];
    if (_n mod (["casingEvery", 4] call ADVSEC_fnc_setting) == 1) then {
        ["casing", _u, [_weapon, _mag, getPosATL _u]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
    };
}];
_unit addEventHandler ["GetInMan", {
    params ["_u", "", "_veh"];
    ["print", _u, [_veh]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
}];
_unit addEventHandler ["InventoryOpened", {
    params ["_u", "_c"];
    if (!isNull _c && {!(_c isKindOf "GroundWeaponHolder")} && {!(_c isKindOf "CAManBase")}) then {
        ["print", _u, [_c]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
    };
    false
}];
_unit addEventHandler ["Hit", {
    params ["_u", "_src", "_dmg", "_by"];
    if (_dmg > 0.05) then {["blood", _u, [getPosATL _u]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]};
    if (!isNull _by && {_by != _u} && {isPlayer _by} && {[_u] call ADVSEC_fnc_isRestrained}) then {
        ["hitRestrained", _u, [_by]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
    };
}];
