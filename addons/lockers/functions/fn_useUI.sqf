disableSerialization;params [['_command','init'],['_row',[]]];
private _d=findDisplay 78150;private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _l=_s getOrDefault ['locker',objNull];if (isNull _d || {isNull _l}) exitWith {};
if (_command=='pick') exitWith {_s set ['useAt',0];[] call TSL_fnc_useFrame;private _h=_s getOrDefault ['useHover',[]];if (_h isNotEqualTo []) then {['select',_h] call TSL_fnc_useUI;} else {['dismiss'] call TSL_fnc_useUI;(_d displayCtrl 78155) ctrlSetText 'No item here. Point at equipment or its marker.';};};
if (_command=='quick') exitWith {
 _s set ['useAt',0];[] call TSL_fnc_useFrame;private _h=_s getOrDefault ['useHover',[]];
 if (_h isNotEqualTo []) then {['select',_h] call TSL_fnc_useUI;} else {if ((_s getOrDefault ['useSelected',[]]) isNotEqualTo []) then {['refresh'] call TSL_fnc_useUI;};};
 if ((_s getOrDefault ['useSelected',[]]) isEqualTo []) exitWith {hint 'Select an item first.';};
 if (_l getVariable ['TSL_busy',false]) exitWith {hint 'Transfer in progress.';};
 private _entries=uiNamespace getVariable ['TSL_UI_entries',[]];private _i=_entries findIf {((_x select 0) select 0) in ['take','put','TSL_take','TSL_stack_take','TSL_stack_return','TSL_editorReturn']};
 if (_i>=0) then {(_d displayCtrl 78151) lbSetCurSel _i;[] call TSL_fnc_uiExecute;} else {hint 'No equipment action for this item.';};
};
if (_command=='init') then {
 _s set ['useMode',true];_s set ['options',(_l getVariable ['TSL_owner',''])!=getPlayerUID player];_s set ['useSelected',[]];
 { _x params ['_id','_x0','_label','_code'];private _b=_d ctrlCreate ['TSL_Button',_id];_b ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*.025,safeZoneW*.10,safeZoneH*.04];_b ctrlCommit 0;_b ctrlSetText _label;_b ctrlSetFontHeight .026;_b ctrlAddEventHandler ['ButtonClick',_code];} forEach [[78900,.02,'Edit',"['toggle'] call TSL_fnc_editorUI"],[78901,.125,'Options',"['options'] call TSL_fnc_useUI"],[78902,.23,'Exit','closeDialog 0']];
 private _b=_d ctrlCreate ['TSL_Button',78903];_b ctrlSetPosition [safeZoneX+safeZoneW*.76,safeZoneY+safeZoneH*.73,safeZoneW*.22,safeZoneH*.04];_b ctrlSetText 'Use [F]';_b ctrlCommit 0;_b ctrlAddEventHandler ['ButtonClick',"['quick'] call TSL_fnc_useUI"];
};
if (_command=='options') then {_s set ['options',!(_s getOrDefault ['options',false])];_s set ['useSelected',[]];uiNamespace setVariable ['TSL_UI_history',[]];[[_l,player,['root']] call TSL_fnc_menu] call TSL_fnc_uiFill;};
if (_command=='dismiss') then {_s set ['useSelected',[]];};
if (_command=='select') then {_s set ['useSelected',_row];uiNamespace setVariable ['TSL_UI_history',[]];};
if (_command in ['select','refresh']) then {
 private _selected=_s getOrDefault ['useSelected',[]];
 if (_selected isNotEqualTo []) then {
  private _rows=[_l] call TSL_fnc_useTargets;private _i=_rows findIf {(_x select 0)==(_selected select 0)};
  if (_i>=0) then {_selected=_rows select _i;_s set ['useSelected',_selected];
   private _entries=switch (_selected select 1) do {case 'slot':{[_l,player,['slot',_selected select 2]] call TSL_fnc_menu};case 'stack':{[_l,player,[_selected select 2]] call TSL_fnc_stackMenu};default {[_l,player,[_selected select 2]] call TSL_fnc_gearMenu};};
   [_entries] call TSL_fnc_uiFill;(_d displayCtrl 78154) ctrlSetText (_selected select 3);
  } else {_s set ['useSelected',[]];};
 };
};
if ((uiNamespace getVariable ['TSL_editor',createHashMap]) getOrDefault ['active',false]) exitWith {{(_d displayCtrl _x) ctrlShow false;} forEach [78900,78901,78902,78903];};
private _options=_s getOrDefault ['options',false];private _card=(_s getOrDefault ['useSelected',[]]) isNotEqualTo [];(_d displayCtrl 78903) ctrlShow (_card && {!_options});
{(_d displayCtrl _x) ctrlShow _options;} forEach [78153,78156,78157,78700];
{(_d displayCtrl _x) ctrlShow (_options || {_card});} forEach [78151,78154,78158,78159];
(_d displayCtrl 78152) ctrlShow (_options || {_card});(_d displayCtrl 78160) ctrlShow false;
{(_d displayCtrl _x) ctrlShow true;} forEach [78900,78901,78902,78155];
if (!_options) then {
 (_d displayCtrl 78152) ctrlSetPosition [safeZoneX+safeZoneW*.75,safeZoneY+safeZoneH*.35,safeZoneW*.24,safeZoneH*.37];(_d displayCtrl 78152) ctrlCommit 0;
 { _x params ['_id','_x0','_y','_w','_h'];private _c=_d displayCtrl _id;_c ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*_y,safeZoneW*_w,safeZoneH*_h];_c ctrlCommit 0;} forEach [[78154,.76,.37,.22,.045],[78151,.76,.42,.22,.24],[78158,.76,.67,.105,.035],[78159,.875,.67,.105,.035]];
 (_d displayCtrl 78158) ctrlSetText 'Select';(_d displayCtrl 78159) ctrlSetText 'Back';
} else {
 (_d displayCtrl 78152) ctrlSetPosition [safeZoneX+safeZoneW*.70,safeZoneY+safeZoneH*.08,safeZoneW*.29,safeZoneH*.84];(_d displayCtrl 78152) ctrlCommit 0;
 { _x params ['_id','_y','_h'];private _c=_d displayCtrl _id;_c ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*_y,safeZoneW*.27,safeZoneH*_h];_c ctrlCommit 0;} forEach [[78154,.195,.045],[78151,.25,.43]];
 { _x params ['_id','_x0'];private _c=_d displayCtrl _id;_c ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*.70,safeZoneW*.085,safeZoneH*.04];_c ctrlCommit 0;} forEach [[78158,.71],[78159,.802]];
};
(_d displayCtrl 78155) ctrlSetPosition [safeZoneX+safeZoneW*.02,safeZoneY+safeZoneH*.95,safeZoneW*.65,safeZoneH*.03];(_d displayCtrl 78155) ctrlCommit 0;(_d displayCtrl 78155) ctrlSetFontHeight .023;(_d displayCtrl 78155) ctrlSetText 'Click: select   F: use   RMB: look   WASD / Q E: move   Wheel: zoom';
(_d displayCtrl 78800) ctrlSetPosition [safeZoneX,safeZoneY+safeZoneH*.075,safeZoneW*(if (_options) then {.69} else {.75}),safeZoneH*.85];(_d displayCtrl 78800) ctrlCommit 0;
