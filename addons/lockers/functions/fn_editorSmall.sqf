params ['_class','_path'];
private _cfg=configFile>>'CfgVehicles'>>_class;if (getNumber (_cfg>>'scope')!=2 || {getNumber (_cfg>>'mapSize')>1.5 || {getNumber (_cfg>>'mapSize')<=0}} || {_class isKindOf ['AllVehicles',configFile>>'CfgVehicles']}) exitWith {false};
private _cache=missionNamespace getVariable ['TSL_smallModelCache',createHashMap];private _key=toLower _path;private _known=_cache getOrDefault [_key,-1];if (_known isEqualType true) exitWith {_known};
private _probe=createSimpleObject [_path,[0,0,-1000],true];private _small=false;
if (!isNull _probe) then {private _b=[_probe] call TSL_fnc_editorBounds;private _extent=(_b select 1) vectorDiff (_b select 0);private _max=(_extent select 0) max (_extent select 1) max (_extent select 2);_small=_max>.005 && {_max<=.85};deleteVehicle _probe;};
_cache set [_key,_small];missionNamespace setVariable ['TSL_smallModelCache',_cache];_small
