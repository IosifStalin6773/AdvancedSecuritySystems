params [['_builtinsOnly',false]];
private _builtins=[
 ['TSL_SourceGlasses','Glasses / Очки'],['TSL_ExtraGarmin','Garmin'],
 ['TSL_SourceFlashbang0','Flashbang / Бэнг'],['TSL_SourceFlashbang1','Flashbang 2 / Бэнг 2'],
 ['TSL_ExtraKnife','Knife / Нож'],['TSL_ExtraNotebook','Notebook / Блокнот'],
 ['cfg:CfgMagazines:TACDEV_SR25_Mag','Single magazine / Один магазин'],['TSL_SourceBeanie','Beanie / Шапка'],
 ['TSL_SourceHeadphones0','Headphones / Наушники'],['TSL_SourceHeadphones1','Headphones 2 / Наушники 2'],
 ['TSL_NewLanyard','Lanyard / Шнурок'],['TSL_NewChestRig','Chest rig / Нагрудник'],
 ['TSL_NewHookHelmet','Helmet / Шлем'],['TSL_NewWater0','Water bottle / Бутылка']
];
_builtins=_builtins apply {
 private _ref=_x select 0;private _gear=(_ref find 'cfg:')==0;private _tags=if (_gear) then {['GEAR','SMALL']} else {if (_ref in ['TSL_SourceGlasses','TSL_ExtraGarmin','TSL_SourceFlashbang0','TSL_SourceFlashbang1','TSL_ExtraKnife','TSL_ExtraNotebook','TSL_NewWater0','TSL_NewLanyard']) then {['SMALL']} else {[]}};
 [_ref,(_x select 1)+(if (_gear) then {''} else {' [decor / декор]'}),'LOCAL',_tags]
};
_builtins=_builtins select {private _ref=_x select 0;if ((_ref find 'cfg:')!=0) then {true} else {private _p=_ref splitString ':';isClass (configFile>>(_p select 1)>>(_p select 2))}};
if (_builtinsOnly) exitWith {_builtins};
private _cached=missionNamespace getVariable ['TSL_fullCatalog',[]];if (_cached isNotEqualTo []) exitWith {_cached};
if !(missionNamespace getVariable ['TSL_catalogBuilding',false]) then {
 missionNamespace setVariable ['TSL_catalogBuilding',true];
 [] spawn {
  private _rows=[true] call TSL_fnc_editorCatalog;private _n=0;private _seen=createHashMapFromArray (_rows apply {[_x select 0,true]});
  missionNamespace setVariable ['TSL_catalogPhase','gear'];
  [''] call TSL_fnc_gearAllowed;
  // Resolve the exact arsenal first, without waiting for thousands of scenery models.
  {
   private _class=_x;
   {
    private _root=_x;private _canonical=configName (configFile>>_root>>_class);private _ref='cfg:'+_root+':'+_canonical;private _info=[_ref] call TSL_fnc_gearInfo;
    if (_info isNotEqualTo [] && {!(_seen getOrDefault [_ref,false])}) then {
     private _model=[_ref] call TSL_fnc_editorModel;
     if (_model isNotEqualTo []) then {private _tags=['GEAR'];if !((_info select 2) in ['uniform','vest','backpack','weapon','headgear']) then {_tags pushBack 'SMALL';};_rows pushBack [_ref,(_model select 1)+' ['+(_info select 1)+']',_root,_tags];_seen set [_ref,true];};
    };
   } forEach ['CfgWeapons','CfgMagazines','CfgGlasses','CfgVehicles'];
   _n=_n+1;if (_n mod 50==0) then {missionNamespace setVariable ['TSL_fullCatalog',+_rows];sleep .001;};
  } forEach (keys TSL_arsenalAllowed);
  missionNamespace setVariable ['TSL_fullCatalog',+_rows];missionNamespace setVariable ['TSL_catalogPhase','objects'];
  {
   private _root=_x;
   {
    private _class=configName _x;private _ref='cfg:'+_root+':'+_class;private _gear=[_ref,false] call TSL_fnc_gearInfo;
    if (_gear isEqualTo [] && {!(_seen getOrDefault [_ref,false])}) then {
     private _info=[_ref] call TSL_fnc_editorModel;
     if (_info isNotEqualTo []) then {
      private _tags=[];private _text=toLower (_class+' '+(_info select 1)+' '+getText (_x>>'editorSubcategory'));
      // Read configuration only: opening the catalog must not instantiate every model in the modpack.
      if (_root=='CfgVehicles' && {((['document','bottle','notebook','passport','file1','file2','paper','wallet','magazine','can_soda','canteen','camera','garmin','watch','optic','flashlight','inventoryitems','food','drink'] findIf {_text find _x>=0})>=0 && {getNumber (_x>>'mapSize')<=1.5}) || {getNumber (_x>>'scope')==2 && {getNumber (_x>>'mapSize')>0} && {getNumber (_x>>'mapSize')<=1} && {(_class isKindOf ['Thing',configFile>>'CfgVehicles']) || {_class isKindOf ['ThingX',configFile>>'CfgVehicles']}}}}) then {_tags pushBack 'SMALL';};
      _rows pushBack [_ref,(_info select 1)+' ['+_class+']',_root,_tags];_seen set [_ref,true];
     };
    };
    _n=_n+1;if (_n mod 100==0) then {missionNamespace setVariable ['TSL_fullCatalog',+_rows];sleep .001;};
   } forEach ('isClass _x' configClasses (configFile>>_root));
  } forEach ['CfgVehicles','CfgAmmo'];
  missionNamespace setVariable ['TSL_fullCatalog',_rows];missionNamespace setVariable ['TSL_catalogBuilding',false];
  missionNamespace setVariable ['TSL_catalogPhase','ready'];
 };
};
_builtins
