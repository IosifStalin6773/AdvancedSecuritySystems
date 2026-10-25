// [laboratorio (objNull fuera del laboratorio)] — registro de pruebas con custodia, análisis, auditoría y manipulación
params [["_lab", objNull]];
ADVSEC_evLab = _lab;
private _ai = [player, "AI"] call ADVSEC_fnc_repAccess;
private _btns = [
    ["Entregar a agente", {
        params ["_id"];
        if (isNil "_id") exitWith {};
        ["ENTREGAR PRUEBA", [["Agente", "", "players"]], {
            params ["_v", "_id"];
            ["transfer", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }],
    ["Adjuntar a informe", {
        params ["_id"];
        if (isNil "_id") exitWith {};
        ["ADJUNTAR A INFORME", [["ID del informe (p. ej. F-PM-03/2026/0001)", ""]], {
            params ["_v", "_id"];
            ["attach", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }]
];
if (!isNull _lab) then {
    _btns pushBack ["Analizar", {params ["_id"]; if (!isNil "_id") then {["analyze", player, [_id, ADVSEC_evLab]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]; [] spawn {sleep 0.5; ["refresh"] call ADVSEC_fnc_panelAction}}}];
    if (_ai) then {_btns pushBack ["Auditoría forense", {params ["_id"]; if (!isNil "_id") then {["auditStart", player, [_id, ADVSEC_evLab]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}}]};
};
if (_ai && {[player, "evidenceTamper"] call ADVSEC_fnc_perm}) then {
    _btns pushBack ["Alterar prueba", {
        params ["_id"];
        if (isNil "_id") exitWith {};
        ["ALTERAR PRUEBA (CORRUPCIÓN)", [["Atribuir a", "", "players"]], {
            params ["_v", "_id"];
            ["tamper", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    }];
};
["evidence", ["Registro de pruebas", "Laboratorio forense"] select (!isNull _lab), _btns select [0, 5], {["list", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}] call ADVSEC_fnc_panelOpen;
