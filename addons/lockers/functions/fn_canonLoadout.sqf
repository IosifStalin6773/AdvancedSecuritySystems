params ['_load'];private _v=parseSimpleArray str _load;
 {private _part=_v select _x;if (_part isEqualType [] && {count _part>0} && {(_part select 0) isEqualTo ''}) then {_v set [_x,[]];};} forEach [0,1,2,3,4,5,8];
 {
  private _part=_v select _x;
  if (count _part==2) then {
   private _rows=[];
   {private _row=+_x;if (count _row>=2 && {(_row select 1) isEqualType 0}) then {private _count=_row select 1;_row set [1,1];for '_i' from 1 to _count do {_rows pushBack str _row;};} else {_rows pushBack str _row;};} forEach (_part select 1);
   _rows sort true;_part set [1,_rows];_v set [_x,_part];
  };
 } forEach [3,4,5];_v
