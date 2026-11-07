// (cliente) Panel de células operativas: miembros, roles CP/QRF/SEC, disponibilidad y tiempos de respuesta de la QRF
if !([player, "cellView"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_pmc_perm_cell" call ADVSEC_fnc_L)};
private _b = [
    [("STR_ADVSEC_pmc_btn_setrole" call ADVSEC_fnc_L), {
        if !([player, "cellManage"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_pmc_perm_cellmanage" call ADVSEC_fnc_L)};
        private _pl = ((allPlayers - entities "HeadlessClient_F") select {[_x, "PM"] call ADVSEC_fnc_repAccess}) apply {[name _x, getPlayerUID _x]};
        if (_pl isEqualTo []) exitWith {hint ("STR_ADVSEC_no_results" call ADVSEC_fnc_L)};
        [("STR_ADVSEC_pmc_btn_setrole" call ADVSEC_fnc_L), [
            [("STR_ADVSEC_pmc_member" call ADVSEC_fnc_L), 0, _pl],
            [("STR_ADVSEC_pmc_role" call ADVSEC_fnc_L), 0, [[("STR_ADVSEC_pmc_role_CP" call ADVSEC_fnc_L), "CP"], [("STR_ADVSEC_pmc_role_QRF" call ADVSEC_fnc_L), "QRF"], [("STR_ADVSEC_pmc_role_SEC" call ADVSEC_fnc_L), "SEC"], [("STR_ADVSEC_pmc_role_none" call ADVSEC_fnc_L), ""]]]
        ], {params ["_v"]; ["set", player, [_v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_cellServer", 2]}] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_pmc_btn_available" call ADVSEC_fnc_L), {["state", player, ["Disponible"]] remoteExecCall ["ADVSEC_fnc_cellServer", 2]}],
    [("STR_ADVSEC_pmc_btn_rest" call ADVSEC_fnc_L), {["state", player, ["Descanso"]] remoteExecCall ["ADVSEC_fnc_cellServer", 2]}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
];
["cell", ("STR_ADVSEC_pmc_cells" call ADVSEC_fnc_L), _b, {["list", player] remoteExecCall ["ADVSEC_fnc_cellServer", 2]}] call ADVSEC_fnc_panelOpen;
