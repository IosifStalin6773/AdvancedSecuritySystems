// [unidad] -> "Sargento PM" / "Comisario AA.II." / "" según su placa de mayor rango
params ["_unit"];
private _ai = [_unit, "AI"] call ADVSEC_fnc_rankLevel;
if (_ai > 0) exitWith {format [("STR_ADVSEC_ia_2" call ADVSEC_fnc_L), (["ranksAI", []] call ADVSEC_fnc_setting) param [_ai - 1, ""]]};
private _pm = [_unit, "PM"] call ADVSEC_fnc_rankLevel;
if (_pm > 0) exitWith {format [("STR_ADVSEC_mp" call ADVSEC_fnc_L), (["ranksPM", []] call ADVSEC_fnc_setting) param [_pm - 1, ""]]};
""
