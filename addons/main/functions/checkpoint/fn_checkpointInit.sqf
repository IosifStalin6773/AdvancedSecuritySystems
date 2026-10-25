/*
    [posición, nombre, radio, agentes IA, llamador, dirección, agentesNuevos] (servidor) -> ancla — control de carretera automático.
    Si no se le dan agentes crea los suyos (agentesNuevos, por defecto checkpointUnits) con conos de señalización.
    Los agentes dan el alto, se acercan al vehículo, piden la documentación y registran; borrar el ancla en Zeus lo retira todo.
*/
params ["_pos", ["_name", "Control PM"], ["_radius", 20], ["_officers", []], ["_caller", objNull], ["_dir", 0], ["_spawn", -1]];
if (!isServer) exitWith {[_pos, _name, _radius, _officers, player, _dir, _spawn] remoteExecCall ["ADVSEC_fnc_checkpointInit", 2]};
if (call ADVSEC_fnc_fromClient && {!([_caller] call ADVSEC_fnc_srvCaller) || {!([_caller] call ADVSEC_fnc_isZeus)}}) exitWith {[_caller, "crear un control de carretera"] call ADVSEC_fnc_deny};
if (_pos isEqualType objNull) then {_dir = getDir _pos; _pos = getPosATL _pos};
private _id = (missionNamespace getVariable ["ADVSEC_cpSeq", 0]) + 1;
ADVSEC_cpSeq = _id;
// Ancla invisible: borrarla desde Zeus desactiva el control
private _anchor = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE"];
_anchor setDir _dir;
_anchor setVariable ["ADVSEC_cpId", _id, true];
private _owned = [];
if (_spawn < 0) then {_spawn = [0, ["checkpointUnits", 2] call ADVSEC_fnc_setting] select (_officers isEqualTo [])};
if (_spawn > 0) then {
    private _classes = (["checkpointUnitClasses", ["B_GEN_Soldier_F", "B_GEN_Commander_F"]] call ADVSEC_fnc_setting) select {isClass (configFile >> "CfgVehicles" >> _x)};
    if (_classes isEqualTo []) then {_classes = ["B_Soldier_F"]};
    private _side = switch (toLower (["checkpointSide", "west"] call ADVSEC_fnc_setting)) do {case "east": {east}; case "independent"; case "resistance": {independent}; case "civilian": {civilian}; default {west}};
    private _grp = createGroup [_side, true];
    for "_i" from 0 to (_spawn - 1) do {
        private _side = [1, -1] select (_i mod 2);
        private _p = _anchor modelToWorld [4.5 * _side, -1.5 * floor (_i / 2), 0];
        private _u = _grp createUnit [_classes select (_i mod count _classes), _p, [], 0, "CAN_COLLIDE"];
        _u setPosATL [_p select 0, _p select 1, 0];
        _u setDir (_dir + 90 * _side * -1);
        _officers pushBack _u;
    };
    _grp setBehaviour "SAFE";
    _grp setCombatMode "YELLOW";
    _grp setSpeedMode "LIMITED";
    _grp setGroupIdGlobal [_name];
    // Señalización
    {
        private _c = createVehicle ["RoadCone_L_F", _anchor modelToWorld _x, [], 0, "CAN_COLLIDE"];
        _c setDir _dir;
        _owned pushBack _c;
    } forEach [[3, 7, 0], [-3, 7, 0], [3, -7, 0], [-3, -7, 0], [0, 9, 0], [0, -9, 0]];
    _owned append _officers;
};
{
    _x setVariable ["ADVSEC_cpPost", [getPosATL _x, getDir _x]];
    // Que el combate no anule las órdenes del control (doMove / doStop)
    [_x, "AUTOCOMBAT"] remoteExecCall ["disableAI", _x];
    [_x, "UP"] remoteExecCall ["setUnitPos", _x];
} forEach _officers;
// Datos para la limpieza: lo que creó el control y los agentes que solo se tomaron prestados (sincronizados)
_anchor setVariable ["ADVSEC_cpOwned", _owned];
_anchor setVariable ["ADVSEC_cpGuests", _officers - _owned];
_anchor setVariable ["ADVSEC_cpRadius", _radius];
_anchor setVariable ["ADVSEC_cpName", _name];
_anchor addEventHandler ["Deleted", {params ["_a"]; [_a, true] call ADVSEC_fnc_cpCleanup}];
{_x addCuratorEditableObjects [[_anchor] + _owned, true]} forEach allCurators;
[_anchor, "checkpoint", _name] call ADVSEC_fnc_register;
["checkpoint", objNull, [_name, mapGridPosition _pos]] call ADVSEC_fnc_logEvent;
[_anchor, _pos, _name, _radius, _officers, _owned] spawn ADVSEC_fnc_checkpointLoop;
_anchor
