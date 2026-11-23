params [['_ref','',['']]];if (_ref=='') exitWith {[]};
private _cache=missionNamespace getVariable ['TSL_modelCache',createHashMap];private _cached=_cache getOrDefault [_ref,0];if (_cached isEqualType []) exitWith {_cached};
private _path='';private _cfg=configNull;private _label=_ref;
if ((_ref select [0,4])=='cfg:') then {
 private _p=_ref splitString ':';if (count _p==3 && {(_p select 1) in ['CfgVehicles','CfgWeapons','CfgMagazines','CfgGlasses','CfgAmmo']}) then {
  _cfg=configFile>>(_p select 1)>>(_p select 2);
  if (isClass _cfg) then {_path=getText (_cfg>>'model');if ((_p select 1)=='CfgMagazines') then {private _single=getText (_cfg>>'modelSpecial');if (_single!='' && {_single!='-'}) then {_path=_single;};};if ((_p select 1)=='CfgWeapons' && {getNumber (_cfg>>'ItemInfo'>>'type')!=801}) then {private _wear=getText (_cfg>>'ItemInfo'>>'uniformModel');if (_wear!='' && {_wear!='-'}) then {_path=_wear;};};_label=getText (_cfg>>'displayName');if (_label=='') then {_label=configName _cfg;};};
 };
} else {
 private _builtins=[true] call TSL_fnc_editorCatalog;private _i=_builtins findIf {(_x select 0)==_ref};
 if (_i>=0 || {_ref=='TSL_ExtraMagazines'}) then {_path='\TS_Lockers\'+_ref+'.p3d';_label=if (_i>=0) then {(_builtins select _i) select 1} else {'Magazine stack / Стопка магазинов'};};
};
private _result=[];
if (([_ref] call TSL_fnc_gearInfo) isNotEqualTo [] && {_path=='' || {_path=='-' } || {!fileExists (if ((toLower (_path select [(count _path-4) max 0]))=='.p3d') then {_path} else {_path+'.p3d'})}}) then {_path=getText (configFile>>'CfgVehicles'>>'Land_PlasticCase_01_small_F'>>'model');_label=_label+' [case / футляр]';};
if (_path!='' && {_path!='-'} && {(_path select [0,1])!='#'}) then {
 if ((toLower (_path select [(count _path-4) max 0]))!='.p3d') then {_path=_path+'.p3d';};
 if (fileExists _path) then {_result=[_path,_label,_cfg];};
};
_cache set [_ref,_result];missionNamespace setVariable ['TSL_modelCache',_cache];_result
