params ['_l'];
if (!hasInterface || {isNull _l}) exitWith {};
// The mission/editor state can arrive after init, so repair the local parent too.
_l enableDynamicSimulation false;
if (!simulationEnabled _l) then {_l enableSimulation true;};
if (isServer) exitWith {};
private _state=_l getVariable ['TSL_visualState',[]];
if (count _state!=2) exitWith {};
private _key=str _state;
if (_key==(_l getVariable ['TSL_clientVisualKey',''])) exitWith {};
private _simpleKey=str (_state select 0);
private _local=_l getVariable ['TSL_clientVisuals',[]];
if (_simpleKey!=(_l getVariable ['TSL_clientSimpleKey',''])) then {
{if (!isNull _x) then {deleteVehicle _x;};} forEach _local;
_local=[];
{
 _x params ['_model','_pose','_textures','_materials',['_editKey',''],['_editSlot',-1],['_editBase',[]],['_editLabel',''],['_editHidden',false],['_assetRef','']];
 private _o=if (_assetRef!='') then {[_assetRef] call TSL_fnc_editorSpawn} else {createSimpleObject [_model,[0,0,-1000],true]};
 if (!isNull _o) then {
  [_o]call TSL_fnc_lockDisplay;_o setVariable ['TSL_locker',_l];_o setVariable ['TSL_editKey',_editKey];_o setVariable ['TSL_editSlot',_editSlot];_o setVariable ['TSL_editBase',_editBase];_o setVariable ['TSL_editLabel',_editLabel];_o setVariable ['TSL_editorHidden',_editHidden];
  _o hideObject true;
  {_o setObjectTexture [_forEachIndex,_x];} forEach _textures;
  {_o setObjectMaterial [_forEachIndex,_x];} forEach _materials;
  _o hideSelection ['zasleh',true];_o hideSelection ['zasleh2',true];
  _o setVectorDirAndUp [_pose select 1,_pose select 2];_o setPosWorld (_pose select 0);_o setObjectScale (_pose param [3,1]);
  _o disableCollisionWith _l;_o hideObject _editHidden;_local pushBack _o;
 };
} forEach (_state select 0);
_l setVariable ['TSL_clientSimpleKey',_simpleKey];
};
private _complete=true;
{
 _x params ['_o','_pose'];
 if (isNull _o) then {_complete=false;} else {
  _o setVariable ['TSL_locker',_l];
  // Network-created equipment retains its actual cargo and class.
  // Its transform is authored by the server, never written back by a client.
  _o hideObject (_o getVariable ['TSL_editorHidden',false]);
 };
} forEach (_state select 1);
_l setVariable ['TSL_clientVisuals',_local];
if (_complete) then {_l setVariable ['TSL_clientVisualKey',_key];};
if (!_complete && {diag_tickTime>=(_l getVariable ['TSL_clientSyncAfter',0])}) then {
 _l setVariable ['TSL_clientSyncAfter',diag_tickTime+5];
 [_l] remoteExecCall ['TSL_fnc_publishVisuals',2];
};
