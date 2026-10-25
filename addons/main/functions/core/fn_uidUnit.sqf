// [SteamID] -> jugador conectado con ese SteamID (objNull si no está)
params ["_uid"];
private _i = allPlayers findIf {getPlayerUID _x isEqualTo _uid};
allPlayers param [_i, objNull]
