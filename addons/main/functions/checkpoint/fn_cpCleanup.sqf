/*
    [ancla, desdeEH] (servidor) — retira un control de carretera. Idempotente: la llaman el EH "Deleted" del ancla,
    el del módulo de Eden y el final del bucle, y solo actúa la primera vez.
    Borra lo que creó el control (agentes nuevos, conos), devuelve a su puesto a los agentes sincronizados
    y suelta todos los vehículos que tuviera retenidos.
*/
params ["_anchor", ["_fromEH", false]];
if (!isServer || {isNull _anchor} || {_anchor getVariable ["ADVSEC_cpClean", false]}) exitWith {};
_anchor setVariable ["ADVSEC_cpClean", true];
private _id = _anchor getVariable ["ADVSEC_cpId", -1];
private _pos = getPosATL _anchor;
private _radius = _anchor getVariable ["ADVSEC_cpRadius", 20];
{
    if (!isNull _x && {(_x getVariable ["ADVSEC_cpHoldBy", -2]) == _id}) then {
        _x setVariable ["ADVSEC_cpHold", false, true];
        _x setVariable ["ADVSEC_cpHoldBy", nil, true];
        private _d = driver _x;
        if (!isNull _d && {!isPlayer _d}) then {
            [_d, "MOVE"] remoteExecCall ["enableAI", _d];
            [_d, -1] remoteExecCall ["forceSpeed", _d];
            [_d, leader _d] remoteExecCall ["doFollow", _d];
        };
    };
} forEach (_pos nearEntities [["Car", "Motorcycle", "Tank"], _radius * 4]);
{
    if (!isNull _x && {alive _x}) then {
        _x setVariable ["ADVSEC_cpBusy", nil];
        [_x, "AUTOCOMBAT"] remoteExecCall ["enableAI", _x];
        [_x, "AUTO"] remoteExecCall ["setUnitPos", _x];
        [_x, objNull] remoteExecCall ["doWatch", _x];
        [_x, leader _x] remoteExecCall ["doFollow", _x];
    };
} forEach (_anchor getVariable ["ADVSEC_cpGuests", []]);
private _owned = (_anchor getVariable ["ADVSEC_cpOwned", []]) select {!isNull _x};
private _groups = [];
{
    if (_x isKindOf "CAManBase") then {_groups pushBackUnique group _x};
    deleteVehicle _x;
} forEach _owned;
{if (!isNull _x && {(units _x) isEqualTo []}) then {deleteGroup _x}} forEach _groups;
["checkpointRemoved", objNull, [_anchor getVariable ["ADVSEC_cpName", ""], mapGridPosition _pos]] call ADVSEC_fnc_logEvent;
if (!_fromEH && {!isNull _anchor}) then {deleteVehicle _anchor};
