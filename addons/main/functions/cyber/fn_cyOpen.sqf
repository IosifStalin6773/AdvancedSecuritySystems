// (cliente) Terminal ciber de Inteligencia y Compliance: alertas, registros, cronología por persona y reconstrucción CCTV
if !([player, "cyberView"] call ADVSEC_fnc_perm || {(([player] call ADVSEC_fnc_cellRole) select 0) == "SEC"}) exitWith {hint ("STR_ADVSEC_pmc_perm_cyber" call ADVSEC_fnc_L)};
ADVSEC_cyTab = "alerts"; ADVSEC_cyArg = [];
private _b = [
    [("STR_ADVSEC_pmc_btn_action" call ADVSEC_fnc_L), {
        params ["_d"];
        switch (ADVSEC_cyTab) do {
            case "alerts": {
                [("STR_ADVSEC_pmc_btn_action" call ADVSEC_fnc_L), [
                    [("STR_ADVSEC_pmc_btn_action" call ADVSEC_fnc_L), 0, [[("STR_ADVSEC_pmc_cy_ack" call ADVSEC_fnc_L), "ack"], [("STR_ADVSEC_pmc_cy_restore" call ADVSEC_fnc_L), "restore"]]]
                ], {
                    params ["_v", "_a"];
                    if ((_v select 0) == "restore") then {["restore", player] remoteExecCall ["ADVSEC_fnc_cyServer", 2]} else {
                        if (_a isEqualType 0) then {["ack", player, [_a]] remoteExecCall ["ADVSEC_fnc_cyServer", 2]} else {hint ("STR_ADVSEC_pmc_cy_pick" call ADVSEC_fnc_L)};
                    };
                }, [-1, _d] select (!isNil "_d" && {_d isEqualType 0})] call ADVSEC_fnc_zeusPrompt;
            };
            case "cctv": {if (!isNil "_d" && {_d isEqualType 0}) then {["replay", player, [_d]] remoteExecCall ["ADVSEC_fnc_cyServer", 2]} else {hint ("STR_ADVSEC_pmc_cy_pick" call ADVSEC_fnc_L)}};
            default {
                // en registros y cronología, la acción abre la cronología del SteamID de la fila
                if (!isNil "_d" && {_d isEqualType ""} && {_d isNotEqualTo ""}) then {ADVSEC_cyTab = "timeline"; ADVSEC_cyArg = [_d]; ["refresh"] call ADVSEC_fnc_panelAction};
            };
        };
    }],
    [("STR_ADVSEC_pmc_cy_btn_alerts" call ADVSEC_fnc_L), {ADVSEC_cyTab = "alerts"; ADVSEC_cyArg = []; ["refresh"] call ADVSEC_fnc_panelAction}],
    [("STR_ADVSEC_pmc_cy_btn_logs" call ADVSEC_fnc_L), {
        [("STR_ADVSEC_pmc_cy_btn_logs" call ADVSEC_fnc_L), [[("STR_ADVSEC_pmc_cy_filter" call ADVSEC_fnc_L), ""]], {params ["_v"]; ADVSEC_cyTab = "logs"; ADVSEC_cyArg = [_v select 0]; ["refresh"] call ADVSEC_fnc_panelAction}] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_pmc_cy_btn_timeline" call ADVSEC_fnc_L), {
        [("STR_ADVSEC_pmc_cy_btn_timeline" call ADVSEC_fnc_L), [[("STR_ADVSEC_pmc_cy_who" call ADVSEC_fnc_L), ""]], {params ["_v"]; if ((_v select 0) isNotEqualTo "") then {ADVSEC_cyTab = "timeline"; ADVSEC_cyArg = [_v select 0]; ["refresh"] call ADVSEC_fnc_panelAction}}] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_pmc_cy_btn_cctv" call ADVSEC_fnc_L), {ADVSEC_cyTab = "cctv"; ADVSEC_cyArg = []; ["refresh"] call ADVSEC_fnc_panelAction}]
];
["cyber", ("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L), _b, {[ADVSEC_cyTab, player, ADVSEC_cyArg] remoteExecCall ["ADVSEC_fnc_cyServer", 2]}] call ADVSEC_fnc_panelOpen;
