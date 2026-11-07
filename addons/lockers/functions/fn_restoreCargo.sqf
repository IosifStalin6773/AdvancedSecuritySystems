params ['_box','_data'];
clearItemCargoGlobal _box;clearMagazineCargoGlobal _box;clearWeaponCargoGlobal _box;clearBackpackCargoGlobal _box;
_data params ['_items','_mags','_weapons','_nested'];
{private _count=(_items select 1) select _forEachIndex;if (_count>0) then {_box addItemCargoGlobal [_x,_count];};} forEach (_items select 0);
{_box addMagazineAmmoCargo [_x select 0,1,_x select 1];} forEach _mags;
{_box addWeaponWithAttachmentsCargoGlobal [_x,1];} forEach _weapons;
{
 _x params ['_class','_inside'];private _old=everyContainer _box;
 if (isClass (configFile>>'CfgVehicles'>>_class)) then {_box addBackpackCargoGlobal [_class,1];} else {_box addItemCargoGlobal [_class,1];};
 private _added=(everyContainer _box) select {!(_x in _old)};
 if (count _added>0) then {[(_added select 0) select 1,_inside] call TSL_fnc_restoreCargo;};
} forEach _nested;
