// Cliente: pide al servidor sus documentos (persisten en el servidor por SteamID) y la documentación automática
if (!hasInterface || {isNull player}) exitWith {};
["sync", player] remoteExecCall ["ADVSEC_fnc_docServer", 2];
