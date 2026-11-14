// Menú propio: Mi personaje, compañía (perfil PMC), Policía Militar y Superadministrador; el resto va en submenús
params ["_unit"];

[_unit, "advsec_me", ("STR_ADVSEC_my_character_2" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {[_player, "me"] call ADVSEC_fnc_policeMenu},
    {alive _player},
    "self", [], 2.5, [0, 0, 0],
    {[_player] call ADVSEC_fnc_selfChildren}
] call ADVSEC_fnc_addInteraction;

// Perfil PMC (1.20): menú de la compañía antes que el de la PM (contratos, células, servicio, central)
[_unit, "advsec_company_self", ["companyName", "I.V.M."] call ADVSEC_fnc_setting, ADVSEC_icDoc,
    {[_player, "company"] call ADVSEC_fnc_policeMenu},
    {(["pmcProfile", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {[_player, "PMC"] call ADVSEC_fnc_repAccess}},
    "self", [], 2.5, [0, 0, 0],
    {[_player, _player, "company"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_police_self", ("STR_ADVSEC_military_police" call ADVSEC_fnc_L), ADVSEC_icPol,
    {[_player, "self"] call ADVSEC_fnc_policeMenu},
    {[_player, "PM"] call ADVSEC_fnc_repAccess},
    "self", [], 2.5, [0, 0, 0],
    {[_player, _player, "self"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_superadmin", ("STR_ADVSEC_superadmin_terminal_2" call ADVSEC_fnc_L), ADVSEC_icPol,
    {[] call ADVSEC_fnc_adminOpen},
    {[_player] call ADVSEC_fnc_adminIs},
    "self"
] call ADVSEC_fnc_addInteraction;
