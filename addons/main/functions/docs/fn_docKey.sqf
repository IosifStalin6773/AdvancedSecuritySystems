// [unidad] -> clave del almacén de documentos: SteamID del jugador o "AI:netId"
params ["_unit"];
private _uid = getPlayerUID _unit;
[_uid, "AI:" + netId _unit] select (_uid isEqualTo "")
