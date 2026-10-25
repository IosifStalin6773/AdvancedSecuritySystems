params ["_kp"];
if (!createDialog "ADVSEC_Keypad") exitWith {};
ADVSEC_kpObj = _kp;
ADVSEC_kpInput = "";
((findDisplay 86100) displayCtrl 1001) ctrlSetText (_kp getVariable ["ADVSEC_kpLabel", "INTRODUZCA PIN"]);
["refresh"] call ADVSEC_fnc_keypadUI;
