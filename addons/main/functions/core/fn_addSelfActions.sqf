// Menú propio: solo tres entradas (Mi personaje, Policía Militar, Superadministrador); el resto va en submenús
params ["_unit"];

[_unit, "advsec_me", "Mi personaje", ADVSEC_icDoc,
    {[_player, "me"] call ADVSEC_fnc_policeMenu},
    {alive _player},
    "self", [], 2.5, [0, 0, 0],
    {[_player] call ADVSEC_fnc_selfChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_police_self", "Policía Militar", ADVSEC_icPol,
    {[_player, "self"] call ADVSEC_fnc_policeMenu},
    {[_player, "PM"] call ADVSEC_fnc_repAccess},
    "self", [], 2.5, [0, 0, 0],
    {[_player, _player, "self"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_superadmin", "Terminal de superadministrador", ADVSEC_icPol,
    {[] call ADVSEC_fnc_adminOpen},
    {[_player] call ADVSEC_fnc_adminIs},
    "self"
] call ADVSEC_fnc_addInteraction;
