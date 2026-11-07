disableSerialization;params [['_command','toggle']];private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _l=_s getOrDefault ['locker',objNull];if (isNull _l) exitWith {};
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];
private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';
if (_command=='toggle') exitWith {
 if (_e getOrDefault ['active',false]) then {['close'] call TSL_fnc_editorUI;} else {
  if ((_l getVariable ['TSL_owner',''])!=getPlayerUID player) exitWith {hint 'Claim your locker first';};
  _e=createHashMapFromArray [['active',true],['poses',parseSimpleArray str (_l getVariable ['TSL_editorPoses',[]])],['added',parseSimpleArray str (_l getVariable ['TSL_editorAdded',[]])],['revision',_l getVariable ['TSL_editorRevision',0]],['selected',''],['selectionLocked',true],['more',false],['mode','MOVE'],['axis','SCREEN'],['undo',[]]];uiNamespace setVariable ['TSL_editor',_e];
  {(_d displayCtrl _x) ctrlShow false;} forEach [78151,78152,78153,78154,78156,78157,78158,78159,78160,78700,78900,78901,78902,78903];
  private _spec=[
   ['TSL_Button',78221,.15,.04,if (_ru) then {'ПРЕДМЕТЫ В ЛОКЕРЕ'} else {'LOCKER CONTENTS'},"['open'] call TSL_fnc_editorObjects"],
   ['TSL_Button',78222,.79,.033,if (_ru) then {'ВЫБОР: ТОЛЬКО ИЗ СПИСКА'} else {'SELECTION: CONTENTS LIST'},"['selectionMode'] call TSL_fnc_editorUI"],
   ['TSL_Button',78223,.83,.033,if (_ru) then {'КАМЕРА / ПРЕДМЕТ'} else {'CAMERA / OBJECT'},"['cameraMode'] call TSL_fnc_editorUI"],
   ['TSL_Text',78200,.20,.07,if (_ru) then {'Выбери предмет в списке. Остальные не мешают.'} else {'Choose from Locker Contents. Other items stay locked.'},''],
   ['TSL_Button',78201,0.247,.033,if (_ru) then {'ПЕРЕМЕЩЕНИЕ [T]'} else {'MOVE [T]'},"['move'] call TSL_fnc_editorUI"],
   ['TSL_Button',78202,0.285,.033,if (_ru) then {'ВРАЩЕНИЕ [Y]'} else {'ROTATE [Y]'},"['rotate'] call TSL_fnc_editorUI"],
   ['TSL_Button',78217,0.323,.033,if (_ru) then {'МАСШТАБ [G]'} else {'SCALE [G]'},"['scale'] call TSL_fnc_editorUI"],
   ['TSL_Button',78203,0.361,.033,'AXIS: SCREEN',"['axis'] call TSL_fnc_editorUI"],
   ['TSL_Button',78204,0.399,.033,if (_ru) then {'ПРИМЕНИТЬ'} else {'APPLY'},"['apply'] call TSL_fnc_editorUI"],
   ['TSL_Button',78205,0.437,.033,if (_ru) then {'ОТМЕНИТЬ ШАГ'} else {'UNDO'},"['undo'] call TSL_fnc_editorUI"],
   ['TSL_Button',78206,0.475,.033,if (_ru) then {'СБРОС ПРЕДМЕТА'} else {'RESET ITEM'},"['reset'] call TSL_fnc_editorUI"],
   ['TSL_Button',78207,0.513,.033,if (_ru) then {'УБРАТЬ ПРЕДМЕТ / ДЕТАЛЬ'} else {'REMOVE ITEM / PART'},"['delete'] call TSL_fnc_editorUI"],
   ['TSL_Button',78208,0.551,.033,if (_ru) then {'ДОБАВИТЬ ОБЪЕКТ'} else {'ADD OBJECT'},"['catalog'] call TSL_fnc_editorUI"],
   ['TSL_Button',78212,0.589,.033,if (_ru) then {'ДУБЛИРОВАТЬ ДЕКОР'} else {'DUPLICATE DECOR'},"[] call TSL_fnc_editorDuplicate"],
   ['TSL_Button',78213,0.627,.033,if (_ru) then {'МОИ ПРЕСЕТЫ'} else {'MY PRESETS'},"['open'] call TSL_fnc_presetUI"],
   ['TSL_Button',78214,0.665,.033,if (_ru) then {'ВЕРНУТЬ УБРАННЫЕ ДЕТАЛИ'} else {'RESTORE HIDDEN PARTS'},"['restoreParts'] call TSL_fnc_editorUI"],
   ['TSL_Button',78215,0.703,.033,if (_ru) then {'СБРОСИТЬ РАССТАНОВКУ'} else {'RESET LAYOUT'},"['resetLayout'] call TSL_fnc_editorUI"],
   ['TSL_Button',78216,0.741,.033,if (_ru) then {'ВЫЙТИ ИЗ РЕДАКТОРА'} else {'EXIT EDITOR'},"['close'] call TSL_fnc_editorUI"]
  ];
  {_x params ['_class','_id','_y','_h','_text','_action'];private _c=_d ctrlCreate [_class,_id];_c ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*_y,safeZoneW*.27,safeZoneH*_h];_c ctrlCommit 0;_c ctrlSetText _text;if (_action!='') then {_c ctrlAddEventHandler ['ButtonClick',_action];};if (_id==78200) then {_c ctrlSetFontHeight .026;};} forEach _spec;
  private _edit=_d ctrlCreate ['TSL_PresetEdit',78218];_edit ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*.20,safeZoneW*.12,safeZoneH*.038];_edit ctrlCommit 0;_edit ctrlSetText '100';_edit ctrlShow false;
  _edit ctrlAddEventHandler ['SetFocus',{(uiNamespace getVariable ['TSL_editor',createHashMap]) set ['scaleTyping',true]}];_edit ctrlAddEventHandler ['KillFocus',{(uiNamespace getVariable ['TSL_editor',createHashMap]) set ['scaleTyping',false]}];
  _edit ctrlAddEventHandler ['KeyDown',{if ((_this select 1)==28) then {['scaleNumber'] call TSL_fnc_editorUI;true} else {false}}];
  { _x params ['_id','_x0','_label','_command'];private _b=_d ctrlCreate ['TSL_Button',_id];_b ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*.20,safeZoneW*.07,safeZoneH*.038];_b ctrlCommit 0;_b ctrlSetText _label;_b ctrlShow false;_b ctrlAddEventHandler ['ButtonClick',_command];} forEach [[78219,.835,'SET %',"['scaleNumber'] call TSL_fnc_editorUI"],[78220,.91,'100%',"['scaleReset'] call TSL_fnc_editorUI"]];
  _e set ['scaleTyping',false];ctrlSetFocus (_d displayCtrl 78900);
  (_d displayCtrl 78155) ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*.87,safeZoneW*.27,safeZoneH*.05];(_d displayCtrl 78155) ctrlCommit 0;
  (_d displayCtrl 78155) ctrlSetText (if (_ru) then {'Список: выбрать предмет | ЛКМ: тянуть выбранный | T: двигать | Y: вращать\nКнопка оси: Экран/X/Y/Z | Shift: точно | Esc: отменить жест\nПКМ и WASD: камера | Выход: неприменённое отменяется'} else {'Contents: choose item | LMB: drag selected | T: move | Y: rotate\nAxis button: Screen/X/Y/Z | Shift: fine\nRMB + WASD: camera | Exit discards preview'});
  [] call TSL_fnc_editorChrome;
 };
};
if !(_e getOrDefault ['active',false]) exitWith {};
if (_command=='close') exitWith {
 ['clear'] call TSL_fnc_editorDraw;
 ['close'] call TSL_fnc_editorObjects;['close'] call TSL_fnc_presetUI;['close'] call TSL_fnc_editorCatalogUI;['cancel'] call TSL_fnc_editorInput;{ctrlDelete (_d displayCtrl _x)} forEach [78200,78201,78202,78203,78204,78205,78206,78207,78208,78212,78213,78214,78215,78216,78217,78218,78219,78220,78221,78222,78223,78224,78225,78226,78210,78211];
 _s set ['cameraMode',false];_s set ['drag',false];_s set ['keys',[]];uiNamespace setVariable ['TSL_editor',createHashMap];(_d displayCtrl 78700) ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*.93,safeZoneW*.27,safeZoneH*.035];(_d displayCtrl 78700) ctrlCommit 0;{(_d displayCtrl _x) ctrlShow true} forEach [78151,78152,78153,78154,78156,78157,78158,78159,78160,78700,78900,78901,78902,78903];(_d displayCtrl 78155) ctrlSetPosition [safeZoneX+safeZoneW*.71,safeZoneY+safeZoneH*.81,safeZoneW*.27,safeZoneH*.10];(_d displayCtrl 78155) ctrlSetFontHeight .025;(_d displayCtrl 78155) ctrlCommit 0;(_d displayCtrl 78800) ctrlSetPosition [safeZoneX,safeZoneY,safeZoneW*.69,safeZoneH];(_d displayCtrl 78800) ctrlCommit 0;[[_l,player,['root']] call TSL_fnc_menu] call TSL_fnc_uiFill;['refresh'] call TSL_fnc_useUI;
};
if (_e getOrDefault ['pending',false]) exitWith {};
if (_command in ['move','rotate','scale','axis','point']) then {['finish'] call TSL_fnc_editorInput;};
switch _command do {
 case 'point': {_e set ['mode','POINT'];_e set ['axis','SCREEN'];};
 case 'pointReset': {private _o=_e getOrDefault ['ghost',objNull];if (!isNull _o) then {['finish'] call TSL_fnc_editorInput;['checkpoint'] call TSL_fnc_editorInput;_o setVariable ['TSL_interactionOffset',[]];private _key=_e get 'selected';private _poses=_e get 'poses';private _i=_poses findIf {(_x select 0)==_key};private _v=[_key,[_l,_o] call TSL_fnc_editorPose];if (_i<0) then {_poses pushBack _v;} else {_poses set [_i,_v];};};};
 case 'more': {_e set ['more',!(_e getOrDefault ['more',false])];};
 case 'cameraMode': {['finish'] call TSL_fnc_editorInput;_s set ['cameraMode',!(_s getOrDefault ['cameraMode',false])];_s set ['keys',[]];_s set ['drag',false];ctrlSetFocus (_d displayCtrl 78900);};
 case 'selectionMode': {['finish'] call TSL_fnc_editorInput;_e set ['selectionLocked',!(_e getOrDefault ['selectionLocked',true])];};
 case 'move': {_e set ['mode','MOVE'];};case 'rotate': {_e set ['mode','ROTATE'];if ((_e get 'axis')=='SCREEN') then {_e set ['axis','Z'];};};
 case 'axis': {private _axes=['SCREEN','X','Y','Z'];_e set ['axis',_axes select (((_axes find (_e get 'axis'))+1) mod 4)];};
 case 'catalog': {['open'] call TSL_fnc_editorCatalogUI;};
 case 'add': {
  private _list=_d displayCtrl 78210;private _i=lbCurSel _list;if (_i<0 || {count (_e get 'added')>=40}) exitWith {};
  private _model=_list lbData _i;private _info=[_model] call TSL_fnc_gearInfo;private _quantity=if (_info isNotEqualTo [] && {(_info select 2)=='magazine'}) then {_e getOrDefault ['catalogQuantity',1]} else {1};if !(_quantity in [1,2,3,5,10]) then {_quantity=1;};if (count (_e get 'added')+_quantity>40) exitWith {hint 'Not enough free positions (40 max).';};private _o=[_model] call TSL_fnc_editorSpawn;if (isNull _o) exitWith {hint 'Model unavailable / Модель недоступна';};
  ['finish'] call TSL_fnc_editorInput;['checkpoint'] call TSL_fnc_editorInput;['cancel'] call TSL_fnc_editorInput;
  private _bb=[_o] call TSL_fnc_editorBounds;private _centre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;private _extent=(_bb select 1) vectorDiff (_bb select 0);
  private _size=(_extent select 0) max (_extent select 1) max (_extent select 2);private _scale=(.8/((_size max vectorMagnitude _centre) max .8)) max .001 min 1;
  private _pos=[-.1,-.35,1.1] vectorDiff (_centre vectorMultiply _scale);private _pose=[_pos,[0,1,0],[0,0,1],_scale];
  private _key='added_'+str floor (diag_tickTime*1000)+'_'+str floor random 1000000;
  private _homes=(_l getVariable ['TSL_gearHomes',[]]) select {_quantity==1 && {([_x select 0] call TSL_fnc_stackKey)==''} && {toLower (_x select 1)==toLower _model && {private _id=_x select 0;((_e get 'added') findIf {(_x select 0)==_id})<0}}};if (_homes isNotEqualTo []) then {private _home=_homes select (count _homes-1);_key=_home select 0;_pose=parseSimpleArray str (_home select 2);};
  private _group='added_stack_'+str floor (diag_tickTime*1000)+'_'+str floor random 1000000;if (_quantity>1) then {_key=_group+'_0_'+str _quantity;};
  (_e get 'added') pushBack [_key,_model,_pose];_e set ['selected',_key];_e set ['selectionLocked',true];_e set ['ghost',_o];_e set ['source',objNull];_e set ['label',([_model] call TSL_fnc_editorModel) select 1];[_l,_o,_pose] call TSL_fnc_editorPose;
  _e set ['proxies',[[_key,_o,objNull,_pose,-1,_e get 'label',false]]];
  for '_n' from 1 to (_quantity-1) do {private _p2=parseSimpleArray str _pose;_p2 set [0,(_pose select 0) vectorAdd [0,0,.035*_n]];(_e get 'added') pushBack [_group+'_'+str _n+'_'+str _quantity,_model,_p2];};
  [] call TSL_fnc_editorRefresh;['close'] call TSL_fnc_editorCatalogUI;
 };
 case 'scale': {_e set ['mode','SCALE'];(_d displayCtrl 78218) ctrlSetText str (100*getObjectScale (_e getOrDefault ['ghost',objNull]));};
 case 'scaleNumber': {
  private _o=_e getOrDefault ['ghost',objNull];if (isNull _o) exitWith {};
  private _scale=(parseNumber ctrlText (_d displayCtrl 78218))/100;if (_scale<.001 || {_scale>20}) exitWith {hint '0.1% - 2000%';};
  ['finish'] call TSL_fnc_editorInput;['checkpoint'] call TSL_fnc_editorInput;[_l,_o,_scale] call TSL_fnc_editorScale;
  private _key=_e get 'selected';private _poses=_e get 'poses';private _i=_poses findIf {(_x select 0)==_key};private _record=[_key,[_l,_o] call TSL_fnc_editorPose];if (_i<0) then {_poses pushBack _record} else {_poses set [_i,_record];};
 };
 case 'scaleReset': {(_d displayCtrl 78218) ctrlSetText '100';['scaleNumber'] call TSL_fnc_editorUI;};
 case 'undo': {private _h=_e get 'undo';if (count _h>0) then {['cancel'] call TSL_fnc_editorInput;private _v=_h deleteAt (count _h-1);_e set ['poses',_v select 0];_e set ['added',_v select 1];};};
 case 'delete': {
 private _key=_e getOrDefault ['selected',''];private _o=_e getOrDefault ['ghost',objNull];if (_key=='' || {isNull _o}) exitWith {};
 if (_key select [0,5]=='slot_') exitWith {hint (if (_ru) then {'Настоящее снаряжение забирается через обычное меню.'} else {'Take real equipment through the normal menu.'});};
 ['finish'] call TSL_fnc_editorInput;['checkpoint'] call TSL_fnc_editorInput;
 if (_key select [0,6]=='added_') then {_e set ['added',(_e get 'added') select {(_x select 0)!=_key}];_e set ['poses',(_e get 'poses') select {(_x select 0)!=_key}];} else {
  private _poses=_e get 'poses';private _i=_poses findIf {(_x select 0)==_key};private _record=[_key,[_l,_o] call TSL_fnc_editorPose,true];if (_i<0) then {_poses pushBack _record} else {_poses set [_i,_record];};
 };['cancel'] call TSL_fnc_editorInput;[] call TSL_fnc_editorRefresh;
 };
 case 'restoreParts': {['checkpoint'] call TSL_fnc_editorInput;['cancel'] call TSL_fnc_editorInput;_e set ['poses',(_e get 'poses') apply {[_x select 0,_x select 1]}];[] call TSL_fnc_editorRefresh;};
 case 'resetLayout': {
  if (diag_tickTime>(_e getOrDefault ['resetConfirmUntil',0])) then {_e set ['resetConfirmUntil',diag_tickTime+8];(_d displayCtrl 78215) ctrlSetText (if (_ru) then {'ПОДТВЕРДИТЬ СБРОС'} else {'CONFIRM RESET'});} else {
   ['checkpoint'] call TSL_fnc_editorInput;['cancel'] call TSL_fnc_editorInput;_e set ['poses',[]];_e set ['added',[]];_e set ['resetConfirmUntil',0];(_d displayCtrl 78215) ctrlSetText (if (_ru) then {'СБРОСИТЬ РАССТАНОВКУ'} else {'RESET LAYOUT'});[] call TSL_fnc_editorRefresh;
  };
 };
 case 'reset': {private _key=_e get 'selected';['checkpoint'] call TSL_fnc_editorInput;_e set ['poses',(_e get 'poses') select {(_x select 0)!=_key}];private _source=_e getOrDefault ['source',objNull];private _ghost=_e getOrDefault ['ghost',objNull];if (!isNull _source && {!isNull _ghost}) then {private _base=_source getVariable ['TSL_editBase',[]];if (_base isNotEqualTo []) then {[_l,_ghost,_base] call TSL_fnc_editorPose;};};};
 case 'apply': {
  ['finish'] call TSL_fnc_editorInput;private _revision=_e get 'revision';_e set ['pending',true];
  [_l,player,'editorApply',[_revision,_e get 'poses',_e get 'added']] remoteExecCall ['TSL_fnc_request',2];
  [_l,_revision,_e] spawn {params ['_l','_revision','_e'];private _until=diag_tickTime+4;waitUntil {sleep .05;isNull _l || {(_l getVariable ['TSL_editorRevision',0])>_revision} || {diag_tickTime>_until}};_e set ['pending',false];if (!isNull _l && {(_l getVariable ['TSL_editorRevision',0])>_revision}) then {['cancel'] call TSL_fnc_editorInput;_e set ['revision',_l getVariable ['TSL_editorRevision',0]];_e set ['poses',parseSimpleArray str (_l getVariable ['TSL_editorPoses',[]])];_e set ['added',parseSimpleArray str (_l getVariable ['TSL_editorAdded',[]])];_e set ['undo',[]];_e set ['savedUntil',diag_tickTime+2];};};
 };
};
(_d displayCtrl 78203) ctrlSetText ('AXIS / ОСЬ: '+(_e get 'axis'));

private _scaling=(_e get 'mode')=='SCALE';{(_d displayCtrl _x) ctrlShow _scaling} forEach [78218,78219,78220];(_d displayCtrl 78200) ctrlShow (!_scaling);

[] call TSL_fnc_editorChrome;
