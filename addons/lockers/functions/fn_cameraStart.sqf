disableSerialization;params ['_l','_display'];
[] call TSL_fnc_cameraStop;
private _returnCamera=cameraOn;private _returnView=cameraView;
private _cam='camera' camCreate (_l modelToWorld [-.1,-2.8,1.15]);
_cam switchCamera 'INTERNAL';cameraEffectEnableHUD true;showCinemaBorder false;
private _s=createHashMapFromArray [['camera',_cam],['returnCamera',_returnCamera],['returnView',_returnView],['position',getPosATL _cam],['locker',_l],['keys',[]],['yaw',getDir _l],['pitch',0],['fov',.75],['last',diag_tickTime],['drag',false],['mouse',getMousePosition]];
uiNamespace setVariable ['TSL_camera',_s];
_s set ['player',player];_s set ['playerHidden',isObjectHidden player];player hideObject true;

private _viewport=_display ctrlCreate ['TSL_CameraViewport',78800];_viewport ctrlSetPosition [safeZoneX,safeZoneY,safeZoneW*.69,safeZoneH];_viewport ctrlCommit 0;
_viewport ctrlAddEventHandler ['MouseButtonDown',{['down',_this] call TSL_fnc_cameraInput;true}];
_viewport ctrlAddEventHandler ['MouseButtonUp',{['up',_this] call TSL_fnc_cameraInput;true}];
_viewport ctrlAddEventHandler ['MouseZChanged',{['wheel',_this] call TSL_fnc_cameraInput;true}];
_viewport ctrlAddEventHandler ['KeyDown',{['keyDown',_this] call TSL_fnc_cameraInput}];_viewport ctrlAddEventHandler ['KeyUp',{['keyUp',_this] call TSL_fnc_cameraInput}];
private _theme=_display ctrlCreate ['TSL_Button',78700];_theme ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*.93,safeZoneW*.27,safeZoneH*.035];_theme ctrlSetText 'MENU COLORS / ЦВЕТА МЕНЮ';_theme ctrlCommit 0;_theme ctrlAddEventHandler ['ButtonClick',{['open'] call TSL_fnc_themeUI;}];

_display displayAddEventHandler ['KeyDown',{['keyDown',_this] call TSL_fnc_cameraInput}];
_display displayAddEventHandler ['KeyUp',{['keyUp',_this] call TSL_fnc_cameraInput}];
_display displayAddEventHandler ['MouseButtonDown',{['down',_this] call TSL_fnc_cameraInput}];
_display displayAddEventHandler ['MouseButtonUp',{['up',_this] call TSL_fnc_cameraInput}];
_display displayAddEventHandler ['MouseZChanged',{['wheel',_this] call TSL_fnc_cameraInput}];
_s set ['frame',addMissionEventHandler ['EachFrame',{[] call TSL_fnc_cameraStep}]];
_s set ['draw',addMissionEventHandler ['Draw3D',{
 private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _l=_s getOrDefault ['locker',objNull];
 if (isNull _l) exitWith {};
 private _owner=(_l getVariable ['TSL_owner',''])==getPlayerUID player;
 if (!_owner) exitWith {};
 if ((uiNamespace getVariable ['TSL_editor',createHashMap]) getOrDefault ['active',false]) exitWith {};
 [] call TSL_fnc_useDraw;
}]];
['init'] call TSL_fnc_useUI;ctrlSetFocus (_display displayCtrl 78900);
[] call TSL_fnc_cameraStep;
