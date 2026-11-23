/*
    [tipo] (cliente, 1.24) — sacar o guardar un objeto en la mano: camera · megaphone · clipboard · shield · baton
    Necesita el objeto en el inventario. El modelo visible sale de handProps (vacío = sin modelo, solo la función).
    Escudo: reduce el daño que llega de frente. Porra: golpe que deja aturdido a una IA cercana.
*/
params ["_kind"];
private _items = createHashMapFromArray [["camera", "ADVSEC_Camera"], ["megaphone", "ADVSEC_Megaphone"], ["clipboard", "ADVSEC_Clipboard"], ["shield", "ADVSEC_RiotShield"], ["baton", "ADVSEC_RiotBaton"]];
private _cur = player getVariable ["ADVSEC_hand", ""];
private _drop = {
    {deleteVehicle _x} forEach (player getVariable ["ADVSEC_handObjs", []]);
    player setVariable ["ADVSEC_handObjs", []];
    player setVariable ["ADVSEC_hand", "", true];
    private _eh = player getVariable ["ADVSEC_shieldEH", -1];
    if (_eh >= 0) then {player removeEventHandler ["HandleDamage", _eh]; player setVariable ["ADVSEC_shieldEH", -1]};
};
if (_cur isNotEqualTo "") then {call _drop};
if (_cur isEqualTo _kind) exitWith {};
private _it = _items getOrDefault [_kind, ""];
if !(_it in items player) exitWith {hint format [("STR_ADVSEC_item_needed" call ADVSEC_fnc_L), getText (configFile >> "CfgWeapons" >> _it >> "displayName")]};
private _cls = ((["handProps", []] call ADVSEC_fnc_setting) select {(_x select 0) == _kind}) param [0, ["", ""]] select 1;
private _objs = [];
if (_cls isNotEqualTo "" && {isClass (configFile >> "CfgVehicles" >> _cls)}) then {
    private _o = createVehicle [_cls, [0, 0, 0], [], 0, "CAN_COLLIDE"];
    private _hand = ["righthand", "lefthand"] select (_kind == "shield");
    _o attachTo [player, [0, 0, 0], _hand, true];
    _objs pushBack _o;
};
player setVariable ["ADVSEC_handObjs", _objs];
player setVariable ["ADVSEC_hand", _kind, true];
if (_kind == "shield") then {
    // Lo que entra por delante (±60°) se reduce al 30 %
    private _eh = player addEventHandler ["HandleDamage", {
        params ["_u", "_sel", "_dmg", "_src", "", "_idx"];
        private _old = [damage _u, _u getHitIndex _idx] select (_idx >= 0);
        if (isNull _src || {_src == _u}) exitWith {_dmg};
        private _rel = _u getRelDir _src;
        if (_rel < 60 || {_rel > 300}) then {_old + (_dmg - _old) * 0.3} else {_dmg};
    }];
    player setVariable ["ADVSEC_shieldEH", _eh];
};
// Se guarda solo al subir a un vehículo, perder el objeto o morir
[_kind, _it, _drop] spawn {
    params ["_kind", "_it", "_drop"];
    waitUntil {sleep 1; (player getVariable ["ADVSEC_hand", ""]) != _kind || {!alive player} || {vehicle player != player} || {!(_it in items player)}};
    if ((player getVariable ["ADVSEC_hand", ""]) == _kind) then {call _drop};
};
hint format [("STR_ADVSEC_hand_on" call ADVSEC_fnc_L), getText (configFile >> "CfgWeapons" >> _it >> "displayName")];
