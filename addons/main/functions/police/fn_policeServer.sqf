// [modo, llamador, unidad, args] (servidor). Valida las acciones policiales pedidas por un cliente y las reenvía a la máquina de la unidad.
params ["_mode", "_caller", "_unit", ["_args", []]];
if (!isServer || {isNull _unit}) exitWith {};
private _dist = [5, 15] select (_mode in ["load", "unload"]);
if !([_caller, _unit, _dist] call ADVSEC_fnc_srvCaller) exitWith {};
private _zeus = [_caller] call ADVSEC_fnc_isZeus;
private _ok = switch (_mode) do {
    case "restrain": {[_caller, "restrain"] call ADVSEC_fnc_perm};
    case "load";
    case "unload": {[_caller, "restrain"] call ADVSEC_fnc_perm && {[_unit] call ADVSEC_fnc_isRestrained}};
    case "seize": {[_caller, "seize"] call ADVSEC_fnc_perm && {_zeus || {[_unit] call ADVSEC_fnc_isRestrained} || {_unit getVariable ["ace_captives_isSurrendering", false]}}};
    default {_zeus};
};
if (!_ok) exitWith {[_caller, format ["%1 a %2", _mode, name _unit]] call ADVSEC_fnc_deny};
if (_mode == "restrain" && {_args param [0, false]} && {isPlayer _unit} && {!([getPlayerUID _unit] call ADVSEC_fnc_causeFor)}) then {
    [_caller, "restrainNoCause", name _unit] call ADVSEC_fnc_heatAdd;
};
[_mode, _caller, [name _unit, getPlayerUID _unit] + _args] call ADVSEC_fnc_logEvent;
if (_mode == "seize") exitWith {
    _args params ["_k", "_class"];
    if !(_class in (weapons _unit + magazines _unit + items _unit + assignedItems _unit)) exitWith {};
    private _holder = (nearestObjects [_caller, ["GroundWeaponHolder"], 2]) param [0, objNull];
    if (isNull _holder) then {_holder = createVehicle ["GroundWeaponHolder", getPosATL _caller, [], 0.5, "CAN_COLLIDE"]};
    switch (_k) do {
        case "W": {_holder addWeaponCargoGlobal [_class, 1]};
        case "M": {_holder addMagazineCargoGlobal [_class, 1]};
        default {_holder addItemCargoGlobal [_class, 1]};
    };
    private _h = _unit getVariable ["ADVSEC_hidden", []];
    if (_class in _h) then {_h deleteAt (_h find _class); _unit setVariable ["ADVSEC_hidden", _h, true]};
    [_unit, _mode, _args] call ADVSEC_fnc_policeLocal;
};
[_unit, _mode, _args] call ADVSEC_fnc_policeLocal;
