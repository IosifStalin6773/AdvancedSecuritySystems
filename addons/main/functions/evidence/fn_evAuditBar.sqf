// [id, laboratorio, segundos] — cliente: barra de progreso de la auditoría forense; al terminar pide el resultado al servidor
params ["_id", "_lab", "_secs"];
closeDialog 0;
player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
[format ["Auditoría forense · %1", _id], _secs,
    {params ["", "_lab"]; (player distance _lab) < 6 && {lifeState player in ["HEALTHY", "INJURED"]}},
    {
        params ["_id", "_lab"];
        ["audit", player, [_id, _lab]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2];
        [] spawn {sleep 0.6; ["refresh"] call ADVSEC_fnc_panelAction};
    },
    [_id, _lab],
    {hint "Auditoría interrumpida: no te alejes del laboratorio."}
] call ADVSEC_fnc_progress;
