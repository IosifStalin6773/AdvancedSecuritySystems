params ['_l'];if (!isServer || {isNull _l}) exitWith {};
private _extra=_l getVariable ['TSL_editorAdded',[]];private _added=_l getVariable ['TSL_editorObjects',[]];
if (str _extra!=(_l getVariable ['TSL_editorAddedKey',''])) then {
 {deleteVehicle _x} forEach _added;_added=[];
 {_x params ['_key','_model','_pose'];private _o=[_model] call TSL_fnc_editorSpawn;_o setVariable ['TSL_editKey',_key];_o setVariable ['TSL_editLabel',([_model] call TSL_fnc_editorModel) select 1];_o setVariable ['TSL_editBase',_pose];_o disableCollisionWith _l;_added pushBack _o;} forEach _extra;
 _l setVariable ['TSL_editorObjects',_added];_l setVariable ['TSL_editorAddedKey',str _extra];
};
private _objects=[];
{if (!isNull _x) then {_x setVariable ['TSL_editKey','slot_'+str _forEachIndex,true];_x setVariable ['TSL_editSlot',_forEachIndex,true];_x setVariable ['TSL_editLabel',(TSL_slots select _forEachIndex) select 0,true];_objects pushBack _x;};} forEach (_l getVariable ['TSL_slotObjects',[]]);
private _counts=createHashMap;
{if (!isNull _x) then {private _m=toLower ((getModelInfo _x) select 1);private _n=_counts getOrDefault [_m,0];_counts set [_m,_n+1];_x setVariable ['TSL_editKey','detail_'+_m+'_'+str _n,true];_x setVariable ['TSL_editLabel',(getModelInfo _x) select 0,true];_objects pushBack _x;};} forEach (_l getVariable ['TSL_extraObjects',[]]);
{_objects append (_l getVariable [_x,[]]);} forEach ['TSL_decor','TSL_panels','TSL_clamps'];
_objects append _added;private _poses=_l getVariable ['TSL_editorPoses',[]];private _points=[];
{
 private _key=_x getVariable ['TSL_editKey',''];private _base=_x getVariable ['TSL_editBase',[]];
 if (_base isEqualTo []) then {_base=[_l,_x] call TSL_fnc_editorPose;_x setVariable ['TSL_editBase',_base,true];_x setVariable ['TSL_editParent',attachedTo _x];};
 _x setVariable ['TSL_interactionOffset',[]];private _i=_poses findIf {(_x select 0)==_key};
 if (_i>=0) then {[_l,_x,(_poses select _i) select 1] call TSL_fnc_editorPose;_x setVariable ['TSL_editOverridden',true];} else {
  if (_x getVariable ['TSL_editOverridden',false] || {_key select [0,6]=='added_'}) then {[_l,_x,_base] call TSL_fnc_editorPose;_x setVariable ['TSL_editOverridden',false];};
 };
 private _hidden=_i>=0 && {(_poses select _i) param [2,false]};_x setVariable ['TSL_editorHidden',_hidden,true];_x hideObjectGlobal _hidden;
 private _b=[_x] call TSL_fnc_editorBounds;private _centre=((_b select 0) vectorAdd (_b select 1)) vectorMultiply .5;
 private _offset=_x getVariable ['TSL_interactionOffset',[]];private _p=_l worldToModel (_x modelToWorld (if (_offset isEqualTo []) then {_centre} else {_offset}));_points pushBack [_key,_p,_x getVariable ['TSL_editSlot',-1],_x getVariable ['TSL_editLabel',_key]];
} forEach _objects;
_l setVariable ['TSL_editorPoints',_points,true];
