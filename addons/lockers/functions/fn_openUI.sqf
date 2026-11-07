params [['_l',objNull,[objNull]]];if (isNull _l || {!hasInterface} || {player distance _l>3}) exitWith {};
if (!isNil 'ADVSEC_fnc_lockerGate' && {!([_l,player,'open'] call ADVSEC_fnc_lockerGate)}) exitWith {};
uiNamespace setVariable ['TSL_UI_locker',_l];
if !(createDialog 'TSL_LockerDialog') exitWith {hint 'Locker interface could not open';};
uiNamespace setVariable ['TSL_UI_history',[]];
private _entries=[_l,player,['root']] call TSL_fnc_menu;
[_entries] call TSL_fnc_uiFill;

disableSerialization;[_l,findDisplay 78150] call TSL_fnc_cameraStart;
