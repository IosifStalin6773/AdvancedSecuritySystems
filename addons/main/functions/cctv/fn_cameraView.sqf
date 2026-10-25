params ["_monitor"];
private _cams = _monitor getVariable ["ADVSEC_cams", []];
if (_cams isEqualType "") then {
    private _net = _cams;
    _cams = ADVSEC_camRegistry select {(_x getVariable ["ADVSEC_camNet", ""]) isEqualTo _net};
};
_cams = _cams select {!isNull _x};
if (_cams isEqualTo [] || {!isNil "ADVSEC_camObj"}) exitWith {};

ADVSEC_camList = _cams;
ADVSEC_camIdx = 0;
ADVSEC_camNV = 0;
ADVSEC_camObj = "camera" camCreate (getPosATL player);
ADVSEC_camObj cameraEffect ["internal", "back"];
showCinemaBorder false;
("ADVSEC_CamLayer" call BIS_fnc_rscLayer) cutRsc ["ADVSEC_RscCameraHUD", "PLAIN", 0];
[0] call ADVSEC_fnc_cameraSwitch;

ADVSEC_camKeyEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["", "_key"];
    switch (_key) do {
        case 203: {[-1] call ADVSEC_fnc_cameraSwitch; true};
        case 205: {[1] call ADVSEC_fnc_cameraSwitch; true};
        case 49: {ADVSEC_camNV = (ADVSEC_camNV + 1) % 3; [0] call ADVSEC_fnc_cameraSwitch; true};
        case 1;
        case 14: {[] call ADVSEC_fnc_cameraExit; true};
        default {false};
    };
}];

[] spawn {
    while {!isNil "ADVSEC_camObj"} do {
        if (!alive player) exitWith {[] call ADVSEC_fnc_cameraExit};
        [0] call ADVSEC_fnc_cameraSwitch;
        sleep 0.5;
    };
};
