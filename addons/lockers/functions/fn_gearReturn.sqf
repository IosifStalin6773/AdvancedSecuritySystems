params ['_l','_p','_args',['_requestLoadout',[]]];if (!isServer || {isNull _l} || {isNull _p} || {!isPlayer _p} || {!alive _p} || {_p distance _l>3} || {(_l getVariable ['TSL_owner',''])!=getPlayerUID _p} || {isRemoteExecuted && {remoteExecutedOwner!=owner _p}} || {_l getVariable ['TSL_busy',false]}) exitWith {};
private _key=_args param [0,''];private _homes=_l getVariable ['TSL_gearHomes',[]];private _hi=_homes findIf {(_x select 0)==_key};if (_hi<0 || {((_l getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key})>=0} || {count (_l getVariable ['TSL_editorAdded',[]])>=40}) exitWith {};
private _home=_homes select _hi;private _ref=_home select 1;private _info=[_ref] call TSL_fnc_gearInfo;if (_info isEqualTo []) exitWith {};
_info params ['_root','_class','_kind','_index'];private _before=if (count _requestLoadout==10) then {parseSimpleArray str _requestLoadout} else {getUnitLoadout _p};private _after=parseSimpleArray str _before;private _payload=[];
// Take an existing inventory copy first; retain rounds, attachments and unique ACRE IDs.
{
 private _piece=_after select _x;
 if (count _payload==0 && {count _piece==2}) then {
  private _rows=_piece select 1;private _ri=_rows findIf {private _value=_x select 0;private _name=if (_value isEqualType '') then {_value} else {_value param [0,'']};[_name,_class] call TSL_fnc_gearClassMatch};
  if (_ri>=0) then {private _row=parseSimpleArray str (_rows select _ri);_row set [1,1];_payload=['cargo',_row];private _n=((_rows select _ri) select 1)-1;if (_n<=0) then {_rows deleteAt _ri;} else {(_rows select _ri) set [1,_n];};};
 };
} forEach [3,4,5];
if (_payload isEqualTo [] && {_index>=0}) then {
 private _value=if (_index==9) then {(_after select 9) select (_info param [5,5])} else {_after select _index};private _name=if (_value isEqualType '') then {_value} else {_value param [0,'']};
 if ([_name,_class] call TSL_fnc_gearClassMatch) then {_payload=['equipped',_value];if (_index==9) then {(_after select 9) set [_info param [5,5],''];} else {_after set [_index,if (_index in [6,7]) then {''} else {[]}];};};
};
if (_payload isEqualTo []) exitWith {['You do not have this item. / У вас нет этого предмета.'] remoteExecCall ['TSL_fnc_notice',owner _p];};
private _token=(_l getVariable ['TSL_token',0])+1;_l setVariable ['TSL_token',_token];_l setVariable ['TSL_busy',true,true];_l setVariable ['TSL_pending',[_token,_p,_l getVariable ['TSL_gear',[]],'editorReturn',_key,_ref,_l getVariable ['TSL_editorRevision',0],[_home,_payload]]];
[_l,_p,_token,_before,_after] remoteExecCall ['TSL_fnc_applyTransfer',owner _p];
[_l,_p,_token,_before,_after] call TSL_fnc_watchTransfer;
