// Immutable, one-time archive. Keep all established save and preset keys readable.
params ['_uid'];if (!isServer || {!(_uid isEqualType '')} || {_uid==''} || {count _uid>80}) exitWith {};
private _key='TSL_PreUpgradeBackup_v1_'+_uid;
if (!isNil {profileNamespace getVariable _key}) exitWith {};
private _saved=parseSimpleArray str(profileNamespace getVariable ['TS_Locker_v1_'+_uid,[]]);
private _equipment=parseSimpleArray str(profileNamespace getVariable ['TS_Locker_backup_'+_uid,[]]);
private _index=parseSimpleArray str(profileNamespace getVariable ['TSL_Presets_Index_'+_uid,[]]);
private _presets=[];
{private _id=_x param [0,''];if (_id isEqualType '' && {_id!=''}) then {_presets pushBack [_id,parseSimpleArray str(profileNamespace getVariable ['TSL_Preset_Data_'+_uid+'_'+_id,[]])];};}forEach _index;
profileNamespace setVariable [_key,[1,systemTimeUTC,_saved,_equipment,_index,_presets,profileNamespace getVariable ['TSL_Presets_Counter_'+_uid,0]]];
saveProfileNamespace;
