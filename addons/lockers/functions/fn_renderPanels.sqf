params ['_l'];if (!isServer) exitWith {};
private _layout=_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]];private _sh=(_l getVariable ['TSL_custom',TSL_customDefault]) select 6;private _shelf=([_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom) select 33;private _key=str [_shelf,_layout,_sh,getPosWorld _l,vectorDir _l,vectorUp _l];
if (_key==(_l getVariable ['TSL_panelKey',''])) exitWith {};
{if (!isNull _x) then {deleteVehicle _x;};} forEach (_l getVariable ['TSL_panels',[]]);private _objects=[];private _shelfCreated=false;
{if (_x>=0 && {_x<count TSL_panelDefs} && {_x!=6 || {!_shelfCreated}}) then {
 if (_x==6) then {_shelfCreated=true;};private _def=TSL_panelDefs select _x;private _model=if (_x==6) then {'TSL_VelcroShelfPanel'} else {if (_x<2) then {'TSL_VelcroPanel'} else {'TSL_VelcroSidePanel'}};
 private _o=createSimpleObject ['\TS_Lockers\'+_model+'.p3d',getPosWorld _l,true];private _pos=(_def select 1) vectorAdd (((_def select 2) vectorCrossProduct [0,0,1]) vectorMultiply (if (_x==6) then {0} else {_sh select _forEachIndex}));[_o,_l,_pos,_def select 2] call TSL_fnc_placeDisplay;_o disableCollisionWith _l;_o setVariable ['TSL_editKey','panel_'+str _forEachIndex,true];_o setVariable ['TSL_editLabel','Velcro panel '+str (_forEachIndex+1),true];_objects pushBack _o;
};} forEach _layout;
if (_shelf && {!_shelfCreated}) then {private _o=createSimpleObject ['\TS_Lockers\TSL_VelcroShelfPanel.p3d',[0,0,-1000],true];[_o,_l,[-.2997,-.5155,1.425],[0,1,0]] call TSL_fnc_placeDisplay;_o disableCollisionWith _l;_o setVariable ['TSL_editKey','panel_shelf',true];_o setVariable ['TSL_editLabel','Shelf velcro',true];_objects pushBack _o;};
_l setVariable ['TSL_panels',_objects];_l setVariable ['TSL_panelKey',_key];

[_l] call TSL_fnc_publishVisuals;
