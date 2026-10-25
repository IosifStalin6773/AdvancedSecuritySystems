// [valores, [tipo, objetivo, posición, dirección]] (máquina del Zeus)
params ["_v", "_ctx"];
_ctx params ["_kind", "_target", "_pos", "_dir"];

private _spawn = {
    params ["_class"];
    private _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
    _obj setDir _dir;
    _obj setPosATL _pos;
    [getAssignedCuratorLogic player, [[_obj], true]] remoteExecCall ["addCuratorEditableObjects", 2];
    _obj
};
// Clave JIP por función y objeto: reaplicar el módulo sustituye la anterior; objetos del mapa sin netId usan su posición
private _jip = {
    params ["_fn", "_o"];
    private _n = netId _o;
    if (_n in ["", "0:0"]) then {_n = str ((getPosWorld _o) apply {round _x})};
    format ["%1_%2", _fn, _n]
};
private _msg = {[objNull, _this] call BIS_fnc_showCuratorFeedbackMessage};
private _done = true;

switch (_kind) do {
    case "camera": {
        if (isNull _target) then {_target = ["Land_HandyCam_F"] call _spawn};
        [_target, _v#0, _v#2, 0, _v#1] remoteExecCall ["ADVSEC_fnc_cameraInit", 0, ["ADVSEC_fnc_cameraInit", _target] call _jip];
    };
    case "monitor": {
        if (isNull _target) then {_target = ["Land_FlatTV_01_F"] call _spawn};
        [_target, _v#0, [_v#1, _v#2, _v#3] call ADVSEC_fnc_buildReq] remoteExecCall ["ADVSEC_fnc_monitorInit", 0, ["ADVSEC_fnc_monitorInit", _target] call _jip];
    };
    case "keypad": {
        if (isNull _target) then {_target = ["Land_Tablet_01_F"] call _spawn};
        private _b = [_target] call ADVSEC_fnc_findBuilding;
        if (isNull _b) then {"Aviso: no hay ningún edificio con puertas a menos de 50 m." call _msg};
        private _doors = if (isNull _b) then {[]} else {([_b, _v#1] call ADVSEC_fnc_doorList) apply {[_b, _x]}};
        [_target, _v#0, _doors, _v#2, [_v#4, _v#5, _v#6] call ADVSEC_fnc_buildReq, _v#3] remoteExecCall ["ADVSEC_fnc_keypadInit", 0, ["ADVSEC_fnc_keypadInit", _target] call _jip];
    };
    case "door": {
        private _b = [[_pos] call ADVSEC_fnc_findBuilding, _target] select ([_target] call ADVSEC_fnc_hasDoors);
        if (isNull _b) exitWith {_done = false; "No hay ningún edificio con puertas cerca." call _msg};
        [_b, _v#0, [_v#2, _v#3, _v#4] call ADVSEC_fnc_buildReq, _v#1] remoteExecCall ["ADVSEC_fnc_doorInit", 0, ["ADVSEC_fnc_doorInit", _b] call _jip];
    };
    case "alarm": {
        if (isNull _target) then {_target = ["Land_Loudspeakers_F"] call _spawn};
        private _b = [_target, 30] call ADVSEC_fnc_findBuilding;
        private _doors = if (isNull _b || {(_v#3) isEqualTo ""}) then {[]} else {([_b, _v#3] call ADVSEC_fnc_doorList) apply {[_b, _x]}};
        [_target, _v#2, [_v#5, _v#6, _v#7] call ADVSEC_fnc_buildReq, _doors, _v#4, _v#0, _v#1] remoteExecCall ["ADVSEC_fnc_alarmInit", 0, ["ADVSEC_fnc_alarmInit", _target] call _jip];
    };
    case "reports": {
        if (isNull _target) then {_target = ["Land_Laptop_unfolded_F"] call _spawn};
        [_target, _v#0, [_v#1, _v#2, _v#3] call ADVSEC_fnc_buildReq] remoteExecCall ["ADVSEC_fnc_repTerminalInit", 0, ["ADVSEC_fnc_repTerminalInit", _target] call _jip];
    };
    case "issuer": {
        if (isNull _target) then {_target = ["Land_CampingTable_F"] call _spawn};
        [_target, _v#1, _v#0, [_v#3, _v#4, _v#5] call ADVSEC_fnc_buildReq, _v#2] remoteExecCall ["ADVSEC_fnc_issuerInit", 0, ["ADVSEC_fnc_issuerInit", _target] call _jip];
    };
    case "jail": {
        if (isNull _target) then {_target = ["Land_HelipadEmpty_F"] call _spawn};
        [_target, _v#0, _v#1] remoteExecCall ["ADVSEC_fnc_jailInit", 0, ["ADVSEC_fnc_jailInit", _target] call _jip];
    };
    case "atm": {
        if (isNull _target) then {_target = ["Land_Atm_01_F"] call _spawn};
        [_target, _v#0] remoteExecCall ["ADVSEC_fnc_atmInit", 0, ["ADVSEC_fnc_atmInit", _target] call _jip];
    };
    case "shop": {
        if (isNull _target) then {_target = ["Land_CampingTable_F"] call _spawn};
        [_target, _v#0, _v#1] remoteExecCall ["ADVSEC_fnc_shopInit", 0, ["ADVSEC_fnc_shopInit", _target] call _jip];
    };
    case "admin": {
        if (isNull _target) then {_target = ["Land_Laptop_unfolded_F"] call _spawn};
        [_target, _v#0] remoteExecCall ["ADVSEC_fnc_adminInit", 0, ["ADVSEC_fnc_adminInit", _target] call _jip];
    };
    case "lab": {
        if (isNull _target) then {_target = ["Land_CampingTable_F"] call _spawn};
        [_target, _v#0] remoteExecCall ["ADVSEC_fnc_labInit", 0, ["ADVSEC_fnc_labInit", _target] call _jip];
    };
    case "checkpoint": {
        private _n = _v#2;
        private _off = [];
        if (_n < 0) then {
            if (isNull _target || {!(_target isKindOf "CAManBase")}) exitWith {_n = 2};
            _off = units group _target; _n = 0;
        };
        [_pos, _v#0, _v#1, _off, player, _dir, _n] call ADVSEC_fnc_checkpointInit;
    };
};
if (_done) then {format ["%1 configurado.", toUpper _kind] call _msg};
