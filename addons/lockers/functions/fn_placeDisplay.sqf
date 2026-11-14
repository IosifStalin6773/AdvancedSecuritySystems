params ['_o','_l','_pos','_dir',['_up',[0,0,1]]];
if (isNull _o || {isNull _l}) exitWith {};
detach _o;
_o setVectorDirAndUp [_l vectorModelToWorld _dir,_l vectorModelToWorld _up];
_o setPosWorld (_l modelToWorldWorld _pos);
