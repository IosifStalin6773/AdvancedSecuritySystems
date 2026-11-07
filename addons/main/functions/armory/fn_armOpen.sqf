// [caja] (cliente) Panel de la armería corporativa: inventario por serie, pedidos, auditoría, reparación y bajas
params ["_box"];
ADVSEC_armBox = _box;
private _b = [
    [("STR_ADVSEC_pmc_btn_order" call ADVSEC_fnc_L), {
        if !([player, "logisticsOrder"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_pmc_perm_order" call ADVSEC_fnc_L)};
        private _it = ["armoryItems", []] call ADVSEC_fnc_setting;
        if (_it isEqualTo []) exitWith {hint ("STR_ADVSEC_no_results" call ADVSEC_fnc_L)};
        private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
        private _opts = _it apply {[format ["%1 · %2 %3", [_x select 0] call ADVSEC_fnc_ecoItemName, _x select 1, _cur], _forEachIndex]};
        [("STR_ADVSEC_pmc_order_title" call ADVSEC_fnc_L), [
            [("STR_ADVSEC_pmc_item" call ADVSEC_fnc_L), 0, _opts],
            [("STR_ADVSEC_pmc_quantity" call ADVSEC_fnc_L), 1, [["1", 1], ["5", 5], ["10", 10]]]
        ], {params ["_v"]; ["order", player, [ADVSEC_armBox, _v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_armServer", 2]}] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_pmc_btn_audit" call ADVSEC_fnc_L), {
        if !([player, "armoryManage"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_pmc_perm_manage" call ADVSEC_fnc_L)};
        [("STR_ADVSEC_pmc_audit_progress" call ADVSEC_fnc_L), ["auditTime", 25] call ADVSEC_fnc_setting, {(player distance ADVSEC_armBox) < 10}, {["audit", player, [ADVSEC_armBox]] remoteExecCall ["ADVSEC_fnc_armServer", 2]}] call ADVSEC_fnc_progress;
    }],
    [("STR_ADVSEC_pmc_btn_repair" call ADVSEC_fnc_L), {
        closeDialog 0;
        [("STR_ADVSEC_pmc_repair_progress" call ADVSEC_fnc_L), 60, {(player distance ADVSEC_armBox) < 6}, {["repair", player] remoteExecCall ["ADVSEC_fnc_armServer", 2]}] call ADVSEC_fnc_progress;
    }],
    [("STR_ADVSEC_pmc_btn_retire" call ADVSEC_fnc_L), {params ["_s"]; if (!isNil "_s" && {_s isEqualType ""}) then {["retire", player, [_s]] remoteExecCall ["ADVSEC_fnc_armServer", 2]}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
];
["armory", ("STR_ADVSEC_pmc_armory" call ADVSEC_fnc_L), _b, {["list", player, [ADVSEC_armBox]] remoteExecCall ["ADVSEC_fnc_armServer", 2]}] call ADVSEC_fnc_panelOpen;
