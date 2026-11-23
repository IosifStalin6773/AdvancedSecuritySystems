disableSerialization;params [['_command','open']];private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];if !(_e getOrDefault ['active',false]) exitWith {};
private _s=uiNamespace getVariable ['TSL_presets',createHashMap];private _ru=false;
if (_command=='close') exitWith {{ctrlDelete (_d displayCtrl _x)} forEach [78300,78301,78302,78303,78304,78305,78306,78307,78308,78309,78310,78311,78312,78313,78314];uiNamespace setVariable ['TSL_presets',createHashMap];};
if (_command=='open') exitWith {
 if (_s getOrDefault ['active',false]) exitWith {['close'] call TSL_fnc_presetUI;};
 ['close'] call TSL_fnc_editorObjects;['close'] call TSL_fnc_editorCatalogUI;
 private _camera=uiNamespace getVariable ['TSL_camera',createHashMap];_camera set ['keys',[]];_camera set ['drag',false];['finish'] call TSL_fnc_editorInput;
 private _s=createHashMapFromArray [['active',true],['page',0],['search',''],['token',''],['pending',false]];uiNamespace setVariable ['TSL_presets',_s];
 private _items=[
 ['TSL_Text',78300,.68,.10,.30,.84,'',''],
 ['TSL_Text',78301,.70,.12,.265,.04,if (_ru) then {'МОИ ПРЕСЕТЫ ЛОКЕРА'} else {'Presets'},''],
 ['TSL_PresetEdit',78302,.70,.18,.19,.035,'',''],
 ['TSL_Button',78314,.90,.18,.065,.035,if (_ru) then {'ПОИСК'} else {'Go'},"['search'] call TSL_fnc_presetUI"],
 ['TSL_EditorList',78303,.70,.23,.265,.31,'',''],
 ['TSL_Text',78304,.70,.56,.265,.025,if (_ru) then {'Название нового пресета / переименование:'} else {'Name'},''],
 ['TSL_PresetEdit',78305,.70,.59,.265,.035,'',''],
 ['TSL_Button',78306,.70,.65,.08,.035,if (_ru) then {'СОХРАНИТЬ НОВЫЙ'} else {'Save new'},"['save'] call TSL_fnc_presetUI"],
 ['TSL_Button',78307,.79,.65,.075,.035,if (_ru) then {'ЗАГРУЗИТЬ'} else {'Load'},"['load'] call TSL_fnc_presetUI"],
 ['TSL_Button',78308,.875,.65,.09,.035,if (_ru) then {'ПЕРЕИМЕНОВАТЬ'} else {'Rename'},"['rename'] call TSL_fnc_presetUI"],
 ['TSL_Button',78309,.70,.70,.08,.035,if (_ru) then {'УДАЛИТЬ'} else {'Delete'},"['delete'] call TSL_fnc_presetUI"],
 ['TSL_Button',78310,.79,.70,.035,.035,'<',"['previous'] call TSL_fnc_presetUI"],
 ['TSL_Button',78311,.83,.70,.035,.035,'>',"['next'] call TSL_fnc_presetUI"],
 ['TSL_Button',78312,.875,.70,.09,.035,if (_ru) then {'ЗАКРЫТЬ'} else {'Close'},"['close'] call TSL_fnc_presetUI"],
 ['TSL_Text',78313,.70,.77,.265,.14,if (_ru) then {'Загрузка заменяет оформление. Вещи в инвентаре не меняются.'} else {'Load replaces appearance. Inventory equipment is unchanged.'},'']
 ];
 {_x params ['_class','_id','_x0','_y','_w','_h','_text','_action'];private _c=_d ctrlCreate [_class,_id];_c ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*_y,safeZoneW*_w,safeZoneH*_h];_c ctrlCommit 0;_c ctrlSetText _text;_c ctrlSetFontHeight .028;if (_action!='') then {_c ctrlAddEventHandler ['ButtonClick',_action]};if (_id==78300) then {_c ctrlSetBackgroundColor [.025,.03,.025,.98]};} forEach _items;
 (_d displayCtrl 78303) ctrlAddEventHandler ['LBSelChanged',{disableSerialization;params ['_ctrl','_index'];private _d=ctrlParent _ctrl;if (_index>=0) then {(_d displayCtrl 78305) ctrlSetText (_ctrl lbText _index);};private _s=uiNamespace getVariable ['TSL_presets',createHashMap];_s set ['confirmDelete',''];(_d displayCtrl 78309) ctrlSetText (if ((profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru') then {'УДАЛИТЬ'} else {'Delete'});}];
 ['refresh'] call TSL_fnc_presetUI;
};
if !(_s getOrDefault ['active',false]) exitWith {};
if (_s getOrDefault ['pending',false]) exitWith {};
private _l=(uiNamespace getVariable ['TSL_camera',createHashMap]) getOrDefault ['locker',objNull];if (isNull _l) exitWith {};
private _list=_d displayCtrl 78303;private _selection=lbCurSel _list;private _id=if (_selection>=0) then {_list lbData _selection} else {''};
private _op='';private _payload=[];
switch _command do {
 case 'refresh': {_op='presetList';_payload=[_s get 'page',_s get 'search'];};
 case 'search': {_s set ['page',0];_s set ['search',(ctrlText (_d displayCtrl 78302)) select [0,96]];_op='presetList';_payload=[0,_s get 'search'];};
 case 'previous': {_s set ['page',((_s get 'page')-1) max 0];_op='presetList';_payload=[_s get 'page',_s get 'search'];};
 case 'next': {_s set ['page',(_s get 'page')+1];_op='presetList';_payload=[_s get 'page',_s get 'search'];};
 case 'save': {['finish'] call TSL_fnc_editorInput;_op='presetSave';_payload=[ctrlText (_d displayCtrl 78305),_e get 'revision',_e get 'poses',_e get 'added'];};
 case 'rename': {if (_id!='') then {_op='presetRename';_payload=[_id,ctrlText (_d displayCtrl 78305)];};};
 case 'load': {
  if (_id!='') then {
   if ((_s getOrDefault ['confirmLoad',''])!=_id || {diag_tickTime>(_s getOrDefault ['confirmUntil',0])}) then {_s set ['confirmLoad',_id];_s set ['confirmUntil',diag_tickTime+8];(_d displayCtrl 78313) ctrlSetText (if (_ru) then {'Нажми «Загрузить» ещё раз: текущее оформление будет заменено.'} else {'Press Load again to replace the current appearance.'});} else {_op='presetLoad';_payload=[_id,_e get 'revision'];_s set ['confirmLoad',''];};
  };
 };
 case 'delete': {
  if (_id!='') then {if ((_s getOrDefault ['confirmDelete',''])!=_id || {diag_tickTime>(_s getOrDefault ['deleteUntil',0])}) then {_s set ['confirmDelete',_id];_s set ['deleteUntil',diag_tickTime+8];(_d displayCtrl 78309) ctrlSetText (if (_ru) then {'ПОДТВЕРДИТЬ УДАЛЕНИЕ'} else {'Confirm delete'});} else {_op='presetDelete';_payload=[_id];_s set ['confirmDelete',''];};};
 };
};
if (_op=='') exitWith {};
private _token=str diag_tickTime+'_'+str floor random 1000000;_s set ['token',_token];_s set ['pending',true];
[_l,player,_op,[_token,_payload]] remoteExecCall ['TSL_fnc_request',2];
[_token] spawn {params ['_token'];sleep 5;private _s=uiNamespace getVariable ['TSL_presets',createHashMap];if ((_s getOrDefault ['token',''])==_token && {_s getOrDefault ['pending',false]}) then {_s set ['pending',false];disableSerialization;private _d=findDisplay 78150;if (!isNull _d) then {(_d displayCtrl 78313) ctrlSetText 'Server response timed out. Retry / Сервер не ответил. Повтори.';};};};
