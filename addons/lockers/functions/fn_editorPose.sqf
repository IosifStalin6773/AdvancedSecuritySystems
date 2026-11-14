params ['_l','_o',['_pose',[]]];
if (isNull _l || {isNull _o}) exitWith {[]};
if (_pose isEqualTo []) exitWith {private _v=[_l worldToModel (ASLToAGL getPosWorld _o),vectorNormalized (_l vectorWorldToModel vectorDir _o),vectorNormalized (_l vectorWorldToModel vectorUp _o),getObjectScale _o];private _offset=_o getVariable ['TSL_interactionOffset',[]];if (_offset isNotEqualTo []) then {_v pushBack _offset;};_v};
private _scale=_pose param [3,1];private _pos=_pose select 0;private _dir=vectorNormalized (_pose select 1);private _up=vectorNormalized (_pose select 2);
_o setVariable ['TSL_interactionOffset',_pose param [4,_o getVariable ['TSL_interactionOffset',[]]]];
detach _o;
if (isSimpleObject _o || {_o getVariable ['TSL_editorGhost',false]}) then {_o setVectorDirAndUp [_l vectorModelToWorld _dir,_l vectorModelToWorld _up];_o setPosWorld (AGLToASL (_l modelToWorld _pos));} else {_o attachTo [_l,_pos];_o setVectorDirAndUp [_dir,_up];_o setPosWorld getPosWorld _o;};
_o setObjectScale _scale;
_pose
