/*
    [objeto, nombre, límite km/h, alcance m, multa base, por km/h] — radar fijo de velocidad (todas las máquinas)
    Valores <= 0 = los de ADVSEC_Settings (speedLimit, speedFineBase, speedFinePerKmh).
*/
params ["_obj", ["_name", "Radar"], ["_lim", 0], ["_range", 40], ["_base", 0], ["_per", 0]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {
    // La configuración vive en el objeto (pública) y la cambia la PM
    _obj setVariable ["ADVSEC_speedCam", [_name, [_lim, ["speedLimit", 90] call ADVSEC_fnc_setting] select (_lim <= 0), (_range max 10) min 200, [_base, ["speedFineBase", 100] call ADVSEC_fnc_setting] select (_base <= 0), [_per, ["speedFinePerKmh", 5] call ADVSEC_fnc_setting] select (_per <= 0), true], true];
    [_obj, "speedcam", _name] call ADVSEC_fnc_register;
    ["start"] call ADVSEC_fnc_speedCamServer;
};
[_obj, "advsec_speedcam_cfg", "Radar: configurar", ADVSEC_icCar,
    {[_target] call ADVSEC_fnc_speedCamConfig},
    {[_player, "radar"] call ADVSEC_fnc_perm},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_speedcam_log", "Radar: últimas capturas", ADVSEC_icDoc,
    {ADVSEC_panelSpeedCam = _target; ["radarLog", "Radar · capturas", [], {["log", player, [ADVSEC_panelSpeedCam]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2]}] call ADVSEC_fnc_panelOpen},
    {[_player, "radar"] call ADVSEC_fnc_perm},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
