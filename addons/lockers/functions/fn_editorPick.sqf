params ['_proxies','_origin','_ray','_mouse',['_locker',objNull]];
private _best=[];private _nearBest=1e10;private _fallback=[];private _fallbackScore=1e10;private _fallbackDepth=1e10;
private _end=_origin vectorAdd (_ray vectorMultiply 20);
// Real surface hits take precedence over bounding boxes, even when a rear object's centre is closer to the cursor.
private _surfaces=lineIntersectsSurfaces [_origin,_end,_locker,player,true,64,'VIEW','FIRE',true];
{
 private _hit=_x;private _i=_proxies findIf {(_x select 1) in [_hit select 2,_hit select 3] && {!isObjectHidden (_x select 1)}};
 if (_i>=0) exitWith {_best=_proxies select _i;_nearBest=(_hit select 0) distance _origin;};
} forEach _surfaces;
// A foreground prop without a collision LOD must still be selectable before a rear surface.
{
 private _o=_x select 1;
 if (!isNull _o && {!isObjectHidden _o}) then {
  private _ro=_o worldToModel (ASLToAGL _origin);private _rd=(_o worldToModel (ASLToAGL (_origin vectorAdd _ray))) vectorDiff _ro;
  private _bb=[_o] call TSL_fnc_editorBounds;private _lo=_bb select 0;private _hi=_bb select 1;private _near=0;private _far=20;private _hit=true;
  for '_axis' from 0 to 2 do {private _v=_rd select _axis;private _p=_ro select _axis;if (abs _v<.000001) then {if (_p<(_lo select _axis) || {_p>(_hi select _axis)}) then {_hit=false;};} else {private _a=((_lo select _axis)-_p)/_v;private _b=((_hi select _axis)-_p)/_v;_near=_near max (_a min _b);_far=_far min (_a max _b);};};
  private _surface=_surfaces findIf {_o in [_x select 2,_x select 3]};if (_surface>=0) then {_near=((_surfaces select _surface) select 0) distance _origin;};
  if (((_hit && {_far>=_near}) || {_surface>=0}) && {_near<_nearBest}) then {_nearBest=_near;_best=_x;};
  private _centre=_o modelToWorld ((_lo vectorAdd _hi) vectorMultiply .5);private _screen=worldToScreen _centre;
  if (count _screen==2) then {
   private _dx=((_screen select 0)-(_mouse select 0))/pixelW;private _dy=((_screen select 1)-(_mouse select 1))/pixelH;private _distance=sqrt (_dx*_dx+_dy*_dy);private _depth=_centre distance (ASLToAGL _origin);
   if (_distance<14 && {_depth<20} && {_distance<_fallbackScore-.5 || {abs (_distance-_fallbackScore)<=.5 && {_depth<_fallbackDepth}}}) then {_fallback=_x;_fallbackScore=_distance;_fallbackDepth=_depth;};
  };
 };
} forEach _proxies;
// Pixel tolerance is used only for empty space, never to select through a directly hit foreground object.
if (_best isEqualTo []) then {_best=_fallback;};_best
