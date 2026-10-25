params ["_msg", ["_ok", false]];
playSound (["FD_CP_Not_Clear_F", "FD_CP_Clear_F"] select _ok);
if (isNull findDisplay 86100) exitWith {hint _msg};
["result", _msg] call ADVSEC_fnc_keypadUI;
if (_ok) then {[] spawn {sleep 1.2; if (!isNull findDisplay 86100) then {closeDialog 0}}};
