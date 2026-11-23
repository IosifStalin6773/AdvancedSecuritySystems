/*
    [acción, jugador, taquilla] (servidor) — equipo completo guardado en la taquilla
    "save":  cada pieza que lleva encima va a su hueco de la taquilla (casco, armas, pistolas, lanzador, chaleco, mochila,
             gafas, prismáticos y visión nocturna) con TSL_fnc_request "putAll". Se queda con el uniforme y su
             documentación ADVSEC (la del chaleco y la mochila pasa al uniforme). Si el hueco está ocupado, la pieza no se mueve.
    "load":  saca de los huecos cada pieza cuyo sitio en el cuerpo está libre ("takeAll"). Si queda un equipo completo
             antiguo (guardado aparte, clave _lkit del perfil del servidor), se recupera ese primero.
    "info":  -> [hay equipo, fecha, resumen] al cliente (ADVSEC_fnc_lockerKitMenu).
    Sin TS_Lockers se usa el sistema antiguo: el equipo se guarda aparte por SteamID en el perfil del servidor.
*/
params ["_action", "_p", ["_l", objNull]];
if (!isServer || {isNull _p} || {!([_p] call ADVSEC_fnc_srvCaller)}) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _db = localNamespace getVariable "ADVSEC_lkitDB";
if (isNil "_db") then {
    _db = createHashMap;
    {if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_lkit", []]);
    localNamespace setVariable ["ADVSEC_lkitDB", _db];
};
private _uid = getPlayerUID _p;
private _say = {_this remoteExecCall ["hint", _p]};
if (isNull _l || {!(_l isKindOf "Land_TS_Locker_F")} || {(_l getVariable ["TSL_owner", ""]) != _uid}) exitWith {("STR_ADVSEC_lkit_not_yours" call ADVSEC_fnc_L) call _say};
if (!alive _p || {(_p distance _l) > 4} || {!isNull objectParent _p}) exitWith {("STR_ADVSEC_lkit_closer" call ADVSEC_fnc_L) call _say};
if (_action != "info" && {!([_l, _p, "kit"] call ADVSEC_fnc_lockerGate)}) exitWith {};

private _keepCls = {(_this isEqualType "") && {(toUpper (_this select [0, 7])) == "ADVSEC_"}};
private _split = {
    // [loadout] -> [equipo sin lo ADVSEC (el uniforme sin clase: se queda puesto), objetos ADVSEC que se quedan en el cuerpo, clase del uniforme]
    params ["_lo"];
    private _kit = +_lo;
    private _keep = [];
    private _uCls = "";
    {
        private _cont = _kit select _x;
        if (_cont isNotEqualTo []) then {
            private _items = (_cont select 1) select {!(((_x select 0)) call _keepCls)};
            _keep append ((_cont select 1) select {((_x select 0)) call _keepCls});
            _kit set [_x, [_cont select 0, _items]];
        };
    } forEach [3, 4, 5];
    private _u = _kit select 3;
    if (_u isNotEqualTo []) then {_uCls = _u select 0};
    [_kit, _keep, _uCls]
};
private _empty = {
    params ["_k"];
    private _u = _k select 3;
    (_k select 0) isEqualTo [] && {(_k select 1) isEqualTo []} && {(_k select 2) isEqualTo []}
        && {_u isEqualTo [] || {(_u select 1) isEqualTo []}} && {(_k select 4) isEqualTo []} && {(_k select 5) isEqualTo []}
        && {(_k select 6) isEqualTo ""} && {(_k select 7) isEqualTo ""} && {(_k select 8) isEqualTo []}
        && {((_k select 9) findIf {_x isNotEqualTo ""}) < 0}
};
private _bare = {
    // cuerpo tras guardar: uniforme puesto con lo ADVSEC dentro
    params ["_uCls", "_keep"];
    [[], [], [], [[], [_uCls, _keep]] select (_uCls isNotEqualTo ""), [], [], "", "", [], ["", "", "", "", "", ""]]
};
private _summary = {
    params ["_k"];
    private _n = [];
    {
        private _w = _x;
        if (_w isNotEqualTo []) then {_n pushBack getText (configFile >> "CfgWeapons" >> (_w select 0) >> "displayName")};
    } forEach [_k select 0, _k select 1, _k select 2];
    {
        private _c = _k select (_x select 0);
        if (_c isNotEqualTo [] && {(_c select 0) isNotEqualTo ""}) then {_n pushBack getText (configFile >> (_x select 1) >> (_c select 0) >> "displayName")};
    } forEach [[4, "CfgWeapons"], [5, "CfgVehicles"]];
    if ((_k select 6) isNotEqualTo "") then {_n pushBack getText (configFile >> "CfgWeapons" >> (_k select 6) >> "displayName")};
    private _items = 0;
    {private _c = _k select _x; if (_c isNotEqualTo []) then {{_items = _items + (_x param [1, 1])} forEach (_c select 1)}} forEach [3, 4, 5];
    format [("STR_ADVSEC_lkit_summary" call ADVSEC_fnc_L), (_n select {_x isNotEqualTo ""}) joinString ", ", _items]
};

private _slotNames = {
    // piezas colocadas en los huecos de la taquilla (TSL_gear)
    private _n = [];
    {
        if (_x isEqualType [] && {_x isNotEqualTo []}) then {
            private _v = _x select 0;
            private _cls = if (_v isEqualType "") then {_v} else {_v param [0, ""]};
            if (_cls isEqualType "" && {_cls isNotEqualTo ""}) then {
                private _t = getText (configFile >> "CfgWeapons" >> _cls >> "displayName");
                if (_t isEqualTo "") then {_t = getText (configFile >> "CfgVehicles" >> _cls >> "displayName")};
                if (_t isEqualTo "") then {_t = getText (configFile >> "CfgGlasses" >> _cls >> "displayName")};
                _n pushBack ([_t, _cls] select (_t isEqualTo ""));
            };
        };
    } forEach (_l getVariable ["TSL_gear", []]);
    _n
};
private _slots = !isNil "TSL_fnc_request";

switch (_action) do {
    case "info": {
        private _e = _db getOrDefault [_uid, []];
        private _sum = "";
        if (_e isNotEqualTo []) then {_sum = [_e select 1] call _summary};
        private _n = call _slotNames;
        if (_n isNotEqualTo []) then {
            _sum = [_sum, format [("STR_ADVSEC_lkit_slots_info" call ADVSEC_fnc_L), _n joinString ", "]] select {_x isNotEqualTo ""} joinString "<br/>";
        };
        [_e isNotEqualTo [] || {_n isNotEqualTo []}, _e param [0, ""], _sum] remoteExecCall ["ADVSEC_fnc_lockerKitMenu", _p];
    };
    case "save": {
        // Con TS_Lockers cargado cada pieza va a su hueco de la taquilla (fn_request "putAll")
        if (_slots) exitWith {
            ["lockerKitSave", _p, [mapGridPosition _l]] call ADVSEC_fnc_logEvent;
            [_l, _p, "putAll", []] call TSL_fnc_request;
        };
        if (_uid in _db) exitWith {("STR_ADVSEC_lkit_already" call ADVSEC_fnc_L) call _say};
        ([getUnitLoadout _p] call _split) params ["_kit", "_keep", "_uCls"];
        if ([_kit] call _empty) exitWith {("STR_ADVSEC_lkit_nothing" call ADVSEC_fnc_L) call _say};
        _db set [_uid, [call ADVSEC_fnc_now, _kit, name _p]];
        ["apply", [_uCls, _keep] call _bare] remoteExecCall ["ADVSEC_fnc_lockerKitMenu", _p];
        ["lkit"] call ADVSEC_fnc_dbDirty;
        ["lockerKitSave", _p, [mapGridPosition _l]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_lkit_saved" call ADVSEC_fnc_L), [_kit] call _summary]) call _say;
    };
    case "load": {
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo [] && {_slots}) exitWith {
            ["lockerKitLoad", _p, [mapGridPosition _l, false]] call ADVSEC_fnc_logEvent;
            [_l, _p, "takeAll", []] call TSL_fnc_request;
        };
        if (_e isEqualTo []) exitWith {("STR_ADVSEC_lkit_none" call ADVSEC_fnc_L) call _say};
        private _kit = +(_e select 1);
        ([getUnitLoadout _p] call _split) params ["_cur", "_keep", "_uCls"];
        // Equipo completo antiguo (guardado aparte, versiones < 1.22.1): solo se recupera; lo que lleva puesto
        // se guarda antes en los huecos para no volver a crear un equipo aparte.
        if (_slots && {!([_cur] call _empty)}) exitWith {("STR_ADVSEC_lkit_legacy_first" call ADVSEC_fnc_L) call _say};
        // El uniforme que lleva puesto se conserva; dentro va lo guardado y su documentación
        private _ku = _kit select 3;
        private _cls = [_uCls, _ku param [0, ""]] select (_uCls isEqualTo "");
        if (_cls isNotEqualTo "") then {_kit set [3, [_cls, (_ku param [1, []]) + _keep]]};
        if ([_cur] call _empty) then {_db deleteAt _uid} else {_db set [_uid, [call ADVSEC_fnc_now, _cur, name _p]]};
        ["apply", _kit] remoteExecCall ["ADVSEC_fnc_lockerKitMenu", _p];
        ["lkit"] call ADVSEC_fnc_dbDirty;
        ["lockerKitLoad", _p, [mapGridPosition _l, !([_cur] call _empty)]] call ADVSEC_fnc_logEvent;
        ([("STR_ADVSEC_lkit_loaded" call ADVSEC_fnc_L), ("STR_ADVSEC_lkit_swapped" call ADVSEC_fnc_L)] select !([_cur] call _empty)) call _say;
    };
};
