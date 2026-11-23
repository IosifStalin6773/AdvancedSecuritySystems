// (cliente, 1.24) radio: red y código 10 o mensaje libre; responder a la comprobación de radio
if !([player, "PM"] call ADVSEC_fnc_repAccess || {[player, "PMC"] call ADVSEC_fnc_repAccess}) exitWith {hint ("STR_ADVSEC_only_the_military_police_can_2" call ADVSEC_fnc_L)};
if (getPlayerUID player in (missionNamespace getVariable ["ADVSEC_radioPend", []])) exitWith {["check", player] remoteExecCall ["ADVSEC_fnc_radioServer", 2]};
private _codes = ["radioCodes", []] call ADVSEC_fnc_setting;
private _nets = [["PM", "PM"], ["PMC", "PMC"]];
if ([player, "supervisor"] call ADVSEC_fnc_perm) then {_nets pushBack [("STR_ADVSEC_radio_cmd" call ADVSEC_fnc_L), "CMD"]};
[("STR_ADVSEC_radio" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_radio_f_net" call ADVSEC_fnc_L), "PM", _nets],
    [("STR_ADVSEC_radio_f_code" call ADVSEC_fnc_L), _codes param [0, ""], _codes apply {[format ["%1 · %2", _x, format [format ["STR_ADVSEC_rc_%1", (_x splitString "-") joinString ""] call ADVSEC_fnc_L, "…"]], _x]}],
    [("STR_ADVSEC_radio_f_text" call ADVSEC_fnc_L), ""]
], {
    params ["_v"];
    ["send", player, [_v select 0, [_v select 1, _v select 2] select ((_v select 2) isNotEqualTo "")]] remoteExecCall ["ADVSEC_fnc_radioServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
