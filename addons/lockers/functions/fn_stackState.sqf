params ['_l','_key'];private _id=[_key] call TSL_fnc_stackKey;if (_id=='') exitWith {[]};
private _all=_l getVariable ['TSL_editorAdded',[]];private _homes=_l getVariable ['TSL_gearHomes',[]];private _members=(_all+_homes) select {([_x select 0] call TSL_fnc_stackKey)==_id};if (_members isEqualTo []) exitWith {[]};
private _ref=(_members select 0) select 1;private _info=[_ref] call TSL_fnc_gearInfo;if (_info isEqualTo [] || {(_info select 2)!='magazine'}) exitWith {[]};
private _poses=_l getVariable ['TSL_editorPoses',[]];private _ids=[];{if ((_x select 1)==_ref) then {_ids pushBackUnique (_x select 0);};} forEach _members;
private _live=_all select {(_x select 0) in _ids && {private _k=_x select 0;private _i=_poses findIf {(_x select 0)==_k};_i<0 || {!((_poses select _i) param [2,false])}}};
private _missing=_homes select {(_x select 0) in _ids && {private _k=_x select 0;(_all findIf {(_x select 0)==_k})<0}};
[_id,_ref,_live,_missing,count _ids]
