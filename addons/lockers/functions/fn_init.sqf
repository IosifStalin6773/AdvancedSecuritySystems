params ['_l'];if (is3DEN || {!isServer}) exitWith {};
// Attached equipment needs a live parent transform on every client.
_l enableDynamicSimulation false;
_l enableSimulationGlobal true;_l setVelocity [0,0,0];
[_l] spawn {params ['_l'];waitUntil {!isNil 'TSL_registry'};
 if (_l getVariable ['TSL_initialized',false]) exitWith {};
 _l setVariable ['TSL_initialized',true];_l allowDamage false;
 _l addEventHandler ['Deleted',{
  params ['_locker'];if (!isServer) exitWith {};
  [_locker]call TSL_fnc_reconcileTransfer;[_locker] call TSL_fnc_save;
  {if (!isNull _x) then {deleteVehicle _x;};} forEach ((_locker getVariable ['TSL_editorObjects',[]])+(_locker getVariable ['TSL_extraObjects',[]])+(_locker getVariable ['TSL_visuals',[]])+(_locker getVariable ['TSL_decor',[]])+(_locker getVariable ['TSL_clamps',[]])+(_locker getVariable ['TSL_panels',[]])+[_locker getVariable ['TSL_crate',objNull]]);
 }];
 _l setVariable ['TSL_panelLayout',if (getNumber (configFile>>'CfgVehicles'>>typeOf _l>>'TSL_hasVelcro')==1) then {[0,1,2,3]} else {[-1,-1,-1,-1]},true];
 _l setVariable ['TSL_custom',parseSimpleArray str TSL_customDefault,true];_l setVariable ['TSL_owner','',true];_l setVariable ['TSL_gear',TSL_slots apply {[]},true];
 private _decor=getNumber (configFile>>'CfgVehicles'>>typeOf _l>>'TSL_defaultDecor')==1;
 _l setVariable ['TSL_patch',if (_decor) then {[0,9,12,13]} else {[-1,-1,-1,-1]},true];_l setVariable ['TSL_photo',if (_decor) then {[10,11,13]} else {[-1,-1,-1]},true];
 _l setVariable ['TSL_wallPhotos',[],true];
 _l setVariable ['TSL_adjust',TSL_slots apply {[0,0,0,0]},true];
 _l setVariable ['TSL_visuals',[]];_l setVariable ['TSL_decor',[]];TSL_registry pushBackUnique _l;[_l] call TSL_fnc_render;_l setVariable ['TSL_ready',true];
};
