private _history=uiNamespace getVariable ['TSL_UI_history',[]];
if (count _history==0) exitWith {private _s=uiNamespace getVariable ['TSL_camera',createHashMap];if (_s getOrDefault ['useMode',false] && {!(_s getOrDefault ['options',false])}) then {['dismiss'] call TSL_fnc_useUI;};};
private _entries=_history deleteAt (count _history-1);uiNamespace setVariable ['TSL_UI_history',_history];[_entries] call TSL_fnc_uiFill;
