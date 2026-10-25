// [campo (5 PM, 6 AA.II., 7 global), valor] -> texto del rango
params ["_i", "_v"];
if (_i == 7) exitWith {(["ranksGlobal", []] call ADVSEC_fnc_setting) param [_v, str _v]};
if (_v < 0) exitWith {"según misión"};
if (_v == 0) exitWith {"sin rango"};
([["ranksPM", []] call ADVSEC_fnc_setting, ["ranksAI", []] call ADVSEC_fnc_setting] select (_i == 6)) param [_v - 1, str _v]
