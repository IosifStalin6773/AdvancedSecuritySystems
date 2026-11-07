/*
    [portador, clase, agente, dónde] (servidor) Sanción automática al encontrar o incautar material:
    desvío de material corporativo, arma personal sin licencia, mercado negro o explosivos (ADVSEC_Settings >> ContrabandRules).
    -> categoría aplicada ("" si es legal)
*/
params ["_u", "_c", ["_by", objNull], ["_where", ""]];
if (isNull _u || {!isPlayer _u}) exitWith {""};
private _base = [_c] call BIS_fnc_baseWeapon;
private _w = [] call ADVSEC_fnc_wpnDB;
private _uid = getPlayerUID _u;
private _cat = "";
private _val = [_base] call ADVSEC_fnc_armValue;
private _corp = "";
{
    if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _base} && {(_y select 5) in ["Firmada", "Perdida"]} && {(_y select 5) == "Perdida" || {((_y select 6) param [0, ""]) != _uid}}) exitWith {_corp = _x};
} forEach _w;
private _isW = isClass (configFile >> "CfgWeapons" >> _base) && {getNumber (configFile >> "CfgWeapons" >> _base >> "type") in [1, 2, 4]};
switch (true) do {
    case (_c in (["contrabandExplosives", []] call ADVSEC_fnc_setting)): {_cat = "explosive"};
    case (_corp isNotEqualTo ""): {_cat = "corpDiverted"};
    case ((["blackMarketItems", []] call ADVSEC_fnc_setting) findIf {(_x select 0) == _c || {(_x select 0) == _base}} >= 0): {_cat = "blackMarket"};
    case (_isW && {((_u getVariable ["ADVSEC_corpArms", []]) findIf {(_x select 0) == _base}) < 0} && {!([_u, "WeaponLicense"] call ADVSEC_fnc_pmcHasLic)}): {_cat = "noLicense"};
};
if (_cat isEqualTo "") exitWith {""};
// Una sanción por portador y categoría cada 10 minutos
private _thr = localNamespace getVariable ["ADVSEC_contraT", createHashMap];
localNamespace setVariable ["ADVSEC_contraT", _thr];
if ((_thr getOrDefault [_uid + _cat, -1e6]) > serverTime - 600) exitWith {_cat};
_thr set [_uid + _cat, serverTime];
private _rc = configNull;
{if (configName _x == _cat) exitWith {_rc = _x}} forEach (["ContrabandRules"] call ADVSEC_fnc_pmcClasses);
if (isNull _rc) exitWith {_cat};
private _fine = [_rc, "fine", 0] call ADVSEC_fnc_pmcVal;
_fine = switch (true) do {
    case (_fine == -1): {((["licensePrices", []] call ADVSEC_fnc_setting) select {(_x select 0) == "WeaponLicense"}) param [0, ["", 1500]] select 1};
    case (_fine < -1): {_val * abs _fine};
    default {_fine};
};
private _why = format [("STR_ADVSEC_pmc_contra_reason" call ADVSEC_fnc_L), (format ["STR_ADVSEC_pmc_contra_%1", _cat]) call ADVSEC_fnc_L, [_c] call ADVSEC_fnc_ecoItemName, _where];
if (_fine > 0) then {[_u, round _fine, _why, [("STR_ADVSEC_pmc_system" call ADVSEC_fnc_L), name _by] select !isNull _by, [getPlayerUID _by, ""] select (isNull _by)] call ADVSEC_fnc_fineAdd};
private _rule = [_rc, "rule", ""] call ADVSEC_fnc_pmcVal;
if (_rule isNotEqualTo "") then {[_u, _rule, _why] call ADVSEC_fnc_heatAdd};
private _lvl = [_rc, "wanted", ""] call ADVSEC_fnc_pmcVal;
if (_lvl isNotEqualTo "") then {[_uid, name _u, _why, _lvl] call ADVSEC_fnc_wantedSys};
if (_corp isNotEqualTo "") then {
    private _e = _w get _corp;
    _e set [5, "Incautada"];
    (_e select 9) pushBack [call ADVSEC_fnc_now, format [("STR_ADVSEC_pmc_arm_seized_from" call ADVSEC_fnc_L), name _u]];
    ["weapons"] call ADVSEC_fnc_dbDirty;
};
["contraband", _u, [_cat, _c, round _fine, _corp, _where]] call ADVSEC_fnc_logEvent;
if (!isNull _by) then {(format [("STR_ADVSEC_pmc_contra_by" call ADVSEC_fnc_L), name _u, (format ["STR_ADVSEC_pmc_contra_%1", _cat]) call ADVSEC_fnc_L, round _fine, ["currency", "€"] call ADVSEC_fnc_setting]) remoteExecCall ["hint", _by]};
_cat
