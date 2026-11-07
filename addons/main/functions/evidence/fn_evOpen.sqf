// [laboratorio (objNull fuera del laboratorio)] — registro de pruebas con custodia, análisis, auditoría y manipulación
params [["_lab", objNull]];
ADVSEC_evLab = _lab;
private _ai = [player, "AI"] call ADVSEC_fnc_repAccess;
private _btns = [
    [("STR_ADVSEC_hand_to_officer" call ADVSEC_fnc_L), {
        params ["_id"];
        if (isNil "_id") exitWith {};
        [("STR_ADVSEC_hand_over_evidence" call ADVSEC_fnc_L), [[("STR_ADVSEC_officer" call ADVSEC_fnc_L), "", "players"]], {
            params ["_v", "_id"];
            ["transfer", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }],
    [("STR_ADVSEC_attach_to_report" call ADVSEC_fnc_L), {
        params ["_id"];
        if (isNil "_id") exitWith {};
        [("STR_ADVSEC_attach_to_report_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_report_id_e_g_f" call ADVSEC_fnc_L), ""]], {
            params ["_v", "_id"];
            ["attach", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }]
];
if (!isNull _lab) then {
    _btns pushBack [("STR_ADVSEC_analyse" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["analyze", player, [_id, ADVSEC_evLab]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]; [] spawn {sleep 0.5; ["refresh"] call ADVSEC_fnc_panelAction}}}];
    if (_ai) then {_btns pushBack [("STR_ADVSEC_forensic_audit" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["auditStart", player, [_id, ADVSEC_evLab]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}}]};
};
if (_ai && {[player, "evidenceTamper"] call ADVSEC_fnc_perm}) then {
    _btns pushBack [("STR_ADVSEC_alter_evidence" call ADVSEC_fnc_L), {
        params ["_id"];
        if (isNil "_id") exitWith {};
        [("STR_ADVSEC_alter_evidence_corruption" call ADVSEC_fnc_L), [[("STR_ADVSEC_attribute_to" call ADVSEC_fnc_L), "", "players"]], {
            params ["_v", "_id"];
            ["tamper", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }];
};
["evidence", [("STR_ADVSEC_evidence_log" call ADVSEC_fnc_L), ("STR_ADVSEC_forensic_lab_2" call ADVSEC_fnc_L)] select (!isNull _lab), _btns select [0, 5], {["list", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}] call ADVSEC_fnc_panelOpen;
