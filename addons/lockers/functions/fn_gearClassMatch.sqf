params ['_actual','_base'];if !(_actual isEqualType '' && {_base isEqualType ''}) exitWith {false};
private _a=toLower _actual;private _b=toLower _base;
_a==_b || {(_b find 'acre_')==0 && {(_a find (_b+'_id_'))==0} && {isClass (configFile>>'CfgWeapons'>>_actual)}}
