// [objeto] (cliente) Añade la interacción «Hackear» (requiere ADVSEC_HackKit) a un teclado o monitor CCTV
params ["_o"];
[_o, "advsec_hack", ("STR_ADVSEC_pmc_cy_hack" call ADVSEC_fnc_L), ADVSEC_icPad,
    {
        [("STR_ADVSEC_pmc_cy_hacking" call ADVSEC_fnc_L), ["hackTime", 20] call ADVSEC_fnc_setting, {alive player && {(player distance _this) < 4}},
            {["hack", player, [_this]] remoteExecCall ["ADVSEC_fnc_cyServer", 2]}, _target] call ADVSEC_fnc_progress;
    },
    {"ADVSEC_HackKit" in (items _player)},
    "main", [], 2.5
] call ADVSEC_fnc_addInteraction;
