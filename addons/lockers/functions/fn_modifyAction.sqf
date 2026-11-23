params ['_target','_player','_actionParams','_action'];
_action set [1,[_action select 1] call TSL_fnc_localize];

private _id=_action select 0;if ((_id select [0,10])=='ItemAction') then {private _slot=parseNumber (_id select [10]);private _points=(_target getVariable ['TSL_editorPoints',[]]) select {(_x select 2)==_slot};if (count _points>0) then {_action set [7,(_points select 0) select 1];};};
