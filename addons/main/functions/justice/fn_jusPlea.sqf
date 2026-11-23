// [idJuicio] (cliente, acusado): declararse culpable o no culpable
params ["_id"];
[format ["%1 · %2", ("STR_ADVSEC_jus_plea_title" call ADVSEC_fnc_L), _id], [[("STR_ADVSEC_jus_plea_q" call ADVSEC_fnc_L), false, [[("STR_ADVSEC_jus_notguilty" call ADVSEC_fnc_L), false], [("STR_ADVSEC_jus_guilty" call ADVSEC_fnc_L), true]]]], {
    params ["_v", "_id"];
    ["trialPlea", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_jusServer", 2];
}, _id] call ADVSEC_fnc_zeusPrompt;
