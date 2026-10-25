/*
    [acción, llamador, args] (servidor) — especialidades (metopas)
    "list" · "view" [esp] · "apply" [esp] · "leave" [esp] · "accept" [esp, uid] · "reject" [esp, uid]
    "add" [esp, unidad] · "remove" [esp, uid] · "lead" [esp, uid] (alternar encargado; solo superadministradores)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = [] call ADVSEC_fnc_specDB;
private _uid = getPlayerUID _caller;
private _say = {_this remoteExecCall ["hint", _caller]};
private _pdb = [] call ADVSEC_fnc_pdbDB;
private _nameOf = {params ["_k"]; ((_pdb getOrDefault [_k, []]) param [0, _k])};
_args params [["_sp", ""], "_who"];
private _e = _db getOrDefault [_sp, []];
private _admin = [_caller] call ADVSEC_fnc_adminIs;
private _canManage = _admin || {_e isNotEqualTo [] && {_uid in (_e select 1)}};
private _hist = {params ["_t"]; (_e select 3) pushBack [call ADVSEC_fnc_now, name _caller, _t]; if (count (_e select 3) > 60) then {(_e select 3) deleteAt 0}; ["spec"] call ADVSEC_fnc_dbDirty};
private _refresh = {
    private _u = [_this] call ADVSEC_fnc_uidUnit;
    if (!isNull _u) then {[_u] call ADVSEC_fnc_specApply};
};
if (_action != "list" && {_e isEqualTo []}) exitWith {};

switch (_action) do {
    case "list": {
        private _rows = [];
        {
            private _id = _x;
            _y params ["_m", "_l", "_a"];
            private _st = switch (true) do {
                case (_uid in _l): {"encargado"};
                case (_uid in _m): {"miembro"};
                case ((_a findIf {(_x select 0) isEqualTo _uid}) >= 0): {"solicitud enviada"};
                default {""};
            };
            _rows pushBack [format ["%1 · %2 miembros%3%4", [_id] call ADVSEC_fnc_specName, count _m, ["", format [" · %1 solicitudes", count _a]] select (_a isNotEqualTo [] && {_uid in _l || _admin}), ["", " · " + toUpper _st] select (_st isNotEqualTo "")], _id,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Miembros: %2<br/>Encargados: %3<br/>Tu situación: %4", [_id] call ADVSEC_fnc_specName, count _m, ((_l apply {[_x] call _nameOf}) joinString ", ") call ADVSEC_fnc_repEsc, ["sin relación", _st] select (_st isNotEqualTo "")],
                [[], [0.82, 0.64, 0.19, 1], [0.45, 1, 0.45, 1]] select (([_st == "encargado", _st == "miembro"] find true) + 1), ""];
        } forEach _db;
        ["specs", "Selecciona una especialidad: «Abrir PDA» para ver su lista o «Solicitar ingreso».", _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "view": {
        _e params ["_m", "_l", "_a"];
        if (!_canManage && {!(_uid in _m)}) exitWith {"Solo los miembros y encargados ven la lista." call _say};
        private _rows = [];
        {_rows pushBack [format ["SOLICITUD · %1 · %2", _x select 1, _x select 2], ["app", _x select 0], format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Solicitada: %3<br/><t color='#8C8C8C'>«Aceptar» le da de alta; «Rechazar / baja» la descarta.</t>", (_x select 1) call ADVSEC_fnc_repEsc, _x select 0, _x select 2], [1, 0.75, 0.3, 1], ""]} forEach _a;
        {
            private _on = !isNull ([_x] call ADVSEC_fnc_uidUnit);
            private _g = (_pdb getOrDefault [_x, []]) param [7, 0];
            _rows pushBack [format ["%1%2 · %3%4", ["", "★ "] select (_x in _l), [_x] call _nameOf, [7, _g] call ADVSEC_fnc_pdbRankName, ["", " · en línea"] select _on], ["mem", _x],
                format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Rango: %3<br/>%4%5", ([_x] call _nameOf) call ADVSEC_fnc_repEsc, _x, [7, _g] call ADVSEC_fnc_pdbRankName, ["Miembro", "Encargado de la especialidad"] select (_x in _l), ["", "<br/><t color='#66FF66'>EN LÍNEA</t>"] select _on],
                [[], [0.82, 0.64, 0.19, 1]] select (_x in _l), ""];
        } forEach _m;
        ["spec_" + _sp, format ["<t size='1.1' font='RobotoCondensedBold'>%1</t> · %2 miembros · %3 solicitudes%4", [_sp] call ADVSEC_fnc_specName, count _m, count _a, ["<br/><t color='#8C8C8C'>Solo lectura: no eres encargado.</t>", ""] select _canManage], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "apply": {
        if (_uid in (_e select 0)) exitWith {"Ya perteneces a esa especialidad." call _say};
        if (((_e select 2) findIf {(_x select 0) isEqualTo _uid}) >= 0) exitWith {"Ya tienes una solicitud pendiente." call _say};
        (_e select 2) pushBack [_uid, name _caller, call ADVSEC_fnc_now];
        ["Solicitud de ingreso"] call _hist;
        {(format ["%1 solicita entrar en %2.", name _caller, [_sp] call ADVSEC_fnc_specName]) remoteExecCall ["hint", _x]} forEach ((_e select 1) apply {[_x] call ADVSEC_fnc_uidUnit} select {!isNull _x});
        "Solicitud enviada a los encargados." call _say;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "leave": {
        _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _uid}];
        _e set [0, (_e select 0) - [_uid]];
        _e set [1, (_e select 1) - [_uid]];
        ["Baja voluntaria"] call _hist;
        [_caller] call ADVSEC_fnc_specApply;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "accept";
    case "reject";
    case "remove";
    case "add";
    case "lead": {
        if (!_canManage) exitWith {[_caller, format ["gestionar la especialidad %1", _sp]] call ADVSEC_fnc_deny};
        private _t = if (_action == "add") then {if (_who isEqualType objNull && {!isNull _who}) then {getPlayerUID _who} else {""}} else {_who};
        if !(_t isEqualType "") exitWith {};
        if (_t isEqualTo "") exitWith {};
        switch (_action) do {
            case "accept";
            case "add": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                (_e select 0) pushBackUnique _t;
                [format ["Alta de %1", [_t] call _nameOf]] call _hist;
            };
            case "reject";
            case "remove": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                _e set [0, (_e select 0) - [_t]];
                if (_admin) then {_e set [1, (_e select 1) - [_t]]};
                [format ["Baja de %1", [_t] call _nameOf]] call _hist;
            };
            case "lead": {
                if (!_admin) exitWith {"Solo un superadministrador nombra encargados." call _say};
                if (_t in (_e select 1)) then {_e set [1, (_e select 1) - [_t]]} else {(_e select 1) pushBack _t; (_e select 0) pushBackUnique _t};
                [format ["Encargado: %1", [_t] call _nameOf]] call _hist;
            };
        };
        ["specChange", _caller, [_sp, _action, _t]] call ADVSEC_fnc_logEvent;
        _t call _refresh;
        ["view", _caller, [_sp]] call ADVSEC_fnc_specServer;
    };
};
