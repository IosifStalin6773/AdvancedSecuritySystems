// [monitor, [cámaras] o "red", requisito ([] = libre)]
params ["_monitor", "_cams", ["_req", []]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _monitor) exitWith {};
if (isServer) then {[_monitor, "monitor", ("STR_ADVSEC_cctv_monitor_2" call ADVSEC_fnc_L), _cams] call ADVSEC_fnc_register};
_monitor setVariable ["ADVSEC_cams", _cams];

[_monitor, "advsec_cctv", ("STR_ADVSEC_view_cctv_cameras" call ADVSEC_fnc_L), ADVSEC_icCam,
    {[_target] call ADVSEC_fnc_cameraView},
    {_args isEqualTo [] || {[_player, _args] call ADVSEC_fnc_accessCheck}},
    "main", _req, 3
] call ADVSEC_fnc_addInteraction;
[_monitor] call ADVSEC_fnc_cyHackAction;
