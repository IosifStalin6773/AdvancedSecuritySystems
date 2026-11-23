disableSerialization;params [['_command','open']];private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];private _ru=false;
if (_command=='close') exitWith {['close'] call TSL_fnc_editorPreview;private _list=_d displayCtrl 78210;if (!isNull _list) then {_e set ['catalogSavedRef',_list lbData (lbCurSel _list)];_e set ['catalogSavedScroll',ctrlScrollValues _list];};_e set ['catalogOpen',false];{ctrlDelete (_d displayCtrl _x)} forEach [78210,78211,78400,78401,78402,78403,78404,78405,78406,78407,78408,78409,78410];ctrlSetFocus (_d displayCtrl 78900);};
if (_command=='open') then {
 if (_e getOrDefault ['catalogOpen',false]) exitWith {['close'] call TSL_fnc_editorCatalogUI;};
 ['close'] call TSL_fnc_presetUI;['close'] call TSL_fnc_editorObjects;['finish'] call TSL_fnc_editorInput;
 _e set ['catalogOpen',true];_e set ['catalogPage',_e getOrDefault ['catalogPage',0]];_e set ['catalogSearch',_e getOrDefault ['catalogSearch','']];_e set ['catalogCategory',_e getOrDefault ['catalogCategory','ALL']];_e set ['catalogShownRefs',[]];_e set ['catalogSnapshot',+([] call TSL_fnc_editorCatalog)];(uiNamespace getVariable ['TSL_camera',createHashMap]) set ['keys',[]];(uiNamespace getVariable ['TSL_camera',createHashMap]) set ['drag',false];
 private _controls=[
 ['TSL_Text',78400,.68,.10,.30,.84,'',''],
 ['TSL_PresetEdit',78401,.70,.12,.16,.035,'',''],
 ['TSL_Button',78402,.865,.12,.05,.035,if (_ru) then {'НАЙТИ'} else {'Go'},"['search'] call TSL_fnc_editorCatalogUI"],
 ['TSL_Button',78409,.92,.12,.045,.035,if (_ru) then {'ОЧИСТИТЬ'} else {'X'},"['clear'] call TSL_fnc_editorCatalogUI"],
 ['RscCombo',78403,.70,.17,.265,.035,'',''],
 ['TSL_EditorList',78210,.70,.22,.265,.33,'',''],
 ['TSL_Wrapped',78407,.70,.81,.265,.035,'',''],
 ['TSL_Button',78410,.79,.86,.06,.035,'x1',"['quantity'] call TSL_fnc_editorCatalogUI"],
 ['TSL_Button',78211,.70,.86,.085,.035,if (_ru) then {'ДОБАВИТЬ ВЫБРАННЫЙ'} else {'Add'},"['add'] call TSL_fnc_editorUI"],
 ['TSL_Button',78404,.70,.90,.045,.03,'<',"['previous'] call TSL_fnc_editorCatalogUI"],
 ['TSL_Button',78405,.75,.90,.045,.03,'>',"['next'] call TSL_fnc_editorCatalogUI"],
 ['TSL_Button',78408,.83,.90,.135,.03,if (_ru) then {'ОБНОВИТЬ'} else {'Refresh'},"['refresh'] call TSL_fnc_editorCatalogUI"],
 ['TSL_Button',78406,.86,.86,.105,.035,if (_ru) then {'ЗАКРЫТЬ'} else {'Close'},"['close'] call TSL_fnc_editorCatalogUI"]];
 {_x params ['_class','_id','_x0','_y','_w','_h','_text','_code'];private _c=_d ctrlCreate [_class,_id];_c ctrlSetPosition [safeZoneX+safeZoneW*_x0,safeZoneY+safeZoneH*_y,safeZoneW*_w,safeZoneH*_h];_c ctrlCommit 0;if (_id!=78403) then {_c ctrlSetText _text;};_c ctrlSetFontHeight .026;if (_id==78400) then {_c ctrlSetBackgroundColor [.025,.03,.025,.98]};if (_code!='') then {_c ctrlAddEventHandler ['ButtonClick',_code]};} forEach _controls;
 private _groups=[['ALL','Все доступные объекты','All available objects'],['GEAR','Разрешённое снаряжение','Allowed equipment'],['SMALL','Мелкие предметы','Small props'],['LOCAL','Декор локера','Locker props'],['CfgVehicles','Объекты и техника','Objects and vehicles'],['CfgWeapons','Оружие, форма и предметы','Weapons, clothing and items'],['CfgMagazines','Магазины, гранаты и заряды','Magazines, grenades and charges'],['CfgGlasses','Маски и очки','Facewear'],['CfgAmmo','Декоративные модели боеприпасов','Ammo display models']];
 private _combo=_d displayCtrl 78403;{private _i=_combo lbAdd (_x select (if (_ru) then {1} else {2}));_combo lbSetData [_i,_x select 0];} forEach _groups;private _index=0;for '_i' from 0 to (lbSize _combo-1) do {if ((_combo lbData _i)==(_e get 'catalogCategory')) exitWith {_index=_i;};};_combo lbSetCurSel _index;(_d displayCtrl 78401) ctrlSetText (_e get 'catalogSearch');
 _combo ctrlAddEventHandler ['LBSelChanged',{['category'] call TSL_fnc_editorCatalogUI;}];
 (_d displayCtrl 78210) ctrlAddEventHandler ['LBSelChanged',{params ['_list','_row'];['show',_list lbData _row] call TSL_fnc_editorPreview;['quantityStatus'] call TSL_fnc_editorCatalogUI;}];
 (_d displayCtrl 78210) ctrlAddEventHandler ['LBDblClick',{['add'] call TSL_fnc_editorUI}];
 (_d displayCtrl 78401) ctrlAddEventHandler ['KeyDown',{if ((_this select 1)==28) then {['search'] call TSL_fnc_editorCatalogUI;true} else {false}}];
};
if !(_e getOrDefault ['catalogOpen',false]) exitWith {};
if (_command in ['quantity','quantityStatus']) exitWith {
 private _list=_d displayCtrl 78210;private _info=[_list lbData (lbCurSel _list)] call TSL_fnc_gearInfo;private _ok=_info isNotEqualTo [] && {(_info select 2)=='magazine'};
 private _n=_e getOrDefault ['catalogQuantity',1];if (_command=='quantity' && {_ok}) then {private _ns=[1,2,3,5,10];_n=_ns select (((_ns find _n)+1) mod count _ns);_e set ['catalogQuantity',_n];};
 (_d displayCtrl 78410) ctrlSetTooltip 'Quantity: 1 / 2 / 3 / 5 / 10';(_d displayCtrl 78410) ctrlShow _ok;(_d displayCtrl 78410) ctrlSetText ('x'+str _n);
};
if (_command=='status') exitWith {
 private _loading=missionNamespace getVariable ['TSL_catalogBuilding',false];private _available=count (missionNamespace getVariable ['TSL_fullCatalog',[]]);private _shown=count (_e getOrDefault ['catalogSnapshot',[]]);
 private _phase=missionNamespace getVariable ['TSL_catalogPhase','gear'];private _stage=if (_phase=='gear') then {if (_ru) then {'снаряжение'} else {'equipment'}} else {if (_ru) then {'объекты'} else {'objects'}};
 private _status=if (_loading) then {if (_ru) then {format ['Загружается %1. Найдено: %2. Нажмите «Обновить» для новых записей.',_stage,_available]} else {format ['Loading %1. Found: %2. Refresh to show new entries.',_stage,_available]}} else {if (_available>_shown) then {if (_ru) then {'Загрузка завершена. Нажмите «Обновить», чтобы показать новые записи.'} else {'Loading complete. Refresh to show new entries.'}} else {_e getOrDefault ['catalogSummary','']}};
 (_d displayCtrl 78407) ctrlSetText _status;
};
switch _command do {
 case 'clear': {(_d displayCtrl 78401) ctrlSetText '';_e set ['catalogSearch',''];_e set ['catalogPage',0];};
 case 'search': {_e set ['catalogSearch',toLower ctrlText (_d displayCtrl 78401)];_e set ['catalogPage',0];};
 case 'category': {_e set ['catalogCategory',(_d displayCtrl 78403) lbData (lbCurSel (_d displayCtrl 78403))];_e set ['catalogPage',0];};
 case 'next': {_e set ['catalogPage',(_e get 'catalogPage')+1];};
 case 'previous': {_e set ['catalogPage',((_e get 'catalogPage')-1) max 0];};
};
if !(_command in ['next','previous']) then {_e set ['catalogSnapshot',+([] call TSL_fnc_editorCatalog)];};
private _search=_e get 'catalogSearch';private _category=_e get 'catalogCategory';
private _rows=(_e get 'catalogSnapshot') select {(_category=='ALL' || {(_x select 2)==_category} || {_category in (_x param [3,[]])}) && {_search=='' || {(toLower ((_x select 1)+' '+(_x select 0))) find _search>=0}}};
private _total=count _rows;private _page=(_e get 'catalogPage') min (((ceil (_total/50))-1) max 0);_e set ['catalogPage',_page];_rows=_rows select [_page*50,50];_e set ['catalogRows',_rows];
private _list=_d displayCtrl 78210;private _refs=_rows apply {_x select 0};
if (_refs isNotEqualTo (_e getOrDefault ['catalogShownRefs',[]])) then {
 ['close'] call TSL_fnc_editorPreview;private _selected=if (_command=='open') then {_e getOrDefault ['catalogSavedRef','']} else {_list lbData (lbCurSel _list)};private _scroll=if (_command=='open') then {_e getOrDefault ['catalogSavedScroll',[0,0]]} else {ctrlScrollValues _list};lbClear _list;{private _i=_list lbAdd (_x select 1);_list lbSetData [_i,_x select 0];_list lbSetTooltip [_i,_x select 1];} forEach _rows;
 if (count _rows>0) then {private _restore=if (_command in ['refresh','open']) then {_refs find _selected} else {-1};_list lbSetCurSel (_restore max 0);};
 if (_command in ['refresh','open']) then {_list ctrlSetScrollValues _scroll;};_e set ['catalogShownRefs',_refs];
};
private _summary=if (_total>0) then {format ['%1: %2 | %3 / %4',if (_ru) then {'Найдено'} else {'Results'},_total,_page+1,(ceil (_total/50)) max 1]} else {if (_search!='') then {if (_ru) then {'Ничего не найдено. Очистите поиск или выберите другую категорию.'} else {'No matches. Clear search or choose another category.'}} else {if (_category=='GEAR') then {if (_ru) then {'Разрешённое снаряжение не найдено в загруженных модах. Проверьте загрузку и нажмите «Обновить».'} else {'No allowed equipment found in loaded mods. Check loading and Refresh.'}} else {if (_ru) then {'В этой категории пока нет записей. Проверьте загрузку и нажмите «Обновить».'} else {'No entries yet. Check loading and Refresh.'}}}};
_e set ['catalogSummary',_summary];(_d displayCtrl 78407) ctrlSetText _summary;
(_d displayCtrl 78404) ctrlEnable (_page>0);(_d displayCtrl 78405) ctrlEnable ((_page+1)*50<_total);(_d displayCtrl 78211) ctrlEnable (_total>0);

['quantityStatus'] call TSL_fnc_editorCatalogUI;
