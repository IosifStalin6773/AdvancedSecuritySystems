params ['_l'];if (!isServer) exitWith {};
private _uid=_l getVariable ['TSL_owner',''];if (_uid=='') exitWith {};
[_uid]call TSL_fnc_migrateLegacy;
private _crate=_l getVariable ['TSL_crate',objNull];private _cargo=if (isNull _crate) then {[[[],[]],[],[],[]]} else {[_crate] call TSL_fnc_cargo};
private _data=[7,_l getVariable ['TSL_gear',[]],_l getVariable ['TSL_patch',[]],_l getVariable ['TSL_photo',[]],_l getVariable ['TSL_adjust',[]],_cargo,_l getVariable ['TSL_holderAdjust',[0,0]],_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]],_l getVariable ['TSL_custom',TSL_customDefault],_l getVariable ['TSL_wallPhotos',[]],_l getVariable ['TSL_editorPoses',[]],_l getVariable ['TSL_editorAdded',[]],_l getVariable ['TSL_gearHomes',[]],_l getVariable ['TSL_gearPayloads',[]]];
private _scenario=[_uid]call TSL_fnc_scenarioKey;
private _binding=[1,typeOf _l,vehicleVarName _l,(getPosWorld _l)apply{round(_x*1000)/1000},vectorDir _l,vectorUp _l];
private _bindingChanged=_binding isNotEqualTo(profileNamespace getVariable [_scenario+'_Locker',[]]);
if (_bindingChanged) then {profileNamespace setVariable [_scenario+'_Locker',_binding];};
private _serial=str _data;if (_serial==(_l getVariable ['TSL_lastSave',''])) exitWith {if (_bindingChanged) then {saveProfileNamespace;};};
_l setVariable ['TSL_menuRevision',(_l getVariable ['TSL_menuRevision',0])+1,true];
private _snapshot=parseSimpleArray _serial;profileNamespace setVariable [_scenario+'_Kit',_snapshot];profileNamespace setVariable ['TS_Locker_v1_'+_uid,parseSimpleArray _serial];saveProfileNamespace;_l setVariable ['TSL_lastSave',_serial];

// Mirror the authoritative snapshot to this player's own local profile as a backup.
private _players=allPlayers select {getPlayerUID _x==_uid};
if (_players isNotEqualTo []) then {[_uid,_data] remoteExecCall ['TSL_fnc_personalSnapshot',owner (_players select 0)];};
