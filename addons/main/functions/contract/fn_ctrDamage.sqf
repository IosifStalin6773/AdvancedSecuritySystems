/*
    ["init"] · ["scan"] · ["incident", [tipo, autor, posición, valor, víctima]] (servidor)
    Daños colaterales en la zona de un contrato en curso: bajas y heridos civiles, vehículos civiles, edificios y propiedad del cliente.
    Cada incidente penaliza el contrato, multa al autor y suma sospecha (a los 5 min; la mitad si lo declara).
*/
params ["_action", ["_args", []]];
if (!isServer) exitWith {};
private _active = {
    // [uid, pos] -> contrato en curso en el que figura el autor y cuya zona contiene la posición
    params ["_uid", "_p"];
    private _r = createHashMap;
    {
        private _c = _y;
        if ((_c get "state") == "En curso" && {((_c get "assigned") findIf {(_x select 0) == _uid}) >= 0}) then {
            private _rt = _c get "route";
            private _in = if (_rt isNotEqualTo []) then {(_rt findIf {(_x distance2D _p) < 400}) >= 0} else {(_p distance2D (_c get "pos")) <= ((_c get "radius") * 1.5)};
            if (_in) exitWith {_r = _c};
        };
    } forEach ([] call ADVSEC_fnc_ctrDB);
    _r
};
private _author = {
    params ["_killer", "_inst"];
    private _a = [_inst, _killer] select (isNull _inst);
    if (!isNull _a && {!(_a isKindOf "CAManBase")}) then {_a = effectiveCommander _a};
    _a
};
private _isCiv = {
    params ["_o"];
    side group _o isEqualTo civilian || {getNumber (configOf _o >> "side") == 3}
};
switch (_action) do {
    case "init": {
        if (!isNil {localNamespace getVariable "ADVSEC_ctrDmgInit"}) exitWith {};
        localNamespace setVariable ["ADVSEC_ctrDmgInit", true];
        addMissionEventHandler ["EntityKilled", {
            params ["_v", "_killer", "_inst"];
            if (isNull _v || {!isNil {_v getVariable "ADVSEC_ctrVIP"}}) exitWith {};
            ["incident", ["", [_killer, _inst], getPosATL _v, 0, _v]] call ADVSEC_fnc_ctrDamage;
        }];
        addMissionEventHandler ["BuildingChanged", {
            params ["_from", "_to", "_ruin"];
            if (!_ruin) exitWith {};
            ["incident", ["building", [objNull, objNull], getPosATL _from, 1500, _from]] call ADVSEC_fnc_ctrDamage;
        }];
    };
    case "scan": {
        // Heridos civiles: Hit en los civiles de la zona (locales al servidor)
        {
            private _c = _y;
            if ((_c get "state") == "En curso") then {
                private _ctr = [(_c get "route") select 0, _c get "pos"] select ((_c get "route") isEqualTo []);
                private _rad = [(_c get "radius") * 1.5, 2500] select ((_c get "route") isNotEqualTo []);
                {
                    if (local _x && {!isPlayer _x} && {[_x] call _isCiv} && {isNil {_x getVariable "ADVSEC_ctrHitEH"}}) then {
                        _x setVariable ["ADVSEC_ctrHitEH", _x addEventHandler ["Hit", {
                            params ["_u", "_src", "_dmg", "_inst"];
                            if (!alive _u || {(_u getVariable ["ADVSEC_ctrHitT", -1e6]) > serverTime - 60}) exitWith {};
                            _u setVariable ["ADVSEC_ctrHitT", serverTime];
                            ["incident", ["civHurt", [_src, _inst], getPosATL _u, 0, _u]] call ADVSEC_fnc_ctrDamage;
                        }]];
                    };
                } forEach (_ctr nearEntities [["CAManBase"], _rad]);
            };
        } forEach ([] call ADVSEC_fnc_ctrDB);
    };
    case "incident": {
        _args params ["_kind", "_by", "_pos", "_val", ["_v", objNull]];
        private _who = [];
        if (_kind == "building") then {
            // Edificio: operadores asignados que dispararon en los últimos 30 s a menos de 300 m
            _who = (allPlayers select {(_x distance2D _pos) < 300 && {(_x getVariable ["ADVSEC_lastShot", -1e6]) > serverTime - 30}});
        } else {
            private _a = _by call _author;
            if (!isNull _a && {isPlayer _a} && {_a isNotEqualTo _v}) then {_who = [_a]};
        };
        if (_who isEqualTo []) exitWith {};
        {
            private _a = _x;
            private _c = [getPlayerUID _a, _pos] call _active;
            if (count _c > 0) exitWith {
                private _k = _kind;
                if (_k == "") then {
                    switch (true) do {
                        case ((_v getVariable ["ADVSEC_ctrOwner", ""]) == (_c get "client")): {_k = "clientProp"; _val = _v getVariable ["ADVSEC_value", 5000]};
                        case (_v isKindOf "CAManBase" && {[_v] call _isCiv}): {_k = ["civKill", "civKillRoe"] select ((_c get "roe") == "Verde")};
                        case (_v isKindOf "AllVehicles" && {[_v] call _isCiv} && {!(_v getVariable ["ADVSEC_corpVehicle", false])}): {
                            _k = "vehicle";
                            private _dv = (["dealerVehicles", []] call ADVSEC_fnc_setting) select {(_x select 0) == typeOf _v};
                            _val = _v getVariable ["ADVSEC_vehValue", [5000, (_dv select 0) select 1] select (_dv isNotEqualTo [])];
                        };
                    };
                };
                if (_k == "") exitWith {};
                if (_k == "civHurt" && {(_c get "roe") == "Rojo"}) exitWith {};
                private _cc = ["Collateral", _k] call {
                    params ["_list", "_key"];
                    private _r = configNull;
                    {if (configName _x == _key) exitWith {_r = _x}} forEach ([_list] call ADVSEC_fnc_pmcClasses);
                    _r
                };
                if (isNull _cc) exitWith {};
                private _m = _c get "metrics";
                private _pp = [_cc, "penalPct", 0] call ADVSEC_fnc_pmcVal;
                if (_pp < 0) then {_pp = ["contractCivPenalty", 0.25] call ADVSEC_fnc_setting};
                private _pen = round ((_c get "pay") * _pp + ([_cc, "penalFlat", 0] call ADVSEC_fnc_pmcVal) + _val * ([_cc, "penalValue", 0] call ADVSEC_fnc_pmcVal));
                if (_pen > 0) then {(_m get "penal") pushBack [_k, _pen]};
                private _rule = [_cc, "rule", ""] call ADVSEC_fnc_pmcVal;
                (_m get "incidents") pushBack [_k, getPlayerUID _a, name _a, mapGridPosition _pos, round _val, call ADVSEC_fnc_now, false, serverTime, false, _rule];
                private _fine = round (([_cc, "fine", 0] call ADVSEC_fnc_pmcVal) + _val * ([_cc, "fineValue", 0] call ADVSEC_fnc_pmcVal));
                private _why = format [("STR_ADVSEC_pmc_fine_reason" call ADVSEC_fnc_L), (format ["STR_ADVSEC_pmc_inc_%1", _k]) call ADVSEC_fnc_L, _c get "id"];
                if (_fine > 0) then {[_a, _fine, _why, ("STR_ADVSEC_pmc_compliance" call ADVSEC_fnc_L), ""] call ADVSEC_fnc_fineAdd};
                if (_k in ["civKill", "civKillRoe", "civHurt"]) then {
                    ["blood", _pos, createHashMapFromArray [["uid", ""], ["name", [name _v, "?"] select (isNull _v)]]] call ADVSEC_fnc_evAdd;
                };
                (format [("STR_ADVSEC_pmc_incident_msg" call ADVSEC_fnc_L), (format ["STR_ADVSEC_pmc_inc_%1", _k]) call ADVSEC_fnc_L, _c get "id", _pen, ["currency", "€"] call ADVSEC_fnc_setting]) remoteExecCall ["hint", _a];
                ["collateral", _a, [_c get "id", _k, round _val, _pen, _fine]] call ADVSEC_fnc_logEvent;
                ["contracts"] call ADVSEC_fnc_dbDirty;
            };
        } forEach _who;
    };
};
