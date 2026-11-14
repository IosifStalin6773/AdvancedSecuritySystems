/*
    Módulo de Eden «Encargo a medida» (isGlobal = 0: solo servidor, 1.20.1).
    Crea al empezar la misión una oferta configurada desde el propio módulo: tipo, cliente (nombre y reputación),
    bando y clases de los NPC, número de NPC, área (el área del módulo en Eden), pago, minutos y título.
    Si se sincroniza con un objeto, ese objeto es lo que hay que proteger (VIP) o recuperar (carga).
    Lo que quede vacío usa la configuración (ContractTypes, contractHostileSide, contractHostileClasses…).
    No se duplica al reiniciar la misión: si ya hay una oferta o un encargo activo de este módulo, no crea otro.
*/
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
if (_logic getVariable ["ADVSEC_ccDone", false]) exitWith {};
_logic setVariable ["ADVSEC_ccDone", true];
[_logic] spawn {
    params ["_logic"];
    sleep 3;
    private _type = _logic getVariable ["Type", "checkpoint"];
    private _area = _logic getVariable ["objectArea", [150, 150, 0, false, -1]];
    private _rad = (((_area param [0, 150]) max (_area param [1, 150])) max 30) min 1000;
    private _side = toLower (_logic getVariable ["Side", ""]);
    // «clase:peso, clase:peso» -> lista con cada clase repetida según su peso (para elegir al azar)
    private _cls = [];
    {
        _x params [["_c", ""], ["_w", "1"]];
        _c = _c trim [" ", 0];
        if (isClass (configFile >> "CfgVehicles" >> _c)) then {for "_i" from 1 to (((round parseNumber _w) max 1) min 10) do {_cls pushBack _c}};
    } forEach (((_logic getVariable ["Units", ""]) splitString ",") apply {_x splitString ":"});
    private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
    private _key = format ["eden:%1:%2", _type, (getPosATL _logic) apply {round _x}];
    private _db = [] call ADVSEC_fnc_ctrDB;
    if ((values _db) findIf {(_x getOrDefault ["edenKey", ""]) == _key && {(_x get "state") in ["Ofertado", "Firmado", "En curso", "Revisión"]}} >= 0) exitWith {};
    ["offer", objNull, [
        _type, _logic getVariable ["Client", ""], getPosATL _logic, _rad,
        _logic getVariable ["Pay", 0], _logic getVariable ["Minutes", 0], [],
        _objs param [0, objNull], _logic getVariable ["Title", ""], -1, -1,
        _side, _cls, _logic getVariable ["Count", -1], _logic getVariable ["ClientName", ""], _key
    ]] call ADVSEC_fnc_ctrServer;
};
