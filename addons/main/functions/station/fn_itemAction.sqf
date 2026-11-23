/*
    [acción, objetivo] (cliente, 1.24) — usos sencillos de los objetos de la PM
    "flare": enciende una bengala de carretera · "watch": cronómetro (empezar/parar) · "tape": mide la distancia a lo que apuntas
    "chain": pone o quita la cadena antirrobo del vehículo apuntado
*/
params ["_action", ["_t", objNull]];
switch (_action) do {
    case "flare": {
        if !("ADVSEC_Flares" in items player) exitWith {};
        player removeItem "ADVSEC_Flares";
        player playActionNow "PutDown";
        // Tres luces químicas rojas en fila, como bengalas de aviso en la carretera
        for "_i" from 0 to 2 do {
            private _f = createVehicle ["Chemlight_red", player getRelPos [1.5 + _i * 6, 0], [], 0, "CAN_COLLIDE"];
            _f setVelocity [0, 0, 0];
        };
        hint ("STR_ADVSEC_it_flare_done" call ADVSEC_fnc_L);
    };
    case "watch": {
        private _t0 = player getVariable ["ADVSEC_watch", -1];
        if (_t0 < 0) then {
            player setVariable ["ADVSEC_watch", time];
            hint ("STR_ADVSEC_it_watch_go" call ADVSEC_fnc_L);
        } else {
            player setVariable ["ADVSEC_watch", -1];
            hint format [("STR_ADVSEC_it_watch_stop" call ADVSEC_fnc_L), (time - _t0) toFixed 2];
        };
    };
    case "tape": {
        private _to = screenToWorld [0.5, 0.5];
        private _d = player distance2D _to;
        if (_d > 50) exitWith {hint ("STR_ADVSEC_it_tape_far" call ADVSEC_fnc_L)};
        hint format [("STR_ADVSEC_it_tape_res" call ADVSEC_fnc_L), _d toFixed 2];
    };
    case "chain": {
        if (isNull _t || {!(_t isKindOf "LandVehicle")} || {(player distance _t) > 5}) exitWith {};
        if (_t getVariable ["ADVSEC_chain", false]) then {
            // La quita quien la puso (recupera la cadena) o quien lleve cortapernos (la corta)
            private _mine = (_t getVariable ["ADVSEC_chainBy", ""]) == getPlayerUID player;
            if (!_mine && {!("ADVSEC_BoltCutter" in items player)}) exitWith {hint ("STR_ADVSEC_it_chain_locked" call ADVSEC_fnc_L)};
            _t setVariable ["ADVSEC_chain", false, true];
            [_t, 0] remoteExecCall ["lock", _t];
            if (_mine) then {player addItem "ADVSEC_SteeringLock"};
            hint ("STR_ADVSEC_it_chain_off" call ADVSEC_fnc_L);
        } else {
            if !("ADVSEC_SteeringLock" in items player) exitWith {};
            player removeItem "ADVSEC_SteeringLock";
            _t setVariable ["ADVSEC_chain", true, true];
            _t setVariable ["ADVSEC_chainBy", getPlayerUID player, true];
            [_t, 2] remoteExecCall ["lock", _t];
            hint ("STR_ADVSEC_it_chain_on" call ADVSEC_fnc_L);
        };
    };
};
