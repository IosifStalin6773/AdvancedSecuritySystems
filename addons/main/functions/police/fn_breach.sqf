// [edificio, puerta] (spawn) — forzado con barra de progreso. El servidor valida el tiempo y dispara las alarmas.
params ["_b", "_i"];
private _time = (["breachTime", 20] call ADVSEC_fnc_cfg);
["start", player, _b, _i] remoteExecCall ["ADVSEC_fnc_breachServer", 2];
private _done = {
    params ["_b", "_i"];
    ["done", player, _b, _i] remoteExecCall ["ADVSEC_fnc_breachServer", 2];
};

if (!isNil "ace_common_fnc_progressBar") exitWith {
    [_time, [_b, _i, _done], {(_this select 0) params ["_b", "_i", "_done"]; [_b, _i] call _done}, {hint "Forzado interrumpido."}, "Forzando cerradura..."] call ace_common_fnc_progressBar;
};

private _start = getPosATL player;
private _end = time + _time;
private _ok = true;
while {time < _end} do {
    if (!alive player || {(player distance _start) > 1.5} || {!isNull objectParent player}) exitWith {_ok = false};
    if !(toLower animationState player in ["ainvpknlmstpsnonwnondnon_medic_1", "ainvpknlmstpsnonwnondnon_medic0s"]) then {player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1"};
    private _p = 1 - (_end - time) / _time;
    private _bar = "";
    for "_k" from 1 to 20 do {_bar = _bar + (["·", "|"] select (_k / 20 <= _p))};
    hintSilent parseText format ["<t font='RobotoCondensedBold'>Forzando cerradura</t><br/>%1<br/>%2 %3", _bar, round (_p * 100), "%"];
    sleep 0.25;
};
[player, ""] remoteExecCall ["switchMove", 0];
hintSilent "";
if (_ok) then {[_b, _i] call _done} else {hint "Forzado interrumpido."};
