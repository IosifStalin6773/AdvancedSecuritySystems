// [radar] — la PM cambia límite, alcance, multas y si está activo
params ["_cam"];
(_cam getVariable ["ADVSEC_speedCam", ["Radar", 90, 40, 100, 5, true]]) params ["_name", "_lim", "_range", "_base", "_per", "_on"];
[("STR_ADVSEC_speed_camera" call ADVSEC_fnc_L) + toUpper _name, [
    [("STR_ADVSEC_name" call ADVSEC_fnc_L), _name],
    [("STR_ADVSEC_limit_km_h" call ADVSEC_fnc_L), str _lim],
    [("STR_ADVSEC_range_m" call ADVSEC_fnc_L), str _range],
    [("STR_ADVSEC_base_fine" call ADVSEC_fnc_L), str _base],
    [("STR_ADVSEC_fine_per_km_h_over" call ADVSEC_fnc_L), str _per],
    [("STR_ADVSEC_active" call ADVSEC_fnc_L), _on, "bool"]
], {
    params ["_v", "_cam"];
    ["set", player, [_cam, _v]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2];
}, _cam] call ADVSEC_fnc_zeusPrompt;
