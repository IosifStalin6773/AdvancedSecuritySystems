// [unidad, escoltar (bool)] — en la máquina del agente
params ["_unit", "_state"];
if (!_state) exitWith {
    if ((attachedTo _unit) isEqualTo player) then {detach _unit};
    player setVariable ["ADVSEC_escorting", objNull, true];
};
if (!isNull (player getVariable ["ADVSEC_escorting", objNull])) exitWith {hint "Ya estás escoltando a alguien."};
_unit attachTo [player, [0.35, 1.0, 0]];
player setVariable ["ADVSEC_escorting", _unit, true];
[_unit] spawn {
    params ["_u"];
    waitUntil {
        sleep 0.5;
        !alive player || {!alive _u} || {(attachedTo _u) isNotEqualTo player} || {!([_u] call ADVSEC_fnc_isRestrained)} || {!isNull objectParent player}
    };
    if ((attachedTo _u) isEqualTo player) then {detach _u};
    player setVariable ["ADVSEC_escorting", objNull, true];
};
