// [objeto] (todas las máquinas, 1.24): club de suboficiales. Barra, cartas, dardos y tablón de récords.
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "club", ("STR_ADVSEC_club" call ADVSEC_fnc_L)] call ADVSEC_fnc_register};
private _cond = {(_player getVariable ["ADVSEC_globalRankIdx", 0]) >= (["clubMinRank", 0] call ADVSEC_fnc_setting)};
[_obj, "advsec_club_drink", ("STR_ADVSEC_club_drink" call ADVSEC_fnc_L), ADVSEC_icDoc, {["drink", _player, [_target]] remoteExecCall ["ADVSEC_fnc_clubServer", 2]}, _cond, "main", [], 3] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_club_cards", ("STR_ADVSEC_club_cards" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {
        [("STR_ADVSEC_club_cards" call ADVSEC_fnc_L), [[("STR_ADVSEC_club_f_bet" call ADVSEC_fnc_L), 20, [10, 20, 50, 100, 200] apply {[str _x, _x]}]], {
            params ["_v", "_t"];
            ["cards", player, [_t, _v select 0]] remoteExecCall ["ADVSEC_fnc_clubServer", 2];
        }, _target] call ADVSEC_fnc_zeusPrompt;
    }, _cond, "main", [], 3] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_club_darts", ("STR_ADVSEC_club_darts" call ADVSEC_fnc_L), ADVSEC_icDoc, {["darts", _player, [_target]] remoteExecCall ["ADVSEC_fnc_clubServer", 2]}, _cond, "main", [], 3] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_club_board", ("STR_ADVSEC_club_board" call ADVSEC_fnc_L), ADVSEC_icDoc, {["board", _player, [_target]] remoteExecCall ["ADVSEC_fnc_clubServer", 2]}, {true}, "main", [], 3] call ADVSEC_fnc_addInteraction;
