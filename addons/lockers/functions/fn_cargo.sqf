params ['_box'];
private _items=getItemCargo _box;private _containers=everyContainer _box;private _nested=[];
{
 _x params ['_class','_container'];_nested pushBack [_class,[_container] call TSL_fnc_cargo];
 private _index=(_items select 0) find _class;if (_index>=0) then {(_items select 1) set [_index,((_items select 1) select _index)-1];};
} forEach _containers;
[_items,magazinesAmmoCargo _box,weaponsItemsCargo _box,_nested]
