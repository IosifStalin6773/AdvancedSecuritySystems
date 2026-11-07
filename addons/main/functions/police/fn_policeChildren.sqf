/*
    Acciones de Policía Militar -> [[id, texto, icono, código, args, subhijos?], ...] (hijos ACE y menú sin ACE)
    [objetivo, agente, modo] modo: "unit" | "self" | "zeus"
*/
params ["_target", "_player", ["_mode", "unit"]];
private _list = [];
private _add = {_list pushBack _this};

if (_mode == "self") exitWith {
    // Agrupado en submenús para no saturar el menú de ACE
    private _grp = {params ["_id", "_t", "_i", "_sub"]; if (_sub isNotEqualTo []) then {_list pushBack [_id, _t, _i, {}, [], _sub]}};
    private _onDuty = _player getVariable ["ADVSEC_onDuty", false];

    private _srv = [["advsec_pm_duty", [("STR_ADVSEC_clock_in_for_duty" call ADVSEC_fnc_L), ("STR_ADVSEC_clock_out_of_duty" call ADVSEC_fnc_L)] select _onDuty, ADVSEC_icJail, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []]];
    if (_onDuty) then {
        _srv pushBack ["advsec_pm_cam", [("STR_ADVSEC_turn_on_body_camera" call ADVSEC_fnc_L), ("STR_ADVSEC_turn_off_body_camera" call ADVSEC_fnc_L)] select (_player getVariable ["ADVSEC_bodycam", false]), ADVSEC_icCam, {["bodycam", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []];
    };
    _srv pushBack ["advsec_pm_panic", ("STR_ADVSEC_panic_button_2" call ADVSEC_fnc_L), ADVSEC_icAlarm, {["panic", _player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}, []];
    _srv pushBack ["advsec_pm_dsp", ("STR_ADVSEC_dispatch_centre" call ADVSEC_fnc_L), ADVSEC_icAlarm, {[] call ADVSEC_fnc_dspOpen}, []];
    if ([_player, "dutyView"] call ADVSEC_fnc_perm) then {_srv pushBack ["advsec_pm_dutyv", ("STR_ADVSEC_duty_control" call ADVSEC_fnc_L), ADVSEC_icJail, {[] call ADVSEC_fnc_dutyOpen}, []]};
    if ([_player, "alertLevel"] call ADVSEC_fnc_perm) then {_srv pushBack ["advsec_pm_alert", ("STR_ADVSEC_base_alert_level_2" call ADVSEC_fnc_L), ADVSEC_icAlarm, {[] call ADVSEC_fnc_alertOpen}, []]};
    _srv pushBack ["advsec_pm_patrol", ("STR_ADVSEC_route_patrols" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_patrolOpen}, []];
    ["advsec_pm_g_srv", ("STR_ADVSEC_duty" call ADVSEC_fnc_L), ADVSEC_icJail, _srv] call _grp;
    // PMC: contratos, células operativas y terminal ciber
    private _pmc = [];
    if ([_player, "contractView"] call ADVSEC_fnc_perm) then {
        _pmc pushBack ["advsec_pmc_ctr", ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_ctrOpen}, []];
        _pmc pushBack ["advsec_pmc_decl", ("STR_ADVSEC_pmc_btn_declare" call ADVSEC_fnc_L), ADVSEC_icDoc, {["declare", _player] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}, []];
    };
    if ([_player, "cellView"] call ADVSEC_fnc_perm || {(([_player] call ADVSEC_fnc_cellRole) select 0) isNotEqualTo ""}) then {_pmc pushBack ["advsec_pmc_cell", ("STR_ADVSEC_pmc_cells" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_cellOpen}, []]};
    if ([_player, "cyberView"] call ADVSEC_fnc_perm || {(([_player] call ADVSEC_fnc_cellRole) select 0) == "SEC"}) then {_pmc pushBack ["advsec_pmc_cy", ("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L), ADVSEC_icCam, {[] call ADVSEC_fnc_cyOpen}, []]};
    ["advsec_pm_g_pmc", ("STR_ADVSEC_pmc_menu" call ADVSEC_fnc_L), ADVSEC_icDoc, _pmc] call _grp;

    private _pat = [["advsec_pm_unload", ("STR_ADVSEC_take_detainees_out_of_the" call ADVSEC_fnc_L), ADVSEC_icCar, {[_player] call ADVSEC_fnc_policeUnload}, []]];
    private _veh = (nearestObjects [_player, ["Car", "Motorcycle", "Tank", "Ship"], 7]) select {alive _x && {isNull objectParent _player}};
    if (_veh isNotEqualTo [] && {[_player, "vehicleSearch"] call ADVSEC_fnc_perm}) then {
        _pat pushBack ["advsec_pm_vehsearch", format [("STR_ADVSEC_search_4" call ADVSEC_fnc_L), getText (configOf (_veh select 0) >> "displayName")], ADVSEC_icCar, {[_args select 0] call ADVSEC_fnc_vehOpen}, [_veh select 0]];
    };
    if ([_player, "radar"] call ADVSEC_fnc_perm) then {_pat pushBack ["advsec_pm_radar", ("STR_ADVSEC_speed_gun_aim" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_radarUse}, []]};
    if ([_player, "k9"] call ADVSEC_fnc_perm) then {
        _pat pushBack ["advsec_pm_k9", [("STR_ADVSEC_k9_call_the_dog" call ADVSEC_fnc_L), ("STR_ADVSEC_k9_dismiss_the_dog" call ADVSEC_fnc_L)] select !isNull (_player getVariable ["ADVSEC_k9", objNull]), ADVSEC_icSearch, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []];
        if (!isNull (_player getVariable ["ADVSEC_k9", objNull])) then {
            _pat pushBack ["advsec_pm_sniff", ("STR_ADVSEC_k9_sniff_what_you_aim" call ADVSEC_fnc_L), ADVSEC_icSearch, {["sniff", _player, [cursorObject]] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []];
        };
    };
    ["advsec_pm_g_pat", ("STR_ADVSEC_patrol" call ADVSEC_fnc_L), ADVSEC_icCar, _pat] call _grp;

    private _q = [["advsec_pm_query", ("STR_ADVSEC_query_dispatch_2" call ADVSEC_fnc_L), ADVSEC_icSearch, {[] call ADVSEC_fnc_queryOpen}, []], ["advsec_pm_wanted", ("STR_ADVSEC_wanted_list" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_wantedOpen}, []]];
    if ([_player, "plateQuery"] call ADVSEC_fnc_perm) then {_q pushBack ["advsec_pm_plate", ("STR_ADVSEC_check_plate_2" call ADVSEC_fnc_L), ADVSEC_icCar, {[] call ADVSEC_fnc_plateQuery}, []]};
    if ([_player, "playerDB"] call ADVSEC_fnc_perm) then {_q pushBack ["advsec_pm_playerdb", ("STR_ADVSEC_player_database" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_pdbOpen}, []]};
    ["advsec_pm_g_q", ("STR_ADVSEC_queries" call ADVSEC_fnc_L), ADVSEC_icSearch, _q] call _grp;

    private _rep = [["advsec_pm_reports", ("STR_ADVSEC_report_archive" call ADVSEC_fnc_L), ADVSEC_icDoc, {["BOTH"] call ADVSEC_fnc_repOpen}, []], ["advsec_pm_incident", ("STR_ADVSEC_log_incident" call ADVSEC_fnc_L), ADVSEC_icDoc, {["PM"] call ADVSEC_fnc_repEditorOpen}, []]];
    if ([_player, "evidenceCollect"] call ADVSEC_fnc_perm) then {_rep pushBack ["advsec_pm_scene", ("STR_ADVSEC_inspect_scene_evidence" call ADVSEC_fnc_L), ADVSEC_icSearch, {["scene", _player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}, []]};
    _rep pushBack ["advsec_pm_evidence", ("STR_ADVSEC_evidence_log" call ADVSEC_fnc_L), ADVSEC_icDoc, {[] call ADVSEC_fnc_evOpen}, []];
    ["advsec_pm_g_rep", ("STR_ADVSEC_reports_and_evidence" call ADVSEC_fnc_L), ADVSEC_icDoc, _rep] call _grp;

    private _ai = [];
    if ([_player, "suspicionView"] call ADVSEC_fnc_perm) then {_ai pushBack ["advsec_ai_heat", ("STR_ADVSEC_suspicion_index_2" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_heatOpen}, []]};
    if ([_player, "bodycamView"] call ADVSEC_fnc_perm) then {
        _ai pushBack ["advsec_ai_live", ("STR_ADVSEC_live_body_cameras" call ADVSEC_fnc_L), ADVSEC_icCam, {["open"] call ADVSEC_fnc_bodyLive}, []];
        _ai pushBack ["advsec_ai_cam", ("STR_ADVSEC_body_camera_recordings" call ADVSEC_fnc_L), ADVSEC_icCam, {[] call ADVSEC_fnc_bodyOpen}, []];
    };
    if ([_player, "suspend"] call ADVSEC_fnc_perm) then {_ai pushBack ["advsec_ai_susp", ("STR_ADVSEC_suspensions" call ADVSEC_fnc_L), ADVSEC_icPol, {[] call ADVSEC_fnc_susOpen}, []]};
    if ([_player, "bankAudit"] call ADVSEC_fnc_perm) then {_ai pushBack ["advsec_ai_bank", ("STR_ADVSEC_bank_audit" call ADVSEC_fnc_L), ADVSEC_icSearch, {[] call ADVSEC_fnc_auditOpen}, []]};
    ["advsec_pm_g_ai", ("STR_ADVSEC_internal_affairs" call ADVSEC_fnc_L), ADVSEC_icPol, _ai] call _grp;
    _list
};
if (!alive _target) exitWith {_list};

private _r = [_target] call ADVSEC_fnc_isRestrained;
private _surr = (_target getVariable ["ace_captives_isSurrendering", false]) || {"surrender" in toLower animationState _target};
private _inVeh = !isNull objectParent _target;

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
["advsec_pm_qry", ("STR_ADVSEC_check_record" call ADVSEC_fnc_L), ADVSEC_icSearch, {[_target] call ADVSEC_fnc_queryOpen}, []] call _add;
["advsec_pm_docs", ("STR_ADVSEC_request_documents" call ADVSEC_fnc_L), ADVSEC_icDoc, {[_target] call ADVSEC_fnc_docListOpen}, []] call _add;
["advsec_pm_inc", ("STR_ADVSEC_log_incident" call ADVSEC_fnc_L), ADVSEC_icDoc, {["PM", format ["%1 [%2]", name _target, getPlayerUID _target]] call ADVSEC_fnc_repEditorOpen}, []] call _add;
_list
