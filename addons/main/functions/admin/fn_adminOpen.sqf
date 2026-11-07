// Abre la terminal de superadministrador
if !([player] call ADVSEC_fnc_adminIs) exitWith {hint ("STR_ADVSEC_superadmins_only_zeus_admins_or" call ADVSEC_fnc_L)};
if (isNull findDisplay 87800 && {!createDialog "ADVSEC_AdminDlg"}) exitWith {};
private _disp = findDisplay 87800;
// [clave, nombre, botones [[texto, acción, necesitaSelección, pideConfirmación, (opcional) [título, campos] de un formulario], ...]]
ADVSEC_admCats = [
    ["reports", ("STR_ADVSEC_reports_and_case_files" call ADVSEC_fnc_L), [[("STR_ADVSEC_delete_report" call ADVSEC_fnc_L), "repDel", true, true], [("STR_ADVSEC_delete_all" call ADVSEC_fnc_L), "repWipe", false, true]]],
    ["players", ("STR_ADVSEC_players_and_ranks" call ADVSEC_fnc_L), [[("STR_ADVSEC_remove_their_ranks" call ADVSEC_fnc_L), "pdbStrip", true, false], [("STR_ADVSEC_ranks_from_mission" call ADVSEC_fnc_L), "pdbReset", true, false], [("STR_ADVSEC_grant_remove_superadmin" call ADVSEC_fnc_L), "adminToggle", true, true], [("STR_ADVSEC_delete_record" call ADVSEC_fnc_L), "pdbDel", true, true], [("STR_ADVSEC_remove_ranks_from_everyone" call ADVSEC_fnc_L), "pdbStripAll", false, true]]],
    ["admins", ("STR_ADVSEC_superadmins" call ADVSEC_fnc_L), [[("STR_ADVSEC_remove_superadmin" call ADVSEC_fnc_L), "adminDel", true, true]]],
    ["wanted", ("STR_ADVSEC_wanted_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_withdraw_warrant" call ADVSEC_fnc_L), "wantedDel", true, false], [("STR_ADVSEC_clear_list" call ADVSEC_fnc_L), "wantedWipe", false, true]]],
    ["jail", ("STR_ADVSEC_detainees" call ADVSEC_fnc_L), [[("STR_ADVSEC_release" call ADVSEC_fnc_L), "jailDel", true, false], [("STR_ADVSEC_release_everyone" call ADVSEC_fnc_L), "jailWipe", false, true]]],
    ["fines", ("STR_ADVSEC_fines" call ADVSEC_fnc_L), [[("STR_ADVSEC_delete_fine" call ADVSEC_fnc_L), "fineDel", true, true], [("STR_ADVSEC_delete_all_2" call ADVSEC_fnc_L), "fineWipe", false, true]]],
    ["evidence", ("STR_ADVSEC_evidence_3" call ADVSEC_fnc_L), [[("STR_ADVSEC_delete_evidence" call ADVSEC_fnc_L), "evDel", true, true], [("STR_ADVSEC_delete_all_2" call ADVSEC_fnc_L), "evWipe", false, true]]],
    ["heat", ("STR_ADVSEC_suspicion_ia" call ADVSEC_fnc_L), [[("STR_ADVSEC_archive_index" call ADVSEC_fnc_L), "heatDel", true, false], [("STR_ADVSEC_archive_all" call ADVSEC_fnc_L), "heatWipe", false, true]]],
    ["docs", ("STR_ADVSEC_documents" call ADVSEC_fnc_L), [[("STR_ADVSEC_revoke_their_documents" call ADVSEC_fnc_L), "docDel", true, true], [("STR_ADVSEC_revoke_all_2" call ADVSEC_fnc_L), "docWipe", false, true]]],
    ["economy", ("STR_ADVSEC_economy" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_add_subtract_money" call ADVSEC_fnc_L), "ecoAdd", true, false, [("STR_ADVSEC_add_or_subtract_money" call ADVSEC_fnc_L), [[("STR_ADVSEC_where" call ADVSEC_fnc_L), "bank", [[("STR_ADVSEC_bank" call ADVSEC_fnc_L), "bank"], [("STR_ADVSEC_cash" call ADVSEC_fnc_L), "cash"]]], [("STR_ADVSEC_amount_negative_to_subtract" call ADVSEC_fnc_L), "1000"]]]],
        [("STR_ADVSEC_reset_to_zero" call ADVSEC_fnc_L), "ecoZero", true, true],
        [("STR_ADVSEC_delete_account" call ADVSEC_fnc_L), "ecoDel", true, true],
        [("STR_ADVSEC_set_treasury" call ADVSEC_fnc_L), "treasurySet", false, false, [("STR_ADVSEC_mp_treasury" call ADVSEC_fnc_L), [[("STR_ADVSEC_new_balance" call ADVSEC_fnc_L), "10000"]]]],
        [("STR_ADVSEC_reset_all_to_zero" call ADVSEC_fnc_L), "ecoWipe", false, true]
    ]],
    ["log", ("STR_ADVSEC_event_log" call ADVSEC_fnc_L), [[("STR_ADVSEC_clear_log" call ADVSEC_fnc_L), "logWipe", false, true]]]
];
ADVSEC_admRows = [];
ADVSEC_admConfirm = [-1, 0];
private _c = _disp displayCtrl 87802;
lbClear _c;
{_c lbAdd (_x select 1)} forEach ADVSEC_admCats;
_c lbSetCurSel 0;
