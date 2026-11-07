private _s=uiNamespace getVariable ['TSL_camera',createHashMap];
private _hover=_s getOrDefault ['useHover',[]];private _selected=_s getOrDefault ['useSelected',[]];
{if (_x isNotEqualTo []) then {private _color=if (_forEachIndex==0) then {[.35,.85,1,1]} else {[.9,.9,.86,.85]};drawIcon3D ['',_color,_x select 4,0,0,0,_x select 3,1,.027,'RobotoCondensed'];};} forEach [_hover,if (_selected isNotEqualTo [] && {_hover isEqualTo [] || {(_hover select 0)!=(_selected select 0)}}) then {_selected} else {[]}];

{if (true) then {private _screen=worldToScreen (_x select 4);if (count _screen==2 && {_screen distance2D getMousePosition<.10}) then {drawIcon3D ['', [.7,.75,.78,.5],_x select 4,0,0,0,'·',1,.035,'RobotoCondensed'];};};} forEach (_s getOrDefault ['useTargets',[]]);
