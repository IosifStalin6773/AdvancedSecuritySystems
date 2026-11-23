params ['_o','_l','_offset','_dir','_up'];if (isNull _o || {isNull _l}) exitWith {};
private _bb=boundingBoxReal [_o,"Geometry"];private _physical=false;
private _items=weaponsItemsCargo _o;
if (count _items>0) then {
 private _class=(_items select 0) select 0;private _model=getText (configFile>>'CfgWeapons'>>_class>>'model');
 if (_model!='') then {private _probe=createSimpleObject [_model,[0,0,0],true];if (!isNull _probe) then {private _body=boundingBoxReal [_probe,'Geometry'];private _extent=(_body select 1) vectorDiff (_body select 0);if (((_extent select 0) max (_extent select 1) max (_extent select 2))>.3) then {_bb=_body;_physical=true;};deleteVehicle _probe;};};
};private _lo=[1e9,1e9,1e9];private _hi=[-1e9,-1e9,-1e9];
{private _xx=_x;{private _yy=_x;{private _q=_l worldToModel (ASLToAGL (_o modelToWorldWorld [_xx,_yy,_x]));for '_i' from 0 to 2 do {_lo set [_i,(_lo select _i) min (_q select _i)];_hi set [_i,(_hi select _i) max (_q select _i)];};} forEach [(_bb select 0) select 2,(_bb select 1) select 2];} forEach [(_bb select 0) select 1,(_bb select 1) select 1];} forEach [(_bb select 0) select 0,(_bb select 1) select 0];
private _off=+_offset;private _span=(_hi select 2)-(_lo select 2);
if (_span>.35 && {_span<2.5}) then {_off set [1,(_off select 1)+(-.525-(_hi select 1))];if (_physical) then {_off set [2,(_off select 2)+.005-(_lo select 2)];};} else {_off set [1,(_off select 1)-.08];};
_o attachTo [_l,_off];_o setVectorDirAndUp [_dir,_up];
diag_log format ['[TS Lockers] external weapon bounds %1 %2, final offset %3',_lo,_hi,_off];
