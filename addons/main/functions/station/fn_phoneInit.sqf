// [objeto] (todas las máquinas, 1.24): teléfono de comisaría. Suena con cada aviso; la PM contesta y cualquiera deja un mensaje.
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {
    [_obj, "phone", ("STR_ADVSEC_phone" call ADVSEC_fnc_L)] call ADVSEC_fnc_register;
    if (isNil "ADVSEC_phones") then {ADVSEC_phones = []};
    ADVSEC_phones pushBackUnique _obj;
};
[_obj, "advsec_phone_answer", ("STR_ADVSEC_phone_answer" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {["answer", _player, [_target]] remoteExecCall ["ADVSEC_fnc_phoneServer", 2]; [] call ADVSEC_fnc_dspOpen},
    {[_player, "PMC"] call ADVSEC_fnc_repAccess},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_phone_msg", ("STR_ADVSEC_phone_leave" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {
        [("STR_ADVSEC_phone_leave" call ADVSEC_fnc_L), [[("STR_ADVSEC_phone_f_msg" call ADVSEC_fnc_L), "", "text"]], {
            params ["_v", "_obj"];
            ["msg", player, [_obj, _v select 0]] remoteExecCall ["ADVSEC_fnc_phoneServer", 2];
        }, _target] call ADVSEC_fnc_zeusPrompt;
    },
    {true},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
