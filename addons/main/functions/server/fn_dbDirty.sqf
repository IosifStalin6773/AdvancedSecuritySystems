// ["rep"|"jail"|"wanted"|"docs"|"log"|"ev"|"heat"|"fines"|"players"|"admins"] (servidor): marca una base de datos para el próximo guardado
params ["_which"];
if (!isServer) exitWith {};
private _d = localNamespace getVariable ["ADVSEC_dbDirty", []];
_d pushBackUnique _which;
localNamespace setVariable ["ADVSEC_dbDirty", _d];
