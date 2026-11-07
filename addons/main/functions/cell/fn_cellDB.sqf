/*
    (servidor) -> hashmap uid -> [rol, nombre, estado, ticksDisponible, ticksServicio]
    Células operativas de la PMC: CP (protección cercana), QRF (reacción rápida) y SEC (Inteligencia/Compliance).
    Estados (en español): Disponible, Movilizado, Descanso. También carga las estadísticas de la QRF (ADVSEC_qrfStats):
    uid -> [respuestas, segundosTotales, bonusTotal, ignoradas].
*/
private _db = localNamespace getVariable "ADVSEC_cellDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {private _e = +(_x select 1); _e set [2, "Disponible"]; _db set [_x select 0, _e]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_cells", []]);
localNamespace setVariable ["ADVSEC_cellDB", _db];
private _st = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_st set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_qrf", []]);
localNamespace setVariable ["ADVSEC_qrfStats", _st];
localNamespace setVariable ["ADVSEC_qrfRuns", createHashMap];
missionNamespace setVariable ["ADVSEC_cellRoles", (keys _db) apply {[_x, (_db get _x) select 0, (_db get _x) select 2]}, true];
_db
