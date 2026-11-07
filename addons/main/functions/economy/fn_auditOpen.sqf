// AA.II.: movimientos sospechosos, auditoría y congelación de cuentas
["flags", ("STR_ADVSEC_ia_bank_audit" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_audit_account" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d") then {["audit", player, [[_d, _d select 0] select (_d isEqualType [])]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    [("STR_ADVSEC_freeze_unfreeze" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d") then {["freeze", player, [[_d, _d select 0] select (_d isEqualType [])]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    [("STR_ADVSEC_audit_the_recipient" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d" && {_d isEqualType []}) then {["audit", player, [_d select 1]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    [("STR_ADVSEC_back_to_the_list" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["flags", player] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}] call ADVSEC_fnc_panelOpen;
