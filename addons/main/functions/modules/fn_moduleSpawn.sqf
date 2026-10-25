/*
    [módulo, clase, función init, argumentos tras el objeto] — Eden sin objeto sincronizado (mismo comportamiento que Zeus):
    el servidor crea el objeto en la posición del módulo y ejecuta su init en todas las máquinas (también JIP).
    En los clientes no hace nada: les llega por remoteExec.
*/
params ["_logic", "_class", "_fn", ["_args", []]];
if (!isServer) exitWith {objNull};
private _obj = createVehicle [_class, getPosATL _logic, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _logic;
_obj setPosATL getPosATL _logic;
([_obj] + _args) remoteExecCall [_fn, 0, format ["%1_%2", _fn, netId _obj]];
_obj
