/*
    [acción, llamador, args] (servidor) — armería corporativa
    "diff" [caja, armasSacadas, armasDevueltas, cargadoresSacados, cargadoresDevueltos] ([[clase, n]]) · "list" [caja]
    "order" [caja, índice, cantidad] · "audit" [caja] · "repair" · "retire" [serie] · "wear" [clase, disparos]
    "sync" · "dutyOff" · "connect" · "sellCorp" [tienda, clase]
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer || {isNull _caller}) exitWith {};
if (!([_caller] call ADVSEC_fnc_srvCaller)) exitWith {};
[] call ADVSEC_fnc_armDB;
private _w = [] call ADVSEC_fnc_wpnDB;
private _uid = getPlayerUID _caller;
private _say = {_this remoteExecCall ["hint", _caller]};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _fmt = {format ["%1 %2", (round _this) call BIS_fnc_numberText, _cur]};
private _wName = {getText (configFile >> "CfgWeapons" >> _this >> "displayName")};
private _hist = {params ["_s", "_t"]; private _e = _w get _s; (_e select 9) pushBack [call ADVSEC_fnc_now, _t]; if (count (_e select 9) > 30) then {(_e select 9) deleteAt 0}};
private _newSerial = {
    params ["_c", "_box"];
    private _n = (localNamespace getVariable ["ADVSEC_armSeq", 0]) + 1;
    localNamespace setVariable ["ADVSEC_armSeq", _n];
    private _sn = str _n; while {count _sn < 4} do {_sn = "0" + _sn};
    private _s = format ["CORP-%1-%2", toUpper (_c select [0, 3]), _sn];
    _w set [_s, [_c, "", ("STR_ADVSEC_pmc_company" call ADVSEC_fnc_L), call ADVSEC_fnc_now, "CORP", "Armería", [], 0, [_c] call ADVSEC_fnc_armValue, [], netId _box]];
    ["weaponRegister", objNull, [_s, _c, "CORP"]] call ADVSEC_fnc_logEvent;
    ["armory"] call ADVSEC_fnc_dbDirty;
    _s
};
private _qm = {(allPlayers - entities "HeadlessClient_F") select {[_x, "armoryManage"] call ADVSEC_fnc_perm}};
private _activeCtr = {
    // ¿el jugador está asignado a un contrato en curso?
    ((values ([] call ADVSEC_fnc_ctrDB)) findIf {(_x get "state") == "En curso" && {((_x get "assigned") findIf {(_x select 0) == _uid}) >= 0}}) >= 0
};
switch (_action) do {
    case "diff": {
        _args params [["_box", objNull], ["_wOut", []], ["_wIn", []], ["_mOut", []], ["_mIn", []]];
        if (isNull _box || {!(_box getVariable ["ADVSEC_armory", false])} || {(_caller distance _box) > 15}) exitWith {};
        private _allowed = [_caller, "armoryCheckout"] call ADVSEC_fnc_perm && {(["armoryNeedDuty", 1] call ADVSEC_fnc_setting) isNotEqualTo 1 || {_caller getVariable ["ADVSEC_onDuty", false]} || {[_caller] call ADVSEC_fnc_isZeus}};
        if (!_allowed && {_wOut isNotEqualTo [] || {_mOut isNotEqualTo []}}) then {
            [_caller, "armoryUnauthorized", typeOf _box] call ADVSEC_fnc_heatAdd;
            ["alert", _caller, ["armoryNoAuth", format [("STR_ADVSEC_pmc_cy_armory_noauth" call ADVSEC_fnc_L), name _caller, mapGridPosition _box]]] call ADVSEC_fnc_cyServer;
        };
        if ((_wOut isNotEqualTo [] || {_mOut isNotEqualTo []}) && {!(call _activeCtr)}) then {
            ["alert", _caller, ["armoryNoContract", format [("STR_ADVSEC_pmc_cy_armory_nocontract" call ADVSEC_fnc_L), name _caller, mapGridPosition _box]]] call ADVSEC_fnc_cyServer;
        };
        private _out = [];
        {
            _x params ["_c", "_n"];
            for "_i" from 1 to (_n min 20) do {
                private _s = "";
                {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) == "Armería"} && {(_y select 10) in [netId _box, ""]}) exitWith {_s = _x}} forEach _w;
                if (_s isEqualTo "") then {_s = [_c, _box] call _newSerial};
                private _e = _w get _s;
                _e set [1, _uid];
                _e set [2, format [("STR_ADVSEC_pmc_company_signed" call ADVSEC_fnc_L), name _caller]];
                _e set [5, "Firmada"];
                _e set [6, [_uid, name _caller, call ADVSEC_fnc_now]];
                [_s, format [("STR_ADVSEC_pmc_arm_signed_by" call ADVSEC_fnc_L), name _caller]] call _hist;
                _out pushBack _s;
                ["armoryOut", _caller, [_s, _c]] call ADVSEC_fnc_logEvent;
            };
        } forEach _wOut;
        private _back = [];
        {
            _x params ["_c", "_n"];
            for "_i" from 1 to (_n min 20) do {
                private _s = "";
                {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) == "Firmada"} && {((_y select 6) param [0, ""]) == _uid}) exitWith {_s = _x}} forEach _w;
                if (_s isEqualTo "") then {
                    // Material que no estaba firmado por él: si es corporativo de otro, descuadre; si no, se registra como corporativo
                    {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) in ["Firmada", "Perdida"]}) exitWith {_s = _x}} forEach _w;
                    if (_s isEqualTo "") then {_s = [_c, _box] call _newSerial; [_s, ("STR_ADVSEC_pmc_arm_donated" call ADVSEC_fnc_L)] call _hist} else {
                        private _sig = (_w get _s) select 6;
                        if ((_sig param [0, ""]) isNotEqualTo "" && {(_sig select 0) != _uid}) then {[[_sig select 0, _sig select 1], "armoryMismatch", format [("STR_ADVSEC_pmc_arm_returned_by" call ADVSEC_fnc_L), _s, name _caller]] call ADVSEC_fnc_heatAdd};
                    };
                };
                private _e = _w get _s;
                _e set [1, ""];
                _e set [2, ("STR_ADVSEC_pmc_company" call ADVSEC_fnc_L)];
                _e set [5, "Armería"];
                _e set [10, netId _box];
                [_s, format [("STR_ADVSEC_pmc_arm_returned" call ADVSEC_fnc_L), name _caller]] call _hist;
                _back pushBack _s;
                ["armoryIn", _caller, [_s, _c]] call ADVSEC_fnc_logEvent;
            };
        } forEach _wIn;
        // Munición: coste al contrato en curso (y se descuenta lo que se devuelve)
        private _mc = 0;
        {_x params ["_c", "_n"]; _mc = _mc + _n * ([_c] call ADVSEC_fnc_armValue)} forEach _mOut;
        {_x params ["_c", "_n"]; _mc = _mc - _n * ([_c] call ADVSEC_fnc_armValue)} forEach _mIn;
        if (_mc != 0) then {[_uid, ("STR_ADVSEC_pmc_cost_ammo" call ADVSEC_fnc_L), _mc] call ADVSEC_fnc_ctrCost};
        [_uid] call ADVSEC_fnc_armSigned;
        ["weapons"] call ADVSEC_fnc_dbDirty;
        if (_out isNotEqualTo [] || {_back isNotEqualTo []}) then {
            (format [("STR_ADVSEC_pmc_arm_diff" call ADVSEC_fnc_L), [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), _out joinString ", "] select (_out isNotEqualTo []), [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), _back joinString ", "] select (_back isNotEqualTo [])]) call _say;
        };
    };
    case "list": {
        _args params [["_box", objNull]];
        private _rows = [];
        private _ids = [keys _w select {((_w get _x) param [4, ""]) == "CORP"}, [], {_x}, "ASCEND"] call BIS_fnc_sortBy;
        private _cnt = createHashMap;
        {
            private _e = _w get _x;
            _e params ["_c", "", "_holder", "_date", "", "_st", "_sig", "_wear", "_val", "_h"];
            _cnt set [_st, (_cnt getOrDefault [_st, 0]) + 1];
            private _det = format [("STR_ADVSEC_pmc_arm_sheet" call ADVSEC_fnc_L), _x, (_c call _wName) call ADVSEC_fnc_repEsc, _c, _st call ADVSEC_fnc_Lv, (_holder) call ADVSEC_fnc_repEsc,
                round (_wear * 100), _val call _fmt, _date, ((_sig param [1, "-"]) call ADVSEC_fnc_repEsc), _sig param [2, "-"]];
            private _hr = +_h;
            reverse _hr;
            {_det = _det + format ["<br/>· %1 · %2", _x select 0, (_x select 1) call ADVSEC_fnc_repEsc]} forEach _hr;
            _rows pushBack [format ["%1 · %2 · %3 · %4%5", _x, _c call _wName, _st call ADVSEC_fnc_Lv, (_sig param [1, ""]), format [" · %1%2", round (_wear * 100), "%"]], _x, _det,
                switch (_st) do {case "Firmada": {[1, 0.75, 0.3, 1]}; case "Perdida": {[1, 0.4, 0.4, 1]}; case "Incautada": {[1, 0.5, 1, 1]}; case "Destruida"; case "Retirada": {[0.55, 0.55, 0.55, 1]}; default {[[], [1, 0.85, 0.4, 1]] select (_wear >= 0.6)}},
                getText (configFile >> "CfgWeapons" >> _c >> "picture")];
        } forEach _ids;
        private _info = format [("STR_ADVSEC_pmc_arm_info" call ADVSEC_fnc_L), count _ids, _cnt getOrDefault ["Armería", 0], _cnt getOrDefault ["Firmada", 0], _cnt getOrDefault ["Perdida", 0], ([] call ADVSEC_fnc_ecoTreasuryNow) call _fmt];
        private _debt = (localNamespace getVariable ["ADVSEC_armDebts", createHashMap]) getOrDefault [_uid, [0, []]];
        if ((_debt select 0) > 0) then {_info = _info + format [("STR_ADVSEC_pmc_arm_your_debt" call ADVSEC_fnc_L), (_debt select 0) call _fmt]};
        ["armory", _info, _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "order": {
        _args params [["_box", objNull], ["_i", -1], ["_n", 1]];
        if !([_caller, "logisticsOrder"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_order" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        if (isNull _box || {!(_box getVariable ["ADVSEC_armory", false])} || {(_caller distance _box) > 15}) exitWith {};
        private _it = (["armoryItems", []] call ADVSEC_fnc_setting) param [_i, []];
        if (_it isEqualTo [] || {!(_n in [1, 5, 10])}) exitWith {};
        _it params ["_c", "_p"];
        private _tot = _p * _n;
        if (([] call ADVSEC_fnc_ecoTreasuryNow) < _tot) exitWith {(format [("STR_ADVSEC_pmc_treasury_short" call ADVSEC_fnc_L), _tot call _fmt]) call _say};
        // 1.22: presupuesto diario del departamento PMC (budgetPMC; 0 = sin límite)
        if !(["PMC", _tot] call ADVSEC_fnc_budgetSpend) exitWith {("STR_ADVSEC_hr_budget_over" call ADVSEC_fnc_L) call _say};
        [-_tot, format [("STR_ADVSEC_pmc_treasury_order" call ADVSEC_fnc_L), _n, [_c] call ADVSEC_fnc_ecoItemName, name _caller]] call ADVSEC_fnc_ecoTreasury;
        private _isW = isClass (configFile >> "CfgWeapons" >> _c) && {getNumber (configFile >> "CfgWeapons" >> _c >> "type") in [1, 2, 4]};
        // 1.22: pedidos con entrega retardada (armoryDelayMin minutos; 0 = inmediata). Se paga al pedir.
        private _dl = ["armoryDelayMin", 0] call ADVSEC_fnc_setting;
        [_box, _c, _n, _isW, _dl, _newSerial] spawn {
            params ["_box", "_c", "_n", "_isW", "_dl", "_ns"];
            if (_dl > 0) then {sleep (_dl * 60)};
            if (isNull _box) exitWith {};
            switch (true) do {
                case _isW: {_box addWeaponCargoGlobal [_c, _n]; for "_k" from 1 to _n do {[_c, _box] call _ns}};
                case (isClass (configFile >> "CfgMagazines" >> _c)): {_box addMagazineCargoGlobal [_c, _n]};
                case (isClass (configFile >> "CfgVehicles" >> _c)): {_box addBackpackCargoGlobal [_c, _n]};
                default {_box addItemCargoGlobal [_c, _n]};
            };
        };
        ["armoryOrder", _caller, [_c, _n, _tot]] call ADVSEC_fnc_logEvent;
        ["weapons"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_pmc_order_done" call ADVSEC_fnc_L), _n, [_c] call ADVSEC_fnc_ecoItemName, _tot call _fmt]) call _say;
        if (_dl > 0) then {(format [("STR_ADVSEC_pmc_order_delayed" call ADVSEC_fnc_L), _dl]) call _say};
        ["list", _caller, [_box]] call ADVSEC_fnc_armServer;
    };
    case "audit": {
        _args params [["_box", objNull]];
        if !([_caller, "armoryManage"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_manage" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        [_caller] call ADVSEC_fnc_armAudit;
    };
    case "repair": {
        private _c = [currentWeapon _caller] call BIS_fnc_baseWeapon;
        private _sdb = [] call ADVSEC_fnc_specDB;
        if (((["ENG", "LOG"] findIf {_uid in ((_sdb getOrDefault [_x, [[]]]) select 0)}) < 0) && {!([_caller] call ADVSEC_fnc_isZeus)}) exitWith {("STR_ADVSEC_pmc_need_eng" call ADVSEC_fnc_L) call _say};
        private _box = (nearestObjects [_caller, [], 6]) select {_x getVariable ["ADVSEC_armory", false]};
        if (_box isEqualTo []) exitWith {("STR_ADVSEC_pmc_at_armory" call ADVSEC_fnc_L) call _say};
        private _s = "";
        {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) == "Firmada"} && {((_y select 6) param [0, ""]) == _uid}) exitWith {_s = _x}} forEach _w;
        if (_s isEqualTo "") exitWith {("STR_ADVSEC_pmc_not_corp_in_hands" call ADVSEC_fnc_L) call _say};
        private _e = _w get _s;
        private _cost = round ((_e select 8) * 0.05);
        [-_cost, format [("STR_ADVSEC_pmc_treasury_repair" call ADVSEC_fnc_L), _s]] call ADVSEC_fnc_ecoTreasury;
        _e set [7, ((_e select 7) - 0.4) max 0];
        if (random 1 < 0.2 && {"ToolKit" in items _caller}) then {_caller removeItem "ToolKit"};
        [_s, format [("STR_ADVSEC_pmc_arm_repaired" call ADVSEC_fnc_L), name _caller]] call _hist;
        [_uid] call ADVSEC_fnc_armSigned;
        ["weapons"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_pmc_repaired_msg" call ADVSEC_fnc_L), _s, round ((_e select 7) * 100), _cost call _fmt]) call _say;
    };
    case "retire": {
        _args params [["_s", ""]];
        if !([_caller, "armoryManage"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_pmc_perm_manage" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _e = _w getOrDefault [_s, []];
        if ((_e param [4, ""]) != "CORP") exitWith {};
        _e set [5, "Retirada"];
        [_s, format [("STR_ADVSEC_pmc_arm_retired" call ADVSEC_fnc_L), name _caller]] call _hist;
        ["armory", _caller, [_s, "Retirada"]] call ADVSEC_fnc_logEvent;
        ["weapons"] call ADVSEC_fnc_dbDirty;
        ["list", _caller, [objNull]] call ADVSEC_fnc_armServer;
    };
    case "wear": {
        _args params [["_c", ""], ["_n", 0]];
        _n = (_n max 0) min 200;
        private _s = "";
        {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) == "Firmada"} && {((_y select 6) param [0, ""]) == _uid}) exitWith {_s = _x}} forEach _w;
        if (_s isEqualTo "") exitWith {};
        private _e = _w get _s;
        private _life = 6000;
        private _t = getNumber (configFile >> "CfgWeapons" >> _c >> "type");
        private _ww = ["WeaponWear"] call ADVSEC_fnc_pmcClasses;
        private _kind = switch (true) do {
            case (_t == 2): {"pistol"};
            case (_t == 4): {"launcher"};
            case ((toLower getText (configFile >> "CfgWeapons" >> _c >> "cursor")) == "mg" || {((toLower _c) find "lmg") >= 0} || {((toLower _c) find "mmg") >= 0}): {"mg"};
            default {"rifle"};
        };
        {if (configName _x == _kind) exitWith {_life = [_x, "life", _life] call ADVSEC_fnc_pmcVal}} forEach _ww;
        private _old = _e select 7;
        _e set [7, (_old + _n / (_life max 1)) min 1];
        if (_old < 0.6 && {(_e select 7) >= 0.6}) then {
            (format [("STR_ADVSEC_pmc_wear_review" call ADVSEC_fnc_L), _s, name _caller]) remoteExecCall ["systemChat", call _qm];
        };
        if ((_e select 7) >= 1) then {
            _e set [5, "Destruida"];
            [_s, ("STR_ADVSEC_pmc_arm_worn_out" call ADVSEC_fnc_L)] call _hist;
            (format [("STR_ADVSEC_pmc_worn_out_msg" call ADVSEC_fnc_L), _s]) call _say;
            [_uid, ("STR_ADVSEC_pmc_cost_lost" call ADVSEC_fnc_L), _e select 8] call ADVSEC_fnc_ctrCost;
        };
        [_uid] call ADVSEC_fnc_armSigned;
        ["weapons"] call ADVSEC_fnc_dbDirty;
    };
    case "sync": {[_uid] call ADVSEC_fnc_armSigned};
    case "dutyOff": {
        private _miss = [_caller] call ADVSEC_fnc_armMissing;
        private _sig = [_uid, false] call ADVSEC_fnc_armSigned;
        if (_sig isEqualTo []) exitWith {};
        (format [("STR_ADVSEC_pmc_duty_off_signed" call ADVSEC_fnc_L), (_sig apply {_x select 1}) joinString ", "]) call _say;
        (format [("STR_ADVSEC_pmc_qm_duty_off" call ADVSEC_fnc_L), name _caller, count _sig, count _miss]) remoteExecCall ["systemChat", call _qm];
    };
    case "connect": {
        private _debts = localNamespace getVariable ["ADVSEC_armDebts", createHashMap];
        private _d = _debts getOrDefault [_uid, [0, []]];
        if ((_d select 0) <= 0) exitWith {[_uid] call ADVSEC_fnc_armSigned};
        [_caller, _d select 0, format [("STR_ADVSEC_pmc_fine_lost" call ADVSEC_fnc_L), (_d select 1) joinString ", "], ("STR_ADVSEC_pmc_quartermaster" call ADVSEC_fnc_L), ""] call ADVSEC_fnc_fineAdd;
        _debts deleteAt _uid;
        ["armory"] call ADVSEC_fnc_dbDirty;
        [_uid] call ADVSEC_fnc_armSigned;
    };
    case "disconnect": {
        // Se marca como perdido lo que se lleva firmado y se apunta la deuda
        private _debts = localNamespace getVariable ["ADVSEC_armDebts", createHashMap];
        private _f = ["armoryLossFactor", 1.5] call ADVSEC_fnc_setting;
        {
            _x params ["_c", "_s"];
            private _e = _w get _s;
            _e set [5, "Perdida"];
            [_s, ("STR_ADVSEC_pmc_arm_not_returned" call ADVSEC_fnc_L)] call _hist;
            private _d = _debts getOrDefault [_uid, [0, []]];
            _d set [0, (_d select 0) + round ((_e select 8) * _f)];
            (_d select 1) pushBack _s;
            _debts set [_uid, _d];
            [_uid, ("STR_ADVSEC_pmc_cost_lost" call ADVSEC_fnc_L), _e select 8] call ADVSEC_fnc_ctrCost;
        } forEach ([_uid, false] call ADVSEC_fnc_armSigned);
        ["weapons"] call ADVSEC_fnc_dbDirty;
        ["armory"] call ADVSEC_fnc_dbDirty;
    };
    case "sellCorp": {
        _args params [["_shop", objNull], ["_c", ""]];
        if (isNull _shop || {!(_shop getVariable ["ADVSEC_shopIllegal", false])} || {(_caller distance _shop) > 4}) exitWith {};
        if !(_c in ((weapons _caller) apply {[_x] call BIS_fnc_baseWeapon})) exitWith {("STR_ADVSEC_you_are_not_carrying_that" call ADVSEC_fnc_L) call _say};
        private _s = "";
        {if ((_y param [4, ""]) == "CORP" && {(_y select 0) == _c} && {(_y select 5) == "Firmada"} && {((_y select 6) param [0, ""]) == _uid}) exitWith {_s = _x}} forEach _w;
        if (_s isEqualTo "") exitWith {("STR_ADVSEC_pmc_not_corp" call ADVSEC_fnc_L) call _say};
        private _e = _w get _s;
        private _v = round ((_e select 8) * (["sellFactor", 0.5] call ADVSEC_fnc_setting) * 1.2);
        private _real = (weapons _caller) select {([_x] call BIS_fnc_baseWeapon) == _c};
        [_real param [0, _c]] remoteExecCall ["ADVSEC_fnc_ecoTakeItem", _caller];
        [_caller, ([_caller] call ADVSEC_fnc_ecoCash) + _v] call ADVSEC_fnc_ecoSetCash;
        [[_uid, name _caller] call ADVSEC_fnc_ecoAcc, format [("STR_ADVSEC_sale" call ADVSEC_fnc_L), _c call _wName], _v] call ADVSEC_fnc_ecoHist;
        _e set [5, "Perdida"];
        _e set [10, ""];
        [_s, ("STR_ADVSEC_pmc_arm_vanished" call ADVSEC_fnc_L)] call _hist;
        // Rastro para Compliance (contrabandAudit)
        if (random 1 < (["blackMarketTrace", 0.5] call ADVSEC_fnc_setting)) then {
            ["blackMarket", _caller, [_s, _c, _v, mapGridPosition _shop]] call ADVSEC_fnc_logEvent;
        };
        [_uid, ("STR_ADVSEC_pmc_cost_lost" call ADVSEC_fnc_L), _e select 8] call ADVSEC_fnc_ctrCost;
        [_uid] call ADVSEC_fnc_armSigned;
        ["weapons"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_pmc_sold_corp" call ADVSEC_fnc_L), _v call _fmt]) call _say;
    };
};
