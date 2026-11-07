params [['_ref',''],['_requireAllowed',true]];
private _parts=_ref splitString ':';if (count _parts!=3 || {(_parts select 0)!='cfg'}) exitWith {[]};
_parts params ['_prefix','_root','_class'];private _cfg=configFile>>_root>>_class;if (!isClass _cfg) exitWith {[]};
_class=configName _cfg;
private _kind='';private _index=-1;private _assigned=-1;
switch _root do {
 case 'CfgGlasses': {_kind='face';_index=7;};
 case 'CfgMagazines': {_kind='magazine';};
 case 'CfgVehicles': {if (getNumber (_cfg>>'isBackpack')==1) then {_kind='backpack';_index=5;};};
 case 'CfgWeapons': {
  private _item=getNumber (_cfg>>'ItemInfo'>>'type');private _type=getNumber (_cfg>>'type');_kind='item';
  switch _item do {case 605:{_kind='headgear';_index=6;};case 701:{_kind='vest';_index=4;};case 801:{_kind='uniform';_index=3;};case 616:{_kind='nvg';_index=9;_assigned=5;};};
  private _simulation=toLower getText (_cfg>>'simulation');private _link=['itemmap','itemgps','itemradio','itemcompass','itemwatch'] find _simulation;if (_link>=0) then {_kind='linked';_index=9;_assigned=_link;};
  if (_type in [1,2,4,4096] && {_item==0} && {_assigned<0}) then {_kind='weapon';_index=[1,2,4,4096] find _type;_index=[0,2,1,8] select _index;};
 };
};
if (_kind=='' || {_requireAllowed && {!([_class] call TSL_fnc_gearAllowed)}}) exitWith {[]};
[_root,_class,_kind,_index,getText (_cfg>>'displayName'),_assigned]
