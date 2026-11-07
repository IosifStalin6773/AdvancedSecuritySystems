// valor de config -> el mismo valor con los "$STR_ADVSEC_..." traducidos (también dentro de arrays)
if (_this isEqualType "") exitWith {if ((_this select [0, 12]) isEqualTo "$STR_ADVSEC_") then {(_this select [1]) call ADVSEC_fnc_L} else {_this}};
if (_this isEqualType []) exitWith {_this apply {_x call ADVSEC_fnc_Lc}};
_this
