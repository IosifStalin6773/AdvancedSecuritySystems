disableSerialization;params [['_command','close'],['_source','']];
private _state=uiNamespace getVariable ['TSL_modelPreview',createHashMap];
if (_command=='shutdown') exitWith {['close'] call TSL_fnc_editorPreview;private _cached=uiNamespace getVariable ['TSL_previewCamera',objNull];if (!isNull _cached) then {_cached cameraEffect ['TERMINATE','BACK','TSL_LockerPreviewRT'];camDestroy _cached;};uiNamespace setVariable ['TSL_previewCamera',objNull];};
if (_command=='close') exitWith {
 // Keep one PiP camera alive for the whole editor session: camera destruction can reset the active view.
 {private _o=_state getOrDefault [_x,objNull];if (!isNull _o) then {deleteVehicle _o;};} forEach ['object','light'];
 private _d=findDisplay 78150;if (!isNull _d) then {{ctrlDelete (_d displayCtrl _x)} forEach [78600,78601,78602];};uiNamespace setVariable ['TSL_modelPreview',createHashMap];
 private _main=(uiNamespace getVariable ['TSL_camera',createHashMap]) getOrDefault ['camera',objNull];if (!isNull _main && {!isNull _d}) then {_main switchCamera 'INTERNAL';};
};
if (_command=='frame') exitWith {
 private _o=_state getOrDefault ['object',objNull];private _cam=_state getOrDefault ['camera',objNull];if (isNull _o || {isNull _cam}) exitWith {};
 private _angle=(diag_tickTime-(_state get 'started'))*18;private _centre=_state get 'centre';private _radius=_state get 'radius';
 // Orbit the preview camera, never transform the object being edited.
 _cam camSetPos (_centre vectorAdd [sin _angle*_radius,-cos _angle*_radius,_radius*.22]);_cam camSetTarget _centre;_cam camCommit 0;
};
private _key=_source;if (_key isEqualTo (_state getOrDefault ['key',''])) exitWith {};
['close'] call TSL_fnc_editorPreview;private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _o=objNull;private _label='';
if (_source isEqualType '') then {
 if (_source=='') exitWith {};
 _o=[_source] call TSL_fnc_editorSpawn;private _info=[_source] call TSL_fnc_editorModel;if (_info isNotEqualTo []) then {_label=_info select 1;};
} else {
 if (!isNull _source) then {
  _label=_source getVariable ['TSL_editLabel',(getModelInfo _source) select 0];
  if (_source isKindOf 'GroundWeaponHolder' || {_source isKindOf 'GroundWeaponHolder_Scripted'} || {(weaponsItemsCargo _source) isNotEqualTo []} || {(itemCargo _source) isNotEqualTo []}) then {
   _o=createVehicleLocal [typeOf _source,[0,0,-1000],[],0,'CAN_COLLIDE'];clearWeaponCargo _o;clearItemCargo _o;clearMagazineCargo _o;clearBackpackCargo _o;
   {_o addWeaponWithAttachmentsCargo [_x,1]} forEach weaponsItemsCargo _source;{_o addItemCargo [_x,1]} forEach itemCargo _source;{_o addMagazineAmmoCargo [_x select 0,1,_x select 1]} forEach magazinesAmmoCargo _source;
  } else {private _ref=_source getVariable ['TSL_assetRef',''];_o=if (_ref!='') then {[_ref] call TSL_fnc_editorSpawn} else {createSimpleObject [(getModelInfo _source) select 1,[0,0,-1000],true]};};
  if (!isNull _o) then {{_o setObjectTexture [_forEachIndex,_x]} forEach getObjectTextures _source;{_o setObjectMaterial [_forEachIndex,_x]} forEach getObjectMaterials _source;};
 };
};
if (isNull _o) exitWith {};
_o enableSimulation false;_o allowDamage false;_o setVectorDirAndUp [[0,1,0],[0,0,1]];_o setPosWorld [4000,4000,10000];
private _bb=[_o] call TSL_fnc_editorBounds;private _modelCentre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;
private _extent=(_bb select 1) vectorDiff (_bb select 0);private _span=(_extent select 0) max (_extent select 1) max (_extent select 2);
private _scale=(.7/(_span max .001)) min 100;_o setObjectScale _scale;
private _centre=AGLToASL (_o modelToWorld _modelCentre);private _actualScale=(getObjectScale _o) max .001;private _radius=(vectorMagnitude _extent)*_actualScale*1.7 max .9;
private _cam=uiNamespace getVariable ['TSL_previewCamera',objNull];if (isNull _cam) then {_cam='camera' camCreate (ASLToAGL (_centre vectorAdd [0,-_radius,_radius*.22]));uiNamespace setVariable ['TSL_previewCamera',_cam];_cam cameraEffect ['INTERNAL','BACK','TSL_LockerPreviewRT'];};_cam camSetFov .45;_cam camSetTarget (ASLToAGL _centre);_cam camCommit 0;
private _mainState=uiNamespace getVariable ['TSL_camera',createHashMap];_mainState set ['restoreView',true];private _main=_mainState getOrDefault ['camera',objNull];if (!isNull _main) then {_main switchCamera 'INTERNAL';};
private _light='#lightpoint' createVehicleLocal (ASLToAGL (_centre vectorAdd [-.7,-.7,.7]));_light setLightBrightness 1.2;_light setLightColor [.3,.85,1];_light setLightAmbient [.3,.5,.6];_light setLightDayLight true;
private _bg=_d ctrlCreate ['TSL_Text',78600];_bg ctrlSetPosition [safeZoneX+safeZoneW*.70,safeZoneY+safeZoneH*.57,safeZoneW*.265,safeZoneH*.23];_bg ctrlSetBackgroundColor [.025,.028,.03,.25];_bg ctrlCommit 0;
private _picture=_d ctrlCreate ['RscPicture',78601];private _pw=safeZoneH*.18*(pixelW/pixelH);_picture ctrlSetPosition [safeZoneX+safeZoneW*.8325-_pw*.5,safeZoneY+safeZoneH*.575,_pw,safeZoneH*.18];_picture ctrlSetText '#(argb,512,512,1)r2t(TSL_LockerPreviewRT,1)';_picture ctrlSetFade .28;_picture ctrlCommit 0;_picture ctrlEnable false;
private _labelCtrl=_d ctrlCreate ['TSL_Wrapped',78602];_labelCtrl ctrlSetPosition [safeZoneX+safeZoneW*.705,safeZoneY+safeZoneH*.76,safeZoneW*.255,safeZoneH*.04];_labelCtrl ctrlSetText _label;_labelCtrl ctrlSetFontHeight .025;_labelCtrl ctrlCommit 0;
uiNamespace setVariable ['TSL_modelPreview',createHashMapFromArray [['key',_key],['object',_o],['camera',_cam],['light',_light],['centre',ASLToAGL _centre],['radius',_radius],['started',diag_tickTime]]];
