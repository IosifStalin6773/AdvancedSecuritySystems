// (cliente, 1.24) el Zeus o un mando lanza un aviso: tipo y lugar (donde estoy, donde apunto o al azar)
private _types = ["awol", "speeding", "blackmarket", "apo", "boq", "sapper", "convoy", "ambush", "transfer", "accident", "raid", "barricade",
    "pow", "refugees", "asp", "port", "perimeter", "hospguard", "amnesty", "trophy", "follow", "wake", "mortar", "press", "down", "tire", "server"];
[("STR_ADVSEC_call_launch" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_call_f_type" call ADVSEC_fnc_L), "awol", _types apply {[format ["STR_ADVSEC_call_t_%1", _x] call ADVSEC_fnc_L, _x]}],
    [("STR_ADVSEC_call_f_where" call ADVSEC_fnc_L), "rand", [[("STR_ADVSEC_call_w_rand" call ADVSEC_fnc_L), "rand"], [("STR_ADVSEC_call_w_me" call ADVSEC_fnc_L), "me"], [("STR_ADVSEC_call_w_aim" call ADVSEC_fnc_L), "aim"]]]
], {
    params ["_v"];
    private _pos = switch (_v select 1) do {
        case "me": {getPosATL player};
        case "aim": {screenToWorld [0.5, 0.5]};
        default {[]};
    };
    ["launch", player, [_v select 0, _pos]] remoteExecCall ["ADVSEC_fnc_callServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
