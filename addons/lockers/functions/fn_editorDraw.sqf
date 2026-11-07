disableSerialization;
params [['_command','draw']];
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];
private _lines=_e getOrDefault ['overlayLines',[]];private _labels=_e getOrDefault ['overlayLabels',[]];
if (_command=='clear') exitWith {{if (!isNull _x) then {ctrlDelete _x;};} forEach (_lines+_labels);_e set ['overlayLines',[]];_e set ['overlayLabels',[]];};
{if (!isNull _x) then {_x ctrlShow false;};} forEach (_lines+_labels);
private _d=findDisplay 78150;if (isNull _d || {!(_e getOrDefault ['active',false])}) exitWith {};
private _locker=(uiNamespace getVariable ['TSL_camera',createHashMap]) getOrDefault ['locker',objNull];if (isNull _locker || {(_locker getVariable ['TSL_owner',''])!=getPlayerUID player}) exitWith {};
if (_e getOrDefault ['objectsOpen',false] || {_e getOrDefault ['catalogOpen',false]} || {(uiNamespace getVariable ['TSL_presets',createHashMap]) getOrDefault ['active',false]} || {(uiNamespace getVariable ['TSL_themeState',createHashMap]) getOrDefault ['active',false]}) exitWith {};
_e set ['overlayLines',_lines];_e set ['overlayLabels',_labels];
private _lineIndex=0;private _labelIndex=0;
private _drawLine={
 params ['_a','_b','_color'];private _pa=worldToScreen _a;private _pb=worldToScreen _b;
 if (count _pa!=2 || {count _pb!=2}) exitWith {};
 private _dx=((_pb select 0)-(_pa select 0))/pixelW;private _dy=((_pb select 1)-(_pa select 1))/pixelH;private _length=sqrt (_dx*_dx+_dy*_dy);
 if (_length<.5 || {_length>10000}) exitWith {};
 private _c=controlNull;if (_lineIndex<count _lines) then {_c=_lines select _lineIndex;};
 if (isNull _c) then {_c=_d ctrlCreate ['TSL_EditorAxisLine',-1];_c setVariable ['TSL_editorOverlay',true];_c ctrlEnable false;if (_lineIndex<count _lines) then {_lines set [_lineIndex,_c];} else {_lines pushBack _c;};};
 // Use an actual padded picture: procedural colour textures do not rotate in Arma.
 private _kind=if (_length>700) then {'fine'} else {if (_length>120) then {'medium'} else {if (_length>25) then {'short'} else {'tiny'}}};
 private _texture='\TS_Lockers\data\editor_axis_line_'+_kind+'_ca.paa';
 if ((_c getVariable ['TSL_lineTexture',''])!=_texture) then {_c ctrlSetText _texture;_c setVariable ['TSL_lineTexture',_texture];};
 _c ctrlSetTextColor _color;_c ctrlSetDisabledColor _color;
 // A physical square allows the line to rotate without clipping its ends.
 private _width=_length*pixelW;private _height=_length*pixelH;
 _c ctrlSetPosition [((_pa select 0)+(_pb select 0))*.5-_width*.5,((_pa select 1)+(_pb select 1))*.5-_height*.5,_width,_height];
 _c ctrlCommit 0;_c ctrlSetAngle [_dy atan2 _dx,.5,.5];_c ctrlShow true;
 _lineIndex=_lineIndex+1;_e set ['overlayVisibleLines',_lineIndex];
};
private _drawIcon={
 params ['_texture','_color','_p','_w','_h','_angle','_text','_shadow','_size'];
 private _screen=worldToScreen _p;if (count _screen!=2) exitWith {};
 private _c=controlNull;if (_labelIndex<count _labels) then {_c=_labels select _labelIndex;};
 if (isNull _c) then {_c=_d ctrlCreate ['TSL_EditorAxisLabel',-1];_c setVariable ['TSL_editorOverlay',true];_c ctrlEnable false;if (_labelIndex<count _labels) then {_labels set [_labelIndex,_c];} else {_labels pushBack _c;};};
 _c ctrlSetText _text;_c ctrlSetTextColor _color;_c ctrlSetDisabledColor _color;_c ctrlSetFontHeight _size;
 private _width=if (count _text>1) then {.40} else {.035};_c ctrlSetPosition [(_screen select 0)-_width*.5,(_screen select 1)-.035,_width,.035];_c ctrlCommit 0;_c ctrlShow true;
 _labelIndex=_labelIndex+1;_e set ['overlayVisibleLabels',_labelIndex];
};
_e set ['overlayVisibleLines',0];_e set ['overlayVisibleLabels',0];
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];if !(_e getOrDefault ['active',false]) exitWith {};
private _hover=_e getOrDefault ['hover',[]];
if (_hover isNotEqualTo [] && {(_hover select 0)!=(_e getOrDefault ['selected',''])}) then {
 private _h=_hover select 1;if (!isNull _h) then {private _bb=[_h] call TSL_fnc_editorBounds;private _p=_h modelToWorldVisual (((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5);['',[.3,.85,1,1],_p,.7,.7,0,_hover select 5,1,.028,'RobotoCondensed'] call _drawIcon;};
};
private _o=_e getOrDefault ['ghost',objNull];if (isNull _o) exitWith {};
private _l=(uiNamespace getVariable ['TSL_camera',createHashMap]) get 'locker';private _bb=[_o] call TSL_fnc_editorBounds;private _centre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;if ((_e get 'mode')=='POINT') then {private _offset=_o getVariable ['TSL_interactionOffset',[]];if (_offset isNotEqualTo []) then {_centre=_offset;};};private _p=_o modelToWorldVisual _centre;
['', [1,.8,.25,1],_p,1,1,0,if ((_e get 'mode')=='POINT') then {'Interaction point'} else {_e getOrDefault ['label','']},1,.032,'RobotoCondensed'] call _drawIcon;
private _corners=[];{private _x0=_x;{private _y0=_x;{_corners pushBack (_o modelToWorldVisual [_x0,_y0,_x]);} forEach [(_bb select 0) select 2,(_bb select 1) select 2];} forEach [(_bb select 0) select 1,(_bb select 1) select 1];} forEach [(_bb select 0) select 0,(_bb select 1) select 0];
{[_corners select (_x select 0),_corners select (_x select 1),[1,.8,.25,.9]] call _drawLine;} forEach [[0,1],[0,2],[0,4],[1,3],[1,5],[2,3],[2,6],[3,7],[4,5],[4,6],[5,7],[6,7]];
private _stroke=_drawLine;
private _axes=[[1,0,0],[0,1,0],[0,0,1]];private _colors=[[1,.2,.2,1],[.2,1,.3,1],[.25,.55,1,1]];
{
 private _i=_forEachIndex;private _end=_p vectorAdd ((_l vectorModelToWorld _x) vectorMultiply .42);[_p,_end,_colors select _i] call _stroke;['',_colors select _i,_end,0,0,0,['X','Y','Z'] select _i,1,.04] call _drawIcon;
 private _wing=_l vectorModelToWorld (_axes select ((_i+1) mod 3));private _back=_end vectorDiff ((_l vectorModelToWorld _x) vectorMultiply .045);[_end,_back vectorAdd (_wing vectorMultiply .022),_colors select _i] call _stroke;[_end,_back vectorDiff (_wing vectorMultiply .022),_colors select _i] call _stroke;
 if ((_e get 'mode')=='ROTATE') then {private _a=_l vectorModelToWorld (_axes select ((_i+1) mod 3));private _b=_l vectorModelToWorld (_axes select ((_i+2) mod 3));private _last=_p vectorAdd (_a vectorMultiply .32);for '_t' from 10 to 360 step 10 do {private _next=(_p vectorAdd (_a vectorMultiply (.32*cos _t))) vectorAdd (_b vectorMultiply (.32*sin _t));[_last,_next,_colors select _i] call _stroke;_last=_next;};};
} forEach _axes;
