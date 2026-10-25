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
            [format ["%1 · %2 %3%4", _n, _p, _cur, ["", " · YA LA TIENES"] select _own], _t, format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Precio: %2 %3<br/>%4", _n, _p, _cur, ["Se expide al momento, ligada a tu SteamID.", "Ya tienes esta licencia."] select _own], [[], [0.45, 1, 0.45, 1]] select _own, ""]
        };
        private _ws = ([primaryWeapon _caller, handgunWeapon _caller, secondaryWeapon _caller] select {_x != ""}) apply {
            private _s = [getPlayerUID _caller, _x] call ADVSEC_fnc_wpnSerial;
            format ["%1 · serie %2 · %3", getText (configFile >> "CfgWeapons" >> _x >> "displayName"), _s, ["SIN REGISTRAR", "registrada"] select (_s in ([] call ADVSEC_fnc_wpnDB))]
        };
        ["lic", format ["%1<br/><t color='#8C8C8C'>Armas que llevas: %2</t>", (_o getVariable ["ADVSEC_issuerName", ""]) call ADVSEC_fnc_repEsc, [(_ws joinString " · ") call ADVSEC_fnc_repEsc, "ninguna"] select (_ws isEqualTo [])], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "buy": {
        _args params [["_o", objNull], ["_t", ""]];
        if !([_o] call _office) exitWith {"Tienes que estar en la oficina." call _say};
        private _i = _prices findIf {(_x select 0) == _t};
        if (_i < 0) exitWith {};
        if ([_caller, _t] call _has) exitWith {"Ya tienes esa licencia." call _say};
        private _p = (_prices select _i) select 1;
        if !([_caller, _p, format ["Tasa: %1", getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName")], true] call ADVSEC_fnc_ecoCharge) exitWith {(format ["No te llega: la tasa es de %1 %2.", _p, _cur]) call _say};
        [_caller, _t, [["name", name _caller], ["uid", getPlayerUID _caller], ["issuer", _o getVariable ["ADVSEC_issuerName", "Autoridad"]], ["notes", "Expedida previo pago de la tasa"]], true, false, true] call ADVSEC_fnc_docCreate;
        ["licenseBuy", _caller, [_t, _p]] call ADVSEC_fnc_logEvent;
        ["list", _caller, [_o]] call ADVSEC_fnc_licServer;
    };
    case "regWeapons": {
        _args params [["_o", objNull]];
        if !([_o] call _office) exitWith {"Tienes que estar en la oficina." call _say};
        if !([_caller, "WeaponLicense"] call _has) exitWith {"Necesitas licencia de armas para registrar un arma." call _say};
        private _ws = [primaryWeapon _caller, handgunWeapon _caller, secondaryWeapon _caller] select {_x != ""};
        if (_ws isEqualTo []) exitWith {"No llevas ningún arma." call _say};
        private _ser = _ws apply {[_caller, _x] call ADVSEC_fnc_wpnRegister};
        ["weaponRegister", _caller, _ser] call ADVSEC_fnc_logEvent;
        (format ["Armas registradas a tu nombre: %1", _ser joinString ", "]) call _say;
        ["list", _caller, [_o]] call ADVSEC_fnc_licServer;
    };
    case "revoke": {
        _args params [["_u", objNull], ["_t", ""]];
        if !([_caller, "licenseRevoke"] call ADVSEC_fnc_perm) exitWith {[_caller, "retirar licencias"] call ADVSEC_fnc_deny};
        if (isNull _u || {(_u distance _caller) > 10}) exitWith {};
        private _ids = ((([] call ADVSEC_fnc_docStore) getOrDefault [[_u] call ADVSEC_fnc_docKey, []]) select {(_x get "type") == _t}) apply {_x get "id"};
        if (_ids isEqualTo []) exitWith {(format ["%1 no tiene esa licencia.", name _u]) call _say};
        {[_u, _x] call ADVSEC_fnc_docRevoke} forEach _ids;
        ["licenseRevoke", _caller, [name _u, getPlayerUID _u, _t]] call ADVSEC_fnc_logEvent;
        (format ["Licencia retirada a %1.", name _u]) call _say;
        (format ["La PM (%1) te ha retirado: %2.", name _caller, getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName")]) remoteExecCall ["hint", _u];
    };
    case "bail": {
        private _until = _caller getVariable ["ADVSEC_jailUntil", 0];
        private _left = _until - serverTime;
        private _per = ["bailPerMinute", 50] call ADVSEC_fnc_setting;
        if (_left <= 0) exitWith {};
        if (_left > 1e6 || {_per <= 0}) exitWith {"Tu detención no admite fianza." call _say};
        private _amt = ceil (_left / 60) * _per;
        if !([_caller, _amt, "Fianza", true] call ADVSEC_fnc_ecoCharge) exitWith {(format ["La fianza es de %1 %2 y no te llega.", _amt, _cur]) call _say};
        [_caller] call ADVSEC_fnc_jailRelease;
        ["bail", _caller, [_amt]] call ADVSEC_fnc_logEvent;
        (format ["Fianza pagada: %1 %2. Quedas en libertad.", _amt, _cur]) call _say;
    };
};
