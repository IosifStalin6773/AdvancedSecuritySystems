// [unidad] (cliente) Armería corporativa: control al abrir y cerrar la caja, desgaste por disparos y encasquillamientos
params ["_unit"];
if (!hasInterface || {isNull _unit} || {!isNil {_unit getVariable "ADVSEC_armEH"}}) exitWith {};
_unit setVariable ["ADVSEC_armEH", true];
["connect", _unit] remoteExecCall ["ADVSEC_fnc_armServer", 2];
private _snap = {
    // [[armas base], [[cargador, n]]] de lo que lleva encima
    params ["_u"];
    private _ws = [primaryWeapon _u, secondaryWeapon _u, handgunWeapon _u] select {_x isNotEqualTo ""};
    {if (!isNull _x) then {_ws append ((getWeaponCargo _x) select 0)}} forEach [uniformContainer _u, vestContainer _u, backpackContainer _u];
    _ws = _ws apply {[_x] call BIS_fnc_baseWeapon};
    private _ms = createHashMap;
    {_ms set [_x, (_ms getOrDefault [_x, 0]) + 1]} forEach (magazines _u);
    [_ws, _ms]
};
ADVSEC_armSnap = _snap;
_unit addEventHandler ["InventoryOpened", {
    params ["_u", "_c", ["_c2", objNull]];
    private _box = [_c2, _c] select (_c getVariable ["ADVSEC_armory", false]);
    if !(_box getVariable ["ADVSEC_armory", false]) exitWith {false};
    private _ok = [_u, "armoryCheckout"] call ADVSEC_fnc_perm && {(["armoryNeedDuty", 1] call ADVSEC_fnc_setting) isNotEqualTo 1 || {_u getVariable ["ADVSEC_onDuty", false]} || {[_u] call ADVSEC_fnc_isZeus}};
    if (!_ok) exitWith {hint ("STR_ADVSEC_pmc_arm_closed" call ADVSEC_fnc_L); true};
    ADVSEC_armOpenBox = _box;
    ADVSEC_armBefore = [_u] call ADVSEC_armSnap;
    false
}];
_unit addEventHandler ["InventoryClosed", {
    params ["_u"];
    if (isNil "ADVSEC_armOpenBox") exitWith {};
    private _box = ADVSEC_armOpenBox;
    ADVSEC_armOpenBox = nil;
    (ADVSEC_armBefore) params ["_w0", "_m0"];
    ([_u] call ADVSEC_armSnap) params ["_w1", "_m1"];
    private _cnt = {private _h = createHashMap; {_h set [_x, (_h getOrDefault [_x, 0]) + 1]} forEach _this; _h};
    private _a = _w0 call _cnt; private _b = _w1 call _cnt;
    private _wOut = []; private _wIn = []; private _mOut = []; private _mIn = [];
    {private _d = (_b getOrDefault [_x, 0]) - (_a getOrDefault [_x, 0]); if (_d > 0) then {_wOut pushBack [_x, _d]}; if (_d < 0) then {_wIn pushBack [_x, -_d]}} forEach ((keys _a) + (keys _b) arrayIntersect ((keys _a) + (keys _b)));
    {private _d = (_m1 getOrDefault [_x, 0]) - (_m0 getOrDefault [_x, 0]); if (_d > 0) then {_mOut pushBack [_x, _d]}; if (_d < 0) then {_mIn pushBack [_x, -_d]}} forEach ((keys _m0) + (keys _m1) arrayIntersect ((keys _m0) + (keys _m1)));
    if (_wOut isNotEqualTo [] || {_wIn isNotEqualTo []} || {_mOut isNotEqualTo []} || {_mIn isNotEqualTo []}) then {
        ["diff", _u, [_box, _wOut, _wIn, _mOut, _mIn]] remoteExecCall ["ADVSEC_fnc_armServer", 2];
    };
}];
_unit addEventHandler ["FiredMan", {
    params ["_u", "_weapon"];
    if (_weapon in ["Throw", "Put"]) exitWith {};
    private _arms = _u getVariable ["ADVSEC_corpArms", []];
    if (_arms isEqualTo []) exitWith {};
    private _b = [_weapon] call BIS_fnc_baseWeapon;
    private _i = _arms findIf {(_x select 0) == _b};
    if (_i < 0) exitWith {};
    private _n = (_u getVariable ["ADVSEC_wearShots", 0]) + 1;
    _u setVariable ["ADVSEC_wearShots", _n];
    if (_n >= 30) then {_u setVariable ["ADVSEC_wearShots", 0]; ["wear", _u, [_b, _n]] remoteExecCall ["ADVSEC_fnc_armServer", 2]};
    // Arma en estado crítico: con ACE Overheating puede encasquillarse
    if (((_arms select _i) param [2, 0]) >= 0.85 && {!isNil "ace_overheating_fnc_jamWeapon"} && {random 1 < 0.02}) then {[_u, _weapon] call ace_overheating_fnc_jamWeapon};
}];
