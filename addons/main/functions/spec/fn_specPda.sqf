// [especialidad] — PDA genérica de una metopa (lista, solicitudes, altas y bajas; parametrizada por especialidad)
params ["_sp"];
ADVSEC_specCur = _sp;
private _send = {params ["_act", "_d"]; [_act, player, [ADVSEC_specCur, _d]] remoteExecCall ["ADVSEC_fnc_specServer", 2]};
ADVSEC_specSend = _send;
["spec_" + _sp, format ["PDA · %1", [_sp] call ADVSEC_fnc_specName], [
    [("STR_ADVSEC_accept" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "app"}) then {["accept", _d select 1] call ADVSEC_specSend}}],
    [("STR_ADVSEC_reject_remove" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d") then {[["remove", "reject"] select ((_d select 0) == "app"), _d select 1] call ADVSEC_specSend}}],
    [("STR_ADVSEC_add_player" call ADVSEC_fnc_L), {[("STR_ADVSEC_add_to_specialty_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_player" call ADVSEC_fnc_L), objNull, "players"]], {params ["_v"]; ["add", _v select 0] call ADVSEC_specSend}] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_manager_yes_no" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "mem"}) then {["lead", _d select 1] call ADVSEC_specSend}}],
    [("STR_ADVSEC_back" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_specOpen}}]
], {["view", player, [ADVSEC_specCur]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}] call ADVSEC_fnc_panelOpen;
