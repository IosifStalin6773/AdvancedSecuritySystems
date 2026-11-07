disableSerialization;params [['_command','open']];private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];private _ru=false;
if (_command=='close') exitWith {['close'] call TSL_fnc_editorPreview;{ctrlDelete (_d displayCtrl _x)} forEach [78500,78501,78502,78503,78504,78505];_e set ['objectsOpen',false];ctrlSetFocus (_d displayCtrl 78900);};
if !(_e getOrDefault ['active',false]) exitWith {};
if (_command=='select') exitWith {
 private _list=_d displayCtrl 78502;private _key=_list lbData (lbCurSel _list);private _i=(_e get 'proxies') findIf {(_x select 0)==_key};if (_i<0) exitWith {};
 ['finish'] call TSL_fnc_editorInput;private _row=(_e get 'proxies') select _i;
 _e set ['selected',_key];_e set ['ghost',_row select 1];_e set ['source',_row select 2];_e set ['label',(_row select 1) getVariable ['TSL_editLabel',_row select 5]];_e set ['selectionLocked',true];['close'] call TSL_fnc_editorObjects;
};
if (_command=='open') then {
 if (_e getOrDefault ['objectsOpen',false]) exitWith {['close'] call TSL_fnc_editorObjects;};
 ['finish'] call TSL_fnc_editorInput;['close'] call TSL_fnc_presetUI;['close'] call TSL_fnc_editorCatalogUI;[] call TSL_fnc_editorRefresh;
 _e set ['objectsOpen',true];(uiNamespace getVariable ['TSL_camera',createHashMap]) set ['keys',[]];(uiNamespace getVariable ['TSL_camera',createHashMap]) set ['drag',false];
 private _controls=[
 ['TSL_Text',78500,.68,.10,.30,.81,'',''],
 ['TSL_Wrapped',78501,.70,.12,.265,.04,if (_ru) then {'ПРЕДМЕТЫ В ЛОКЕРЕ. Выберите строку: после подтверждения редактируется только этот предмет.'} else {'Contents'},''],
 ['TSL_EditorList',78502,.70,.18,.265,.37,'',''],
 ['TSL_Button',78503,.70,.85,.125,.04,if (_ru) then {'ВЫБРАТЬ И ЗАКРЕПИТЬ'} else {'Select'},"['select'] call TSL_fnc_editorObjects"],
 ['TSL_Button',78504,.835,.85,.13,.04,if (_ru) then {'НАЗАД'} else {'Close'},"['close'] call TSL_fnc_editorObjects"]];
 {_x params ['_class','_id','_x','_y','_w','_h','_label','_code'];private _c=_d ctrlCreate [_class,_id];_c ctrlSetPosition [safeZoneX+safeZoneW*_x,safeZoneY+safeZoneH*_y,safeZoneW*_w,safeZoneH*_h];_c ctrlCommit 0;_c ctrlSetText _label;_c ctrlSetFontHeight .027;if (_id==78500) then {_c ctrlSetBackgroundColor [.02,.025,.02,.98];};if (_code!='') then {_c ctrlAddEventHandler ['ButtonClick',_code];};} forEach _controls;
 private _list=_d displayCtrl 78502;_list ctrlAddEventHandler ['LBSelChanged',{params ['_list','_row'];private _key=_list lbData _row;private _e=uiNamespace getVariable ['TSL_editor',createHashMap];private _i=(_e get 'proxies') findIf {(_x select 0)==_key};if (_i>=0) then {['show',((_e get 'proxies') select _i) select 1] call TSL_fnc_editorPreview;};}];private _selected=-1;
 {
  _x params ['_key','_object','_source','_base','_slot','_label'];
  if (!isNull _object && {!isObjectHidden _object}) then {private _ref=_object getVariable ['TSL_assetRef',''];if (_ref!='') then {private _info=[_ref] call TSL_fnc_editorModel;if (_info isNotEqualTo []) then {_label=_info select 1;};};
   private _kind=if ((_key find 'added_')==0) then {if (_ru) then {'Добавленный'} else {'Added'}} else {if (_slot>=0) then {if (_ru) then {'Снаряжение'} else {'Stored equipment'}} else {if (_ru) then {'Деталь / декор'} else {'Part / decoration'}}};
   private _i=_list lbAdd format ['%1. %2 — %3',lbSize _list+1,[_label] call TSL_fnc_localize,_kind];_list lbSetData [_i,_key];_list lbSetTooltip [_i,_key];if (_key==(_e get 'selected')) then {_selected=_i;};
  };
 } forEach (_e getOrDefault ['proxies',[]]);if (lbSize _list>0) then {_list lbSetCurSel (_selected max 0);};(_d displayCtrl 78503) ctrlEnable (lbSize _list>0);
 _list ctrlAddEventHandler ['LBDblClick',{['select'] call TSL_fnc_editorObjects;}];
};
