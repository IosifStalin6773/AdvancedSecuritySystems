params ["_unit"];

[_unit, "advsec_show", ("STR_ADVSEC_show_document" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {ADVSEC_showTarget = _target; [_player] call ADVSEC_fnc_docListOpen},
    {alive _target && {([_player] call ADVSEC_fnc_docGetAll) isNotEqualTo []}},
    "main", [], 3, [0, 0, 0],
    {[_player, "show"] call ADVSEC_fnc_docChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_inspect", ("STR_ADVSEC_request_documents" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_docListOpen},
    {alive _target && {([_target] call ADVSEC_fnc_docGetAll) isNotEqualTo []}},
    "main", [], 3, [0, 0, 0],
    {[_target, "inspect"] call ADVSEC_fnc_docChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_police", [("STR_ADVSEC_military_police" call ADVSEC_fnc_L), ["companyName", "I.V.M."] call ADVSEC_fnc_setting] select ((["pmcProfile", 1] call ADVSEC_fnc_setting) isEqualTo 1), ADVSEC_icPol,
    {[_target, "unit"] call ADVSEC_fnc_policeMenu},
    {alive _target && {[_player, "PMC"] call ADVSEC_fnc_repAccess}},
    "main", [], 3, [0, 0, 0],
    {[_target, _player, "unit"] call ADVSEC_fnc_policeChildren}
] call ADVSEC_fnc_addInteraction;

[_unit, "advsec_bribe", ("STR_ADVSEC_offer_money" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_bribeOffer},
    {alive _target && {isPlayer _target} && {[] call ADVSEC_fnc_ecoOn} && {[_target, "PM"] call ADVSEC_fnc_repAccess} && {!([_player, "PM"] call ADVSEC_fnc_repAccess)}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
