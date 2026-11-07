params ['_ref'];private _info=[_ref] call TSL_fnc_editorModel;if (_info isEqualTo []) exitWith {objNull};
_info params ['_path','_label','_cfg'];
// Eden weapon/magazine entries are containers with proxy cargo, not standalone meshes.
private _parts=_ref splitString ':';private _hasCargo=(count ('true' configClasses (_cfg>>'TransportWeapons'))+count ('true' configClasses (_cfg>>'TransportMagazines'))+count ('true' configClasses (_cfg>>'TransportItems')))>0;
if (_hasCargo && {count _parts==3} && {(_parts select 1)=='CfgVehicles'} && {(toLower getText (_cfg>>'vehicleClass')) in ['weaponsprimary','weaponssecondary','weaponshandguns','weaponsitems','magazines','items'] || {((toLower configName _cfg) find 'weapon_')==0}}) exitWith {
 private _weapons='true' configClasses (_cfg>>'TransportWeapons');private _magazines='true' configClasses (_cfg>>'TransportMagazines');private _items='true' configClasses (_cfg>>'TransportItems');private _o=objNull;
 if (count _weapons>0) then {_o=['cfg:CfgWeapons:'+getText ((_weapons select 0)>>'weapon')] call TSL_fnc_editorSpawn;} else {if (count _magazines>0) then {_o=['cfg:CfgMagazines:'+getText ((_magazines select 0)>>'magazine')] call TSL_fnc_editorSpawn;} else {if (count _items>0) then {_o=['cfg:CfgWeapons:'+getText ((_items select 0)>>'name')] call TSL_fnc_editorSpawn;};};};
 if (!isNull _o) then {_o setVariable ['TSL_assetRef',_ref];_o setVariable ['TSL_editLabel',_label];};_o
};
private _gearInfo=[_ref,false] call TSL_fnc_gearInfo;
if (_gearInfo isNotEqualTo [] && {(_gearInfo select 2)=='weapon'}) exitWith {
 private _o=createVehicleLocal ['GroundWeaponHolder_Scripted',[0,0,-1000],[],0,'CAN_COLLIDE'];clearWeaponCargo _o;clearMagazineCargo _o;clearItemCargo _o;clearBackpackCargo _o;_o addWeaponCargo [_gearInfo select 1,1];_o lockInventory true;_o enableSimulation false;_o allowDamage false;_o setVariable ['TSL_assetRef',_ref];_o setVariable ['TSL_editLabel',_label];_o setVariable ['TSL_localDisplay',true];_o setVariable ['TSL_weaponVisual',true];_o
};
private _original=getText (_cfg>>'model');if (_original!='' && {(toLower (_original select [(count _original-4) max 0]))!='.p3d'}) then {_original=_original+'.p3d';};private _shape=if ((_ref find 'cfg:CfgVehicles:')==0 && {toLower _original==toLower _path}) then {configName _cfg} else {_path};private _o=createSimpleObject [_shape,[0,0,-1000],true];if (isNull _o) exitWith {objNull};
if (!isNull _cfg) then {
 private _textures=getArray (_cfg>>'hiddenSelectionsTextures');if (_textures isEqualTo []) then {_textures=getArray (_cfg>>'ItemInfo'>>'hiddenSelectionsTextures');};
 {_o setObjectTexture [_forEachIndex,_x]} forEach _textures;
 {_o setObjectMaterial [_forEachIndex,_x]} forEach getArray (_cfg>>'hiddenSelectionsMaterials');
};
_o setVariable ['TSL_assetRef',_ref];_o setVariable ['TSL_editLabel',_label];private _gear=[_ref,false] call TSL_fnc_gearInfo;_o setVariable ['TSL_weaponVisual',_gear isNotEqualTo [] && {(_gear select 2)=='weapon'}];_o allowDamage false;_o hideSelection ['zasleh',true];_o hideSelection ['zasleh2',true];_o
