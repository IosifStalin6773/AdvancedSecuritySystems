/*
    Acciones de Policía Militar -> [[id, texto, icono, código, args, subhijos?], ...] (hijos ACE y menú sin ACE)
    [objetivo, agente, modo] modo: "unit" | "self" | "zeus"
*/
params ["_target", "_player", ["_mode", "unit"]];
private _list = [];
private _add = {_list pushBack _this};

if (_mode in ["self", "company"]) exitWith {
    // Menús propios de dos niveles como máximo (1.20.1): una entrada por tema y dentro acciones directas, sin submenús.
    // «company» = menú de la compañía (perfil PMC); «self» = Policía Militar. Sin perfil PMC, la PM lleva también lo de la compañía.
    private _pmc = (["pmcProfile", 1] call ADVSEC_fnc_setting) isEqualTo 1;
    private _onDuty = _player getVariable ["ADVSEC_onDuty", false];
    private _co = [];
    if (_mode == "company" || {!_pmc}) then {
        if ([_player, "contractView"] call ADVSEC_fnc_perm) then {
            _co pushBack ["advsec_pmc_ctr", ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_ctrOpen}, []];
            _co pushBack ["advsec_pmc_decl", ("STR_ADVSEC_pmc_btn_declare" call ADVSEC_fnc_L), ADVSEC_icDoc, {["declare", _player] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}, []];
        };
        if ([_player, "cellView"] call ADVSEC_fnc_perm || {(([_player] call ADVSEC_fnc_cellRole) select 0) isNotEqualTo ""}) then {_co pushBack ["advsec_pmc_cell", ("STR_ADVSEC_pmc_cells" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_cellOpen}, []]};
        _co pushBack ["advsec_pm_duty", [("STR_ADVSEC_clock_in_for_duty" call ADVSEC_fnc_L), ("STR_ADVSEC_clock_out_of_duty" call ADVSEC_fnc_L)] select _onDuty, ADVSEC_icJail, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []];
        _co pushBack ["advsec_pm_panic", ("STR_ADVSEC_panic_button_2" call ADVSEC_fnc_L), ADVSEC_icAlarm, {["panic", _player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}, []];
        _co pushBack ["advsec_pm_dsp", ("STR_ADVSEC_dispatch_centre" call ADVSEC_fnc_L), ADVSEC_icAlarm, {[] call ADVSEC_fnc_dspOpen}, []];
        _co pushBack ["advsec_pm_patrol", ("STR_ADVSEC_route_patrols" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_patrolOpen}, []];
        if ([_player, "query"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pm_query", ("STR_ADVSEC_query_dispatch_2" call ADVSEC_fnc_L), ADVSEC_icSearch, {[] call ADVSEC_fnc_queryOpen}, []]};
        if ([_player, "plateQuery"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pm_plate", ("STR_ADVSEC_check_plate_2" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_plateQuery}, []]};
        private _vc = (nearestObjects [_player, ["Car", "Motorcycle", "Tank", "Ship"], 7]) select {alive _x && {isNull objectParent _player}};
        if (_vc isNotEqualTo [] && {[_player, "vehicleSearch"] call ADVSEC_fnc_perm}) then {
            _co pushBack ["advsec_pm_vehsearch", format [("STR_ADVSEC_search_4" call ADVSEC_fnc_L), getText (configOf (_vc select 0) >> "displayName")], ADVSEC_icCar, {[_args select 0] call ADVSEC_fnc_vehOpen}, [_vc select 0]];
        };
        if ([_player, "dutyView"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pm_dutyv", ("STR_ADVSEC_duty_control" call ADVSEC_fnc_L), ADVSEC_icJail, {[] call ADVSEC_fnc_dutyOpen}, []]};
        if ([_player, "alertLevel"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pm_alert", ("STR_ADVSEC_base_alert_level_2" call ADVSEC_fnc_L), ADVSEC_icAlarm, {[] call ADVSEC_fnc_alertOpen}, []]};
        if ([_player, "playerDB"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pmc_orbat", ("STR_ADVSEC_pmc_orbat" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_pdbOpen}, []]};
        if ([_player, "treasury"] call ADVSEC_fnc_perm) then {_co pushBack ["advsec_pmc_treasury", ("STR_ADVSEC_pmc_treasury" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_ecoTreasuryOpen}, []]};
    };
    if (_mode == "company") exitWith {_co};
    // Policía Militar y AA.II.: solo lo propio del cuerpo (lo de la compañía va en su menú con el perfil PMC)
    private _po = +_co;
    if (_onDuty) then {
        _po pushBack ["advsec_pm_cam", [("STR_ADVSEC_turn_on_body_camera" call ADVSEC_fnc_L), ("STR_ADVSEC_turn_off_body_camera" call ADVSEC_fnc_L)] select (_player getVariable ["ADVSEC_bodycam", false]), ADVSEC_icCam, {["bodycam", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []];
    };
    _po pushBack ["advsec_pm_unload", ("STR_ADVSEC_take_detainees_out_of_the" call ADVSEC_fnc_L), ADVSEC_icCar, {[_player] call ADVSEC_fnc_policeUnload}, []];
    if ([_player, "radar"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_pm_radar", ("STR_ADVSEC_speed_gun_aim" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_radarUse}, []]};
    // 1.22: tráfico y vía pública
    if ([_player, "traffic"] call ADVSEC_fnc_perm) then {
        private _tv = (nearestObjects [_player, ["LandVehicle"], 12]) param [0, objNull];
        if (!isNull _tv) then {
            _po pushBack ["advsec_pm_tow", format [("STR_ADVSEC_m_tow_menu" call ADVSEC_fnc_L), getText (configOf _tv >> "displayName")], ADVSEC_icCar, {["tow", _player, [_args select 0]] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, [_tv]];
        };
        _po pushBack ["advsec_pm_acc", ("STR_ADVSEC_m_acc_menu" call ADVSEC_fnc_L), ADVSEC_icDoc, {["accident", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
        _po pushBack ["advsec_pm_lane", ("STR_ADVSEC_m_lane_menu" call ADVSEC_fnc_L), ADVSEC_icCar, {["lane", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
        _po pushBack ["advsec_pm_lane0", ("STR_ADVSEC_m_lane_menu_off" call ADVSEC_fnc_L), ADVSEC_icCar, {["laneEnd", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
        _po pushBack ["advsec_pm_div", ("STR_ADVSEC_m_div_menu" call ADVSEC_fnc_L), ADVSEC_icCar, {["divert", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
        _po pushBack ["advsec_pm_div0", ("STR_ADVSEC_m_div_menu_off" call ADVSEC_fnc_L), ADVSEC_icCar, {["divertEnd", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
        _po pushBack ["advsec_pm_imp", ("STR_ADVSEC_m_imp_title" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_impoundOpen}, []];
    };
    if ([_player, "patrolPlan"] call ADVSEC_fnc_perm) then {
        _po pushBack ["advsec_pm_convoy", ("STR_ADVSEC_m_convoy_new" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_convoyPlan}, []];
    };
    if (((getPosATL _player) nearObjects ["Land_HelipadEmpty_F", 120]) findIf {(_x getVariable ["ADVSEC_cpId", -1]) > 0} >= 0) then {
        _po pushBack ["advsec_pm_book", ("STR_ADVSEC_m_book_menu" call ADVSEC_fnc_L), ADVSEC_icDoc, {["cpBook", _player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []];
    };
    if ([_player, "k9"] call ADVSEC_fnc_perm) then {
        _po pushBack ["advsec_pm_k9", [("STR_ADVSEC_k9_call_the_dog" call ADVSEC_fnc_L), ("STR_ADVSEC_k9_dismiss_the_dog" call ADVSEC_fnc_L)] select !isNull (_player getVariable ["ADVSEC_k9", objNull]), ADVSEC_icSearch, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []];
        if (!isNull (_player getVariable ["ADVSEC_k9", objNull])) then {
            _po pushBack ["advsec_pm_sniff", ("STR_ADVSEC_k9_sniff_what_you_aim" call ADVSEC_fnc_L), ADVSEC_icSearch, {["sniff", _player, [cursorObject]] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []];
        };
    };
    _po pushBack ["advsec_pm_wanted", ("STR_ADVSEC_wanted_list" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_wantedOpen}, []];
    _po pushBack ["advsec_pm_reports", ("STR_ADVSEC_report_archive" call ADVSEC_fnc_L), ADVSEC_icDoc, {["BOTH"] call ADVSEC_fnc_repOpen}, []];
    _po pushBack ["advsec_pm_incident", ("STR_ADVSEC_log_incident" call ADVSEC_fnc_L), ADVSEC_icDoc, {["PM"] call ADVSEC_fnc_repEditorOpen}, []];
    if ([_player, "evidenceCollect"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_pm_scene", ("STR_ADVSEC_inspect_scene_evidence" call ADVSEC_fnc_L), ADVSEC_icSearch, {["scene", _player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}, []]};
    _po pushBack ["advsec_pm_evidence", ("STR_ADVSEC_evidence_log" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_evOpen}, []];
    if ([_player, "cyberView"] call ADVSEC_fnc_perm || {(([_player] call ADVSEC_fnc_cellRole) select 0) == "SEC"}) then {_po pushBack ["advsec_pmc_cy", ("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L), ADVSEC_icCam, {[] call ADVSEC_fnc_cyOpen}, []]};
    if ([_player, "suspicionView"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_ai_heat", ("STR_ADVSEC_suspicion_index_2" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_heatOpen}, []]};
    // 1.22: marca táctica y mensaje del canal (cifrado con pdaCipherKey si está configurada)
    _po pushBack ["advsec_pm_tacmark", ("STR_ADVSEC_m_tac_menu" call ADVSEC_fnc_L), ADVSEC_icCar, {
        [] spawn {
            [("STR_ADVSEC_m_tac_menu" call ADVSEC_fnc_L), [[("STR_ADVSEC_m_tac_text" call ADVSEC_fnc_L), ""]], {
                params ["_v"];
                ["mark", player, [getPosATL player, _v select 0, "PM"]] remoteExecCall ["ADVSEC_fnc_pdaComms", 2];
            }] call ADVSEC_fnc_zeusPrompt;
        };
    }, []];
    _po pushBack ["advsec_pm_chanmsg", ("STR_ADVSEC_m_msg_menu" call ADVSEC_fnc_L), ADVSEC_icDoc, {
        [("STR_ADVSEC_m_msg_menu" call ADVSEC_fnc_L), [[("STR_ADVSEC_m_msg_text" call ADVSEC_fnc_L), ""]], {
            params ["_v"];
            ["msg", player, [_v select 0, "PM", ["pdaCipherKey", ""] call ADVSEC_fnc_setting]] remoteExecCall ["ADVSEC_fnc_pdaComms", 2];
        }] call ADVSEC_fnc_zeusPrompt;
    }, []];
    if ([_player, "restrain"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_pm_custody", ("STR_ADVSEC_m_care_register" call ADVSEC_fnc_L), ADVSEC_icDoc, {["register", _player] remoteExecCall ["ADVSEC_fnc_jailCare", 2]}, []]};
    if ([_player, "caseClose"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_ai_cases", ("STR_ADVSEC_m_case_title_panel" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_caseOpen}, []]};
    if ([_player, "bodycamView"] call ADVSEC_fnc_perm) then {
        _po pushBack ["advsec_ai_live", ("STR_ADVSEC_live_body_cameras" call ADVSEC_fnc_L), ADVSEC_icCam, {["open"] call ADVSEC_fnc_bodyLive}, []];
        _po pushBack ["advsec_ai_cam", ("STR_ADVSEC_body_camera_recordings" call ADVSEC_fnc_L), ADVSEC_icCam, {[] call ADVSEC_fnc_bodyOpen}, []];
    };
    if ([_player, "suspend"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_ai_susp", ("STR_ADVSEC_suspensions" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_susOpen}, []]};
    if ([_player, "bankAudit"] call ADVSEC_fnc_perm) then {_po pushBack ["advsec_ai_bank", ("STR_ADVSEC_bank_audit" call ADVSEC_fnc_L), ADVSEC_icSearch, {[] call ADVSEC_fnc_auditOpen}, []]};
    if ([_player, "PM"] call ADVSEC_fnc_repAccess || {[_player, "PMC"] call ADVSEC_fnc_repAccess}) then {_po pushBack ["advsec_ai_hr", ("STR_ADVSEC_hr_menu" call ADVSEC_fnc_L), ADVSEC_icSearch, {[] call ADVSEC_fnc_hrOpen}, []]};
    _po
};
if (!alive _target) exitWith {_list};

private _r = [_target] call ADVSEC_fnc_isRestrained;
private _surr = (_target getVariable ["ace_captives_isSurrendering", false]) || {"surrender" in toLower animationState _target};
private _inVeh = !isNull objectParent _target;

if (!_r && {_inVeh} && {!isPlayer _target} && {[_player, "vehicleSearch"] call ADVSEC_fnc_perm}) then {
    ["advsec_pm_orderout", ("STR_ADVSEC_pmc_order_out" call ADVSEC_fnc_L), ADVSEC_icCar, {[_target, "orderOut"] call ADVSEC_fnc_policeLocal}, []] call _add;
};
if (_r) then {
    ["advsec_pm_free", ("STR_ADVSEC_remove_handcuffs" call ADVSEC_fnc_L), ADVSEC_icPol, {[_target, false, _player] call ADVSEC_fnc_restrain}, []] call _add;
    if (!_inVeh && {_mode == "unit"}) then {
        if ((attachedTo _target) isEqualTo _player) then {
            ["advsec_pm_escoff", ("STR_ADVSEC_stop_escorting" call ADVSEC_fnc_L), ADVSEC_icRun, {[_target, false] call ADVSEC_fnc_escort}, []] call _add;
        } else {
            ["advsec_pm_esc", ("STR_ADVSEC_escort" call ADVSEC_fnc_L), ADVSEC_icRun, {[_target, true] call ADVSEC_fnc_escort}, []] call _add;
        };
    };
    if (_inVeh) then {
        ["advsec_pm_out", ("STR_ADVSEC_take_out_of_vehicle" call ADVSEC_fnc_L), ADVSEC_icCar, {[_target, "unload"] call ADVSEC_fnc_policeLocal}, []] call _add;
    } else {
        ["advsec_pm_load", ("STR_ADVSEC_put_in_vehicle" call ADVSEC_fnc_L), ADVSEC_icCar, {[_target] call ADVSEC_fnc_policeLoad}, []] call _add;
    };
} else {
    ["advsec_pm_cuff", ("STR_ADVSEC_handcuff" call ADVSEC_fnc_L), ADVSEC_icPol, {[_target, true, _player] call ADVSEC_fnc_restrain}, []] call _add;
};
if ((_r || {_surr} || {_mode == "zeus"}) && {[_player, "search"] call ADVSEC_fnc_perm}) then {
    ["advsec_pm_search", ("STR_ADVSEC_search_frisk" call ADVSEC_fnc_L), ADVSEC_icSearch, {[_target] call ADVSEC_fnc_searchOpen}, []] call _add;
};
if ((_target getVariable ["ADVSEC_jailUntil", 0]) > serverTime) then {
    ["advsec_pm_treat", ("STR_ADVSEC_m_care_treat" call ADVSEC_fnc_L), ADVSEC_icAlarm, {["treat", _player, [_target]] remoteExecCall ["ADVSEC_fnc_jailCare", 2]}, []] call _add;
    ["advsec_pm_feed", ("STR_ADVSEC_m_care_feed" call ADVSEC_fnc_L), ADVSEC_icDoc, {["feed", _player, [_target]] remoteExecCall ["ADVSEC_fnc_jailCare", 2]}, []] call _add;
    ["advsec_pm_release", ("STR_ADVSEC_release_2" call ADVSEC_fnc_L), ADVSEC_icRun, {["release", _player, [_target]] remoteExecCall ["ADVSEC_fnc_jailServer", 2]}, []] call _add;
} else {
    if ((_r || {_mode == "zeus"}) && {(missionNamespace getVariable ["ADVSEC_jails", []]) isNotEqualTo []}) then {
        ["advsec_pm_jail", ("STR_ADVSEC_arrest_jail" call ADVSEC_fnc_L), ADVSEC_icJail, {[_target] call ADVSEC_fnc_jailPrompt}, []] call _add;
    };
};
if (isPlayer _target) then {
    if ((getPlayerUID _target) in (missionNamespace getVariable ["ADVSEC_wantedUIDs", []])) then {
        ["advsec_pm_unwant", ("STR_ADVSEC_remove_from_wanted" call ADVSEC_fnc_L), ADVSEC_icPol, {["del", _player, [getPlayerUID _target]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2]}, []] call _add;
    } else {
        ["advsec_pm_want", ("STR_ADVSEC_declare_wanted_2" call ADVSEC_fnc_L), ADVSEC_icPol, {[_target] call ADVSEC_fnc_wantedPrompt}, []] call _add;
    };
};
if (isPlayer _target && {[_player, "licenseRevoke"] call ADVSEC_fnc_perm}) then {
    ["advsec_pm_lic", ("STR_ADVSEC_revoke_licence_2" call ADVSEC_fnc_L), ADVSEC_icDoc, {[_target] call ADVSEC_fnc_licRevokePrompt}, []] call _add;
};
if ([_player, "fine"] call ADVSEC_fnc_perm) then {
    ["advsec_pm_fine", ("STR_ADVSEC_fine_5" call ADVSEC_fnc_L), ADVSEC_icDoc, {[_target] call ADVSEC_fnc_finePrompt}, []] call _add;
};
if ([_player, "breath"] call ADVSEC_fnc_perm) then {
    ["advsec_pm_breath", ("STR_ADVSEC_m_breath_menu" call ADVSEC_fnc_L), ADVSEC_icSearch, {["breath", _player, [_target]] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []] call _add;
};
if ([_player] call ADVSEC_fnc_isZeus) then {
    ["advsec_pm_drunk", ("STR_ADVSEC_m_drunk_menu" call ADVSEC_fnc_L), ADVSEC_icSearch, {["setDrunk", _player, [_target, 0.4 + random 0.8]] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}, []] call _add;
};
["advsec_pm_qry", ("STR_ADVSEC_check_record" call ADVSEC_fnc_L), ADVSEC_icSearch, {[_target] call ADVSEC_fnc_queryOpen}, []] call _add;
["advsec_pm_docs", ("STR_ADVSEC_request_documents" call ADVSEC_fnc_L), ADVSEC_icDoc, {[_target] call ADVSEC_fnc_docListOpen}, []] call _add;
["advsec_pm_inc", ("STR_ADVSEC_log_incident" call ADVSEC_fnc_L), ADVSEC_icDoc, {["PM", format ["%1 [%2]", name _target, getPlayerUID _target]] call ADVSEC_fnc_repEditorOpen}, []] call _add;
_list
