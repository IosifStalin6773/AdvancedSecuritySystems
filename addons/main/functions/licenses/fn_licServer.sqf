/*
    [acción, llamador, args] (servidor) — licencias de pago y registro de armas
    "list" [oficina] · "buy" [oficina, tipo] · "regWeapons" [oficina] · "revoke" [unidad, tipo] · "bail"
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _prices = ["licensePrices", []] call ADVSEC_fnc_setting;
private _has = {params ["_u", "_t"]; (([] call ADVSEC_fnc_docStore) getOrDefault [[_u] call ADVSEC_fnc_docKey, []]) findIf {(_x get "type") == _t} >= 0};
private _office = {params ["_o"]; !isNull _o && {(_o getVariable ["ADVSEC_issuerName", ""]) isNotEqualTo ""} && {(_caller distance _o) < 6}};
switch (_action) do {
    case "list": {
        _args params [["_o", objNull]];
        if !([_o] call _office) exitWith {};
        private _rows = _prices apply {
            _x params ["_t", "_p"];
            private _own = [_caller, _t] call _has;
            private _n = getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName");
            [format ["%1 · %2 %3%4", _n, _p, _cur, ["", ("STR_ADVSEC_already_owned" call ADVSEC_fnc_L)] select _own], _t, format [("STR_ADVSEC_price" call ADVSEC_fnc_L), _n, _p, _cur, [("STR_ADVSEC_issued_on_the_spot_tied" call ADVSEC_fnc_L), ("STR_ADVSEC_you_already_have_this_licence" call ADVSEC_fnc_L)] select _own], [[], [0.45, 1, 0.45, 1]] select _own, ""]
        };
        private _ws = ([primaryWeapon _caller, handgunWeapon _caller, secondaryWeapon _caller] select {_x != ""}) apply {
            private _s = [getPlayerUID _caller, _x] call ADVSEC_fnc_wpnSerial;
            format [("STR_ADVSEC_serial" call ADVSEC_fnc_L), getText (configFile >> "CfgWeapons" >> _x >> "displayName"), _s, [("STR_ADVSEC_unregistered" call ADVSEC_fnc_L), "registrada"] select (_s in ([] call ADVSEC_fnc_wpnDB))]
        };
        ["lic", format [("STR_ADVSEC_weapons_you_carry" call ADVSEC_fnc_L), (_o getVariable ["ADVSEC_issuerName", ""]) call ADVSEC_fnc_repEsc, [(_ws joinString " · ") call ADVSEC_fnc_repEsc, "ninguna"] select (_ws isEqualTo [])], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "buy": {
        _args params [["_o", objNull], ["_t", ""]];
        if !([_o] call _office) exitWith {("STR_ADVSEC_you_must_be_at_the_2" call ADVSEC_fnc_L) call _say};
        private _i = _prices findIf {(_x select 0) == _t};
        if (_i < 0) exitWith {};
        if ([_caller, _t] call _has) exitWith {("STR_ADVSEC_you_already_have_that_licence" call ADVSEC_fnc_L) call _say};
        private _p = (_prices select _i) select 1;
        if !([_caller, _p, format [("STR_ADVSEC_fee" call ADVSEC_fnc_L), getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName")], true] call ADVSEC_fnc_ecoCharge) exitWith {(format [("STR_ADVSEC_not_enough_money_the_fee" call ADVSEC_fnc_L), _p, _cur]) call _say};
        [_caller, _t, [["name", name _caller], ["uid", getPlayerUID _caller], ["issuer", _o getVariable ["ADVSEC_issuerName", ("STR_ADVSEC_authority" call ADVSEC_fnc_L)]], ["notes", ("STR_ADVSEC_issued_after_paying_the_fee" call ADVSEC_fnc_L)]], true, false, true] call ADVSEC_fnc_docCreate;
        ["licenseBuy", _caller, [_t, _p]] call ADVSEC_fnc_logEvent;
        ["list", _caller, [_o]] call ADVSEC_fnc_licServer;
    };
    case "regWeapons": {
        _args params [["_o", objNull]];
        if !([_o] call _office) exitWith {("STR_ADVSEC_you_must_be_at_the_2" call ADVSEC_fnc_L) call _say};
        if !([_caller, "WeaponLicense"] call _has) exitWith {("STR_ADVSEC_you_need_a_weapons_licence" call ADVSEC_fnc_L) call _say};
        private _ws = [primaryWeapon _caller, handgunWeapon _caller, secondaryWeapon _caller] select {_x != ""};
        if (_ws isEqualTo []) exitWith {("STR_ADVSEC_you_are_not_carrying_any" call ADVSEC_fnc_L) call _say};
        private _ser = _ws apply {[_caller, _x] call ADVSEC_fnc_wpnRegister};
        ["weaponRegister", _caller, _ser] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_weapons_registered_in_your_name" call ADVSEC_fnc_L), _ser joinString ", "]) call _say;
        ["list", _caller, [_o]] call ADVSEC_fnc_licServer;
    };
    case "revoke": {
        _args params [["_u", objNull], ["_t", ""]];
        if !([_caller, "licenseRevoke"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_revoke_licences" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (isNull _u || {(_u distance _caller) > 10}) exitWith {};
        private _ids = ((([] call ADVSEC_fnc_docStore) getOrDefault [[_u] call ADVSEC_fnc_docKey, []]) select {(_x get "type") == _t}) apply {_x get "id"};
        if (_ids isEqualTo []) exitWith {(format [("STR_ADVSEC_does_not_have_that_licence" call ADVSEC_fnc_L), name _u]) call _say};
        {[_u, _x] call ADVSEC_fnc_docRevoke} forEach _ids;
        ["licenseRevoke", _caller, [name _u, getPlayerUID _u, _t]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_licence_revoked_from" call ADVSEC_fnc_L), name _u]) call _say;
        (format [("STR_ADVSEC_the_mp_has_revoked_your" call ADVSEC_fnc_L), name _caller, getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName")]) remoteExecCall ["hint", _u];
    };
    case "bail": {
        private _until = _caller getVariable ["ADVSEC_jailUntil", 0];
        private _left = _until - serverTime;
        private _per = ["bailPerMinute", 50] call ADVSEC_fnc_setting;
        if (_left <= 0) exitWith {};
        if (_left > 1e6 || {_per <= 0}) exitWith {("STR_ADVSEC_your_detention_does_not_allow" call ADVSEC_fnc_L) call _say};
        private _amt = ceil (_left / 60) * _per;
        if !([_caller, _amt, ("STR_ADVSEC_bail" call ADVSEC_fnc_L), true] call ADVSEC_fnc_ecoCharge) exitWith {(format [("STR_ADVSEC_bail_is_and_you_cannot" call ADVSEC_fnc_L), _amt, _cur]) call _say};
        [_caller] call ADVSEC_fnc_jailRelease;
        ["bail", _caller, [_amt]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_bail_paid_you_are_free" call ADVSEC_fnc_L), _amt, _cur]) call _say;
    };
};
