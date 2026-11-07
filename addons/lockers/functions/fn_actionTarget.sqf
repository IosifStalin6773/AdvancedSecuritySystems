params [['_targets',[cursorObject,cursorTarget]],['_viewer',player]];
if (isNull _viewer) exitWith {objNull};
private _locker=objNull;
{
 private _object=_x;
 for '_depth' from 0 to 3 do {
  if (isNull _object) exitWith {};
  private _root=if (_object isKindOf 'Land_TS_Locker_F') then {_object} else {_object getVariable ['TSL_locker',objNull]};
  if (!isNull _root && {_root isKindOf 'Land_TS_Locker_F'} && {_viewer distance _root<3}) exitWith {_locker=_root;};
  _object=attachedTo _object;
 };
 if (!isNull _locker) exitWith {};
} forEach _targets;
_locker
