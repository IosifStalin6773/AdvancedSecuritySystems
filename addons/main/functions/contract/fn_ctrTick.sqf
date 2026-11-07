/*
    (servidor) Evalúa los contratos en curso cada 3 s. Solo se llama desde ADVSEC_fnc_ctrServer "tick":
    usa sus variables locales (_db, _finish, _push, _units, _notify, _cfgOf).
*/
params ["_db", "_finish", "_push", "_units"];
private _inZone = {
    // [contrato, posición] -> la posición está en la zona (o a menos de 400 m de la ruta)
    params ["_c", "_p"];
    private _r = _c get "route";
    if (_r isNotEqualTo []) exitWith {(_r findIf {(_x distance2D _p) < 400}) >= 0};
    (_p distance2D (_c get "pos")) <= ((_c get "radius") * 1.5)
};
localNamespace setVariable ["ADVSEC_ctrInZone", _inZone];
private _enemies = {
    params ["_p", "_rad"];
    {alive _x && {[west, side group _x] call BIS_fnc_sideIsEnemy} && {!(side group _x isEqualTo civilian)}} count (_p nearEntities [["CAManBase"], _rad])
};
{
    private _id = _x;
    private _c = _db get _x;
    private _m = _c get "metrics";
    // Sospecha pendiente: se aplica a los 5 minutos (la mitad si el autor declaró el incidente)
    {
        _x params ["_k", "_uid", "_nm", "", "", "", ["_decl", false], ["_t", 0], ["_done", false], ["_rule", ""]];
        if (!_done && {_rule isNotEqualTo ""} && {serverTime - _t > 300 || {_decl} || {(_c get "state") != "En curso"}}) then {
            _x set [8, true];
            private _pts = [["Rules", _rule], 0] call ADVSEC_fnc_setting;
            if (_decl) then {_pts = ceil (_pts / 2)};
            if (_pts > 0) then {[[_uid, _nm], _rule, format ["%1 (%2)", _id, (format ["STR_ADVSEC_pmc_inc_%1", _k]) call ADVSEC_fnc_L], _pts] call ADVSEC_fnc_heatAdd};
            ["contracts"] call ADVSEC_fnc_dbDirty;
        };
    } forEach (_m get "incidents");
    if ((_c get "state") == "En curso") then {
        private _us = [_c] call _units;
        private _type = _c get "type";
        private _el = (serverTime - (_c get "t0")) / 60;
        private _over = (_c get "minutes") > 0 && {_el > (_c get "minutes")};
        private _route = _c get "route";
        private _rch = _c get "reached";
        private _reach = {
            // [quién (unidades), radio] marca en orden el siguiente punto de la ruta
            params ["_who", "_rad"];
            private _i = _rch find false;
            if (_i < 0) exitWith {};
            private _pt = _route select _i;
            if ((_who findIf {(_x distance2D _pt) <= _rad}) >= 0) then {
                _rch set [_i, true];
                [_c, format [("STR_ADVSEC_pmc_point_reached" call ADVSEC_fnc_L), _id, _i + 1, count _route]] call _notify;
                [_id, _c] call _push;
                ["contracts"] call ADVSEC_fnc_dbDirty;
            };
        };
        switch (_type) do {
            case "escort": {
                [_us, 60] call _reach;
                if ((_rch find false) < 0) exitWith {[_id, _c, "Cumplido"] call _finish};
                if (_over) then {[_id, _c, ["Fallido", "Parcial"] select (({_x} count _rch) * 2 >= count _rch)] call _finish};
            };
            case "vip": {
                private _vip = objectFromNetId (_c getOrDefault ["vipNet", ""]);
                if (isNull _vip || {!alive _vip}) exitWith {
                    _m set ["vipDmg", 1];
                    if (((_m get "incidents") findIf {(_x select 0) == "vip"}) < 0) then {
                        (_m get "incidents") pushBack ["vip", (_c get "assigned") param [0, ["", ""]] select 0, (_c get "assigned") param [0, ["", "-"]] select 1, mapGridPosition (_c get "pos"), 0, call ADVSEC_fnc_now, false, serverTime, true, ""];
                    };
                    [_id, _c, "Fallido", ("STR_ADVSEC_pmc_vip_dead" call ADVSEC_fnc_L)] call _finish;
                };
                _m set ["vipDmg", (_m get "vipDmg") max (damage _vip)];
                private _veh = objectParent _vip;
                if (!isNull _veh && {_veh getVariable ["ADVSEC_corpVehicle", false]}) then {_c set ["vipVeh", netId _veh]};
                private _close = ["cpCloseRadius", 5] call ADVSEC_fnc_setting;
                if (isNull _veh && {(_us findIf {(_x distance _vip) <= _close}) < 0}) then {_m set ["exposure", (_m get "exposure") + 3]};
                // Desvío de la ruta sin evacuación: -5 % una vez por desvío
                private _near = _route findIf {(_x distance2D _vip) < 300};
                if (_near < 0 && {!(_c get "evac")}) then {
                    if !(_m get "deviation") then {
                        _m set ["deviation", true];
                        (_m get "penal") pushBack ["deviation", round ((_c get "pay") * 0.05)];
                        [_c, format [("STR_ADVSEC_pmc_deviation" call ADVSEC_fnc_L), _id]] call _notify;
                    };
                } else {_m set ["deviation", false]};
                // Avanzada: un miembro 60 s en el destino antes que el VIP, sin enemigos
                private _dst = _route select (count _route - 1);
                private _advR = ["cpAdvanceRadius", 150] call ADVSEC_fnc_setting;
                if (!(_m get "advance") && {(_vip distance2D _dst) > _advR}) then {
                    if ((_us findIf {(_x distance2D _dst) <= _advR}) >= 0 && {([_dst, _advR] call _enemies) == 0}) then {
                        _m set ["advT", (_m get "advT") + 3];
                        if ((_m get "advT") >= 60) then {
                            _m set ["advance", true];
                            [_c, format [("STR_ADVSEC_pmc_zone_cleared" call ADVSEC_fnc_L), _id]] call _notify;
                        };
                    };
                };
                [[_vip], 60] call _reach;
                if ((_rch select (count _rch - 1))) exitWith {[_id, _c, ["Cumplido", "Parcial"] select ((_m get "vipDmg") > 0.3)] call _finish};
                if (_over) then {[_id, _c, "Fallido", ("STR_ADVSEC_pmc_time_out" call ADVSEC_fnc_L)] call _finish};
            };
            case "guard": {
                _m set ["ticks", (_m get "ticks") + 1];
                if ((_us findIf {(_x distance2D (_c get "pos")) <= (_c get "radius")}) >= 0) then {_m set ["presence", (_m get "presence") + 1]};
                if (_over || {(_c get "minutes") <= 0 && {_el > 60}}) then {
                    private _r = (_m get "presence") / ((_m get "ticks") max 1);
                    [_id, _c, switch (true) do {case (_r >= 0.7): {"Cumplido"}; case (_r >= 0.4): {"Parcial"}; default {"Fallido"}}, format [("STR_ADVSEC_pmc_presence" call ADVSEC_fnc_L), round (_r * 100)]] call _finish;
                };
            };
            case "checkpoint": {
                private _uids = (_c get "assigned") apply {_x select 0};
                private _t0 = _c get "t0";
                private _n = {(_x select 1) >= _t0 && {(_x select 4) in _uids} && {(_x select 2) in ["vehSearch", "queryRun", "plateQuery", "checkpointCheck", "search", "seize", "vehSeize"]}} count (localNamespace getVariable ["ADVSEC_eventLog", []]);
                _m set ["actions", _n];
                private _goal = 3 + 2 * (_c get "risk");
                if (_n >= _goal) exitWith {[_id, _c, "Cumplido", format [("STR_ADVSEC_pmc_actions" call ADVSEC_fnc_L), _n, _goal]] call _finish};
                if (_over || {(_c get "minutes") <= 0 && {_el > 60}}) then {[_id, _c, ["Fallido", "Parcial"] select (_n * 2 >= _goal), format [("STR_ADVSEC_pmc_actions" call ADVSEC_fnc_L), _n, _goal]] call _finish};
            };
            case "qrf": {
                if (_over || {(_c get "minutes") <= 0 && {_el > 60}}) then {
                    private _tgt = 60 * (["qrfTarget", 8] call ADVSEC_fnc_setting);
                    private _rs = _m get "responses";
                    private _res = switch (true) do {
                        case ((_rs findIf {(_x select 1) < 0}) >= 0): {"Fallido"};
                        case ((_rs findIf {(_x select 1) > _tgt * 1.5}) >= 0): {"Parcial"};
                        default {"Cumplido"};
                    };
                    [_id, _c, _res] call _finish;
                };
            };
            case "recovery": {
                private _box = objectFromNetId (_c getOrDefault ["cargoNet", ""]);
                if (isNull _box || {!alive _box}) exitWith {[_id, _c, "Fallido", ("STR_ADVSEC_pmc_cargo_lost" call ADVSEC_fnc_L)] call _finish};
                if ((_box distance2D (_c get "home")) < 50) exitWith {[_id, _c, "Cumplido"] call _finish};
                if (_over) then {[_id, _c, "Fallido", ("STR_ADVSEC_pmc_time_out" call ADVSEC_fnc_L)] call _finish};
            };
            default {if (_over) then {[_id, _c, "Parcial"] call _finish}};
        };
    };
} forEach (keys _db);
