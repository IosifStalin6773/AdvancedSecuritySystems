params ['_l','_p','_op','_args'];
if (!isServer || {isNull _l} || {isNull _p} || {!isPlayer _p} || {!alive _p} || {_p distance _l>3} || {isRemoteExecuted && {remoteExecutedOwner!=owner _p}}) exitWith {};
private _uid=getPlayerUID _p;if (_uid=='' || {(_l getVariable ['TSL_owner',''])!=_uid}) exitWith {};
if (_l getVariable ['TSL_busy',false]) exitWith {};
_args params [['_token',''],['_payload',[]]];if !(_token isEqualType '' && {count _token<100} && {_payload isEqualType []}) exitWith {};
private _reply={params ['_kind','_data'];[_token,_kind,_data] remoteExecCall ['TSL_fnc_presetResponse',owner _p];};
[_uid]call TSL_fnc_migrateLegacy;
private _indexKey='TSL_Presets_Index_'+_uid;private _index=+(profileNamespace getVariable [_indexKey,[]]);
private _dataKey={params ['_id'];'TSL_Preset_Data_'+_uid+'_'+_id};
private _nameCheck={params ['_name'];if !(_name isEqualType '') exitWith {''};private _chars=toArray _name;while {count _chars>0 && {(_chars select 0) in [9,10,13,32]}} do {_chars deleteAt 0;};while {count _chars>0 && {(_chars select (count _chars-1)) in [9,10,13,32]}} do {_chars deleteAt (count _chars-1);};if (count _chars>96 || {{_x<32} count _chars>0}) exitWith {''};toString _chars};
switch _op do {
 case 'presetList': {
  _payload params [['_page',0],['_search','']];if !(_page isEqualType 0 && {finite _page} && {_search isEqualType ''} && {count _search<=96}) exitWith {};
  private _rows=_index select {(toLower (_x select 1)) find (toLower _search)>=0};private _total=count _rows;_page=(floor _page) max 0 min (((ceil (_total/30))-1) max 0);
  ['list',[_rows select [_page*30,30],_total,_page,_search]] call _reply;
 };
 case 'presetSave': {
  _payload params [['_name',''],['_revision',-1],['_poses',[]],['_added',[]]];_name=[_name] call _nameCheck;
  if (_name=='') exitWith {['error',['NAME']] call _reply;};
  if (_revision!=(_l getVariable ['TSL_editorRevision',0])) exitWith {['error',['STALE']] call _reply;};
  if !([_l,_poses,_added] call TSL_fnc_editorValidate) exitWith {['error',['INVALID']] call _reply;};
  private _counterKey='TSL_Presets_Counter_'+_uid;private _number=(profileNamespace getVariable [_counterKey,0])+1;private _id=str _number;profileNamespace setVariable [_counterKey,_number];
  private _style=[_l getVariable ['TSL_custom',TSL_customDefault],_l getVariable ['TSL_patch',[]],_l getVariable ['TSL_photo',[]],_l getVariable ['TSL_panelLayout',[]],_l getVariable ['TSL_wallPhotos',[]]];
  profileNamespace setVariable [[_id] call _dataKey,parseSimpleArray str [1,_poses,_added,_style]];
  _index pushBack [_id,_name,systemTimeUTC];profileNamespace setVariable [_indexKey,_index];saveProfileNamespace;
  ['saved',[_id,_name]] call _reply;
 };
 case 'presetRename': {
  _payload params [['_id',''],['_name','']];_name=[_name] call _nameCheck;private _i=_index findIf {(_x select 0)==_id};
  if (_i<0) exitWith {['error',['MISSING']] call _reply;};if (_name=='') exitWith {['error',['NAME']] call _reply;};
  private _row=+(_index select _i);_row set [1,_name];_index set [_i,_row];profileNamespace setVariable [_indexKey,_index];saveProfileNamespace;['renamed',[_id,_name]] call _reply;
 };
 case 'presetDelete': {
  _payload params [['_id','']];private _i=_index findIf {(_x select 0)==_id};if (_i<0) exitWith {['error',['MISSING']] call _reply;};
  _index deleteAt _i;profileNamespace setVariable [_indexKey,_index];profileNamespace setVariable [[_id] call _dataKey,nil];saveProfileNamespace;['deleted',[_id]] call _reply;
 };
 case 'presetLoad': {
  _payload params [['_id',''],['_revision',-1]];private _i=_index findIf {(_x select 0)==_id};if (_i<0) exitWith {['error',['MISSING']] call _reply;};
  if (_revision!=(_l getVariable ['TSL_editorRevision',0])) exitWith {['error',['STALE']] call _reply;};
  private _data=parseSimpleArray str (profileNamespace getVariable [[_id] call _dataKey,[]]);if (count _data!=4 || {(_data select 0)!=1}) exitWith {['error',['INVALID']] call _reply;};
  _data params ['_version','_poses','_added','_style'];
  if !([_l,_poses,_added,true] call TSL_fnc_editorValidate) exitWith {['error',['INVALID']] call _reply;};
  if (count _style!=5) exitWith {['error',['INVALID']] call _reply;};
  {_l setVariable [_x,_style select _forEachIndex,true];} forEach ['TSL_custom','TSL_patch','TSL_photo','TSL_panelLayout','TSL_wallPhotos'];
  _l setVariable ['TSL_editorPoses',_poses,true];_l setVariable ['TSL_editorAdded',_added,true];_l setVariable ['TSL_editorRevision',_revision+1,true];
  [_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
  ['loaded',[_id,(_index select _i) select 1,_revision+1,_poses,_added]] call _reply;
 };
};
