// Screen-space hit gate shared by navigation, hover and dragging.
disableSerialization;params [['_mouse',getMousePosition]];
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];
if !(_e getOrDefault ['active',false]) exitWith {
 private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _d=findDisplay 78150;private _blocked=false;
 {private _c=_d displayCtrl _x;if (!isNull _c && {ctrlShown _c}) then {private _p=ctrlPosition _c;if ((_mouse select 0)>=(_p select 0) && {(_mouse select 0)<=(_p select 0)+(_p select 2)} && {(_mouse select 1)>=(_p select 1)} && {(_mouse select 1)<=(_p select 1)+(_p select 3)}) then {_blocked=true;};};} forEach [78900,78901,78902,78903,78151,78154,78158,78159,78152];
 !_blocked && {(_mouse select 1)>safeZoneY+safeZoneH*.075} && {(_mouse select 1)<safeZoneY+safeZoneH*.93}
};
private _d=findDisplay 78150;private _blocked=false;
{private _c=_d displayCtrl _x;if (!isNull _c && {ctrlShown _c}) then {private _p=ctrlPosition _c;if ((_mouse select 0)>=(_p select 0) && {(_mouse select 0)<=(_p select 0)+(_p select 2)} && {(_mouse select 1)>=(_p select 1)} && {(_mouse select 1)<=(_p select 1)+(_p select 3)}) exitWith {_blocked=true;};};} forEach [78208,78221,78213,78205,78204,78224,78216,78200,78201,78202,78217,78203,78222,78223,78212,78206,78207,78214,78215,78218,78219,78220,78400,78500,78700,78225,78226];
!_blocked && {(_mouse select 1)>safeZoneY+safeZoneH*.075} && {(_mouse select 1)<safeZoneY+safeZoneH*.95}
