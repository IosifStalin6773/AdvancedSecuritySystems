params ['_l'];if (!hasInterface || {isNull _l} || {is3DEN} || {isNil 'ace_interact_menu_fnc_addActionToObject'}) exitWith {};
private _language=profileNamespace getVariable ['TSL_uiLanguage','en'];private _key=str [_l getVariable ['TSL_editorAdded',[]],_l getVariable ['TSL_editorPoints',[]],_l getVariable ['TSL_editorPoses',[]],_l getVariable ['TSL_gearHomes',[]],_language];
if (_key==(_l getVariable ['TSL_gearActionKey',''])) exitWith {};
{[_l,0,_x] call ace_interact_menu_fnc_removeActionFromObject;} forEach (_l getVariable ['TSL_gearActionPaths',[]]);private _paths=[];
{
 _x params ['_id','_ref'];private _info=[_ref] call TSL_fnc_gearInfo;
 if (_info isNotEqualTo [] && {([_id] call TSL_fnc_stackKey)==''}) then {
  private _points=_l getVariable ['TSL_editorPoints',[]];private _point=_points findIf {(_x select 0)==_id};private _poses=_l getVariable ['TSL_editorPoses',[]];private _pi=_poses findIf {(_x select 0)==_id};private _hidden=_pi>=0 && {(_poses select _pi) param [2,false]};
  if (_point>=0 && {!_hidden}) then {
   private _action=['TSL_gear_'+_id,_info select 4,'',{}, {
    params ['_target','_player'];alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player} && {!(_target getVariable ['TSL_busy',false])} && {!((uiNamespace getVariable ['TSL_editor',createHashMap]) getOrDefault ['active',false])} && {[_player,_target] call ace_common_fnc_canInteractWith}
   },{_this call TSL_fnc_gearMenu},[_id],(_points select _point) select 1,3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;
   _paths pushBack ([_l,0,[],_action] call ace_interact_menu_fnc_addActionToObject);
  };
 };
} forEach (_l getVariable ['TSL_editorAdded',[]]);

{
 _x params ['_key','_ref','_pose'];private _info=[_ref] call TSL_fnc_gearInfo;
 if (_info isNotEqualTo [] && {([_key] call TSL_fnc_stackKey)==''} && {((_l getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key})<0}) then {
  private _action=['TSL_home_'+_key,(if (_language=='ru') then {'Вернуть: '} else {'Return: '})+(_info select 4),'',{}, {params ['_target','_player'];alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player} && {!(_target getVariable ['TSL_busy',false])}},{_this call TSL_fnc_gearMenu},[_key],_x param [3,_pose select 0],3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;
  _paths pushBack ([_l,0,[],_action] call ace_interact_menu_fnc_addActionToObject);
 };
} forEach (_l getVariable ['TSL_gearHomes',[]]);
_paths=[_l,_paths] call TSL_fnc_stackActions;
_l setVariable ['TSL_gearActionPaths',_paths];_l setVariable ['TSL_gearActionKey',_key];
