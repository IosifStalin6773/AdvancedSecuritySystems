params ['_l'];if (isServer && {_l getVariable ['TSL_busy',false]}) then {[_l]call TSL_fnc_reconcileTransfer;};_l setVariable ['TSL_gearHomes',[],true];_l setVariable ['TSL_gearPayloads',[]];{deleteVehicle _x} forEach (_l getVariable ['TSL_editorObjects',[]]);_l setVariable ['TSL_editorObjects',[]];_l setVariable ['TSL_editorAddedKey',''];_l setVariable ['TSL_editorPoses',[],true];_l setVariable ['TSL_editorAdded',[],true];_l setVariable ['TSL_editorRevision',0,true];{if (!isNull _x) then {deleteVehicle _x;};} forEach ((_l getVariable ['TSL_visuals',[]])+(_l getVariable ['TSL_decor',[]]));
private _crate=_l getVariable ['TSL_crate',objNull];if (!isNull _crate) then {deleteVehicle _crate;};
_l setVariable ['TSL_crate',objNull,true];_l setVariable ['TSL_visuals',[]];_l setVariable ['TSL_decor',[]];
_l setVariable ['TSL_owner','',true];_l setVariable ['TSL_gear',TSL_slots apply {[]},true];
_l setVariable ['TSL_wallPhotos',[],true];
_l setVariable ['TSL_patch',[-1,-1,-1,-1],true];_l setVariable ['TSL_photo',[-1,-1,-1],true];
_l setVariable ['TSL_busy',false,true];_l setVariable ['TSL_pending',nil];_l setVariable ['TSL_lastSave',''];

_l setVariable ['TSL_slotObjects',TSL_slots apply {objNull}];_l setVariable ['TSL_slotKeys',TSL_slots apply {''}];

_l setVariable ['TSL_holderAdjust',[0,0],true];[_l] call TSL_fnc_renderClamps;

_l setVariable ['TSL_decorKey',''];private _decor=getNumber (configFile>>'CfgVehicles'>>typeOf _l>>'TSL_defaultDecor')==1;
if (_decor) then {_l setVariable ['TSL_patch',[0,9,12,13],true];_l setVariable ['TSL_photo',[10,11,13],true];};[_l] call TSL_fnc_renderDecor;

_l setVariable ['TSL_panelLayout',if (getNumber (configFile>>'CfgVehicles'>>typeOf _l>>'TSL_hasVelcro')==1) then {[0,1,2,3]} else {[-1,-1,-1,-1]},true];[_l] call TSL_fnc_renderDecor;

_l setVariable ['TSL_custom',parseSimpleArray str TSL_customDefault,true];[_l] call TSL_fnc_renderExtras;
