disableSerialization;private _display=findDisplay 78150;if (isNull _display) exitWith {};
private _selected=lbCurSel (_display displayCtrl 78151);private _entries=uiNamespace getVariable ['TSL_UI_entries',[]];
if (_selected<0 || {_selected>=count _entries}) exitWith {};
private _target=uiNamespace getVariable ['TSL_UI_locker',objNull];private _player=player;
if (isNull _target || {_player distance _target>3}) exitWith {closeDialog 0;};
private _a=(_entries select _selected) select 0;private _actionParams=_a select 6;
private _children=[_target,_player,_actionParams] call (_a select 5);
if (!isNil '_children' && {_children isEqualType []} && {count _children>0}) exitWith {
 private _history=uiNamespace getVariable ['TSL_UI_history',[]];_history pushBack _entries;uiNamespace setVariable ['TSL_UI_history',_history];[_children] call TSL_fnc_uiFill;
};
if ((_a select 0)=='storage') then {closeDialog 0;};
private _revision=_target getVariable ['TSL_menuRevision',0];private _language=profileNamespace getVariable ['TSL_uiLanguage','en'];
[_target,_player,_actionParams] call (_a select 3);
if ((_a select 0)!='storage') then {[_target,_revision,_language] spawn {params ['_l','_revision','_language'];private _deadline=diag_tickTime+2;waitUntil {sleep .03;isNull findDisplay 78150 || {isNull _l} || {(_l getVariable ['TSL_menuRevision',0])!=_revision} || {(profileNamespace getVariable ['TSL_uiLanguage','en'])!=_language} || {diag_tickTime>_deadline}};if (!isNull _l && {!isNull findDisplay 78150} && {player distance _l<3}) then {uiNamespace setVariable ['TSL_UI_history',[]];private _s=uiNamespace getVariable ['TSL_camera',createHashMap];if (_s getOrDefault ['useMode',false] && {!(_s getOrDefault ['options',false])}) then {['refresh'] call TSL_fnc_useUI;} else {[[_l,player,['root']] call TSL_fnc_menu] call TSL_fnc_uiFill;};};};};
