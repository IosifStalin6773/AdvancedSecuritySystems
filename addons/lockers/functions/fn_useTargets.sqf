// [key, kind, payload, label, world point, actual visual]
params ['_l'];private _rows=[];private _points=_l getVariable ['TSL_editorPoints',[]];
private _sources=if (isServer) then {(_l getVariable ['TSL_slotObjects',[]])+(_l getVariable ['TSL_editorObjects',[]])} else {(_l getVariable ['TSL_clientVisuals',[]])+(((_l getVariable ['TSL_visualState',[[],[]]]) select 1) apply {_x select 0})};
private _visual={params ['_key'];private _i=_sources findIf {(_x getVariable ['TSL_editKey',''])==_key};if (_i<0) then {objNull} else {_sources select _i}};
{private _slot=_forEachIndex;private _key='slot_'+str _slot;private _i=_points findIf {(_x select 0)==_key};private _pos=if (_i>=0) then {(_points select _i) select 1} else {_x select 2};_rows pushBack [_key,'slot',_slot,[_x select 0] call TSL_fnc_localize,_l modelToWorld _pos,[_key] call _visual];} forEach TSL_slots;
private _groups=[];
{
 _x params ['_key','_ref','_pose'];private _info=[_ref] call TSL_fnc_gearInfo;
 if (_info isNotEqualTo []) then {
  private _group=[_key] call TSL_fnc_stackKey;
  if (_group=='') then {
   private _pi=_points findIf {(_x select 0)==_key};private _point=if (_pi>=0) then {(_points select _pi) select 1} else {_x param [3,_pose select 0]};
   private _poses=_l getVariable ['TSL_editorPoses',[]];private _i=_poses findIf {(_x select 0)==_key};private _hidden=_i>=0 && {(_poses select _i) param [2,false]};
   if (!_hidden) then {_rows pushBack [_key,'gear',_key,_info select 4,_l modelToWorld _point,[_key] call _visual];};
  } else {
   if !(_group in _groups) then {
    _groups pushBack _group;private _state=[_l,_key] call TSL_fnc_stackState;
    if (_state isNotEqualTo []) then {
     _state params ['_id','_ref','_live','_missing','_total'];private _anchor='';private _point=[];
     if (_live isNotEqualTo []) then {private _v=_live select (count _live-1);_anchor=_v select 0;private _pi=_points findIf {(_x select 0)==_anchor};_point=if (_pi>=0) then {(_points select _pi) select 1} else {(_v select 2) select 0};} else {if (_missing isNotEqualTo []) then {private _home=_missing select 0;_point=_home param [3,(_home select 2) select 0];};};
     if (_point isNotEqualTo []) then {_rows pushBack [_group,'stack',_key,format ['%1  %2/%3',_info select 4,count _live,_total],_l modelToWorld _point,[_anchor] call _visual,_live apply {[_x select 0] call _visual}];};
    };
   };
  };
 };
} forEach ((_l getVariable ['TSL_editorAdded',[]])+((_l getVariable ['TSL_gearHomes',[]]) select {private _key=_x select 0;((_l getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key})<0}));
_rows

