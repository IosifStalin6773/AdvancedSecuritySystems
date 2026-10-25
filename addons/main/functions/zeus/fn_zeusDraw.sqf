// Draw3D: iconos de los elementos de seguridad y estado policial de los jugadores, solo con la interfaz Zeus abierta
if (isNull findDisplay 312 || {isNull curatorCamera}) exitWith {};
private _cam = curatorCamera;
{
    _x params ["_obj", "_kind", "_label", ["_data", []]];
    if (!isNull _obj && {_obj distance _cam < 800}) then {
        private _col = [0.816, 0.639, 0.188, 1];
        private _state = "";
        switch (_kind) do {
            case "alarm": {
                _state = ["desarmada", "armada"] select (_obj getVariable ["ADVSEC_armed", false]);
                if (_obj getVariable ["ADVSEC_active", false]) then {_col = [1, 0.302, 0.302, 1]; _state = "¡DISPARADA!"};
            };
            case "door": {
                private _n = {_obj getVariable [format ["ADVSEC_locked_%1", _x], false]} count _data;
                _state = format ["%1/%2 cerradas", _n, count _data];
                if (_n == 0) then {_col = [0.4, 1, 0.4, 1]};
            };
            case "keypad": {
                private _d = _obj getVariable ["ADVSEC_kpDoors", []];
                if (_d isNotEqualTo []) then {
                    (_d select 0) params ["_b", "_i"];
                    private _l = _b getVariable [format ["ADVSEC_locked_%1", _i], false];
                    _state = ["abierto", "cerrado"] select _l;
                    if (!_l) then {_col = [0.4, 1, 0.4, 1]};
                };
                if (_obj getVariable ["ADVSEC_kpLockout", 0] > time) then {_col = [1, 0.302, 0.302, 1]; _state = "BLOQUEADO"};
            };
            case "camera": {_state = format ["[%1]", _data]};
            case "jail": {_state = format ["%1 detenidos", {(_x getVariable ["ADVSEC_jailObj", objNull]) isEqualTo _obj} count allPlayers]};
        };
        drawIcon3D [
            ADVSEC_kindIcons getOrDefault [_kind, ADVSEC_icPad], _col,
            (ASLToAGL getPosASLVisual _obj) vectorAdd [0, 0, 1.5],
            0.8, 0.8, 0, format ["%1 %2", _label, _state], 2, 0.03, "RobotoCondensed", "center", true
        ];
    };
} forEach (missionNamespace getVariable ["ADVSEC_secObjects", []]);

private _wanted = missionNamespace getVariable ["ADVSEC_wantedUIDs", []];
{
    if (_x distance _cam < 800) then {
        private _t = [];
        if (_x getVariable ["ADVSEC_jailUntil", 0] > serverTime) then {_t pushBack "DETENIDO"};
        if ((getPlayerUID _x) in _wanted) then {_t pushBack "BUSCADO"};
        if ([_x] call ADVSEC_fnc_isRestrained) then {_t pushBack "ESPOSADO"};
        if (_t isNotEqualTo []) then {
            drawIcon3D ["", [1, 0.302, 0.302, 1], _x modelToWorldVisual [0, 0, 2.2], 0, 0, 0, _t joinString " · ", 2, 0.03, "RobotoCondensedBold", "center"];
        };
    };
} forEach allPlayers;
