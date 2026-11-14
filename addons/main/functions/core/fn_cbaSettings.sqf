/*
    Registra los ajustes en Opciones > Opciones de complementos (CBA). Sin CBA no hace nada y se usan description.ext y el addon.
    El valor por defecto de cada ajuste es el de la misión (o el del addon), así que CBA solo pisa lo que el admin cambie.
    Todos son globales: los fija el servidor/administrador y se sincronizan a los clientes.
*/
if (!isClass (configFile >> "CfgPatches" >> "cba_settings") || {isNil "CBA_fnc_addSetting"}) exitWith {};
private _cat = "Advanced Security Systems";
// [variable, tipo, título, descripción, subcategoría, datos]
private _add = {
    params ["_var", "_type", "_title", "_tip", "_sub", "_data", ["_restart", false], ["_script", {}]];
    ["ADVSEC_cba_" + _var, _type, [_title, _tip], [_cat, _sub], _data, 1, _script, _restart] call CBA_fnc_addSetting;
};
private _num = {params ["_path", "_def"]; [_path, _def] call ADVSEC_fnc_setting};
private _mis = {params ["_name", "_def"]; getMissionConfigValue ["ADVSEC_" + _name, _def]};
private _bool = {(_this isEqualTo 1) || {_this isEqualTo true}};

// --- General
["language", "LIST", "Idioma / Language", "Automático: idioma del juego (un servidor dedicado usa inglés para sus mensajes). / Automatic: game language (a dedicated server uses English for its messages).", "1 · General", [[0, 1, 2], ["Automático / Automatic", "English", "Español"], ((["language", 0] call _mis) max 0 min 2)], false, {ADVSEC_Lmap = nil}] call _add;
["pmcProfile", "CHECKBOX", ("STR_ADVSEC_pmc_s_pmcProfile" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_pmcProfile_tip" call ADVSEC_fnc_L), "1 · General", ([["pmcProfile"], 1] call _num) call _bool, true] call _add;
["companyName", "EDITBOX", ("STR_ADVSEC_pmc_s_companyName" call ADVSEC_fnc_L), "", "1 · General", [["companyName"], "I.V.M."] call _num, true] call _add;
["saveInterval", "SLIDER", ("STR_ADVSEC_save_to_disk_s" call ADVSEC_fnc_L), ("STR_ADVSEC_how_often_in_seconds_server" call ADVSEC_fnc_L), "1 · General", [15, 600, ["saveInterval", 60] call _mis, 0]] call _add;
["logMax", "SLIDER", ("STR_ADVSEC_event_log_size" call ADVSEC_fnc_L), ("STR_ADVSEC_maximum_stored_events_audit" call ADVSEC_fnc_L), "1 · General", [500, 50000, ["logMax", 5000] call _mis, 0]] call _add;
["uiBlur", "CHECKBOX", ("STR_ADVSEC_blur_behind_menus" call ADVSEC_fnc_L), ("STR_ADVSEC_blurs_the_background_when_the" call ADVSEC_fnc_L), "1 · General", (["uiBlur", 1] call _mis) call _bool] call _add;
["pdaGrantsAccess", "CHECKBOX", ("STR_ADVSEC_the_pda_is_enough_for" call ADVSEC_fnc_L), ("STR_ADVSEC_carrying_the_pda_grants_access" call ADVSEC_fnc_L), "1 · General", (["pdaGrantsAccess", 0] call _mis) call _bool] call _add;

// --- Documentos
["autoMilitaryID", "CHECKBOX", ("STR_ADVSEC_automatic_military_id" call ADVSEC_fnc_L), ("STR_ADVSEC_hands_out_a_military_id" call ADVSEC_fnc_L), ("STR_ADVSEC_2_documents" call ADVSEC_fnc_L), (["autoMilitaryID", 1] call _mis) call _bool] call _add;
["militaryIssuer", "EDITBOX", ("STR_ADVSEC_military_id_issuer" call ADVSEC_fnc_L), ("STR_ADVSEC_issuer_text_on_the_automatic" call ADVSEC_fnc_L), ("STR_ADVSEC_2_documents" call ADVSEC_fnc_L), ["militaryIssuer", ("STR_ADVSEC_general_staff" call ADVSEC_fnc_L)] call _mis] call _add;
["militaryClearance", "SLIDER", ("STR_ADVSEC_military_id_level" call ADVSEC_fnc_L), ("STR_ADVSEC_access_level_of_the_automatic" call ADVSEC_fnc_L), ("STR_ADVSEC_2_documents" call ADVSEC_fnc_L), [0, 5, ["militaryClearance", 1] call _mis, 0]] call _add;

// --- Policía Militar
["breachItem", "EDITBOX", ("STR_ADVSEC_lockpicking_item" call ADVSEC_fnc_L), ("STR_ADVSEC_class_of_the_required_item" call ADVSEC_fnc_L), ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), ["breachItem", "ToolKit"] call _mis] call _add;
["breachTime", "SLIDER", ("STR_ADVSEC_lockpicking_time_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), [3, 120, ["breachTime", 20] call _mis, 0]] call _add;
["hiddenFindChance", "SLIDER", ("STR_ADVSEC_chance_to_find_items_hidden" call ADVSEC_fnc_L), "", ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), [0, 1, [["hiddenFindChance"], 0.75] call _num, 2]] call _add;
["stashFindChance", "SLIDER", ("STR_ADVSEC_chance_to_find_a_vehicle" call ADVSEC_fnc_L), "", ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), [0, 1, [["stashFindChance"], 0.5] call _num, 2]] call _add;
["queryNeedsRadio", "CHECKBOX", ("STR_ADVSEC_dispatch_queries_require_a_radio" call ADVSEC_fnc_L), ("STR_ADVSEC_tfar_acre_if_loaded_otherwise" call ADVSEC_fnc_L), ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), ([["queryNeedsRadio"], 1] call _num) call _bool] call _add;
["queryDelay", "SLIDER", ("STR_ADVSEC_dispatch_wait_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_3_military_police" call ADVSEC_fnc_L), [0, 30, [["queryDelay"], 3] call _num, 0]] call _add;

// --- Rangos y permisos (rango mínimo 0-5; 0 = cualquiera del cuerpo)
private _names = createHashMapFromArray [
    ["restrain", ("STR_ADVSEC_handcuff" call ADVSEC_fnc_L)], ["search", ("STR_ADVSEC_frisk" call ADVSEC_fnc_L)], ["seize", ("STR_ADVSEC_seize" call ADVSEC_fnc_L)], ["vehicleSearch", ("STR_ADVSEC_search_vehicles" call ADVSEC_fnc_L)],
    ["evidenceCollect", ("STR_ADVSEC_collect_evidence_2" call ADVSEC_fnc_L)], ["query", ("STR_ADVSEC_query_dispatch_3" call ADVSEC_fnc_L)], ["fine", ("STR_ADVSEC_fine_5" call ADVSEC_fnc_L)], ["fineCancel", ("STR_ADVSEC_cancel_fines" call ADVSEC_fnc_L)],
    ["wanted", ("STR_ADVSEC_manage_wanted_list" call ADVSEC_fnc_L)], ["arrest", ("STR_ADVSEC_arrest_3" call ADVSEC_fnc_L)], ["release", ("STR_ADVSEC_release" call ADVSEC_fnc_L)], ["evidenceAnalyze", ("STR_ADVSEC_analyse_evidence" call ADVSEC_fnc_L)],
    ["reportStatus", ("STR_ADVSEC_change_report_status" call ADVSEC_fnc_L)], ["revokeDoc", ("STR_ADVSEC_revoke_documents_2" call ADVSEC_fnc_L)], ["caseClose", ("STR_ADVSEC_ia_close_case_files" call ADVSEC_fnc_L)],
    ["suspicionView", ("STR_ADVSEC_ia_view_suspicion_index" call ADVSEC_fnc_L)], ["evidenceTamper", ("STR_ADVSEC_ia_tamper_with_evidence" call ADVSEC_fnc_L)], ["evidenceAudit", ("STR_ADVSEC_ia_forensic_audit" call ADVSEC_fnc_L)],
    ["playerDB", ("STR_ADVSEC_player_database" call ADVSEC_fnc_L)], ["rankPM", ("STR_ADVSEC_assign_mp_ranks" call ADVSEC_fnc_L)], ["rankAI", ("STR_ADVSEC_ia_assign_ranks" call ADVSEC_fnc_L)], ["rankGlobal", ("STR_ADVSEC_assign_global_ranks" call ADVSEC_fnc_L)], ["treasury", ("STR_ADVSEC_mp_treasury_4" call ADVSEC_fnc_L)], ["dutyView", ("STR_ADVSEC_duty_control" call ADVSEC_fnc_L)], ["dispatch", ("STR_ADVSEC_dispatch_centre" call ADVSEC_fnc_L)], ["suspend", ("STR_ADVSEC_ia_suspend_officers" call ADVSEC_fnc_L)], ["alertLevel", ("STR_ADVSEC_alert_level" call ADVSEC_fnc_L)], ["plateQuery", ("STR_ADVSEC_check_plates_2" call ADVSEC_fnc_L)], ["licenseRevoke", ("STR_ADVSEC_revoke_licences_2" call ADVSEC_fnc_L)], ["bankAudit", ("STR_ADVSEC_ia_bank_audit_2" call ADVSEC_fnc_L)], ["bankFreeze", ("STR_ADVSEC_ia_freeze_accounts" call ADVSEC_fnc_L)], ["k9", ("STR_ADVSEC_k9_unit" call ADVSEC_fnc_L)], ["radar", ("STR_ADVSEC_speed_gun" call ADVSEC_fnc_L)], ["bodycamView", ("STR_ADVSEC_ia_body_cameras_2" call ADVSEC_fnc_L)], ["patrolPlan", ("STR_ADVSEC_plan_patrols_2" call ADVSEC_fnc_L)]
];
_names insert [
    ["contractView", ("STR_ADVSEC_pmc_p_contractView" call ADVSEC_fnc_L)], ["contractAssign", ("STR_ADVSEC_pmc_p_contractAssign" call ADVSEC_fnc_L)], ["contractSign", ("STR_ADVSEC_pmc_p_contractSign" call ADVSEC_fnc_L)],
    ["contractGrey", ("STR_ADVSEC_pmc_p_contractGrey" call ADVSEC_fnc_L)], ["armoryCheckout", ("STR_ADVSEC_pmc_p_armoryCheckout" call ADVSEC_fnc_L)], ["armoryManage", ("STR_ADVSEC_pmc_p_armoryManage" call ADVSEC_fnc_L)],
    ["logisticsOrder", ("STR_ADVSEC_pmc_p_logisticsOrder" call ADVSEC_fnc_L)], ["cellView", ("STR_ADVSEC_pmc_p_cellView" call ADVSEC_fnc_L)], ["cellManage", ("STR_ADVSEC_pmc_p_cellManage" call ADVSEC_fnc_L)],
    ["cyberView", ("STR_ADVSEC_pmc_p_cyberView" call ADVSEC_fnc_L)], ["cyberManage", ("STR_ADVSEC_pmc_p_cyberManage" call ADVSEC_fnc_L)]
];
{
    private _c = _x;
    private _a = configName _c;
    private _def = (getArray _c) param [1, 1];
    private _m = missionConfigFile >> "ADVSEC_Settings" >> "Permissions" >> _a;
    if (isArray _m) then {_def = (getArray _m) param [1, _def]};
    ["perm_" + _a, "SLIDER", format [("STR_ADVSEC_minimum_rank" call ADVSEC_fnc_L), _names getOrDefault [_a, _a]], format [("STR_ADVSEC_corps" call ADVSEC_fnc_L), (getArray _c) param [0, "PM"]], ("STR_ADVSEC_4_ranks_and_permissions" call ADVSEC_fnc_L), [0, 5, _def, 0]] call _add;
} forEach (configProperties [configFile >> "ADVSEC_Settings" >> "Permissions", "isArray _x", true]);
["globalRankSetUnit", "CHECKBOX", ("STR_ADVSEC_global_rank_changes_the_arma" call ADVSEC_fnc_L), ("STR_ADVSEC_applies_setunitrank_from_ranksglobalarma" call ADVSEC_fnc_L), ("STR_ADVSEC_4_ranks_and_permissions" call ADVSEC_fnc_L), ([["globalRankSetUnit"], 1] call _num) call _bool] call _add;

// --- Evidencias
["evidenceTTL", "SLIDER", ("STR_ADVSEC_evidence_lifetime_on_the_ground" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [60, 14400, [["evidenceTTL"], 3600] call _num, 0]] call _add;
["casingEvery", "SLIDER", ("STR_ADVSEC_casing_logged_every_n_shots" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [1, 30, [["casingEvery"], 4] call _num, 0]] call _add;
["printChance", "SLIDER", ("STR_ADVSEC_chance_to_leave_a_print" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [0, 1, [["printChance"], 0.8] call _num, 2]] call _add;
["gloveChance", "SLIDER", ("STR_ADVSEC_chance_to_leave_a_print_2" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [0, 1, [["gloveChance"], 0.15] call _num, 2]] call _add;
["labTime", "SLIDER", ("STR_ADVSEC_analysis_time_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [5, 900, [["labTime"], 90] call _num, 0]] call _add;
["auditTime", "SLIDER", ("STR_ADVSEC_forensic_audit_time_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [5, 300, [["auditTime"], 25] call _num, 0]] call _add;
["sceneRadius", "SLIDER", ("STR_ADVSEC_scene_inspection_radius_m" call ADVSEC_fnc_L), "", ("STR_ADVSEC_5_evidence" call ADVSEC_fnc_L), [3, 60, [["sceneRadius"], 15] call _num, 0]] call _add;

// --- Asuntos Internos
["heatThreshold", "SLIDER", ("STR_ADVSEC_automatic_case_file_threshold" call ADVSEC_fnc_L), ("STR_ADVSEC_suspicion_points_that_open_an" call ADVSEC_fnc_L), ("STR_ADVSEC_6_internal_affairs" call ADVSEC_fnc_L), [5, 300, [["heatThreshold"], 30] call _num, 0]] call _add;
["heatDecay", "SLIDER", ("STR_ADVSEC_suspicion_decay_every_10_min" call ADVSEC_fnc_L), "", ("STR_ADVSEC_6_internal_affairs" call ADVSEC_fnc_L), [0, 20, [["heatDecay"], 1] call _num, 0]] call _add;
private _rules = createHashMapFromArray [
    ["restrainNoCause", ("STR_ADVSEC_handcuff_without_reason" call ADVSEC_fnc_L)], ["arrestNoCause", ("STR_ADVSEC_arrest_without_reason" call ADVSEC_fnc_L)], ["arrestNoReport", ("STR_ADVSEC_arrest_without_a_report" call ADVSEC_fnc_L)],
    ["hitRestrained", ("STR_ADVSEC_injure_a_handcuffed_person" call ADVSEC_fnc_L)], ["earlyRelease", ("STR_ADVSEC_release_early" call ADVSEC_fnc_L)], ["wantedRemovedByOther", ("STR_ADVSEC_remove_someone_else_s_wanted" call ADVSEC_fnc_L)],
    ["ownCaseAccess", ("STR_ADVSEC_view_their_own_case_file" call ADVSEC_fnc_L)], ["evidenceTamper", ("STR_ADVSEC_tamper_with_evidence_2" call ADVSEC_fnc_L)], ["fineCancelled", ("STR_ADVSEC_cancel_someone_else_s_fine" call ADVSEC_fnc_L)], ["bribe", ("STR_ADVSEC_accept_a_bribe" call ADVSEC_fnc_L)], ["suspiciousMoney", ("STR_ADVSEC_suspicious_money_transaction" call ADVSEC_fnc_L)], ["bodycamOff", ("STR_ADVSEC_turn_off_the_body_camera" call ADVSEC_fnc_L)]
];
_rules insert [
    ["contractGrey", ("STR_ADVSEC_pmc_r_contractGrey" call ADVSEC_fnc_L)], ["collateralHurt", ("STR_ADVSEC_pmc_r_collateralHurt" call ADVSEC_fnc_L)], ["collateralKill", ("STR_ADVSEC_pmc_r_collateralKill" call ADVSEC_fnc_L)],
    ["collateralKillRoe", ("STR_ADVSEC_pmc_r_collateralKillRoe" call ADVSEC_fnc_L)], ["armoryMismatch", ("STR_ADVSEC_pmc_r_armoryMismatch" call ADVSEC_fnc_L)], ["armoryUnauthorized", ("STR_ADVSEC_pmc_r_armoryUnauthorized" call ADVSEC_fnc_L)],
    ["corpDiversion", ("STR_ADVSEC_pmc_r_corpDiversion" call ADVSEC_fnc_L)], ["qrfIgnored", ("STR_ADVSEC_pmc_r_qrfIgnored" call ADVSEC_fnc_L)], ["cyberAnomaly", ("STR_ADVSEC_pmc_r_cyberAnomaly" call ADVSEC_fnc_L)]
];
{
    ["Rules_" + configName _x, "SLIDER", format [("STR_ADVSEC_suspicion_for" call ADVSEC_fnc_L), _rules getOrDefault [configName _x, configName _x]], "", ("STR_ADVSEC_6_internal_affairs" call ADVSEC_fnc_L), [0, 100, [["Rules", configName _x], getNumber _x] call _num, 0]] call _add;
} forEach (configProperties [configFile >> "ADVSEC_Settings" >> "Rules", "isNumber _x", true]);

// --- Multas
["currency", "EDITBOX", ("STR_ADVSEC_currency" call ADVSEC_fnc_L), "", ("STR_ADVSEC_7_fines" call ADVSEC_fnc_L), [["currency"], "€"] call _num] call _add;
["moneyVar", "EDITBOX", ("STR_ADVSEC_player_money_variable" call ADVSEC_fnc_L), ("STR_ADVSEC_empty_manual_payment_before_an" call ADVSEC_fnc_L), ("STR_ADVSEC_7_fines" call ADVSEC_fnc_L), [["moneyVar"], ""] call _num] call _add;
["fineWantedThreshold", "SLIDER", ("STR_ADVSEC_debt_that_adds_to_wanted" call ADVSEC_fnc_L), "", ("STR_ADVSEC_7_fines" call ADVSEC_fnc_L), [0, 100000, [["fineWantedThreshold"], 0] call _num, 0]] call _add;

// --- Economía
["economy", "CHECKBOX", ("STR_ADVSEC_advsec_economy" call ADVSEC_fnc_L), ("STR_ADVSEC_cash_bank_salaries_atms_and" call ADVSEC_fnc_L), ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["economy"], 1] call _num) call _bool] call _add;
["startCash", "SLIDER", ("STR_ADVSEC_starting_cash" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), [0, 100000, [["startCash"], 500] call _num, 0]] call _add;
["startBank", "SLIDER", ("STR_ADVSEC_starting_bank" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), [0, 1000000, [["startBank"], 2000] call _num, 0]] call _add;
["salaryInterval", "SLIDER", ("STR_ADVSEC_minutes_between_salaries_0_no" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), [0, 240, [["salaryInterval"], 30] call _num, 0]] call _add;
["salaryBase", "SLIDER", ("STR_ADVSEC_base_salary" call ADVSEC_fnc_L), ("STR_ADVSEC_plus_the_mp_ia_and" call ADVSEC_fnc_L), ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), [0, 10000, [["salaryBase"], 100] call _num, 0]] call _add;
["salaryFromTreasury", "CHECKBOX", ("STR_ADVSEC_salaries_come_from_the_treasury" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["salaryFromTreasury"], 0] call _num) call _bool] call _add;
["fineToTreasury", "CHECKBOX", ("STR_ADVSEC_fines_go_to_the_mp" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["fineToTreasury"], 1] call _num) call _bool] call _add;
["shopToTreasury", "CHECKBOX", ("STR_ADVSEC_purchases_go_to_the_mp" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["shopToTreasury"], 0] call _num) call _bool] call _add;
["sellFactor", "SLIDER", ("STR_ADVSEC_share_of_the_price_when" call ADVSEC_fnc_L), "", ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), [0, 1, [["sellFactor"], 0.5] call _num, 2]] call _add;
["atmAnywhere", "CHECKBOX", ("STR_ADVSEC_bank_without_atm" call ADVSEC_fnc_L), ("STR_ADVSEC_deposit_withdraw_and_transfer_from" call ADVSEC_fnc_L), ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["atmAnywhere"], 0] call _num) call _bool] call _add;
["thudCompat", "CHECKBOX", ("STR_ADVSEC_thud_hud_compatibility" call ADVSEC_fnc_L), ("STR_ADVSEC_publishes_treasury_officers_and_boss" call ADVSEC_fnc_L), ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["thudCompat"], 1] call _num) call _bool] call _add;
["a3aTreasury", "CHECKBOX", ("STR_ADVSEC_antistasi_the_treasury_is_the" call ADVSEC_fnc_L), ("STR_ADVSEC_in_an_antistasi_mission_fines" call ADVSEC_fnc_L), ("STR_ADVSEC_9_economy" call ADVSEC_fnc_L), ([["a3aTreasury"], 1] call _num) call _bool] call _add;

// --- Patrullas
["patrolOrdered", "CHECKBOX", ("STR_ADVSEC_patrol_points_in_order" call ADVSEC_fnc_L), ("STR_ADVSEC_if_enabled_the_patrol_must" call ADVSEC_fnc_L), ("STR_ADVSEC_11_patrols" call ADVSEC_fnc_L), ([["patrolOrdered"], 1] call _num) call _bool] call _add;
["patrolNeedDuty", "CHECKBOX", ("STR_ADVSEC_only_on_duty_officers_count" call ADVSEC_fnc_L), "", ("STR_ADVSEC_11_patrols" call ADVSEC_fnc_L), ([["patrolNeedDuty"], 1] call _num) call _bool] call _add;
["patrolBonus", "SLIDER", ("STR_ADVSEC_bonus_per_completed_patrol" call ADVSEC_fnc_L), ("STR_ADVSEC_paid_into_the_bank_of" call ADVSEC_fnc_L), ("STR_ADVSEC_11_patrols" call ADVSEC_fnc_L), [0, 5000, ([["patrolBonus"], 0] call _num), 0]] call _add;

// --- PMC: contratos (12), armería y contrabando (13), células QRF/CP (14), Inteligencia y ciber (15)
["contractAuto", "CHECKBOX", ("STR_ADVSEC_pmc_s_contractAuto" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), ([["contractAuto"], 1] call _num) call _bool] call _add;
["contractEvery", "SLIDER", ("STR_ADVSEC_pmc_s_contractEvery" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [5, 180, [["contractEvery"], 20] call _num, 0]] call _add;
["contractMax", "SLIDER", ("STR_ADVSEC_pmc_s_contractMax" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [1, 20, [["contractMax"], 6] call _num, 0]] call _add;
["contractMaxActive", "SLIDER", ("STR_ADVSEC_pmc_s_contractMaxActive" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [1, 10, [["contractMaxActive"], 3] call _num, 0]] call _add;
["contractMinOps", "SLIDER", ("STR_ADVSEC_pmc_s_contractMinOps" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractMinOps_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [-1, 10, [["contractMinOps"], -1] call _num, 0]] call _add;
["contractCivilians", "CHECKBOX", ("STR_ADVSEC_pmc_s_contractCivilians" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractCivilians_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), ([["contractCivilians"], 1] call _num) call _bool] call _add;
["contractCivSuspect", "SLIDER", ("STR_ADVSEC_pmc_s_contractCivSuspect" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 1, [["contractCivSuspect"], 0.3] call _num, 2]] call _add;
["contractCivEvery", "SLIDER", ("STR_ADVSEC_pmc_s_contractCivEvery" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [15, 300, [["contractCivEvery"], 45] call _num, 0]] call _add;
["contractMilestones", "CHECKBOX", ("STR_ADVSEC_pmc_s_contractMilestones" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractMilestones_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), ([["contractMilestones"], 0] call _num) call _bool] call _add;
["contractCheckRep", "CHECKBOX", ("STR_ADVSEC_pmc_s_contractCheckRep" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractCheckRep_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), ([["contractCheckRep"], 1] call _num) call _bool] call _add;
["contractCheckSpecs", "CHECKBOX", ("STR_ADVSEC_pmc_s_contractCheckSpecs" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractCheckSpecs_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), ([["contractCheckSpecs"], 1] call _num) call _bool] call _add;
["contractAdvance", "SLIDER", ("STR_ADVSEC_pmc_s_contractAdvance" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 1, [["contractAdvance"], 0.3] call _num, 2]] call _add;
["contractInsurance", "SLIDER", ("STR_ADVSEC_pmc_s_contractInsurance" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 0.5, [["contractInsurance"], 0.05] call _num, 2]] call _add;
["contractOpShare", "SLIDER", ("STR_ADVSEC_pmc_s_contractOpShare" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 1, [["contractOpShare"], 0.4] call _num, 2]] call _add;
["contractCivPenalty", "SLIDER", ("STR_ADVSEC_pmc_s_contractCivPenalty" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 1, [["contractCivPenalty"], 0.25] call _num, 2]] call _add;
["contractRepGain", "SLIDER", ("STR_ADVSEC_pmc_s_contractRepGain" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 50, [["contractRepGain"], 10] call _num, 0]] call _add;
["contractRepLoss", "SLIDER", ("STR_ADVSEC_pmc_s_contractRepLoss" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 100, [["contractRepLoss"], 20] call _num, 0]] call _add;
["contractAuctionMin", "SLIDER", ("STR_ADVSEC_pmc_s_contractAuctionMin" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_contractAuctionMin_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 120, [["contractAuctionMin"], 0] call _num, 0]] call _add;
["contractRepDecay", "SLIDER", ("STR_ADVSEC_pmc_s_contractRepDecay" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 30, [["contractRepDecay"], 3] call _num, 0]] call _add;
["contractHostiles", "LIST", ("STR_ADVSEC_pmc_s_contractHostiles" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [[0, 1, 2, 3], [("STR_ADVSEC_pmc_host_m0" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_host_m1" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_host_m2" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_host_m3" call ADVSEC_fnc_L)], ([["contractHostiles"], 3] call _num) max 0 min 3]] call _add;
["contractHostileScale", "SLIDER", ("STR_ADVSEC_pmc_s_contractHostileScale" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [0, 4, [["contractHostileScale"], 1] call _num, 1]] call _add;
["contractHostileSide", "EDITBOX", ("STR_ADVSEC_pmc_s_contractHostileSide" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [["contractHostileSide"], "east"] call _num] call _add;
["collateralCaseAt", "SLIDER", ("STR_ADVSEC_pmc_s_collateralCaseAt" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec12" call ADVSEC_fnc_L), [1, 10, [["collateralCaseAt"], 2] call _num, 0]] call _add;
["arsenalSerial", "CHECKBOX", ("STR_ADVSEC_s_arsenalSerial" call ADVSEC_fnc_L), ("STR_ADVSEC_s_arsenalSerial_tip" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), ([["arsenalSerial"], 1] call _num) call _bool] call _add;
["armoryNeedDuty", "CHECKBOX", ("STR_ADVSEC_pmc_s_armoryNeedDuty" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), ([["armoryNeedDuty"], 1] call _num) call _bool] call _add;
["armoryLossFactor", "SLIDER", ("STR_ADVSEC_pmc_s_armoryLossFactor" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), [0, 5, [["armoryLossFactor"], 1.5] call _num, 1]] call _add;
["armoryAuditEvery", "SLIDER", ("STR_ADVSEC_pmc_s_armoryAuditEvery" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), [0, 240, [["armoryAuditEvery"], 0] call _num, 0]] call _add;
["blackMarketIllegal", "CHECKBOX", ("STR_ADVSEC_pmc_s_blackMarketIllegal" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), ([["blackMarketIllegal"], 1] call _num) call _bool] call _add;
["blackMarketTrace", "SLIDER", ("STR_ADVSEC_pmc_s_blackMarketTrace" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec13" call ADVSEC_fnc_L), [0, 1, [["blackMarketTrace"], 0.5] call _num, 2]] call _add;
["qrfTarget", "SLIDER", ("STR_ADVSEC_pmc_s_qrfTarget" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [1, 30, [["qrfTarget"], 8] call _num, 0]] call _add;
["qrfArriveRadius", "SLIDER", ("STR_ADVSEC_pmc_s_qrfArriveRadius" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [10, 300, [["qrfArriveRadius"], 50] call _num, 0]] call _add;
["qrfBonus", "SLIDER", ("STR_ADVSEC_pmc_s_qrfBonus" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [0, 5000, [["qrfBonus"], 250] call _num, 0]] call _add;
["qrfStandbyPay", "SLIDER", ("STR_ADVSEC_pmc_s_qrfStandbyPay" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [0, 5000, [["qrfStandbyPay"], 150] call _num, 0]] call _add;
["qrfStandbyMin", "SLIDER", ("STR_ADVSEC_pmc_s_qrfStandbyMin" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [0, 1, [["qrfStandbyMin"], 0.8] call _num, 2]] call _add;
["cpCloseRadius", "SLIDER", ("STR_ADVSEC_pmc_s_cpCloseRadius" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [2, 30, [["cpCloseRadius"], 5] call _num, 0]] call _add;
["cpExposurePenalty", "SLIDER", ("STR_ADVSEC_pmc_s_cpExposurePenalty" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec14" call ADVSEC_fnc_L), [0, 0.1, [["cpExposurePenalty"], 0.01] call _num, 3]] call _add;
["cctvSnapEvery", "SLIDER", ("STR_ADVSEC_pmc_s_cctvSnapEvery" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec15" call ADVSEC_fnc_L), [0, 120, [["cctvSnapEvery"], 20] call _num, 0]] call _add;
["cctvSnapRange", "SLIDER", ("STR_ADVSEC_pmc_s_cctvSnapRange" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec15" call ADVSEC_fnc_L), [10, 200, [["cctvSnapRange"], 60] call _num, 0]] call _add;
["hackChance", "SLIDER", ("STR_ADVSEC_pmc_s_hackChance" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec15" call ADVSEC_fnc_L), [0, 1, [["hackChance"], 0.5] call _num, 2]] call _add;
["hackTime", "SLIDER", ("STR_ADVSEC_pmc_s_hackTime" call ADVSEC_fnc_L), "", ("STR_ADVSEC_pmc_s_sec15" call ADVSEC_fnc_L), [5, 120, [["hackTime"], 20] call _num, 0]] call _add;

// --- Taquillas (TS_Lockers)
["lockerAccess", "LIST", ("STR_ADVSEC_who_can_claim_a_locker" call ADVSEC_fnc_L), "", ("STR_ADVSEC_10_lockers" call ADVSEC_fnc_L), [[0, 1, 2], [("STR_ADVSEC_all" call ADVSEC_fnc_L), ("STR_ADVSEC_military_police_only" call ADVSEC_fnc_L), ("STR_ADVSEC_mp_or_internal_affairs" call ADVSEC_fnc_L)], ([["lockerAccess"], 0] call _num) max 0 min 2]] call _add;
["lockerJailBlock", "CHECKBOX", ("STR_ADVSEC_detainees_cannot_use_their_locker" call ADVSEC_fnc_L), "", ("STR_ADVSEC_10_lockers" call ADVSEC_fnc_L), ([["lockerJailBlock"], 1] call _num) call _bool] call _add;
["lockerPersist", "LIST", ("STR_ADVSEC_recreate_lockers_placed_with_zeus" call ADVSEC_fnc_L), ("STR_ADVSEC_they_reappear_where_they_were" call ADVSEC_fnc_L), ("STR_ADVSEC_10_lockers" call ADVSEC_fnc_L), [[0, 1, 2], [("STR_ADVSEC_never" call ADVSEC_fnc_L), ("STR_ADVSEC_always" call ADVSEC_fnc_L), ("STR_ADVSEC_antistasi_only" call ADVSEC_fnc_L)], ([["lockerPersist"], 2] call _num) max 0 min 2]] call _add;

// --- Control de carretera
["checkpointFine", "SLIDER", ("STR_ADVSEC_fine_for_having_no_documents" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [0, 10000, [["checkpointFine"], 150] call _num, 0]] call _add;
["checkpointSearchChance", "SLIDER", ("STR_ADVSEC_chance_to_search_the_vehicle" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [0, 1, [["checkpointSearchChance"], 1] call _num, 2]] call _add;
["checkpointPapersTime", "SLIDER", ("STR_ADVSEC_time_checking_documents_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [2, 60, [["checkpointPapersTime"], 8] call _num, 0]] call _add;
["checkpointVehicleTime", "SLIDER", ("STR_ADVSEC_time_searching_the_vehicle_s" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [2, 120, [["checkpointVehicleTime"], 15] call _num, 0]] call _add;
["checkpointUnits", "SLIDER", ("STR_ADVSEC_officers_a_checkpoint_creates" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [0, 8, [["checkpointUnits"], 2] call _num, 0]] call _add;
["checkpointSide", "LIST", ("STR_ADVSEC_side_of_the_created_officers" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), [["west", "east", "independent", "civilian"], ["BLUFOR", "OPFOR", ("STR_ADVSEC_independent" call ADVSEC_fnc_L), "Civil"], (["west", "east", "independent", "civilian"] find toLower ([["checkpointSide"], "west"] call _num)) max 0]] call _add;
["checkpointExemptPM", "CHECKBOX", ("STR_ADVSEC_do_not_stop_mp_admins" call ADVSEC_fnc_L), "", ("STR_ADVSEC_8_road_checkpoint" call ADVSEC_fnc_L), ([["checkpointExemptPM"], 0] call _num) call _bool] call _add;
