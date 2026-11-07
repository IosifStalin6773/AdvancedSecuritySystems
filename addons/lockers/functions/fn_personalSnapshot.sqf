// Only accept the owner's server-issued snapshot. It is a local backup, never a client authority for cargo.
params ['_uid','_data'];
if (!hasInterface || {isRemoteExecuted && {remoteExecutedOwner!=2}}) exitWith {};
if (isNull player || {_uid!=getPlayerUID player}) exitWith {};
if !(_data isEqualType [] && {count _data>=6} && {(_data select 0) isEqualType 0} && {count str _data<500000}) exitWith {};
private _scenarioKey=([_uid]call TSL_fnc_scenarioKey)+'_PlayerBackup';private _key='TSL_PersonalLocker_v1_'+_uid;private _serial=str _data;
if (_serial==str(profileNamespace getVariable [_key,[]]) && {_serial==str(profileNamespace getVariable [_scenarioKey,[]])}) exitWith {};
profileNamespace setVariable [_scenarioKey,parseSimpleArray _serial];profileNamespace setVariable [_key,parseSimpleArray _serial];saveProfileNamespace;
