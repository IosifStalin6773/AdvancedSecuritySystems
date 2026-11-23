// Recursos humanos (cliente, 1.22): certificados, permisos, bajas, cuadrante, evaluación, pases, accesos, plantillas y escenarios
params [["_mode", ""]];
private _go = {format ["closeDialog 0; [] spawn {sleep 0.1; [""%1""] call ADVSEC_fnc_hrOpen}", _this]};
private _srv = {format ["[""%1"", player, []] remoteExecCall [""ADVSEC_fnc_hrServer"", 2]", _this]};
switch (_mode) do {
    case "": {
        private _b = [
            [("STR_ADVSEC_hr_b_certs" call ADVSEC_fnc_L), compile ("certs" call _srv)],
            [("STR_ADVSEC_hr_b_leave" call ADVSEC_fnc_L), compile ("leave-ui" call _go)],
            [("STR_ADVSEC_hr_b_leaves" call ADVSEC_fnc_L), compile ("leaves" call _srv)],
            [("STR_ADVSEC_hr_b_decide" call ADVSEC_fnc_L), compile ("decide-ui" call _go)],
            [("STR_ADVSEC_hr_b_cert" call ADVSEC_fnc_L), compile ("cert-ui" call _go)],
            [("STR_ADVSEC_hr_b_medleave" call ADVSEC_fnc_L), compile ("medLeave-ui" call _go)],
            [("STR_ADVSEC_hr_b_rota" call ADVSEC_fnc_L), compile ("rotaShow" call _srv)],
            [("STR_ADVSEC_hr_b_eval" call ADVSEC_fnc_L), compile ("eval-ui" call _go)],
            [("STR_ADVSEC_hr_b_pass" call ADVSEC_fnc_L), compile ("pass-ui" call _go)],
            [("STR_ADVSEC_hr_b_access" call ADVSEC_fnc_L), compile ("acc-ui" call _go)],
            [("STR_ADVSEC_hr_b_tpl" call ADVSEC_fnc_L), compile ("tpl-ui" call _go)],
            [("STR_ADVSEC_hr_b_scen" call ADVSEC_fnc_L), compile ("scen-ui" call _go)],
            [("STR_ADVSEC_hr_b_airlock" call ADVSEC_fnc_L), compile ("air-ui" call _go)]
        ];
        ["hr", ("STR_ADVSEC_hr_menu" call ADVSEC_fnc_L), _b, {}] call ADVSEC_fnc_panelOpen;
    };
    case "leave-ui": {[("STR_ADVSEC_hr_b_leave" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_type" call ADVSEC_fnc_L), "Vacaciones", ["Vacaciones", "Asuntos propios", "Médica"]], [("STR_ADVSEC_hr_f_days" call ADVSEC_fnc_L), "1"]], {params ["_v"]; ["leave", player, [_v select 0, parseNumber (_v select 1)]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "decide-ui": {[("STR_ADVSEC_hr_b_decide" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_id" call ADVSEC_fnc_L), "0"], [("STR_ADVSEC_hr_f_ok" call ADVSEC_fnc_L), "Sí", ["Sí", "No"]]], {params ["_v"]; ["decide", player, [parseNumber (_v select 0), (_v select 1) isEqualTo "Sí"]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "cert-ui": {[("STR_ADVSEC_hr_b_cert" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_uid" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_kind" call ADVSEC_fnc_L), "Curso", ["Curso", "Medalla"]]], {params ["_v"]; ["cert", player, _v] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "medLeave-ui": {[("STR_ADVSEC_hr_b_medleave" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_uid" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_days" call ADVSEC_fnc_L), "1"]], {params ["_v"]; ["medLeave", player, [_v select 0, _v select 1, parseNumber (_v select 2)]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "eval-ui": {[("STR_ADVSEC_hr_b_eval" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_uid" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""]], {params ["_v"]; ["eval", player, _v] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "pass-ui": {[("STR_ADVSEC_hr_b_pass" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_min" call ADVSEC_fnc_L), "60"], [("STR_ADVSEC_hr_f_zone" call ADVSEC_fnc_L), ""]], {params ["_v"]; ["pass", player, [_v select 0, parseNumber (_v select 1), _v select 2]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "acc-ui": {[("STR_ADVSEC_hr_b_access" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_uid" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_zone" call ADVSEC_fnc_L), ""]], {params ["_v"]; ["accGrant", player, _v] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "tpl-ui": {[("STR_ADVSEC_hr_b_tpl" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_type" call ADVSEC_fnc_L), "escort", ["escort", "vip"]], [("STR_ADVSEC_hr_f_client" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_pay" call ADVSEC_fnc_L), "5000"], [("STR_ADVSEC_hr_f_min" call ADVSEC_fnc_L), "45"]], {params ["_v"]; ["tplSave", player, [_v select 0, _v select 1, _v select 2, parseNumber (_v select 3), parseNumber (_v select 4)]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "scen-ui": {[("STR_ADVSEC_hr_b_scen" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_tpls" call ADVSEC_fnc_L), ""]], {params ["_v"]; ["scenSave", player, [_v select 0, (_v select 1) splitString ","]] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
    case "air-ui": {[("STR_ADVSEC_hr_b_airlock" call ADVSEC_fnc_L), [[("STR_ADVSEC_hr_f_name" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_hr_f_side" call ADVSEC_fnc_L), "in", ["in", "out", ""]]], {params ["_v"]; ["airlock", player, _v] remoteExecCall ["ADVSEC_fnc_hrServer", 2]}] call ADVSEC_fnc_zeusPrompt};
};
