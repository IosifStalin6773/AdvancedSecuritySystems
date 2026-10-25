// [filas, [puedePM, puedeAI, puedeGlobal, nivelPM, nivelAI]] (cliente): respuesta del servidor
params ["_rows", "_rights"];
if (isNull findDisplay 87700) exitWith {};
ADVSEC_pdbRows = _rows;
ADVSEC_pdbRights = _rights;
["filter"] call ADVSEC_fnc_pdbAction;
