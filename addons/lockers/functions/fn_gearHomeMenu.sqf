params ['_target','_player'];private _actions=[];private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';
{
 _x params ['_key','_ref'];private _info=[_ref] call TSL_fnc_gearInfo;
 if (_info isNotEqualTo [] && {((_target getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key})<0}) then {
  private _a=['TSL_home_'+_key,format ['%1 — %2 %3',_info select 4,if (_ru) then {'место'} else {'place'},_forEachIndex+1],'',{}, {true},{_this call TSL_fnc_gearMenu},[_key],'',3,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;_actions pushBack [_a,[],_target];
 };
} forEach (_target getVariable ['TSL_gearHomes',[]]);_actions
