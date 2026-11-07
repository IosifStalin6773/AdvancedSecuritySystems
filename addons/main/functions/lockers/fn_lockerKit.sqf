/*
    [acción, jugador, taquilla] (servidor) — equipo completo guardado en la taquilla
    "save":  guarda todo lo que lleva encima (armas, chaleco, mochila, casco, gafas, prismáticos, objetos enlazados y el
             contenido del uniforme) y le deja con el uniforme y su documentación/credenciales ADVSEC.
    "load":  se equipa lo guardado; si lleva equipo encima, ese pasa a la taquilla (intercambio).
    "info":  -> [hay equipo, fecha, resumen] al cliente (ADVSEC_fnc_lockerKitMenu).
    Se guarda por SteamID en el perfil del servidor (clave _lkit), así que sobrevive a cambios de misión.
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

switch (_action) do {
    case "info": {
        private _e = _db getOrDefault [_uid, []];
        private _sum = "";
        if (_e isNotEqualTo []) then {_sum = [_e select 1] call _summary};
        [_e isNotEqualTo [], _e param [0, ""], _sum] remoteExecCall ["ADVSEC_fnc_lockerKitMenu", _p];
    };
    case "save": {
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
        if (_e isEqualTo []) exitWith {("STR_ADVSEC_lkit_none" call ADVSEC_fnc_L) call _say};
        private _kit = +(_e select 1);
        ([getUnitLoadout _p] call _split) params ["_cur", "_keep", "_uCls"];
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
