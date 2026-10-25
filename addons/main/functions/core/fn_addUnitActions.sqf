params ["_unit"];

[_unit, "advsec_show", "Mostrar documento", ADVSEC_icDoc,
    {ADVSEC_showTarget = _target; [_player] call ADVSEC_fnc_docListOpen},
    {alive _target && {([_player] call ADVSEC_fnc_docGetAll) isNotEqualTo []}},
    "main", [], 3, [0, 0, 0],
    {[_player, "show"] call ADVSEC_fnc_docChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_inspect", "Solicitar documentación", ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_docListOpen},
    {alive _target && {([_target] call ADVSEC_fnc_docGetAll) isNotEqualTo []}},
    "main", [], 3, [0, 0, 0],
    {[_target, "inspect"] call ADVSEC_fnc_docChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_police", "Policía Militar", ADVSEC_icPol,
    {[_target, "unit"] call ADVSEC_fnc_policeMenu},
    {alive _target && {[_player, "PM"] call ADVSEC_fnc_repAccess}},
    "main", [], 3, [0, 0, 0],
    {[_target, _player, "unit"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_bribe", "Ofrecer dinero", ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_bribeOffer},
    {alive _target && {isPlayer _target} && {[] call ADVSEC_fnc_ecoOn} && {[_target, "PM"] call ADVSEC_fnc_repAccess} && {!([_player, "PM"] call ADVSEC_fnc_repAccess)}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
