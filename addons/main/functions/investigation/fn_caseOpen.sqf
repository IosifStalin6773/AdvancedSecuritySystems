// (cliente) Expedientes de caso: crear, añadir pruebas y personas, registrar una rueda de reconocimiento y ver vínculos
private _b = [
    [("STR_ADVSEC_m_case_btn_new" call ADVSEC_fnc_L), {
        [("STR_ADVSEC_m_case_new_title" call ADVSEC_fnc_L), [[("STR_ADVSEC_m_case_title" call ADVSEC_fnc_L), ""]], {
            params ["_v"];
            ["new", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_caseServer", 2];
        }] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_m_case_btn_ev" call ADVSEC_fnc_L), {
        params ["_id"];
        if (isNil "_id") exitWith {};
        [("STR_ADVSEC_m_case_ev_title" call ADVSEC_fnc_L), [[("STR_ADVSEC_m_case_ev" call ADVSEC_fnc_L), ""]], {
            params ["_v", "_id"];
            ["addEv", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_caseServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_m_case_btn_links" call ADVSEC_fnc_L), {
        params ["_id"];
        if (isNil "_id") exitWith {};
        ["links", player, [_id]] remoteExecCall ["ADVSEC_fnc_caseServer", 2];
    }],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
];
["cases", ("STR_ADVSEC_m_case_title_panel" call ADVSEC_fnc_L), _b, {["links", player, []] remoteExecCall ["ADVSEC_fnc_caseServer", 2]}] call ADVSEC_fnc_panelOpen;
