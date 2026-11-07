params ['_l','_o','_scale',['_pivot',[]]];if (isNull _o || {!finite _scale}) exitWith {};
_scale=_scale max .001 min 20;private _old=(getObjectScale _o) max .001;private _bb=[_o] call TSL_fnc_editorBounds;private _centre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;
if (_pivot isEqualTo []) then {_pivot=AGLToASL (_o modelToWorld _centre);};
private _offset=(_o vectorModelToWorld _centre) vectorMultiply (_scale/_old);
private _pose=[_l,_o] call TSL_fnc_editorPose;_pose set [0,_l worldToModel (ASLToAGL (_pivot vectorDiff _offset))];_pose set [3,_scale];[_l,_o,_pose] call TSL_fnc_editorPose;
