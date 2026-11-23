// [acción, llamador, args] (servidor, 1.24) — "photo" [objeto, posición] (queda en el registro y en la cámara corporal) · "baton" [unidad]
params ["_action", "_caller", ["_args", []]];
if (!isServer || {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
switch (_action) do {
    case "photo": {
        if ((_caller getVariable ["ADVSEC_hand", ""]) != "camera") exitWith {};
        _args params [["_o", objNull], ["_p", [0, 0, 0]]];
        private _what = if (isNull _o) then {""} else {[getText (configOf _o >> "displayName"), name _o] select (_o isKindOf "CAManBase")};
        ["photo", _caller, [_what, mapGridPosition _p]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_hand_photo" call ADVSEC_fnc_L), [_what, "-"] select (_what isEqualTo ""), mapGridPosition _p]) remoteExecCall ["hint", _caller];
    };
    case "baton": {
        _args params [["_u", objNull]];
        if ((_caller getVariable ["ADVSEC_hand", ""]) != "baton" || {isNull _u} || {_caller distance _u > 3} || {!alive _u}) exitWith {};
        ["baton", _caller, [name _u]] call ADVSEC_fnc_logEvent;
        if (isPlayer _u) exitWith {
            [_u, ["HitArms", 0.3]] remoteExecCall ["setHitPointDamage", _u];
            ("STR_ADVSEC_hand_baton_you" call ADVSEC_fnc_L) remoteExecCall ["hint", _u];
        };
        // IA: aturdida 20 s, sin daño grave
        [_u, true] remoteExecCall ["setUnconscious", _u];
        [_u] spawn {params ["_u"]; sleep 20; if (alive _u) then {[_u, false] remoteExecCall ["setUnconscious", _u]}};
    };
};
