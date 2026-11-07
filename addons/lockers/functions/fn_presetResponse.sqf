if (!hasInterface || {isRemoteExecuted && {remoteExecutedOwner!=2}}) exitWith {};
disableSerialization;params ['_token','_kind','_data'];private _s=uiNamespace getVariable ['TSL_presets',createHashMap];
if !(_s getOrDefault ['active',false] && {(_s getOrDefault ['token',''])==_token}) exitWith {};
private _d=findDisplay 78150;if (isNull _d) exitWith {};
private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';_s set ['pending',false];
private _message='';
switch _kind do {
 case 'list': {
  _data params ['_rows','_total','_page','_search'];_s set ['rows',_rows];_s set ['page',_page];_s set ['total',_total];
  private _list=_d displayCtrl 78303;lbClear _list;{private _i=_list lbAdd (_x select 1);_list lbSetData [_i,_x select 0]} forEach _rows;
  if (count _rows>0) then {_list lbSetCurSel 0;};
  _message=if (_ru) then {format ['Пресетов: %1 | Страница %2 / %3',_total,_page+1,(ceil (_total/30)) max 1]} else {format ['Presets: %1 | Page %2 / %3',_total,_page+1,(ceil (_total/30)) max 1]};
  (_d displayCtrl 78310) ctrlEnable (_page>0);(_d displayCtrl 78311) ctrlEnable ((_page+1)*30<_total);
 };
 case 'saved': {_s set ['lastId',_data select 0];_message=if (_ru) then {'Пресет сохранён.'} else {'Preset saved.'};['refresh'] call TSL_fnc_presetUI;};
 case 'renamed': {_message=if (_ru) then {'Название изменено.'} else {'Preset renamed.'};['refresh'] call TSL_fnc_presetUI;};
 case 'deleted': {_message=if (_ru) then {'Пресет удалён.'} else {'Preset deleted.'};['refresh'] call TSL_fnc_presetUI;};
 case 'loaded': {
  private _e=uiNamespace getVariable ['TSL_editor',createHashMap];['cancel'] call TSL_fnc_editorInput;
  _e set ['revision',_data select 2];_e set ['poses',parseSimpleArray str (_data select 3)];_e set ['added',parseSimpleArray str (_data select 4)];_e set ['undo',[]];
  _message=if (_ru) then {'Пресет применён. Снаряжение осталось прежним.'} else {'Preset applied. Equipment is unchanged.'};
 };
 case 'error': {
  _message=switch (_data param [0,'']) do {case 'NAME': {if (_ru) then {'Введи название: от 1 до 96 символов.'} else {'Enter a name: 1 to 96 characters.'}};case 'STALE': {if (_ru) then {'Расстановка изменилась. Переоткрой редактор.'} else {'Layout changed. Reopen the editor.'}};case 'MISSING': {if (_ru) then {'Пресет уже отсутствует. Обнови список.'} else {'Preset no longer exists. Refresh the list.'}};default {if (_ru) then {'Не удалось обработать пресет.'} else {'Could not process preset.'}};};
 };
};
(_d displayCtrl 78313) ctrlSetText _message;
