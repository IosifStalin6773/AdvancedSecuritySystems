/*
    [acción, llamador, args] (servidor) — contratos de la PMC y reputación de clientes
    "list" · "clients" · "offer" [tipo, cliente, pos, radio, pago, minutos, ruta, objeto, título] (Zeus) · "gen" (interno)
    "counter" [id, %pago, %anticipo, %penalización] · "sign" [id, seguro] · "assign" [id, [uid], roe] · "route" [id, puntos]
    "start" [id] · "cancel" [id] · "evac" [id] · "show" [id] · "declare" · "review" [id, veredicto] · "tick" (interno)
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if (_action in ["tick", "gen"] && {call ADVSEC_fnc_fromClient}) exitWith {};
if (!(_action in ["tick", "gen"]) && {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _db = [] call ADVSEC_fnc_ctrDB;
private _cl = localNamespace getVariable ["ADVSEC_ctrClients", createHashMap];
private _say = {if (!isNull _caller) then {_this remoteExecCall ["hint", _caller]}};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _fmt = {format ["%1 %2", (round _this) call BIS_fnc_numberText, _cur]};
private _cfgOf = {
    params ["_list", "_key"];
    private _r = configNull;
    {if (configName _x == _key) exitWith {_r = _x}} forEach ([_list] call ADVSEC_fnc_pmcClasses);
    _r
};
private _clName = {private _c = ["Clients", _this] call _cfgOf; [_this, [_c, "name", _this] call ADVSEC_fnc_pmcVal] select !isNull _c};
private _tyName = {private _c = ["ContractTypes", _this] call _cfgOf; [_this, [_c, "name", _this] call ADVSEC_fnc_pmcVal] select !isNull _c};
private _rep = {(_cl getOrDefault [_this, [0]]) select 0};
// Nivel de reputación -> [texto, riesgo máximo]
private _tier = {
    switch (true) do {
        case (_this < -30): {[("STR_ADVSEC_pmc_tier_banned" call ADVSEC_fnc_L), 0]};
        case (_this < 20): {[("STR_ADVSEC_pmc_tier_neutral" call ADVSEC_fnc_L), 1]};
        case (_this < 50): {[("STR_ADVSEC_pmc_tier_reliable" call ADVSEC_fnc_L), 2]};
        case (_this < 80): {[("STR_ADVSEC_pmc_tier_preferred" call ADVSEC_fnc_L), 3]};
        default {[("STR_ADVSEC_pmc_tier_partner" call ADVSEC_fnc_L), 3]};
    }
};
private _repAdd = {
    params ["_key", "_d", "_why"];
    if (_d == 0) exitWith {};
    private _e = _cl getOrDefault [_key, [0, 0, 0, call ADVSEC_fnc_utcMin, []]];
    _e set [0, (((_e select 0) + _d) max -100) min 100];
    (_e select 4) pushBack [call ADVSEC_fnc_now, round _d, _why];
    if (count (_e select 4) > 30) then {(_e select 4) deleteAt 0};
    _cl set [_key, _e];
    ["clients"] call ADVSEC_fnc_dbDirty;
    missionNamespace setVariable ["ADVSEC_clientRep", (keys _cl) apply {[_x, (_cl get _x) select 0]}, true];
};
private _pm = {(allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PMC"] call ADVSEC_fnc_repAccess}}};
// Requisitos ajustables (CBA, para probar en local). contractMinOps >= 0 se aplica también a las ofertas ya abiertas.
private _minOps = {private _o = round (["contractMinOps", -1] call ADVSEC_fnc_setting); [_this get "minOps", _o] select (_o >= 0)};
private _chkRep = (["contractCheckRep", 1] call ADVSEC_fnc_setting) isEqualTo 1;
private _chkSpecs = (["contractCheckSpecs", 1] call ADVSEC_fnc_setting) isEqualTo 1;
private _units = {
    params ["_c"];
    private _duty = (["patrolNeedDuty", 1] call ADVSEC_fnc_setting) isEqualTo 1;
    ((_c get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) select {!isNull _x && {alive _x} && {!_duty || {_x getVariable ["ADVSEC_onDuty", false]}}}
};
private _notify = {
    params ["_c", "_msg"];
    private _to = ((_c get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) + [[(_c get "signer") param [0, ""]] call ADVSEC_fnc_uidUnit];
    _to = (_to select {!isNull _x}) arrayIntersect (_to select {!isNull _x});
    if (_to isNotEqualTo []) then {_msg remoteExecCall ["hint", _to]};
};
private _ctrPts = {
    // puntos que se muestran en el mapa: la ruta o el centro de la zona
    params ["_c"];
    private _r = _c get "route";
    [_r, [_c get "pos"]] select (_r isEqualTo [])
};
private _push = {
    params ["_id", "_c", ["_to", []]];
    private _st = switch (_c get "state") do {case "En curso": {"active"}; case "Firmado": {"assigned"}; default {"done"}};
    if (_to isEqualTo []) then {
        _to = ((_c get "assigned") apply {[_x select 0] call ADVSEC_fnc_uidUnit}) + [[(_c get "signer") param [0, ""]] call ADVSEC_fnc_uidUnit];
        _to = (_to select {!isNull _x}) arrayIntersect (_to select {!isNull _x});
    };
    if (_to isEqualTo []) exitWith {};
    private _p = [_c] call _ctrPts;
    private _rch = _c get "reached";
    if (count _rch != count _p) then {_rch = _p apply {false}};
    [_id, _c get "title", _p, _rch, [_c get "radius", 60] select ((_c get "route") isNotEqualTo []), _st] remoteExecCall ["ADVSEC_fnc_patrolMarkers", _to];
};
private _newMetrics = {
    createHashMapFromArray [["incidents", []], ["costs", []], ["exposure", 0], ["vipDmg", 0], ["advance", false], ["advT", 0], ["presence", 0], ["ticks", 0],
        ["actions", 0], ["responses", []], ["penal", []], ["deviation", false], ["vehDmg", 0], ["host", 0], ["hostDown", 0]]
};
private _offer = {
    // [tipo, cliente, pos, radio, pago, minutos, ruta, título] -> id
    params ["_type", "_client", "_pos", "_rad", "_pay", "_min", "_route", "_title"];
    private _tc = ["ContractTypes", _type] call _cfgOf;
    private _cc = ["Clients", _client] call _cfgOf;
    private _n = (localNamespace getVariable ["ADVSEC_ctrSeq", 0]) + 1;
    localNamespace setVariable ["ADVSEC_ctrSeq", _n];
    private _id = format ["C-%1", _n];
    private _risk = [_tc, "risk", 1] call ADVSEC_fnc_pmcVal;
    if (_title isEqualTo "") then {_title = format ["%1 · %2", _client call _clName, _type call _tyName]};
    // contractMinOps >= 0 fija el número de operadores PM (útil para probar en local); -1 usa el de cada tipo
    private _minOps = ["contractMinOps", -1] call ADVSEC_fnc_setting;
    if (_minOps < 0) then {_minOps = [_tc, "minOps", 2] call ADVSEC_fnc_pmcVal};
    private _c = createHashMapFromArray [
        ["id", _id], ["client", _client], ["type", _type], ["title", _title select [0, 60]], ["pos", [_pos select 0, _pos select 1]], ["radius", _rad],
        ["route", _route], ["minutes", _min], ["pay", round _pay], ["adv", ["contractAdvance", 0.3] call ADVSEC_fnc_setting], ["penal", 0.5],
        ["repMin", [-30, 0, 20, 50] select (_risk min 3)], ["specs", [_tc, "specs", []] call ADVSEC_fnc_pmcVal], ["minOps", _minOps],
        ["grey", ([_cc, "kind", ""] call ADVSEC_fnc_pmcVal) == "grey"], ["risk", _risk], ["rounds", ["contractRounds", 2] call ADVSEC_fnc_setting], ["rejects", 0],
        ["state", "Ofertado"], ["signer", []], ["assigned", []], ["roe", "Ámbar"], ["insured", false], ["created", call ADVSEC_fnc_now],
        ["expires", serverTime + 120 * (["contractEvery", 45] call ADVSEC_fnc_setting)], ["t0", -1], ["start", ""], ["end", ""], ["home", []],
        ["evac", false], ["reached", []], ["metrics", call _newMetrics], ["result", ""], ["sheet", ""], ["report", ""], ["review", ""]
    ];
    _db set [_id, _c];
    private _ids = keys _db;
    if (count _ids > 100) then {
        _ids = [_ids, [], {parseNumber (_x select [2])}, "ASCEND"] call BIS_fnc_sortBy;
        {if (((_db get _x) get "state") in ["Cumplido", "Parcial", "Fallido", "Rescindido", "Retirado"]) then {_db deleteAt _x}} forEach (_ids select [0, count _ids - 100]);
    };
    ["contracts"] call ADVSEC_fnc_dbDirty;
    {(format [("STR_ADVSEC_pmc_new_offer" call ADVSEC_fnc_L), _id, _title]) remoteExecCall ["systemChat", _x]} forEach ((call _pm) select {[_x, "contractSign"] call ADVSEC_fnc_perm});
    _id
};
private _routeFrom = {
    // ruta automática entre dos puntos: un punto cada ~700 m, ajustado a la carretera más cercana
    params ["_a", "_b"];
    private _d = _a distance2D _b;
    private _n = ((ceil (_d / 700)) max 2) min 12;
    private _out = [];
    for "_i" from 0 to _n do {
        private _p = (_a vectorMultiply (1 - _i / _n)) vectorAdd (_b vectorMultiply (_i / _n));
        private _r = [_p, 150] call BIS_fnc_nearestRoad;
        if (!isNull _r) then {_p = getPosATL _r};
        _out pushBack [_p select 0, _p select 1];
    };
    _out
};
private _sheet = {
    // ficha del contrato (texto estructurado)
    params ["_c"];
    private _m = _c get "metrics";
    private _cost = 0; {_cost = _cost + (_x select 1)} forEach (_m get "costs");
    private _pen = 0; {_pen = _pen + (_x select 1)} forEach (_m get "penal");
    private _t = format [("STR_ADVSEC_pmc_sheet" call ADVSEC_fnc_L),
        _c get "id", (_c get "title") call ADVSEC_fnc_repEsc, (_c get "client") call _clName, (_c get "type") call _tyName, (_c get "state") call ADVSEC_fnc_Lv,
        (_c get "pay") call _fmt, round ((_c get "adv") * 100), round ((_c get "penal") * 100), _c get "risk", _c get "repMin",
        [("STR_ADVSEC_pmc_no_limit" call ADVSEC_fnc_L), format ["%1 min", _c get "minutes"]] select ((_c get "minutes") > 0),
        mapGridPosition (_c get "pos"), _c get "radius", count (_c get "route"), _c call _minOps,
        [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), ((_c get "specs") apply {[_x] call ADVSEC_fnc_specName}) joinString ", "] select ((_c get "specs") isNotEqualTo []),
        [("STR_ADVSEC_no" call ADVSEC_fnc_L), ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select (_c get "grey"),
        ((_c get "signer") param [1, "-"]) call ADVSEC_fnc_repEsc, (((_c get "assigned") apply {_x select 1}) joinString ", ") call ADVSEC_fnc_repEsc,
        (_c get "roe") call ADVSEC_fnc_Lv, [("STR_ADVSEC_no" call ADVSEC_fnc_L), ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select (_c get "insured"),
        [_c get "start", "-"] select ((_c get "start") isEqualTo ""), [_c get "end", "-"] select ((_c get "end") isEqualTo ""),
        _cost call _fmt, _pen call _fmt, count (_m get "incidents")
    ];
    {
        _x params ["_k", "_uid", "_nm", "_grid", "_val", "_date", ["_decl", false]];
        _t = _t + format ["<br/>· %1 · %2 · %3 · %4%5", (format ["STR_ADVSEC_pmc_inc_%1", _k]) call ADVSEC_fnc_L, _nm call ADVSEC_fnc_repEsc, _grid, _date, ["", (" · " + ("STR_ADVSEC_pmc_declared" call ADVSEC_fnc_L))] select _decl];
    } forEach (_m get "incidents");
    if ((_m get "responses") isNotEqualTo []) then {
        _t = _t + "<br/>" + ("STR_ADVSEC_pmc_qrf_responses" call ADVSEC_fnc_L) + ((_m get "responses") apply {format [" %1 (%2)", [(_x select 1) / 60, "MM:SS"] call BIS_fnc_secondsToString, _x select 0]} joinString ",");
    };
    if ((_m getOrDefault ["host", 0]) > 0) then {
        _t = _t + format [("STR_ADVSEC_pmc_host_sheet" call ADVSEC_fnc_L), _m get "host", _m getOrDefault ["hostDown", 0]];
    };
    if ((_c get "type") == "vip") then {
        _t = _t + format [("STR_ADVSEC_pmc_vip_metrics" call ADVSEC_fnc_L), round (_m get "exposure"), round ((_m get "vipDmg") * 100), [("STR_ADVSEC_no" call ADVSEC_fnc_L), ("STR_ADVSEC_yes" call ADVSEC_fnc_L)] select (_m get "advance")];
    };
    if ((_c get "sheet") isNotEqualTo "") then {_t = _t + "<br/><br/>" + (_c get "sheet")};
    _t
};
private _finish = {
    // Cierra el contrato con un resultado y lo liquida (o lo deja en revisión de Compliance)
    params ["_id", "_c", "_res", ["_why", ""]];
    private _m = _c get "metrics";
    _c set ["end", call ADVSEC_fnc_now];
    _c set ["result", _res];
    if (_why isNotEqualTo "") then {_c set ["sheet", _why]};
    // Retira al VIP y la carga
    private _tmp = localNamespace getVariable ["ADVSEC_ctrObjs", createHashMap];
    {if (!isNull _x && {!isPlayer _x}) then {[_x] spawn {params ["_o"]; sleep 60; if (!isNull _o) then {deleteVehicle _o}}}} forEach (_tmp getOrDefault [_id, []]);
    _tmp deleteAt _id;
    ["end", _id] call ADVSEC_fnc_ctrHostiles;
    ["end", _id] call ADVSEC_fnc_ctrCivil;
    // Nóminas de los asignados mientras duró
    private _every = ["salaryInterval", 30] call ADVSEC_fnc_setting;
    if (_every > 0 && {(_c get "t0") >= 0}) then {
        private _min = (serverTime - (_c get "t0")) / 60;
        (_m get "costs") pushBack [("STR_ADVSEC_pmc_cost_payroll" call ADVSEC_fnc_L), round (count (_c get "assigned") * (["salaryBase", 100] call ADVSEC_fnc_setting) * _min / _every)];
    };
    private _grave = {(_x select 0) in ["civKill", "civKillRoe", "clientProp", "vip"]} count (_m get "incidents");
    if (_res != "Rescindido" && {_grave >= (["collateralCaseAt", 2] call ADVSEC_fnc_setting) || {((_m get "incidents") findIf {(_x select 0) == "civKillRoe"}) >= 0}}) exitWith {
        _c set ["state", "Revisión"];
        private _lines = (_m get "incidents") apply {format ["- %1 · %2 · %3 · %4", (format ["STR_ADVSEC_pmc_inc_%1", _x select 0]) call ADVSEC_fnc_L, _x select 2, _x select 3, _x select 5]};
        private _rid = ["FAI01", format [("STR_ADVSEC_pmc_case_title" call ADVSEC_fnc_L), _id, _c get "title"], (_m get "incidents") apply {format ["%1 [%2]", _x select 2, _x select 1]},
            format [("STR_ADVSEC_pmc_case_body" call ADVSEC_fnc_L), _id, _res call ADVSEC_fnc_Lv, endl, _lines joinString endl], "Grave", true] call ADVSEC_fnc_repSystem;
        _c set ["review", _rid];
        _c set ["pendingRes", _res];
        [_c, format [("STR_ADVSEC_pmc_in_review" call ADVSEC_fnc_L), _id, _rid]] call _notify;
        {if ([_x, "caseClose"] call ADVSEC_fnc_perm) then {(format [("STR_ADVSEC_pmc_in_review" call ADVSEC_fnc_L), _id, _rid]) remoteExecCall ["systemChat", _x]}} forEach allPlayers;
        [_id, _c] call _push;
        ["contractReview", objNull, [_id, _rid, _grave]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
    };
    [_id, _c, _res] call ADVSEC_fnc_ctrSettle;
    [_id, _c] call _push;
};
switch (_action) do {
    case "roe": {
        // 1.22: cambio de ROE durante el encargo (escalonadas). Avisa a los asignados.
        _args params [["_id", ""], ["_roe", "Ámbar"]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "En curso"}) exitWith {("STR_ADVSEC_pmc_not_active" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractAssign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_assign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if !(_roe in ["Verde", "Ámbar", "Rojo"]) exitWith {};
        _c set ["roe", _roe];
        [_c, format [("STR_ADVSEC_pmc_roe_changed" call ADVSEC_fnc_L), _id, _roe call ADVSEC_fnc_Lv]] call _notify;
        ["contractRoe", _caller, [_id, _roe]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "intel": {
        // 1.22: resumen de célula (moral, nivel, descansos) e inteligencia compartida de los últimos encargos
        private _lvl = (floor ((localNamespace getVariable ["ADVSEC_cellWins", 0]) / 5)) min 5;
        private _txt = format [("STR_ADVSEC_pmc_cell_status" call ADVSEC_fnc_L), localNamespace getVariable ["ADVSEC_morale", 60], _lvl];
        private _intel = (localNamespace getVariable ["ADVSEC_intel", []]) select [(count (localNamespace getVariable ["ADVSEC_intel", []]) - 5) max 0];
        {_txt = _txt + endl + format ["%1 · %2 · %3", _x select 2, _x select 3, _x select 4]} forEach _intel;
        _txt call _say;
    };
    case "list": {
        if !([_caller, "contractView"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_view" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _uid = getPlayerUID _caller;
        private _rows = [];
        private _ids = [keys _db, [], {parseNumber (_x select [2])}, "DESCEND"] call BIS_fnc_sortBy;
        private _sec = {
            params ["_title", "_states"];
            private _sel = _ids select {((_db get _x) get "state") in _states};
            _rows pushBack [format ["▾ %1 (%2)", toUpper _title, count _sel], [], "", [0.4, 0.8, 1, 1], ""];
            {
                private _c = _db get _x;
                private _st = _c get "state";
                private _mine = (_c get "signer") param [0, ""] == _uid || {((_c get "assigned") findIf {(_x select 0) == _uid}) >= 0};
                _rows pushBack [format ["    %1 · %2 · %3 · %4%5", _x, _c get "title", (_c get "pay") call _fmt, _st call ADVSEC_fnc_Lv, ["", " ★"] select _mine],
                    [_x, _st, _c get "type"], [_c] call _sheet,
                    switch (_st) do {
                        case "Cumplido": {[0.45, 1, 0.45, 1]}; case "Fallido": {[1, 0.4, 0.4, 1]}; case "Parcial": {[1, 0.85, 0.4, 1]};
                        case "En curso": {[1, 0.75, 0.3, 1]}; case "Revisión": {[1, 0.5, 1, 1]}; case "Rescindido"; case "Retirado": {[0.55, 0.55, 0.55, 1]}; default {[]}
                    }, ["", ADVSEC_icAlarm] select (_c get "grey")];
            } forEach (_sel select [0, 25]);
        };
        [("STR_ADVSEC_pmc_tab_offers" call ADVSEC_fnc_L), ["Ofertado"]] call _sec;
        [("STR_ADVSEC_pmc_tab_active" call ADVSEC_fnc_L), ["Firmado", "En curso", "Revisión"]] call _sec;
        [("STR_ADVSEC_pmc_tab_history" call ADVSEC_fnc_L), ["Cumplido", "Parcial", "Fallido", "Rescindido", "Retirado"]] call _sec;
        private _active = {(_x get "state") in ["Firmado", "En curso", "Revisión"]} count (values _db);
        ["contract", format [("STR_ADVSEC_pmc_list_info" call ADVSEC_fnc_L), ([] call ADVSEC_fnc_ecoTreasuryNow) call _fmt, _active, ["contractMaxActive", 3] call ADVSEC_fnc_setting, count (call _pm)], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "clients": {
        if !([_caller, "contractView"] call ADVSEC_fnc_perm) exitWith {};
        private _rows = [];
        {
            private _k = configName _x;
            private _e = _cl getOrDefault [_k, [0, 0, 0, 0, []]];
            (_e select 0) call _tier params ["_tn", "_risk"];
            private _det = format [("STR_ADVSEC_pmc_client_sheet" call ADVSEC_fnc_L), (_k call _clName) call ADVSEC_fnc_repEsc, (format ["STR_ADVSEC_pmc_kind_%1", [_x, "kind", "corp"] call ADVSEC_fnc_pmcVal]) call ADVSEC_fnc_L,
                _e select 0, _tn, _risk, _e select 1, _e select 2, [_x, "payMul", 1] call ADVSEC_fnc_pmcVal,
                (([_x, "rivals", []] call ADVSEC_fnc_pmcVal) apply {_x call _clName}) joinString ", "];
            private _h = +(_e select 4);
            reverse _h;
            {_det = _det + format ["<br/>· %1 · %2%3 · %4", _x select 0, ["", "+"] select ((_x select 1) > 0), _x select 1, (_x select 2) call ADVSEC_fnc_repEsc]} forEach _h;
            _rows pushBack [format ["%1 · %2 (%3)", _k call _clName, _e select 0, _tn], [], _det,
                switch (true) do {case ((_e select 0) < -30): {[1, 0.4, 0.4, 1]}; case ((_e select 0) >= 50): {[0.45, 1, 0.45, 1]}; default {[]}}, ""];
        } forEach (["Clients"] call ADVSEC_fnc_pmcClasses);
        ["contract", ("STR_ADVSEC_pmc_clients_info" call ADVSEC_fnc_L), _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "offer": {
        // Zeus, o el propio servidor (módulo de Eden «Encargo a medida»)
        if (!(isNull _caller && {!(call ADVSEC_fnc_fromClient)}) && {!([_caller] call ADVSEC_fnc_isZeus)}) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_offer" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_type", "escort"], ["_client", ""], ["_pos", [0, 0, 0]], ["_rad", 150], ["_pay", 0], ["_min", 0], ["_route", []], ["_obj", objNull], ["_title", ""], ["_hMode", -1], ["_hN", -1],
            ["_hSide", ""], ["_hCls", []], ["_hUnits", -1], ["_clLabel", ""], ["_edenKey", ""]];
        if (_title isEqualTo "" && {_clLabel isNotEqualTo ""}) then {_title = format ["%1 · %2", _clLabel select [0, 40], _type call _tyName]};
        if (isNull (["ContractTypes", _type] call _cfgOf)) exitWith {("STR_ADVSEC_invalid_data" call ADVSEC_fnc_L) call _say};
        if (isNull (["Clients", _client] call _cfgOf)) then {_client = configName ((["Clients"] call ADVSEC_fnc_pmcClasses) select 0)};
        private _tc = ["ContractTypes", _type] call _cfgOf;
        if (_pay <= 0) then {_pay = [_tc, "base", 5000] call ADVSEC_fnc_pmcVal};
        if (_min <= 0) then {_min = [_tc, "minutes", 45] call ADVSEC_fnc_pmcVal};
        if (_type in ["escort", "vip"] && {_route isEqualTo []}) then {
            private _dst = _pos getPos [1500 + random 2500, random 360];
            private _loc = (nearestLocations [_dst, ["NameVillage", "NameCity", "NameCityCapital", "NameLocal"], 2000]) param [0, locationNull];
            if (!isNull _loc) then {_dst = locationPosition _loc};
            _route = [_pos, _dst] call _routeFrom;
        };
        private _id = [_type, _client, _pos, (_rad max 30) min 1000, _pay, _min, _route, _title] call _offer;
        if (!isNull _obj) then {(_db get _id) set ["objNet", (_obj call BIS_fnc_netId)]};
        if (_hMode isEqualType 0 && {_hMode >= 0}) then {(_db get _id) set ["hostileMode", _hMode min 3]};
        if (_hN isEqualType 0 && {_hN >= 0}) then {(_db get _id) set ["hostileN", _hN min 12]};
        // Encargo a medida (1.20.1): bando, clases y número de NPC, nombre del cliente; las de Eden no caducan
        if (_hSide isEqualType "" && {_hSide in ["east", "west", "independent", "civilian"]}) then {(_db get _id) set ["hostileSide", _hSide]};
        if (_hCls isEqualType [] && {_hCls isNotEqualTo []}) then {(_db get _id) set ["hostileClasses", (_hCls select {_x isEqualType "" && {isClass (configFile >> "CfgVehicles" >> _x)}}) select [0, 60]]};
        if (_hUnits isEqualType 0 && {_hUnits >= 0}) then {(_db get _id) set ["hostileUnits", _hUnits min 60]};
        if (_clLabel isEqualType "" && {_clLabel isNotEqualTo ""}) then {(_db get _id) set ["clientName", _clLabel select [0, 40]]};
        if (_edenKey isEqualType "" && {_edenKey isNotEqualTo ""}) then {(_db get _id) set ["edenKey", _edenKey]; (_db get _id) set ["expires", serverTime + 1e7]};
        // 1.22: subasta. Con contractAuctionMin > 0 las compañías pujan (% del pago) hasta que cierra el plazo
        private _aMin = ["contractAuctionMin", 0] call ADVSEC_fnc_setting;
        if (_aMin > 0) then {(_db get _id) set ["auctionEnd", serverTime + _aMin * 60]; (_db get _id) set ["bids", []]};
        (format [("STR_ADVSEC_pmc_offer_published" call ADVSEC_fnc_L), _id]) call _say;
        ["contractOffer", _caller, [_id, _type, _client, _pay]] call ADVSEC_fnc_logEvent;
    };
    case "gen": {
        // Generador automático de ofertas (bucle del servidor) y decaimiento de la reputación
        private _now = call ADVSEC_fnc_utcMin;
        private _decay = 1440 * (["contractRepDecay", 3] call ADVSEC_fnc_setting);
        if (_decay > 0) then {
            {
                if (_now - (_y select 3) >= _decay && {(_y select 0) != 0}) then {
                    _y set [0, (_y select 0) - ([-1, 1] select ((_y select 0) > 0))];
                    _y set [3, _now];
                    ["clients"] call ADVSEC_fnc_dbDirty;
                };
            } forEach _cl;
        };
        {if ((_y get "state") == "Ofertado" && {serverTime > (_y get "expires")}) then {_y set ["state", "Retirado"]; ["contracts"] call ADVSEC_fnc_dbDirty}} forEach _db;
        if ({(_x get "state") == "Ofertado"} count (values _db) >= (["contractMax", 6] call ADVSEC_fnc_setting)) exitWith {};
        private _clients = (["Clients"] call ADVSEC_fnc_pmcClasses) select {((configName _x) call _rep) >= -30};
        if (_clients isEqualTo []) exitWith {};
        private _cc = selectRandom _clients;
        private _key = configName _cc;
        private _maxRisk = [3, (((_key call _rep) call _tier) select 1) max 1] select _chkRep;
        private _types = (["ContractTypes"] call ADVSEC_fnc_pmcClasses) select {([_x, "risk", 1] call ADVSEC_fnc_pmcVal) <= _maxRisk};
        if (_types isEqualTo []) exitWith {};
        private _tc = selectRandom _types;
        private _type = configName _tc;
        // Zona: marcadores advsec_ctr_* o una población cerca de un terminal
        private _marks = allMapMarkers select {(_x find "advsec_ctr_") == 0};
        private _pos = [];
        if (_marks isNotEqualTo []) then {_pos = getMarkerPos selectRandom _marks} else {
            private _ref = (missionNamespace getVariable ["ADVSEC_ctrTerminals", []]) select {!isNull _x};
            private _c0 = [[worldSize / 2, worldSize / 2, 0], getPosATL selectRandom _ref] select (_ref isNotEqualTo []);
            private _locs = nearestLocations [_c0, ["NameVillage", "NameCity", "NameCityCapital", "NameLocal"], 6000];
            _pos = [_c0 getPos [500 + random 3000, random 360], locationPosition selectRandom _locs] select (_locs isNotEqualTo []);
        };
        private _risk = [_tc, "risk", 1] call ADVSEC_fnc_pmcVal;
        private _r = _key call _rep;
        private _pay = ([_tc, "base", 5000] call ADVSEC_fnc_pmcVal) * ([_cc, "payMul", 1] call ADVSEC_fnc_pmcVal) * (1 + 0.15 * _risk) * (0.8 + 0.45 * ((_r + 100) / 200));
        // Clientes rivales de uno vetado pagan un 10 % más
        if (((["Clients"] call ADVSEC_fnc_pmcClasses) findIf {(_key in ([_x, "rivals", []] call ADVSEC_fnc_pmcVal)) && {((configName _x) call _rep) < -30}}) >= 0) then {_pay = _pay * 1.1};
        private _route = [];
        if (_type in ["escort", "vip"]) then {
            private _locs = (nearestLocations [_pos, ["NameVillage", "NameCity", "NameCityCapital", "NameLocal"], 5000]) select {(locationPosition _x distance2D _pos) > 1200};
            private _dst = [_pos getPos [1500 + random 2500, random 360], locationPosition selectRandom _locs] select (_locs isNotEqualTo []);
            _route = [_pos, _dst] call _routeFrom;
        };
        [_type, _key, _pos, [150, 250] select (_type == "guard"), round (_pay / 50) * 50, [_tc, "minutes", 45] call ADVSEC_fnc_pmcVal, _route, ""] call _offer;
    };
    case "counter": {
        if !([_caller, "contractSign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_sign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_id", ""], ["_payP", 0], ["_advP", 30], ["_penP", 50]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Ofertado"}) exitWith {("STR_ADVSEC_pmc_not_an_offer" call ADVSEC_fnc_L) call _say};
        if ((_c get "rounds") <= 0) exitWith {("STR_ADVSEC_pmc_no_rounds_left" call ADVSEC_fnc_L) call _say};
        _payP = (_payP max 0) min 30; _advP = (_advP max 10) min 50; _penP = (_penP max 0) min 100;
        private _r = (_c get "client") call _rep;
        private _p = 0.9 - 0.02 * _payP - 0.005 * (_advP - 30) - 0.004 * (((_c get "penal") * 100) - _penP) + 0.003 * _r;
        _p = (_p max 0.05) min 0.95;
        _c set ["rounds", (_c get "rounds") - 1];
        private _ok = random 1 < _p;
        if (_ok) then {
            _c set ["pay", round ((_c get "pay") * (1 + _payP / 100))];
            _c set ["adv", _advP / 100];
            _c set ["penal", _penP / 100];
            (format [("STR_ADVSEC_pmc_counter_ok" call ADVSEC_fnc_L), (_c get "client") call _clName, round (_p * 100), (_c get "pay") call _fmt]) call _say;
        } else {
            _c set ["rejects", (_c get "rejects") + 1];
            if ((_c get "rejects") >= 2) then {
                _c set ["state", "Retirado"];
                [_c get "client", -2, format [("STR_ADVSEC_pmc_rep_withdrawn" call ADVSEC_fnc_L), _id]] call _repAdd;
                (format [("STR_ADVSEC_pmc_counter_withdrawn" call ADVSEC_fnc_L), (_c get "client") call _clName]) call _say;
            } else {
                (format [("STR_ADVSEC_pmc_counter_rejected" call ADVSEC_fnc_L), (_c get "client") call _clName, round (_p * 100)]) call _say;
            };
        };
        ["contractCounter", _caller, [_id, _payP, _advP, _penP, round (_p * 100), _ok]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "bid": {
        // 1.22: puja de una compañía (grupo) con el % del pago que pide (50-100). Gana la puja más baja al cerrar.
        if !([_caller, "contractSign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_sign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _args params [["_id", ""], ["_pct", 100]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Ofertado"}) exitWith {("STR_ADVSEC_pmc_not_an_offer" call ADVSEC_fnc_L) call _say};
        private _end = _c getOrDefault ["auctionEnd", 0];
        if (_end <= 0 || {_end <= serverTime}) exitWith {("STR_ADVSEC_pmc_auction_closed" call ADVSEC_fnc_L) call _say};
        _pct = (round _pct) max 50 min 100;
        private _g = groupId group _caller;
        private _bids = (_c getOrDefault ["bids", []]) select {(_x select 0) != _g};
        _bids pushBack [_g, _pct, name _caller];
        _c set ["bids", _bids];
        (format [("STR_ADVSEC_pmc_bid_ok" call ADVSEC_fnc_L), _pct, _g]) call _say;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "sign": {
        _args params [["_id", ""], ["_ins", false]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Ofertado"}) exitWith {("STR_ADVSEC_pmc_not_an_offer" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractSign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_sign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if ((_c get "grey") && {!([_caller, "contractGrey"] call ADVSEC_fnc_perm)}) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_grey" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _r = (_c get "client") call _rep;
        if (_chkRep && {_r < (_c get "repMin")}) exitWith {(format [("STR_ADVSEC_pmc_rep_too_low" call ADVSEC_fnc_L), _r, _c get "repMin"]) call _say};
        if ({(_x get "state") in ["Firmado", "En curso", "Revisión"]} count (values _db) >= (["contractMaxActive", 3] call ADVSEC_fnc_setting)) exitWith {("STR_ADVSEC_pmc_too_many_active" call ADVSEC_fnc_L) call _say};
        private _on = call _pm;
        if (count _on < (_c call _minOps)) exitWith {(format [("STR_ADVSEC_pmc_need_ops" call ADVSEC_fnc_L), _c call _minOps, count _on]) call _say};
        private _sdb = [] call ADVSEC_fnc_specDB;
        private _uids = _on apply {getPlayerUID _x};
        private _miss = [[], _c get "specs"] select _chkSpecs;
        _miss = _miss select {(((_sdb getOrDefault [_x, [[]]]) select 0) arrayIntersect _uids) isEqualTo []};
        if (_miss isNotEqualTo []) exitWith {(format [("STR_ADVSEC_pmc_need_specs" call ADVSEC_fnc_L), (_miss apply {[_x] call ADVSEC_fnc_specName}) joinString ", "]) call _say};
        // 1.22: subasta. Mientras esté abierta no se firma; después firma solo la puja más baja, al precio que pujó.
        if ((_c getOrDefault ["auctionEnd", 0]) > serverTime) exitWith {("STR_ADVSEC_pmc_auction_open" call ADVSEC_fnc_L) call _say};
        private _w = [];
        {if (_w isEqualTo [] || {(_x select 1) < (_w select 1)}) then {_w = _x}} forEach (_c getOrDefault ["bids", []]);
        if (_w isNotEqualTo [] && {(groupId group _caller) != (_w select 0)}) exitWith {(format [("STR_ADVSEC_pmc_auction_lost" call ADVSEC_fnc_L), _w select 0]) call _say};
        if (_w isNotEqualTo [] && {!(_c getOrDefault ["auctionPaid", false])}) then {
            _c set ["pay", round ((_c get "pay") * (_w select 1) / 100)];
            _c set ["auctionPaid", true];
        };
        // 1.22: ascenso de célula. Cada 5 contratos cumplidos sube un nivel y el pago sube un 5 % (máximo 25 %).
        if !(_c getOrDefault ["cellBonus", false]) then {
            private _lvl = (floor ((localNamespace getVariable ["ADVSEC_cellWins", 0]) / 5)) min 5;
            _c set ["pay", round ((_c get "pay") * (1 + 0.05 * _lvl))];
            _c set ["cellBonus", true];
        };
        private _adv = round ((_c get "pay") * (_c get "adv"));
        _c set ["state", "Firmado"];
        _c set ["signer", [getPlayerUID _caller, name _caller]];
        _c set ["home", getPosATL _caller];
        _c set ["insured", _ins];
        [_adv, format [("STR_ADVSEC_pmc_treasury_advance" call ADVSEC_fnc_L), _id, (_c get "client") call _clName]] call ADVSEC_fnc_ecoTreasury;
        if (_ins) then {
            private _prem = round ((_c get "pay") * (["contractInsurance", 0.05] call ADVSEC_fnc_setting));
            [-_prem, format [("STR_ADVSEC_pmc_treasury_insurance" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_ecoTreasury;
            ((_c get "metrics") get "costs") pushBack [("STR_ADVSEC_pmc_cost_insurance" call ADVSEC_fnc_L), _prem];
        };
        if (_c get "grey") then {[_caller, "contractGrey", _id, ["contractGreyHeat", 15] call ADVSEC_fnc_setting] call ADVSEC_fnc_heatAdd};
        (format [("STR_ADVSEC_pmc_signed" call ADVSEC_fnc_L), _id, _adv call _fmt]) call _say;
        ["contractSign", _caller, [_id, _c get "client", _c get "pay", _adv, _ins]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "sub": {
        // 1.22: subcontrata. El firmante cede un encargo firmado (sin iniciar) a otro agente PMC y cobra una comisión al cerrarlo.
        _args params [["_id", ""], ["_uid", ""]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Firmado"}) exitWith {("STR_ADVSEC_pmc_sub_started" call ADVSEC_fnc_L) call _say};
        if ((getPlayerUID _caller) != ((_c get "signer") param [0, ""])) exitWith {("STR_ADVSEC_pmc_sub_not_signer" call ADVSEC_fnc_L) call _say};
        if (_c getOrDefault ["subFrom", []] isNotEqualTo []) exitWith {("STR_ADVSEC_pmc_sub_already" call ADVSEC_fnc_L) call _say};
        private _t = [_uid] call ADVSEC_fnc_uidUnit;
        if (isNull _t || {!([_t, "PMC"] call ADVSEC_fnc_repAccess)} || {!([_t, "contractSign"] call ADVSEC_fnc_perm)}) exitWith {("STR_ADVSEC_pmc_sub_bad_target" call ADVSEC_fnc_L) call _say};
        _c set ["subFrom", [getPlayerUID _caller, name _caller, ["contractSubFee", 0.25] call ADVSEC_fnc_setting]];
        _c set ["signer", [_uid, name _t]];
        _c set ["assigned", []];
        (format [("STR_ADVSEC_pmc_sub_done" call ADVSEC_fnc_L), _id, name _t]) call _say;
        (format [("STR_ADVSEC_pmc_sub_received" call ADVSEC_fnc_L), _id, name _caller]) remoteExecCall ["hint", _t];
        ["contractSub", _caller, [_id, name _t]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "assign": {
        _args params [["_id", ""], ["_uids", []], ["_roe", "Ámbar"]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {!((_c get "state") in ["Firmado", "En curso"])}) exitWith {("STR_ADVSEC_pmc_not_signed" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractAssign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_assign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _as = [];
        {
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            if (!isNull _u && {[_u, "PMC"] call ADVSEC_fnc_repAccess}) then {_as pushBackUnique [_x, name _u]};
        } forEach (_uids select {_x isEqualType ""});
        private _rdb = localNamespace getVariable ["ADVSEC_rest", createHashMap];
        private _resting = _as select {(_rdb getOrDefault [_x select 0, 0]) > serverTime};
        if (_resting isNotEqualTo []) exitWith {(format [("STR_ADVSEC_pmc_resting" call ADVSEC_fnc_L), _resting apply {_x select 1} joinString ", "]) call _say};
        if (count _as < (_c call _minOps)) exitWith {(format [("STR_ADVSEC_pmc_need_ops" call ADVSEC_fnc_L), _c call _minOps, count _as]) call _say};
        if !(_roe in ["Verde", "Ámbar", "Rojo"]) then {_roe = "Ámbar"};
        _c set ["assigned", _as];
        _c set ["roe", _roe];
        [_c, format [("STR_ADVSEC_pmc_assigned_msg" call ADVSEC_fnc_L), _id, _c get "title", name _caller, _roe call ADVSEC_fnc_Lv]] call _notify;
        [_id, _c] call _push;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "route": {
        _args params [["_id", ""], ["_pts", []]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Firmado"}) exitWith {("STR_ADVSEC_pmc_not_signed" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractAssign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_assign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _pts = ((_pts select {_x isEqualType [] && {count _x >= 2}}) apply {[_x select 0, _x select 1]}) select [0, 30];
        if (count _pts < 2) exitWith {("STR_ADVSEC_pmc_route_two_points" call ADVSEC_fnc_L) call _say};
        _c set ["route", _pts];
        _c set ["pos", _pts select 0];
        [_id, _c] call _push;
        ("STR_ADVSEC_pmc_route_saved" call ADVSEC_fnc_L) call _say;
        ["contracts"] call ADVSEC_fnc_dbDirty;
    };
    case "start": {
        _args params [["_id", ""]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Firmado"}) exitWith {("STR_ADVSEC_pmc_not_signed" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractAssign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_assign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if ((_c get "assigned") isEqualTo []) exitWith {("STR_ADVSEC_pmc_assign_first" call ADVSEC_fnc_L) call _say};
        _c set ["state", "En curso"];
        _c set ["t0", serverTime];
        _c set ["start", call ADVSEC_fnc_now];
        _c set ["reached", ([_c] call _ctrPts) apply {false}];
        private _objs = [];
        private _type = _c get "type";
        private _given = ((_c getOrDefault ["objNet", ""]) call BIS_fnc_objectFromNetId);
        if (_type == "vip") then {
            private _vip = _given;
            if (isNull _vip || {!alive _vip}) then {
                private _g = createGroup [civilian, true];
                _vip = _g createUnit ["C_man_polo_1_F", (_c get "route") select 0, [], 5, "NONE"];
                    _vip setVariable ["ADVSEC_ctrSpawned", true];
                _objs pushBack _vip;
            };
            _vip setVariable ["ADVSEC_ctrVIP", _id, true];
            _vip setCaptive true;
            // Sigue al jefe de la célula (el primero asignado conectado)
            private _lead = ([_c] call _units) param [0, objNull];
            if (!isNull _lead) then {[_vip] joinSilent group _lead};
            [_vip, "VIPPass", [["name", name _vip], ["number", _id], ["issuer", (_c get "client") call _clName], ["clearance", 2], ["notes", _c get "title"]], true, true, true] call ADVSEC_fnc_docCreate;
            _c set ["vipNet", (_vip call BIS_fnc_netId)];
        };
        if (_type == "recovery") then {
            private _box = _given;
            if (isNull _box) then {
                _box = createVehicle ["Land_PlasticCase_01_medium_F", (_c get "pos") getPos [random ((_c get "radius") * 0.7), random 360], [], 0, "NONE"];
                _objs pushBack _box;
            };
            _box setVariable ["ADVSEC_ctrCargo", _id, true];
            _c set ["cargoNet", (_box call BIS_fnc_netId)];
        };
        private _tmp = localNamespace getVariable ["ADVSEC_ctrObjs", createHashMap];
        _tmp set [_id, _objs];
        localNamespace setVariable ["ADVSEC_ctrObjs", _tmp];
        // Enemigos: los ya colocados en la zona y/o generados (contractHostiles)
        (["start", _id, _c] call ADVSEC_fnc_ctrHostiles) params [["_hN", 0]];
        ["start", _id, _c] call ADVSEC_fnc_ctrCivil;
        if (_hN > 0) then {[_c, format [("STR_ADVSEC_pmc_host_intel" call ADVSEC_fnc_L), _id, _hN]] call _notify};
        // Disparos de los asignados (para atribuir daños a edificios)
        {
            private _u = [_x select 0] call ADVSEC_fnc_uidUnit;
            if (!isNull _u && {isNil {_u getVariable "ADVSEC_ctrFiredEH"}}) then {
                _u setVariable ["ADVSEC_ctrFiredEH", _u addEventHandler ["Fired", {(_this select 0) setVariable ["ADVSEC_lastShot", serverTime]}]];
            };
        } forEach (_c get "assigned");
        [_c, format [("STR_ADVSEC_pmc_started_msg" call ADVSEC_fnc_L), _id, _c get "title", (_c get "roe") call ADVSEC_fnc_Lv, [("STR_ADVSEC_pmc_no_limit" call ADVSEC_fnc_L), format ["%1 min", _c get "minutes"]] select ((_c get "minutes") > 0)]] call _notify;
        [_id, _c] call _push;
        ["contractStart", _caller, [_id, _type, (_c get "assigned") apply {_x select 1}]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
        [] call ADVSEC_fnc_pmcLoop;
    };
    case "cancel": {
        _args params [["_id", ""]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {!((_c get "state") in ["Firmado", "En curso"])}) exitWith {("STR_ADVSEC_pmc_not_signed" call ADVSEC_fnc_L) call _say};
        if !([_caller, "contractSign"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_sign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if ((_c get "state") == "Firmado") then {
            // Antes de empezar: se devuelve el anticipo y baja la reputación
            [-round ((_c get "pay") * (_c get "adv")), format [("STR_ADVSEC_pmc_treasury_refund" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_ecoTreasury;
            [_c get "client", -5, format [("STR_ADVSEC_pmc_rep_rescinded" call ADVSEC_fnc_L), _id]] call _repAdd;
            _c set ["state", "Rescindido"];
            _c set ["end", call ADVSEC_fnc_now];
            _c set ["result", ("STR_ADVSEC_pmc_rescinded_before" call ADVSEC_fnc_L)];
            [_id, _c] call _push;
            ["contracts"] call ADVSEC_fnc_dbDirty;
        } else {
            [_id, _c, "Rescindido", format [("STR_ADVSEC_pmc_rescinded_by" call ADVSEC_fnc_L), name _caller]] call _finish;
        };
        ["contractCancel", _caller, [_id]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "evac": {
        _args params [["_id", ""]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "En curso"}) exitWith {};
        if !([_caller, "contractAssign"] call ADVSEC_fnc_perm || {((_c get "assigned") findIf {(_x select 0) == getPlayerUID _caller}) == 0}) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_assign" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        _c set ["evac", !(_c get "evac")];
        [_c, format [[("STR_ADVSEC_pmc_evac_off" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_evac_on" call ADVSEC_fnc_L)] select (_c get "evac"), _id, name _caller]] call _notify;
        ["contracts"] call ADVSEC_fnc_dbDirty;
    };
    case "show": {
        _args params [["_id", ""]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0) exitWith {};
        [_id, _c, [_caller]] call _push;
        ("STR_ADVSEC_route_marked_on_your_map" call ADVSEC_fnc_L) call _say;
    };
    case "declare": {
        // El autor declara sus incidentes de los últimos 5 minutos: la sospecha se queda en la mitad
        private _uid = getPlayerUID _caller;
        private _n = 0;
        {
            {
                if ((_x select 1) == _uid && {!(_x param [6, false])} && {serverTime - (_x param [7, 0]) <= 300}) then {_x set [6, true]; _n = _n + 1};
            } forEach ((_y get "metrics") get "incidents");
        } forEach _db;
        if (_n == 0) exitWith {("STR_ADVSEC_pmc_nothing_to_declare" call ADVSEC_fnc_L) call _say};
        (format [("STR_ADVSEC_pmc_declared_n" call ADVSEC_fnc_L), _n]) call _say;
        ["contractDeclare", _caller, [_n]] call ADVSEC_fnc_logEvent;
        ["contracts"] call ADVSEC_fnc_dbDirty;
    };
    case "review": {
        _args params [["_id", ""], ["_verdict", "Justificado"]];
        private _c = _db getOrDefault [_id, createHashMap];
        if (count _c == 0 || {(_c get "state") != "Revisión"}) exitWith {("STR_ADVSEC_pmc_not_in_review" call ADVSEC_fnc_L) call _say};
        if !([_caller, "caseClose"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_review" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _m = _c get "metrics";
        if (_verdict == "Justificado") then {
            // Se devuelve la mitad de la penalización de las bajas civiles
            {if ((_x select 0) in ["civKill", "civKillRoe"]) then {_x set [1, round ((_x select 1) / 2)]}} forEach (_m get "penal");
        } else {
            _verdict = "Negligencia";
            {
                private _u = [_x select 1] call ADVSEC_fnc_uidUnit;
                if (!isNull _u && {[_caller, "suspend"] call ADVSEC_fnc_perm} && {_u isNotEqualTo _caller}) then {
                    ["suspend", _caller, [_u, 24, format [("STR_ADVSEC_pmc_suspend_reason" call ADVSEC_fnc_L), _id]]] call ADVSEC_fnc_susServer;
                };
            } forEach ((_m get "incidents") select {(_x select 0) in ["civKill", "civKillRoe", "clientProp"]});
        };
        _c set ["review", format ["%1 · %2 · %3", _c get "review", _verdict call ADVSEC_fnc_Lv, name _caller]];
        ["contractReviewed", _caller, [_id, _verdict]] call ADVSEC_fnc_logEvent;
        [_id, _c, _c getOrDefault ["pendingRes", "Parcial"]] call ADVSEC_fnc_ctrSettle;
        [_id, _c] call _push;
        ["list", _caller] call ADVSEC_fnc_ctrServer;
    };
    case "tick": {
        [_db, _finish, _push, _units] call ADVSEC_fnc_ctrTick;
    };
};
