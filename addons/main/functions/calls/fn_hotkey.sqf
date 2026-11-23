/*
    [modo] (cliente, 1.24) — atajos de la PM
    "halt": da el alto a lo que apuntas (los conductores IA paran 30 s) · "siren": sirena del vehículo (activar/apagar)
    "megaphone": frase por megáfono a los que estén a menos de 80 m (los civiles IA se detienen)
*/
params [["_mode", ""]];
if !([player, "PMC"] call ADVSEC_fnc_repAccess) exitWith {};
switch (_mode) do {
    case "halt": {
        private _t = cursorObject;
        if (isNull _t || {(player distance _t) > 40}) exitWith {hint ("STR_ADVSEC_hk_halt_none" call ADVSEC_fnc_L)};
        private _drv = driver _t;
        if (_t isKindOf "AllVehicles" && {!(_t isKindOf "CAManBase")} && {!isNull _drv}) then {
            if (isPlayer _drv) then {("STR_ADVSEC_hk_halt_you" call ADVSEC_fnc_L) remoteExecCall ["hint", _drv]} else {
                [_drv] remoteExecCall ["doStop", _drv];
                [_t, 0] remoteExecCall ["forceSpeed", _t];
                [_t] spawn {params ["_t"]; sleep 30; if (!isNull _t) then {[_t, -1] remoteExecCall ["forceSpeed", _t]}};
            };
        } else {
            if (_t isKindOf "CAManBase") then {
                if (isPlayer _t) then {("STR_ADVSEC_hk_halt_you" call ADVSEC_fnc_L) remoteExecCall ["hint", _t]} else {[_t] remoteExecCall ["doStop", _t]};
            };
        };
        (format [("STR_ADVSEC_hk_halt_say" call ADVSEC_fnc_L), name player]) remoteExecCall ["systemChat", allPlayers select {_x distance player < 60}];
    };
    case "siren": {
        private _v = vehicle player;
        if (_v == player) exitWith {hint ("STR_ADVSEC_hk_siren_veh" call ADVSEC_fnc_L)};
        private _on = !(_v getVariable ["ADVSEC_vehSiren", false]);
        _v setVariable ["ADVSEC_vehSiren", _on, true];
        if (_on) then {
            [_v] spawn {
                params ["_v"];
                private _snd = ["vehSirenSound", "A3\Sounds_F\sfx\alarm_independent.wss"] call ADVSEC_fnc_setting;
                while {alive _v && {_v getVariable ["ADVSEC_vehSiren", false]}} do {
                    playSound3D [_snd, _v, false, getPosASL _v, 4, 1.4, 600];
                    sleep 1.6;
                };
            };
        };
        hint ((["STR_ADVSEC_hk_siren_off", "STR_ADVSEC_hk_siren_on"] select _on) call ADVSEC_fnc_L);
    };
    case "megaphone": {
        private _ph = ["STR_ADVSEC_hk_mg_1", "STR_ADVSEC_hk_mg_2", "STR_ADVSEC_hk_mg_3", "STR_ADVSEC_hk_mg_4", "STR_ADVSEC_hk_mg_5"] apply {_x call ADVSEC_fnc_L};
        [("STR_ADVSEC_hk_megaphone" call ADVSEC_fnc_L), [
            [("STR_ADVSEC_hk_mg_phrase" call ADVSEC_fnc_L), _ph select 0, _ph apply {[_x, _x]}],
            [("STR_ADVSEC_hk_mg_own" call ADVSEC_fnc_L), ""]
        ], {
            params ["_v"];
            private _txt = [_v select 0, _v select 1] select ((_v select 1) isNotEqualTo "");
            (format [("STR_ADVSEC_hk_mg_say" call ADVSEC_fnc_L), name player, _txt select [0, 120]]) remoteExecCall ["systemChat", allPlayers select {_x distance player < 80}];
            {if (!isPlayer _x && {side group _x == civilian}) then {[_x] remoteExecCall ["doStop", _x]}} forEach (player nearEntities ["CAManBase", 80]);
        }] call ADVSEC_fnc_zeusPrompt;
    };
};
