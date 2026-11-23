// [destino, minutos] (cliente, 1.24): vuelo de permiso. Pantalla en negro mientras despega y aviso de la vuelta.
params ["_dest", "_min"];
[_dest, _min] spawn {
    params ["_dest", "_min"];
    titleCut ["", "BLACK OUT", 2];
    sleep 2;
    titleText [format [("STR_ADVSEC_rnr_flight" call ADVSEC_fnc_L), _dest, _min], "BLACK FADED", 4];
    sleep 8;
    titleCut ["", "BLACK IN", 3];
    hint format [("STR_ADVSEC_rnr_on_leave" call ADVSEC_fnc_L), _min];
};
