// [unidad] -> clave del almacén de documentos: SteamID del jugador o "AI:netId"
params ["_unit"];
private _uid = getPlayerUID _unit;
[_uid, "AI:" + (_unit call BIS_fnc_netId)] select (_uid isEqualTo "")
