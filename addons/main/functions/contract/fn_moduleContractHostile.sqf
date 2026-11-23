// Módulo de Eden (solo servidor): marca como enemigos de contrato a las unidades sincronizadas.
// El contrato las cuenta como suyas estén donde estén; no hace falta que caigan dentro de la zona.
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
{
    if (_x isKindOf "CAManBase" && {alive _x} && {!isPlayer _x}) then {
        _x setVariable ["ADVSEC_ctrHostile", true, true];
    };
} forEach (synchronizedObjects _logic);
