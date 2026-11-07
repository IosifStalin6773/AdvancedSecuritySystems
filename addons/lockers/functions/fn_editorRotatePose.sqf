// Rotate about the visible model centre in locker coordinates, retaining scale and point metadata.
params ['_pose','_axis','_angle','_centre'];
_axis=vectorNormalized _axis;
private _rotate={params ['_v'];((_v vectorMultiply cos _angle) vectorAdd ((_axis vectorCrossProduct _v) vectorMultiply sin _angle)) vectorAdd (_axis vectorMultiply ((_axis vectorDotProduct _v)*(1-cos _angle)))};
private _dir=vectorNormalized (_pose select 1);private _up=vectorNormalized (_pose select 2);private _right=vectorNormalized (_dir vectorCrossProduct _up);
_up=vectorNormalized (_right vectorCrossProduct _dir);
private _scale=_pose param [3,1];
private _offset=((_right vectorMultiply (_centre select 0)) vectorAdd (_dir vectorMultiply (_centre select 1))) vectorAdd (_up vectorMultiply (_centre select 2));
private _pivot=(_pose select 0) vectorAdd (_offset vectorMultiply _scale);
private _newDir=vectorNormalized ([_dir] call _rotate);private _newUp=vectorNormalized ([_up] call _rotate);private _newRight=vectorNormalized (_newDir vectorCrossProduct _newUp);_newUp=vectorNormalized (_newRight vectorCrossProduct _newDir);
private _newOffset=((_newRight vectorMultiply (_centre select 0)) vectorAdd (_newDir vectorMultiply (_centre select 1))) vectorAdd (_newUp vectorMultiply (_centre select 2));
private _result=+_pose;_result set [0,_pivot vectorDiff (_newOffset vectorMultiply _scale)];_result set [1,_newDir];_result set [2,_newUp];_result
