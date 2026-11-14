disableSerialization;
private _d=findDisplay 78150;private _e=uiNamespace getVariable ['TSL_editor',createHashMap];
if (isNull _d || {!(_e getOrDefault ['active',false])}) exitWith {};
private _more=_e getOrDefault ['more',false];private _selected=!isNull (_e getOrDefault ['ghost',objNull]);private _scale=(_e get 'mode')=='SCALE';
if (isNull (_d displayCtrl 78224)) then {private _b=_d ctrlCreate ['TSL_Button',78224];_b ctrlAddEventHandler ['ButtonClick',"['more'] call TSL_fnc_editorUI"];};
{_x params ['_id','_label','_command'];if (isNull (_d displayCtrl _id)) then {private _b=_d ctrlCreate ['TSL_Button',_id];_b ctrlSetText _label;_b ctrlAddEventHandler ['ButtonClick',_command];};} forEach [[78225,'Interaction point',"['point'] call TSL_fnc_editorUI"],[78226,'Reset point',"['pointReset'] call TSL_fnc_editorUI"]];
private _layout=[
 [78208,.02,.025,.085,.04,'Add'],[78221,.109,.025,.105,.04,'Contents'],[78213,.218,.025,.085,.04,'Presets'],[78205,.307,.025,.075,.04,'Undo'],[78204,.386,.025,.075,.04,if (_e getOrDefault ['pending',false]) then {'Saving...'} else {if (diag_tickTime<(_e getOrDefault ['savedUntil',0])) then {'Saved'} else {'Save'}}],[78224,.465,.025,.075,.04,'More'],[78216,.544,.025,.075,.04,'Exit'],
 [78200,.25,.82,.50,.035,if (_selected) then {_e getOrDefault ['label','']} else {'Choose an item in Contents'}],
 [78201,.25,.86,.09,.04,'Move'],[78202,.344,.86,.09,.04,'Rotate'],[78217,.438,.86,.09,.04,'Scale'],[78203,.532,.86,.12,.04,'Axis: '+(_e get 'axis')],
 [78222,.02,.08,.18,.038,if (_e getOrDefault ['selectionLocked',true]) then {'Selection: locked'} else {'Selection: mouse'}],
 [78223,.02,.122,.18,.038,if ((uiNamespace getVariable ['TSL_camera',createHashMap]) getOrDefault ['cameraMode',false]) then {'Camera: on'} else {'Camera'}],
 [78212,.02,.164,.18,.038,'Duplicate'],[78206,.02,.206,.18,.038,'Reset item'],[78207,.02,.248,.18,.038,'Remove'],[78214,.02,.290,.18,.038,'Restore parts'],[78215,.02,.332,.18,.038,if (diag_tickTime<(_e getOrDefault ['resetConfirmUntil',0])) then {'Confirm reset'} else {'Reset layout'}],
 [78225,.02,.416,.18,.038,'Interaction point'],[78226,.02,.458,.18,.038,'Reset point'],
 [78218,.25,.91,.12,.038,''],[78219,.374,.91,.09,.038,'Set %'],[78220,.468,.91,.09,.038,'100%']
];
{_x params ['_id','_x0','_y','_w','_h','_label'];private _c=_d displayCtrl _id;_c ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*_y,safeZoneW*_w,safeZoneH*_h];_c ctrlCommit 0;if (_id!=78218) then {_c ctrlSetText _label;};_c ctrlSetFontHeight .026;} forEach _layout;
{(_d displayCtrl _x) ctrlShow _more;} forEach [78222,78223,78212,78206,78207,78214,78215];
{(_d displayCtrl _x) ctrlShow _selected;} forEach [78201,78202,78217,78203];
(_d displayCtrl 78200) ctrlShow true;
{(_d displayCtrl _x) ctrlShow (_selected && {_scale});} forEach [78218,78219,78220];
(_d displayCtrl 78155) ctrlSetPosition [safeZoneX+safeZoneW*.25,safeZoneY+safeZoneH*.96,safeZoneW*.65,safeZoneH*.025];(_d displayCtrl 78155) ctrlCommit 0;
(_d displayCtrl 78155) ctrlSetText 'RMB: look   WASD / Q E: move   Wheel: zoom   T / Y / G: tools';(_d displayCtrl 78155) ctrlSetFontHeight .022;
(_d displayCtrl 78800) ctrlSetPosition [safeZoneX,safeZoneY+safeZoneH*.075,safeZoneW,safeZoneH*.74];(_d displayCtrl 78800) ctrlCommit 0;

{(_d displayCtrl _x) ctrlEnable _selected;} forEach [78212,78206,78207];

private _c=_d displayCtrl 78700;_c ctrlSetPosition [safeZoneX+safeZoneW*.02,safeZoneY+safeZoneH*.374,safeZoneW*.18,safeZoneH*.038];_c ctrlCommit 0;_c ctrlSetText 'Appearance';_c ctrlShow _more;

{(_d displayCtrl _x) ctrlShow (_more && {_selected});} forEach [78225,78226];
