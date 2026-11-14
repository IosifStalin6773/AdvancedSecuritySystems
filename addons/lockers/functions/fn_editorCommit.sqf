params ['_l','_p','_args'];if (!isServer) exitWith {};if (_l getVariable ['TSL_busy',false]) exitWith {};
_args params [['_revision',-1],['_poses',[]],['_added',[]]];
if (_revision!=(_l getVariable ['TSL_editorRevision',0])) exitWith {['Layout changed. Reopen editor before applying.'] remoteExecCall ['TSL_fnc_notice',owner _p];};
if !([_l,_poses,_added] call TSL_fnc_editorValidate) exitWith {['Invalid editor layout rejected.'] remoteExecCall ['TSL_fnc_notice',owner _p];};
_l setVariable ['TSL_editorPoses',_poses,true];_l setVariable ['TSL_editorAdded',_added,true];_l setVariable ['TSL_editorRevision',_revision+1,true];
[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
['Layout saved.'] remoteExecCall ['TSL_fnc_notice',owner _p];
