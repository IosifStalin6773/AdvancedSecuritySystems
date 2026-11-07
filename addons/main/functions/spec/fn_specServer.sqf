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
                case ((_a findIf {(_x select 0) isEqualTo _uid}) >= 0): {("STR_ADVSEC_request_sent" call ADVSEC_fnc_L)};
                default {""};
            };
            _rows pushBack [format [("STR_ADVSEC_members" call ADVSEC_fnc_L), [_id] call ADVSEC_fnc_specName, count _m, ["", format [("STR_ADVSEC_requests" call ADVSEC_fnc_L), count _a]] select (_a isNotEqualTo [] && {_uid in _l || _admin}), ["", " · " + toUpper _st] select (_st isNotEqualTo "")], _id,
                format [("STR_ADVSEC_members_managers_your_status" call ADVSEC_fnc_L), [_id] call ADVSEC_fnc_specName, count _m, ((_l apply {[_x] call _nameOf}) joinString ", ") call ADVSEC_fnc_repEsc, [("STR_ADVSEC_not_related" call ADVSEC_fnc_L), _st] select (_st isNotEqualTo "")],
                [[], [0.82, 0.64, 0.19, 1], [0.45, 1, 0.45, 1]] select (([_st == "encargado", _st == "miembro"] find true) + 1), ""];
        } forEach _db;
        ["specs", ("STR_ADVSEC_select_a_specialty_open_pda" call ADVSEC_fnc_L), _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "view": {
        _e params ["_m", "_l", "_a"];
        if (!_canManage && {!(_uid in _m)}) exitWith {("STR_ADVSEC_only_members_and_managers_can" call ADVSEC_fnc_L) call _say};
        private _rows = [];
        {_rows pushBack [format [("STR_ADVSEC_request_2" call ADVSEC_fnc_L), _x select 1, _x select 2], ["app", _x select 0], format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Solicitada: %3<br/><t color='#8C8C8C'>«Aceptar» le da de alta; «Rechazar / baja» la descarta.</t>", (_x select 1) call ADVSEC_fnc_repEsc, _x select 0, _x select 2], [1, 0.75, 0.3, 1], ""]} forEach _a;
        {
            private _on = !isNull ([_x] call ADVSEC_fnc_uidUnit);
            private _g = (_pdb getOrDefault [_x, []]) param [7, 0];
            _rows pushBack [format ["%1%2 · %3%4", ["", "★ "] select (_x in _l), [_x] call _nameOf, [7, _g] call ADVSEC_fnc_pdbRankName, ["", ("STR_ADVSEC_online_4" call ADVSEC_fnc_L)] select _on], ["mem", _x],
                format [("STR_ADVSEC_steamid_rank" call ADVSEC_fnc_L), ([_x] call _nameOf) call ADVSEC_fnc_repEsc, _x, [7, _g] call ADVSEC_fnc_pdbRankName, [("STR_ADVSEC_member" call ADVSEC_fnc_L), ("STR_ADVSEC_specialty_manager_2" call ADVSEC_fnc_L)] select (_x in _l), ["", ("STR_ADVSEC_online_5" call ADVSEC_fnc_L)] select _on],
                [[], [0.82, 0.64, 0.19, 1]] select (_x in _l), ""];
        } forEach _m;
        ["spec_" + _sp, format [("STR_ADVSEC_members_requests" call ADVSEC_fnc_L), [_sp] call ADVSEC_fnc_specName, count _m, count _a, [("STR_ADVSEC_read_only_you_are_not" call ADVSEC_fnc_L), ""] select _canManage], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "apply": {
        if (_uid in (_e select 0)) exitWith {("STR_ADVSEC_you_already_belong_to_that" call ADVSEC_fnc_L) call _say};
        if (((_e select 2) findIf {(_x select 0) isEqualTo _uid}) >= 0) exitWith {("STR_ADVSEC_you_already_have_a_pending" call ADVSEC_fnc_L) call _say};
        (_e select 2) pushBack [_uid, name _caller, call ADVSEC_fnc_now];
        [("STR_ADVSEC_join_request" call ADVSEC_fnc_L)] call _hist;
        {(format [("STR_ADVSEC_asks_to_join" call ADVSEC_fnc_L), name _caller, [_sp] call ADVSEC_fnc_specName]) remoteExecCall ["hint", _x]} forEach ((_e select 1) apply {[_x] call ADVSEC_fnc_uidUnit} select {!isNull _x});
        ("STR_ADVSEC_request_sent_to_the_managers" call ADVSEC_fnc_L) call _say;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "leave": {
        _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _uid}];
        _e set [0, (_e select 0) - [_uid]];
        _e set [1, (_e select 1) - [_uid]];
        [("STR_ADVSEC_voluntary_leave" call ADVSEC_fnc_L)] call _hist;
        [_caller] call ADVSEC_fnc_specApply;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "accept";
    case "reject";
    case "remove";
    case "add";
    case "lead": {
        if (!_canManage) exitWith {[_caller, format [("STR_ADVSEC_manage_the_specialty" call ADVSEC_fnc_L), _sp]] call ADVSEC_fnc_deny};
        private _t = if (_action == "add") then {if (_who isEqualType objNull && {!isNull _who}) then {getPlayerUID _who} else {""}} else {_who};
        if !(_t isEqualType "") exitWith {};
        if (_t isEqualTo "") exitWith {};
        switch (_action) do {
            case "accept";
            case "add": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                (_e select 0) pushBackUnique _t;
                [format [("STR_ADVSEC_joined" call ADVSEC_fnc_L), [_t] call _nameOf]] call _hist;
            };
            case "reject";
            case "remove": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                _e set [0, (_e select 0) - [_t]];
                if (_admin) then {_e set [1, (_e select 1) - [_t]]};
                [format [("STR_ADVSEC_left" call ADVSEC_fnc_L), [_t] call _nameOf]] call _hist;
            };
            case "lead": {
                if (!_admin) exitWith {("STR_ADVSEC_only_a_superadmin_appoints_managers" call ADVSEC_fnc_L) call _say};
                if (_t in (_e select 1)) then {_e set [1, (_e select 1) - [_t]]} else {(_e select 1) pushBack _t; (_e select 0) pushBackUnique _t};
                [format [("STR_ADVSEC_manager_2" call ADVSEC_fnc_L), [_t] call _nameOf]] call _hist;
            };
        };
        ["specChange", _caller, [_sp, _action, _t]] call ADVSEC_fnc_logEvent;
        _t call _refresh;
        ["view", _caller, [_sp]] call ADVSEC_fnc_specServer;
    };
};
