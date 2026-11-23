// [texto estructurado, título] (cliente): muestra una ficha larga (hoja de servicio, sentencia) en el panel genérico
params ["_txt", ["_title", ""]];
if (_title isEqualTo "") then {_title = "STR_ADVSEC_car_b_record" call ADVSEC_fnc_L};
["carShow", _title, [], {}] call ADVSEC_fnc_panelOpen;
["carShow", "", [[_title, "", _txt, [], ""]]] call ADVSEC_fnc_panelSet;
