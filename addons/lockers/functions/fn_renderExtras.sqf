params ['_l'];if (!isServer) exitWith {};
private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;private _key=str [_c,getPosWorld _l,vectorDir _l,vectorUp _l];
if (_key==(_l getVariable ['TSL_extraKey',''])) exitWith {};
{if (!isNull _x) then {deleteVehicle _x;};} forEach (_l getVariable ['TSL_extraObjects',[]]);private _objs=[];
private _spawn={params ['_model','_pos','_dir'];private _o=if (_model=='TSL_NameTape') then {createVehicle ['TSL_NameTape',[0,0,-1000],[],0,'CAN_COLLIDE']} else {createSimpleObject ['\TS_Lockers\'+_model+'.p3d',[0,0,-1000],true]};_o hideObjectGlobal true;_o enableSimulationGlobal false;_o allowDamage false;[_o,_l,_pos,_dir] call TSL_fnc_placeDisplay;_o disableCollisionWith _l;_o hideObjectGlobal false;_objs pushBack _o;_o};
['TSL_UniformDisplay'+str (_c select 2),[0,0,0],[0,1,0]] call _spawn;
['TSL_ClothesHanger'+str (_c select 2),[0,0,0],[0,1,0]] call _spawn;
if (_c select 3) then {[if ((_c select 19)==1) then {'TSL_SourceCase'} else {'TSL_DisplayCase'},[0,0,0],[0,1,0]] call _spawn;};
if (_c select 23 && {!(_c select 3 && {(_c select 19)==0})}) then {['TSL_DisplayCase',[0,0,0],[0,1,0]] call _spawn;};
{if (_c param [9+_forEachIndex,false]) then {[_x,[0,0,0],[0,1,0]] call _spawn;};} forEach ['TSL_ExtraMagazines','TSL_ExtraKnife','TSL_ExtraGarmin','TSL_ExtraNotebook'];
{if (_x) then {['TSL_SourceFlashbang'+str _forEachIndex,[0,0,0],[0,1,0]] call _spawn;};} forEach (_c select 15);
if (_c select 16 && {!(_c select 28)}) then {['TSL_SourceBeanie',[0,0,0],[0,1,0]] call _spawn;};
{if (_x) then {['TSL_SourceHeadphones'+str _forEachIndex,[0,0,0],[0,1,0]] call _spawn;};} forEach (_c select 17);
if (_c select 18 && {!(_c select 27)}) then {['TSL_SourceGlasses',[0,0,0],[0,1,0]] call _spawn;};
if (_c select 26) then {['TSL_NewLanyard',[0,0,0],[0,1,0]] call _spawn;};
if (_c select 27) then {['TSL_NewChestRig',[0,0,0],[0,1,0]] call _spawn;};
if (_c select 28) then {['TSL_NewHookHelmet',[0,0,0],[0,1,0]] call _spawn;};
{if (_forEachIndex<(_c select 29)) then {[_x,[0,0,0],[0,1,0]] call _spawn;};} forEach TSL_waterModels;
if ((_c select 0)>=0) then {
 private _pos=if ((_c select 1)==0) then {[-.12,-.526,1.735]} else {[-.055,-.24,1.605]};
 private _dir=if ((_c select 1)==0) then {[0,1,0]} else {[1,0,0]};
 private _o=['TSL_NameTape',_pos,_dir] call _spawn;
 _o setObjectTextureGlobal [0,'\TS_Lockers\data\update\name_'+(TSL_nameCodes select (_c select 0))+'_co.paa'];
};
_l setVariable ['TSL_extraObjects',_objs];_l setVariable ['TSL_extraKey',_key];

[_l] call TSL_fnc_publishVisuals;
