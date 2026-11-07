disableSerialization;params ['_entries'];
private _display=findDisplay 78150;if (isNull _display) exitWith {};
uiNamespace setVariable ['TSL_UI_entries',_entries];
private _list=_display displayCtrl 78151;lbClear _list;
{private _a=_x select 0;_list lbAdd (_a select 1);} forEach _entries;
if (count _entries==0) then {_list lbAdd (['This locker belongs to another player'] call TSL_fnc_localize);};
_list lbSetCurSel 0;
private _l=uiNamespace getVariable ['TSL_UI_locker',objNull];private _owner=_l getVariable ['TSL_owner',''];
(_display displayCtrl 78154) ctrlSetText ([(if (_owner=='') then {'Empty locker - claim it to begin'} else {if (_owner==getPlayerUID player) then {'Your locker - automatic saving enabled'} else {'Locker occupied'}})] call TSL_fnc_localize);

{if (ctrlType _x in [0,1,2]) then {_x ctrlSetText ([ctrlText _x] call TSL_fnc_localize);};} forEach allControls _display;

private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';(_display displayCtrl 78155) ctrlSetText (if (_ru) then {'WASD: движение | Q/E: вверх/вниз\nПКМ: обзор | Колесо: зум\nShift: быстро | Ctrl: точно'} else {'WASD: move | Q/E: up/down\nRMB: look | Wheel: zoom\nShift: fast | Ctrl: precise'});(_display displayCtrl 78156) ctrlSetText (if (_ru) then {'СБРОС КАМЕРЫ [R]'} else {'Reset camera'});
