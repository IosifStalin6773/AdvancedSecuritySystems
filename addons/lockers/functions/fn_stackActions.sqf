params ['_l','_paths'];private _seen=[];
{private _key=_x select 0;private _id=[_key] call TSL_fnc_stackKey;
 if (_id!='' && {!(_id in _seen)}) then {
  _seen pushBack _id;private _state=[_l,_key] call TSL_fnc_stackState;
  if (_state isNotEqualTo []) then {
   _state params ['_id','_ref','_live','_missing','_total'];private _info=[_ref] call TSL_fnc_gearInfo;private _point=[];
   if (_live isNotEqualTo []) then {private _anchor=(_live select (count _live-1)) select 0;private _points=_l getVariable ['TSL_editorPoints',[]];private _pi=_points findIf {(_x select 0)==_anchor};if (_pi>=0) then {_point=(_points select _pi) select 1;};};
   if (_point isEqualTo [] && {_missing isNotEqualTo []}) then {private _home=_missing select 0;_point=_home param [3,(_home select 2) select 0];};
   if (_point isNotEqualTo []) then {
    private _label=format ['%1  %2/%3',_info select 4,count _live,_total];
    private _a=['TSL_stack_'+_id,_label,'',{}, {params ['_target','_player'];alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player} && {!(_target getVariable ['TSL_busy',false])} && {!((uiNamespace getVariable ['TSL_editor',createHashMap]) getOrDefault ['active',false])} && {[_player,_target] call ace_common_fnc_canInteractWith}},{_this call TSL_fnc_stackMenu},[_key],_point,3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;
    _paths pushBack ([_l,0,[],_a] call ace_interact_menu_fnc_addActionToObject);
   };
  };
 };
} forEach ((_l getVariable ['TSL_editorAdded',[]])+(_l getVariable ['TSL_gearHomes',[]]));_paths
