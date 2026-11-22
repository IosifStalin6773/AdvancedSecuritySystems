/*
    [edificio, texto] — expresión del atributo de Eden «Puertas (ADVSEC)» (se ejecuta en todas las máquinas, también JIP).
    Texto: [[índice, "lock"|"keypad", bloqueada, pin, zonaAlarma, nivel, "Doc1,Doc2", llave], ...] (ver ADVSEC_fnc_doorAttr)
    Cerradura: igual que el módulo «Cerradura» pero solo en esa puerta.
    Keypad: keypad junto a la puerta (acciones «Usar keypad» / «Pasar tarjeta» en la propia puerta); PIN y zona de alarma propios.
*/
params ["_b", ["_txt", ""]];
if (is3DEN || {isNull _b} || {!(_txt isEqualType "")} || {_txt isEqualTo ""}) exitWith {};
private _cfg = parseSimpleArray _txt;
if (!(_cfg isEqualType []) || {_cfg isEqualTo []}) exitWith {};
private _n = count ([_b, "all"] call ADVSEC_fnc_doorList);
_cfg = _cfg select {_x isEqualType [] && {count _x >= 8} && {(_x select 0) isEqualType 0} && {(_x select 0) > 0} && {(_x select 0) <= _n}};

private _locks = [];
{
    _x params ["_i", "_t", "_lk", "_pin", "_zone", "_clr", "_docs", "_key"];
    private _req = [_clr, _docs, _key] call ADVSEC_fnc_buildReq;
    switch (_t) do {
        case "lock": {
            [_b, [_i], _req, _lk] call ADVSEC_fnc_doorInit;
            _locks pushBack _i;
        };
        case "keypad": {
            private _label = format [("STR_ADVSEC_dr_kp_label" call ADVSEC_fnc_L), _i];
            if (isServer) then {
                private _sel = format ["Door_%1_trigger", _i];
                private _rel = _b selectionPosition [_sel, "Memory"];
                if (_rel isEqualTo [0, 0, 0]) then {_rel = _b selectionPosition _sel};
                private _kp = createVehicle ["Land_HelipadEmpty_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
                _kp setPosASL (_b modelToWorldWorld _rel);
                _kp setVariable ["ADVSEC_pin", [_pin, str _pin] select (_pin isEqualType 0)];
                _kp setVariable ["ADVSEC_kpDoors", [[_b, _i]], true];
                _kp setVariable ["ADVSEC_kpAlarm", _zone, true];
                _kp setVariable ["ADVSEC_kpReq", _req, true];
                _kp setVariable ["ADVSEC_kpLabel", _label, true];
                [_kp, "keypad", _label] call ADVSEC_fnc_register;
                [_b, _i, _lk] call ADVSEC_fnc_doorSet;
                _b setVariable [format ["ADVSEC_kpHolder_%1", _i], _kp, true];
            };
            [_b, [_i]] call ADVSEC_fnc_breachActions;
            [_b, format ["advsec_kp_%1", _i], format [("STR_ADVSEC_dr_use_kp" call ADVSEC_fnc_L), _i], ADVSEC_icPad,
                {[_target getVariable [format ["ADVSEC_kpHolder_%1", _args select 0], objNull]] call ADVSEC_fnc_keypadOpen},
                {!isNull (_target getVariable [format ["ADVSEC_kpHolder_%1", _args select 0], objNull])},
                "root", [_i], 2.5, format ["Door_%1_trigger", _i]
            ] call ADVSEC_fnc_addInteraction;
            if (_req isNotEqualTo []) then {
                [_b, format ["advsec_kpc_%1", _i], format [("STR_ADVSEC_dr_card_kp" call ADVSEC_fnc_L), _i], ADVSEC_icKey,
                    {["card", _target getVariable [format ["ADVSEC_kpHolder_%1", _args select 0], objNull], _player] remoteExecCall ["ADVSEC_fnc_keypadServer", 2]},
                    {[_player, _args select 1] call ADVSEC_fnc_accessCheck},
                    "root", [_i, _req], 2.5, format ["Door_%1_trigger", _i]
                ] call ADVSEC_fnc_addInteraction;
            };
        };
    };
} forEach _cfg;
// doorInit registra el edificio puerta a puerta: se deja un único registro con todas las cerraduras
if (isServer && {_locks isNotEqualTo []}) then {[_b, "door", getText (configOf _b >> "displayName"), _locks] call ADVSEC_fnc_register};
