// [acción, valor] — cámara orbital sobre el jugador mientras la tienda está abierta, como en el arsenal
params ["_a", ["_v", 0]];
// Zona central libre entre los paneles: solo ahí se arrastra y se hace zoom
private _inArea = {
    getMousePosition params ["_mx", "_my"];
    _mx > (safeZoneX + 0.55) && {_mx < (safeZoneX + safeZoneW - 0.45)} && {_my < (safeZoneY + safeZoneH - 0.11)}
};
switch (_a) do {
    case "on": {
        if ((["shopCamera", 1] call ADVSEC_fnc_setting) isNotEqualTo 1 || {!isNull (missionNamespace getVariable ["ADVSEC_shopCamObj", objNull])} || {!isNull objectParent player}) exitWith {};
        private _cam = "camera" camCreate (player modelToWorldVisual [0, 3, 1.6]);
        _cam cameraEffect ["internal", "back"];
        showCinemaBorder false;
        ADVSEC_shopCamObj = _cam;
        ADVSEC_shopCamOrbit = [getDir player + 20, 10, 3.2];
        ADVSEC_shopCamDrag = false;
        ADVSEC_shopCamMouse = getMousePosition;
        ["frame"] call ADVSEC_fnc_shopCam;
        ADVSEC_shopCamEH = addMissionEventHandler ["EachFrame", {["frame"] call ADVSEC_fnc_shopCam}];
    };
    case "off": {
        if (!isNil "ADVSEC_shopCamEH") then {removeMissionEventHandler ["EachFrame", ADVSEC_shopCamEH]; ADVSEC_shopCamEH = nil};
        private _cam = missionNamespace getVariable ["ADVSEC_shopCamObj", objNull];
        if (!isNull _cam) then {_cam cameraEffect ["terminate", "back"]; camDestroy _cam};
        ADVSEC_shopCamObj = objNull;
    };
    case "down": {if (call _inArea) then {ADVSEC_shopCamDrag = true; ADVSEC_shopCamMouse = getMousePosition}};
    case "up": {ADVSEC_shopCamDrag = false};
    case "wheel": {
        if (isNull (missionNamespace getVariable ["ADVSEC_shopCamObj", objNull]) || {!(call _inArea)}) exitWith {};
        ADVSEC_shopCamOrbit set [2, (((ADVSEC_shopCamOrbit select 2) - _v * 0.25) max 1.2) min 8];
    };
    case "frame": {
        private _cam = missionNamespace getVariable ["ADVSEC_shopCamObj", objNull];
        if (isNull _cam) exitWith {};
        if (isNull findDisplay 87900 || {!alive player}) exitWith {["off"] call ADVSEC_fnc_shopCam};
        ADVSEC_shopCamOrbit params ["_dir", "_pitch", "_dist"];
        if (ADVSEC_shopCamDrag) then {
            getMousePosition params ["_mx", "_my"];
            ADVSEC_shopCamMouse params ["_ox", "_oy"];
            _dir = _dir - (_mx - _ox) * 250;
            _pitch = ((_pitch + (_my - _oy) * 120) max -15) min 70;
            ADVSEC_shopCamMouse = [_mx, _my];
            ADVSEC_shopCamOrbit = [_dir, _pitch, _dist];
        };
        private _tgt = (getPosASLVisual player) vectorAdd [0, 0, 1.0];
        private _pos = _tgt vectorAdd [sin _dir * cos _pitch * _dist, cos _dir * cos _pitch * _dist, sin _pitch * _dist];
        private _vd = vectorNormalized (_tgt vectorDiff _pos);
        private _up = vectorNormalized ((_vd vectorCrossProduct [0, 0, 1]) vectorCrossProduct _vd);
        _cam setPosASL _pos;
        _cam setVectorDirAndUp [_vd, _up];
    };
};
