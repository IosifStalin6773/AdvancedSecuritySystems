params ['_target','_player','_params'];private _actions=[];
private _language=profileNamespace getVariable ['TSL_uiLanguage','en'];private _epoch=[_target getVariable ['TSL_menuRevision',0],_target getVariable ['TSL_owner',''],getPlayerUID _player,_language];private _cache=_target getVariable ['TSL_menuCache',[]];
if (count _cache!=2 || {(_cache select 0) isNotEqualTo _epoch}) then {_cache=[_epoch,createHashMap];_target setVariable ['TSL_menuCache',_cache];};private _query=str _params;private _saved=(_cache select 1) getOrDefault [_query,false];if (_saved isEqualType []) exitWith {_saved};
private _make={params ['_id','_label','_args',['_children',{}]];private _a=[_id,_label,'',{params ['_target','_player','_params'];if ((_params select 0)=='language') exitWith {[(_params select 1) select 0,_target] call TSL_fnc_setLanguage;};[_target,_player,_params select 0,_params select 1] remoteExecCall ['TSL_fnc_request',2];},{true},_children,_args,'',2.5,[false,false,false,false,true]] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];};
if ((_target getVariable ['TSL_owner',''])=='') exitWith {['claim','Claim locker',['claim',[]]] call _make;_actions};
if ((_target getVariable ['TSL_owner',''])!=getPlayerUID _player) exitWith {[]};
switch (_params param [0,'root']) do {
 case 'aceRoot';case 'root':{
 if ((_params select 0)=='aceRoot') then {private _open=['openUI','Open personal locker','',{[_target] call TSL_fnc_openUI;},{true},{},[],[0,0,0],2.5] call TSL_fnc_createAction;_actions pushBack [_open,[],_target];};
 ['homes','Saved equipment positions / Сохранённые места',['none',[]],{params ['_target','_player'];[_target,_player] call TSL_fnc_gearHomeMenu;}] call _make;
 ['custom','Appearance',['none',[]],{params ['_target','_player'];[_target,_player,['custom']] call TSL_fnc_menu}] call _make;
  ['equipment','Equipment',['none',[]],{params ['_target','_player'];[_target,_player,['gear']] call TSL_fnc_menu}] call _make;
  ['photos','Photos',['none',[]],{params ['_target','_player'];[_target,_player,['photoWalls']] call TSL_fnc_menu}] call _make;
  ['settings','Settings',['none',[]],{params ['_target','_player'];[_target,_player,['settings']] call TSL_fnc_menu}] call _make;
  private _a=['storage','Open storage','',{private _crate=_target getVariable ['TSL_crate',objNull];if (!isNull _crate) then {_player action ['Gear',_crate];};},{true},{},[],[0,-.30,.43],2.5,[false,false,false,false,true]] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];
 };
 case 'photoWalls':{
 {private _a=['wall'+str _forEachIndex,_x select 0,'',{}, {true},{params ['_target','_player','_params'];[_target,_player,['photoAddChoices',_params select 0]] call TSL_fnc_menu;},[_forEachIndex],'',2.5] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];} forEach TSL_photoWalls;
 {private _a=['existing'+str _forEachIndex,format ['Photo %1: %2',_forEachIndex+1,(TSL_photoWalls select (_x select 0)) select 0],'',{}, {true},{params ['_target','_player','_params'];[_target,_player,['photoEdit',_params select 0]] call TSL_fnc_menu;},[_forEachIndex],'',2.5] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];} forEach (_target getVariable ['TSL_wallPhotos',[]]);
 };
 case 'photoAddChoices':{private _wall=_params select 1;{['add'+str _forEachIndex,_x select 0,['photoAdd',[_wall,_forEachIndex]]] call _make;} forEach TSL_photos;};
 case 'photoEdit':{private _i=_params select 1;['delete','Remove photograph',['photoDelete',[_i]]] call _make;{_x params ['_label','_axis','_delta'];['move'+str _forEachIndex,_label,['photoMove',[_i,_axis,_delta]]] call _make;} forEach [['Left',2,-.01],['Right',2,.01],['Up',3,.01],['Down',3,-.01]];};
 case 'backpackSlots':{
 private _bags=_target getVariable ['TSL_gear',[]];
 {private _slot=_x;private _occupied=count (_bags param [_slot,[]])>0;private _title=format ['Backpack %1: %2',(TSL_backpackSlots find _slot)+1,if (_occupied) then {'stored'} else {'empty'}];['bag'+str _slot,_title,['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['backpackPlacement',_params select 2]] call TSL_fnc_menu}] call _make;} forEach TSL_backpackSlots;
 };
 case 'backpackPlacement':{private _slot=_params param [1,6];private _positionIndex=([_slot] call TSL_backpackSettings) select 0;private _modelIndex=([_slot] call TSL_backpackSettings) select 1;

 ['model','Display model',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['backpackModels',_params select 2]] call TSL_fnc_menu}] call _make;
 ['position','Position',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['backpackPositions',_params select 2]] call TSL_fnc_menu}] call _make;
 private _occupied=count ((_target getVariable ['TSL_gear',[]]) param [_slot,[]])>0;[if (_occupied) then {'take'} else {'put'},if (_occupied) then {'Take backpack'} else {'Store equipped backpack'},[if (_occupied) then {'take'} else {'put'},[_slot]]] call _make;
 };
 case 'backpackModels':{private _slot=_params param [1,6];private _modelIndex=([_slot] call TSL_backpackSettings) select 1;
 ['auto','Automatic: match stored backpack',['custom',[_modelIndex,0]]] call _make;if (_slot!=17) then {['6500','Display variant: Mystery Ranch 6500',['custom',[_modelIndex,1]]] call _make;['satl','Display variant: Mystery Ranch SATL',['custom',[_modelIndex,2]]] call _make;};
 ['eagle','Eagle BATP: Chemlight',['custom',[_modelIndex,3]]] call _make;['eagleC','Eagle BATP: Blade Antenna',['custom',[_modelIndex,4]]] call _make;
 };
 case 'backpackPositions':{private _slot=_params param [1,6];private _positionIndex=([_slot] call TSL_backpackSettings) select 0;private _modelIndex=([_slot] call TSL_backpackSettings) select 1;
 private _custom=_target getVariable ['TSL_custom',TSL_customDefault];private _variant=_custom param [_modelIndex,0];private _bag=((_target getVariable ['TSL_gear',[]]) param [_slot,[]]) param [0,''];_bag=if (_bag isEqualType []) then {_bag param [0,'']} else {_bag};private _model=toLower getText (configFile>>'CfgVehicles'>>_bag>>'model');private _newBag=_slot==17 || {_variant in [3,4]} || {_variant==0 && {(_model find 'bsqdn_backpacks\eagle')>=0}};
 if (_newBag) then {
 ['leftSource','Left mount',['custom',[_positionIndex,0]]] call _make;['rightSource','Right mount',['custom',[_positionIndex,1]]] call _make;
 } else {
 ['inside','Backpack inside lower section',['custom',[_positionIndex,0]]] call _make;['top','Backpack on top of locker',['custom',[_positionIndex,1]]] call _make;['floor','Backpack beside locker on floor',['custom',[_positionIndex,2]]] call _make;
 };
 if (_variant==1 || {_variant==0 && {(_model find '6500')>=0}}) then {['caseTop','Backpack on new top case',['custom',[_positionIndex,3]]] call _make;};
 };
 case 'nvgPlacement':{['helmet','NVG on helmet',['custom',[4,0]]] call _make;['shelf','NVG on shelf',['custom',[4,1]]] call _make;};
 case 'resetConfirm':{['confirm','Confirm: erase stored gear and decorations',['reset',[]]] call _make;};
 case 'panelSlots':{
  for '_i' from 0 to 3 do {private _a=['panel'+str _i,'Panel '+str (_i+1),'',{}, {true},{params ['_target','_player','_params'];[_target,_player,['panelPlacement',_params select 0]] call TSL_fnc_menu;},[_i],'',2.5,[false,false,false,false,true]] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];};
 };
 case 'panelPlacement':{
 private _slot=_params select 1;['moveLeft','Move panel left',['panelShift',[_slot,-.01]]] call _make;['moveRight','Move panel right',['panelShift',[_slot,.01]]] call _make;
  private _slot=_params select 1;['removePanel','Remove velcro panel',['panel',[_slot,-1]]] call _make;
  {['position'+str _forEachIndex,_x select 0,['panel',[_slot,_forEachIndex]]] call _make;} forEach TSL_panelDefs;
 };
 case 'shelfStrip':{
 private _c=[_target getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 ['shelfVisible',if (_c select 33) then {'Hide shelf strip'} else {'Show shelf strip'},['shelfPanel',[!(_c select 33)]]] call _make;
 {['shelfPatch'+str _forEachIndex,_x,['none',[],_forEachIndex],{params ['_target','_player','_params'];[_target,_player,['shelfPatchSelect',_params select 2]] call TSL_fnc_menu}] call _make;} forEach ['Shelf patch 1','Shelf patch 2','Shelf patch 3','Shelf patch 4'];
 };
 case 'shelfPatchSelect':{
 private _slot=_params select 1;
 ['left','Move patch left',['shelfShift',[_slot,-.01]]] call _make;
 ['right','Move patch right',['shelfShift',[_slot,.01]]] call _make;
 ['resetPosition','Reset patch position',['shelfShift',[_slot,0]]] call _make;

 ['rotation','Patch rotation',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['shelfPatchRotation',_params select 2]] call TSL_fnc_menu}] call _make;
 ['remove','Remove',['shelfPatch',[_slot,-1]]] call _make;
 {['choice'+str _forEachIndex,_x select 0,['shelfPatch',[_slot,_forEachIndex]]] call _make;} forEach TSL_patches;
 };
 case 'shelfPatchRotation':{
 private _slot=_params select 1;
 {['rotate'+str _forEachIndex,_x select 0,['shelfRotate',[_slot,_x select 1]]] call _make;} forEach [['Turn left 5°',-5],['Turn right 5°',5],['Turn left 15°',-15],['Turn right 15°',15],['Rotate 90°',90],['Turn upside down',180],['Straighten patch',0]];
 };
 case 'custom':{
 ['sourceDetails','New details',['none',[]],{params ['_target','_player'];[_target,_player,['sourceDetails']] call TSL_fnc_menu}] call _make;
 ['shelfStrip','Shelf velcro strip',['none',[]],{params ['_target','_player'];[_target,_player,['shelfStrip']] call TSL_fnc_menu}] call _make;
 ['panels','Velcro panels',['none',[]],{params ['_target','_player'];[_target,_player,['panelSlots']] call TSL_fnc_menu}] call _make;
  if (((_target getVariable ['TSL_panelLayout',[-1,-1,-1,-1]]) findIf {_x>=0})>=0) then {['patches','Patches',['none',[]],{params ['_target','_player'];[_target,_player,['patchSlots']] call TSL_fnc_menu}] call _make;};

 ['names','Name tape',['none',[]],{params ['_target','_player'];[_target,_player,['nameSettings']] call TSL_fnc_menu}] call _make;
 ['uniform','Uniform and hanger',['none',[]],{params ['_target','_player'];[_target,_player,['uniformSettings']] call TSL_fnc_menu}] call _make;
 ['accessories','Shelf items',['none',[]],{params ['_target','_player'];[_target,_player,['accessories']] call TSL_fnc_menu}] call _make;
 ['backpack','Backpack 1: model and position',['none',[]],{params ['_target','_player'];[_target,_player,['backpackPlacement']] call TSL_fnc_menu}] call _make;
 ['backpack2','Backpack 2: model and position',['none',[]],{params ['_target','_player'];[_target,_player,['backpackPlacement',13]] call TSL_fnc_menu}] call _make;
 ['backpack3','Backpack 3 (Eagle)',['none',[]],{params ['_target','_player'];[_target,_player,['backpackPlacement',17]] call TSL_fnc_menu}] call _make;
 ['nvg','NVG position',['none',[]],{params ['_target','_player'];[_target,_player,['nvgPlacement']] call TSL_fnc_menu}] call _make;
 };
 case 'language':{['english','English',['language',['en']]] call _make;['russian','Русский',['language',['ru']]] call _make;};
 case 'sourceDetails':{
 private _c=[_target getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 ['flashbangs','Flashbangs',['none',[]],{params ['_target','_player'];[_target,_player,['flashbangs']] call TSL_fnc_menu}] call _make;
 ['headphones','Headphones',['none',[]],{params ['_target','_player'];[_target,_player,['headphones']] call TSL_fnc_menu}] call _make;
 ['glassesHook','Glasses hook',['none',[]],{params ['_target','_player'];[_target,_player,['hookChoice',0]] call TSL_fnc_menu}] call _make;
 ['headwearHook','Headwear hook',['none',[]],{params ['_target','_player'];[_target,_player,['hookChoice',1]] call TSL_fnc_menu}] call _make;
 ['lanyard',format ['Lanyard — %1',if (_c select 26) then {'Hide'} else {'Show'}],['custom',[26,!(_c select 26)]]] call _make;
 ['water','Water bottles',['none',[]],{params ['_target','_player'];[_target,_player,['waterBottles']] call TSL_fnc_menu}] call _make;
 ['case','Case variation',['none',[]],{params ['_target','_player'];[_target,_player,['caseSettings']] call TSL_fnc_menu}] call _make;
 };
 case 'hookChoice':{
 private _hook=_params select 1;
 ['empty','Empty hook',['hookChoice',[_hook,0]]] call _make;
 ['original',if (_hook==0) then {'Glasses on hook'} else {'Beanie on hook'},['hookChoice',[_hook,1]]] call _make;
 ['new',if (_hook==0) then {'Chest rig on hook'} else {'Helmet on hook'},['hookChoice',[_hook,2]]] call _make;
 };
 case 'waterBottles':{
 private _c=[_target getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 if ((_c select 29)<count TSL_waterModels) then {['add','Add one bottle',['waterStep',[1]]] call _make;};
 if ((_c select 29)>0) then {['remove','Remove one bottle',['waterStep',[-1]]] call _make;};
 };
 case 'flashbangs';case 'headphones':{
 private _index=if ((_params select 0)=='flashbangs') then {15} else {17};private _c=[_target getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 {['detail'+str _forEachIndex,format ['%1 %2 — %3',if (_index==15) then {'Flashbang'} else {'Headphones position'},_forEachIndex+1,if (_x) then {'Hide'} else {'Show'}],['sourceDetail',[_index,_forEachIndex,!_x]]] call _make;} forEach (_c select _index);
 };
 case 'caseSettings':{private _c=[_target getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;{_x params ['_index','_title'];private _on=_c select _index;['case'+str _index,format ['%1 — %2',_title,if (_on) then {'Hide'} else {'Show'}],['custom',[_index,!_on]]] call _make;} forEach [[3,'Upper case'],[23,'Lower case']];};
 case 'rifleSource':{private _slot=_params select 1;{['source'+str _forEachIndex,_x,['rifleSource',[_slot,_forEachIndex+1]]] call _make;} forEach ['Left front position','Front horizontal position','Right outside position','Inside weapon section','On top case'];if (_slot<2) then {['other','Other positions',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['rifleLegacy',_params select 2]] call TSL_fnc_menu}] call _make;};};
 case 'pistolSource':{private _slot=_params select 1;['source','Authored pistol position',['pistolSource',[_slot,1]]] call _make;['original','Original pistol position',['pistolSource',[_slot,0]]] call _make;};
 case 'uniformSettings':{['uniform1','Uniform display 1',['custom',[2,1]]] call _make;['uniform2','Uniform display 2',['custom',[2,2]]] call _make;};
 case 'accessories':{
 private _c=_target getVariable ['TSL_custom',TSL_customDefault];
 { _x params ['_idx','_title'];private _on=_c param [_idx,false];['decor'+str _idx,format ['%1 — %2',_title,if (_on) then {'Hide'} else {'Show'}],['custom',[_idx,!_on]]] call _make; } forEach [[3,'Upper case'],[23,'Lower case'],[9,'Magazines'],[10,'Knife'],[11,'Garmin'],[12,'Notebook']];
 };
 case 'nameSettings':{
 ['nameFront','Front top',['custom',[1,0]]] call _make;['nameInside','Right wall',['custom',[1,1]]] call _make;
 ['ea','EA callsigns',['none',[]],{params ['_target','_player'];[_target,_player,['nameCodes',0]] call TSL_fnc_menu}] call _make;
 ['eb','EB callsigns',['none',[]],{params ['_target','_player'];[_target,_player,['nameCodes',6]] call TSL_fnc_menu}] call _make;
 ['ec','EC callsigns',['none',[]],{params ['_target','_player'];[_target,_player,['nameCodes',12]] call TSL_fnc_menu}] call _make;
 ['nameOff','Remove name tape',['custom',[0,-1]]] call _make;
 };
 case 'nameCodes':{private _start=_params select 1;for '_i' from _start to (_start+5) do {['name'+str _i,TSL_nameCodes select _i,['custom',[0,_i]]] call _make;};};
 case 'settings':{
 ['language','Language',['none',[]],{params ['_target','_player'];[_target,_player,['language']] call TSL_fnc_menu}] call _make;
 ['restore','Restore saved equipment',['restore',[]]] call _make;
 ['save','Save',['save',[]]] call _make;
 ['release','Release locker',['release',[]]] call _make;
 ['reset','Reset save',['none',[]],{params ['_target','_player'];[_target,_player,['resetConfirm']] call TSL_fnc_menu}] call _make;
 };
 case 'rifleSlots':{
  {private _slot=_x;private _occupied=count ((_target getVariable ['TSL_gear',[]]) param [_slot,[]])>0;['rifle'+str _slot,format ['Primary weapon %1 · %2',_forEachIndex+1,if (_occupied) then {'stored'} else {'empty'}],['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['slot',_params select 2]] call TSL_fnc_menu}] call _make;} forEach TSL_rifleSlots;
 };
 case 'gear':{
  ['rifles','Rifles / 5 slots',['none',[]],{params ['_target','_player'];[_target,_player,['rifleSlots']] call TSL_fnc_menu}] call _make;
  {private _slot=_forEachIndex;if !(_slot in TSL_rifleSlots) then {private _occupied=count ((_target getVariable ['TSL_gear',[]]) param [_slot,[]])>0;private _label=(_x select 0)+(if (_occupied) then {' · stored'} else {' · empty'});['slot'+str _slot,_label,['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['slot',_params select 2]] call TSL_fnc_menu}] call _make;};} forEach TSL_slots;
 };
 case 'slot':{
  private _slot=_params select 1;
  if (_slot in TSL_backpackSlots) then {['backpack','Backpack model / position',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['backpackPlacement',_params select 2]] call TSL_fnc_menu}] call _make;};
  if (_slot in [3,4]) then {['pistolSource','Pistol placement',['none',[],_slot-3],{params ['_target','_player','_params'];[_target,_player,['pistolSource',_params select 2]] call TSL_fnc_menu}] call _make;};
  if (_slot in TSL_rifleSlots) then {['authored','Weapon placement',['none',[],TSL_rifleSlots find _slot],{params ['_target','_player','_params'];[_target,_player,['rifleSource',_params select 2]] call TSL_fnc_menu}] call _make;};
  private _occupied=count ((_target getVariable ['TSL_gear',[]]) param [_slot,[]])>0;
  if (_occupied) then {['take','Take equipment',['take',[_slot]]] call _make;
   ['adjust','Fine adjustment',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['fineAdjustment',_params select 2]] call TSL_fnc_menu}] call _make;
  } else {['put','Store equipped item',['put',[_slot]]] call _make;};
 };
 case 'rifleLegacy':{private _slot=(_params select 1)+1;['inside','Weapon inside locker',['riflePosition',[_slot-1,0]]] call _make;['floorLeft','Weapon leaning outside left',['riflePosition',[_slot-1,1]]] call _make;['floorRight','Weapon leaning outside right',['riflePosition',[_slot-1,2]]] call _make;['frontHorizontal','Front horizontal mount',['riflePosition',[_slot-1,3]]] call _make; };
 case 'fineAdjustment':{private _slot=_params select 1;
   { _x params ['_label','_axis','_delta'];['adj'+str _forEachIndex,_label,['adjust',[_slot,_axis,_delta]]] call _make;} forEach [['Left',0,-.01],['Right',0,.01],['Deeper',1,.01],['Forward',1,-.01],['Up',2,.01],['Down',2,-.01],['Rotate +5',3,5],['Rotate -5',3,-5]]; };
 case 'patchSlots';case 'photoSlots':{
  private _kind=if ((_params select 0)=='patchSlots') then {'patch'} else {'photo'};private _labels=if (_kind=='patch') then {['Front left','Front right','Left side','Right side']} else {['Photo upper left','Photo lower right','Photo middle']};
  {private _a=[_kind+str _forEachIndex,_x,'',{}, {true},{params ['_target','_player','_params'];[_target,_player,['select',_params select 0,_params select 1]] call TSL_fnc_menu;},[_kind,_forEachIndex],'',2.5,[false,false,false,false,true]] call TSL_fnc_createAction;_actions pushBack [_a,[],_target];} forEach _labels;
 };
 case 'patchRotation':{
 private _slot=_params select 1;
 {['rotate'+str _forEachIndex,_x select 0,['patchRotate',[_slot,_x select 1]]] call _make;} forEach [['Turn left 5°',-5],['Turn right 5°',5],['Turn left 15°',-15],['Turn right 15°',15],['Rotate 90°',90],['Turn upside down',180],['Straighten patch',0]];
 };
 case 'select':{
  _params params ['_ignore','_kind','_slot'];
  if (_kind=='patch') then {['rotation','Patch rotation',['none',[],_slot],{params ['_target','_player','_params'];[_target,_player,['patchRotation',_params select 2]] call TSL_fnc_menu}] call _make;};
  private _catalog=if (_kind=='patch') then {TSL_patches} else {TSL_photos};
  ['remove','Remove',[_kind,[_slot,-1]]] call _make;
  {['choice'+str _forEachIndex,_x select 0,[_kind,[_slot,_forEachIndex]]] call _make;} forEach _catalog;
 };
};(_cache select 1) set [_query,_actions];_actions
