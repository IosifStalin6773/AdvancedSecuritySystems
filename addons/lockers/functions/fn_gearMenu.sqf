params ['_target','_player','_params'];private _key=_params param [0,''];
private _i=(_target getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key};if (_i<0) exitWith {
 private _homes=_target getVariable ['TSL_gearHomes',[]];if ((_homes findIf {(_x select 0)==_key})<0) exitWith {[]};private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';private _result=[];
 { _x params ['_op','_label'];private _a=['TSL_'+_op,_label,'',{params ['_target','_player','_params'];[_target,_player,_params select 0,[_params select 1]] remoteExecCall ['TSL_fnc_request',2];},{params ['_target','_player'];alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player} && {!(_target getVariable ['TSL_busy',false])}},{},[_op,_key],'',3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;_result pushBack [_a,[],_target];} forEach [['editorReturn',if (_ru) then {'Вернуть из инвентаря на место'} else {'Return inventory item to saved place'}],['editorForget',if (_ru) then {'Забыть это место'} else {'Forget saved place'}]];_result
};
private _ref=((_target getVariable ['TSL_editorAdded',[]]) select _i) select 1;private _info=[_ref] call TSL_fnc_gearInfo;if (_info isEqualTo []) exitWith {[]};
private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';private _actions=[];
{
 _x params ['_op','_label'];private _action=['TSL_'+_op,_label,'',{
  params ['_target','_player','_params'];[_target,_player,'editorGear',_params] remoteExecCall ['TSL_fnc_request',2];
 },{params ['_target','_player'];alive _player && {!(_target getVariable ['TSL_busy',false])} && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player} && {[_player,_target] call ace_common_fnc_canInteractWith}},{},[_key,_op],'',3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;
 _actions pushBack [_action,[],_target];
} forEach ([['take',if (_ru) then {'Взять'} else {'Take'}]]+ (if ((_info select 3)>=0) then {[['equip',if (_ru) then {'Надеть / экипировать'} else {'Equip'}]]} else {[]}));_actions
