params [['_l',objNull,[objNull]]];
if (!hasInterface || {isNull _l} || {is3DEN}) exitWith {};
player reveal _l;
if (isNil 'ace_interact_menu_fnc_compileMenu') exitWith {};
[_l] call ace_interact_menu_fnc_compileMenu;
if (_l getVariable ['TSL_actionsRegistered',false]) exitWith {};
_l setVariable ['TSL_actionsRegistered',true];
// The ordinary action is registered on the player so aiming at a display object
// works as well as aiming at the cabinet. ACE retains its authored interaction points.
