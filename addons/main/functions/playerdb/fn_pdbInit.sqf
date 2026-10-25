// (servidor): registro de conexiones para la base de datos de jugadores
if (!isServer || {!isNil "ADVSEC_pdbEH"}) exitWith {};
[] call ADVSEC_fnc_pdbDB;
localNamespace setVariable ["ADVSEC_pdbSince", createHashMap];
ADVSEC_pdbEH = [
    addMissionEventHandler ["PlayerConnected", {
        params ["", "_uid", "_name"];
        [_uid, _name, true] call ADVSEC_fnc_pdbSeen;
    }],
    addMissionEventHandler ["PlayerDisconnected", {
        params ["", "_uid"];
        [_uid] call ADVSEC_fnc_pdbLeft;
    }]
];
// Jugadores ya conectados (anfitrión o reinicio de misión)
{[getPlayerUID _x, name _x, true] call ADVSEC_fnc_pdbSeen} forEach (allPlayers - entities "HeadlessClient_F");
