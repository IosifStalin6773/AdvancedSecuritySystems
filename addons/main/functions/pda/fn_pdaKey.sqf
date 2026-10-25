// KeyDown del diálogo de la PDA: la misma tecla que la abre la cierra
params ["_d", "_k", "_s", "_c", "_a"];
(["pda"] call ADVSEC_fnc_keyCurrent) params ["_key", "_ks", "_kc", "_ka"];
if (_k != _key || {_s != _ks} || {_c != _kc} || {_a != _ka}) exitWith {false};
closeDialog 0;
true
