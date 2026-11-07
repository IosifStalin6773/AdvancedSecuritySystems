// Terminal de contratos de la PMC (cliente): ofertas, contratos activos, historial y clientes
if !([player, "contractView"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_pmc_perm_view" call ADVSEC_fnc_L)};
ADVSEC_ctrTab = "list";
private _b = [
    [("STR_ADVSEC_pmc_btn_action" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d" && {_d isEqualType []} && {_d isNotEqualTo []}) then {_d call ADVSEC_fnc_ctrAction} else {hint ("STR_ADVSEC_pmc_pick_contract" call ADVSEC_fnc_L)}}],
    [("STR_ADVSEC_pmc_btn_contracts" call ADVSEC_fnc_L), {ADVSEC_ctrTab = "list"; ["refresh"] call ADVSEC_fnc_panelAction}],
    [("STR_ADVSEC_pmc_btn_clients" call ADVSEC_fnc_L), {ADVSEC_ctrTab = "clients"; ["refresh"] call ADVSEC_fnc_panelAction}],
    [("STR_ADVSEC_pmc_btn_declare" call ADVSEC_fnc_L), {["declare", player] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
];
["contract", ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L), _b, {[ADVSEC_ctrTab, player] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}] call ADVSEC_fnc_panelOpen;
