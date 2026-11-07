params ['_l','_p','_token','_ok'];if (!isServer || {isNull _l}) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner!=owner _p}) exitWith {};
private _pending=_l getVariable ['TSL_pending',[]];
if !(_ok isEqualType true) exitWith {};
if (count _pending<3 || {(_pending select 0)!=_token} || {(_pending select 1)!=_p}) exitWith {};
_l setVariable ['TSL_busy',false,true];
_l setVariable ['TSL_pending',nil];
_l setVariable ['TSL_transferPlan',nil];

if (count _pending==8 && {(_pending select 3)=='editorReturn'}) exitWith {
 if ((_pending select 0)!=_token || {(_pending select 1)!=_p}) exitWith {};
 if (_ok) then {
  private _key=_pending select 4;private _ref=_pending select 5;(_pending select 7) params ['_home','_payload'];private _added=(_l getVariable ['TSL_editorAdded',[]]) select {(_x select 0)!=_key};
  _added pushBack [_key,_ref,_home select 2];_l setVariable ['TSL_editorAdded',_added,true];private _poses=(_l getVariable ['TSL_editorPoses',[]]) select {(_x select 0)!=_key};_poses pushBack [_key,_home select 2];_l setVariable ['TSL_editorPoses',_poses,true];
  private _payloads=(_l getVariable ['TSL_gearPayloads',[]]) select {(_x select 0)!=_key};_payloads pushBack [_key,_payload];_l setVariable ['TSL_gearPayloads',_payloads];_l setVariable ['TSL_editorRevision',(_l getVariable ['TSL_editorRevision',0])+1,true];[_l] call TSL_fnc_save;[_l] call TSL_fnc_render;
 };
 _l setVariable ['TSL_busy',false,true];_l setVariable ['TSL_pending',nil];
};
if (count _pending==7 && {(_pending select 3)=='editorGear'}) exitWith {
 if ((_pending select 0)!=_token || {(_pending select 1)!=_p}) exitWith {};
 if (_ok) then {
  private _added=_l getVariable ['TSL_editorAdded',[]];private _key=_pending select 4;private _ref=_pending select 5;private _i=_added findIf {(_x select 0)==_key && {(_x select 1)==_ref}};
  if (_i>=0) then {
 private _entry=_added select _i;private _poses=_l getVariable ['TSL_editorPoses',[]];private _pi=_poses findIf {(_x select 0)==_key};private _pose=if (_pi>=0) then {(_poses select _pi) select 1} else {_entry select 2};private _points=_l getVariable ['TSL_editorPoints',[]];private _point=_points findIf {(_x select 0)==_key};private _position=if (_point>=0) then {(_points select _point) select 1} else {_pose select 0};
 private _homes=(_l getVariable ['TSL_gearHomes',[]]) select {(_x select 0)!=_key};_homes pushBack [_key,_ref,_pose,_position];_l setVariable ['TSL_gearHomes',_homes,true];_l setVariable ['TSL_gearPayloads',(_l getVariable ['TSL_gearPayloads',[]]) select {(_x select 0)!=_key}];
 _added deleteAt _i;_l setVariable ['TSL_editorAdded',_added,true];_l setVariable ['TSL_editorPoses',(_l getVariable ['TSL_editorPoses',[]]) select {(_x select 0)!=_key},true];_l setVariable ['TSL_editorRevision',(_l getVariable ['TSL_editorRevision',0])+1,true];[_l] call TSL_fnc_save;[_l] call TSL_fnc_render;};
 };
 _l setVariable ['TSL_busy',false,true];_l setVariable ['TSL_pending',nil];
};
if (count _pending!=3 || {(_pending select 0)!=_token} || {(_pending select 1)!=_p}) exitWith {};
if (_ok) then {{private _slot=_x;if (count ((_l getVariable ['TSL_gear',[]]) param [_slot,[]])==0 && {count ((_pending select 2) param [_slot,[]])>0}) then {private _c=parseSimpleArray str (_l getVariable ['TSL_custom',TSL_customDefault]);while {count _c<15} do {_c pushBack (TSL_customDefault select (count _c));};_c set [([_slot] call TSL_backpackSettings) select 1,0];_l setVariable ['TSL_custom',_c,true];};} forEach TSL_backpackSlots;private _gear=_pending select 2;private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;private _poses=+(_c select 21);private _used=[];
{if (count (_gear param [_x,[]])>0) then {private _position=_poses select _forEachIndex;if (_position in _used) then {private _free=[3,1,2,4,5] select {!(_x in _used)};if (count _free>0) then {_position=_free select 0;_poses set [_forEachIndex,_position];};};if (_position>0) then {_used pushBack _position;};if (_position==5) then {_c set [3,true];_c set [19,1];};};} forEach TSL_rifleSlots;_c set [21,_poses];_l setVariable ['TSL_custom',_c,true];
_l setVariable ['TSL_gear',_pending select 2,true];[_l] call TSL_fnc_save;[_l] call TSL_fnc_render;};
_l setVariable ['TSL_busy',false,true];_l setVariable ['TSL_pending',nil];
