params ["_unit"];

[_unit, "advsec_mydocs", "Mis documentos", ADVSEC_icDoc,
    {[_player] call ADVSEC_fnc_docListOpen},
    {([_player] call ADVSEC_fnc_docGetAll) isNotEqualTo []},
    "self", [], 2.5, [0, 0, 0],
    {[_player, "review"] call ADVSEC_fnc_docChildren}
] call ADVSEC_fnc_addInteraction;

if (((["reportsSelfAction", 1] call ADVSEC_fnc_cfg)) isEqualTo 1) then {
    [_unit, "advsec_reports_self", "Informes PM / AA.II.", ADVSEC_icDoc,
        {["BOTH"] call ADVSEC_fnc_repOpen},
        {[_player, "PM"] call ADVSEC_fnc_repAccess},
        "self"
    ] call ADVSEC_fnc_addInteraction;
};

[_unit, "advsec_police_self", "Policía Militar", ADVSEC_icPol,
    {[_player, "self"] call ADVSEC_fnc_policeMenu},
    {[_player, "PM"] call ADVSEC_fnc_repAccess},
    "self", [], 2.5, [0, 0, 0],
    {[_player, _player, "self"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_myfines", "Mis multas", ADVSEC_icDoc,
    {[] call ADVSEC_fnc_fineOpen},
    {true},
    "self"
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_hide", "Ocultar objeto entre la ropa", ADVSEC_icSearch,
    {[] call ADVSEC_fnc_hideItem},
    {isNull objectParent _player && {!([_player] call ADVSEC_fnc_isRestrained)}},
    "self"
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_stash", "Doble fondo del vehículo", ADVSEC_icCar,
    {[(_player nearEntities [["Car", "Motorcycle", "Tank"], 5]) select 0] call ADVSEC_fnc_vehStash},
    {isNull objectParent _player && {(_player nearEntities [["Car", "Motorcycle", "Tank"], 5]) isNotEqualTo []} && {!([_player] call ADVSEC_fnc_isRestrained)}},
    "self"
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_superadmin", "Terminal de superadministrador", ADVSEC_icPol,
    {[] call ADVSEC_fnc_adminOpen},
    {[_player] call ADVSEC_fnc_adminIs},
    "self"
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_wallet", "Cartera y banco", ADVSEC_icDoc,
    {[] call ADVSEC_fnc_ecoOpen},
    {[] call ADVSEC_fnc_ecoOn},
    "self"
] call ADVSEC_fnc_addInteraction;
