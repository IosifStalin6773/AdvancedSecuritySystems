// [radar] — la PM cambia límite, alcance, multas y si está activo
params ["_cam"];
(_cam getVariable ["ADVSEC_speedCam", ["Radar", 90, 40, 100, 5, true]]) params ["_name", "_lim", "_range", "_base", "_per", "_on"];
["RADAR · " + toUpper _name, [
    ["Nombre", _name],
    ["Límite (km/h)", str _lim],
    ["Alcance (m)", str _range],
    ["Multa base", str _base],
    ["Multa por km/h de más", str _per],
    ["Activo", _on, "bool"]
], {
    params ["_v", "_cam"];
    ["set", player, [_cam, _v]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2];
}, _cam] call ADVSEC_fnc_zeusPrompt;
