// Panel de AA.II.: índice de sospecha de los agentes
["heat", ("STR_ADVSEC_internal_affairs_suspicion_index" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_open_case_file" call ADVSEC_fnc_L), {
        params ["_uid"];
        if (isNil "_uid") exitWith {};
        closeDialog 0;
        ["AI", format ["[%1]", _uid]] call ADVSEC_fnc_repEditorOpen;
    }],
    [("STR_ADVSEC_archive_index" call ADVSEC_fnc_L), {
        params ["_uid"];
        if (!isNil "_uid") then {["reset", player, [_uid]] remoteExecCall ["ADVSEC_fnc_heatServer", 2]};
    }],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_heatServer", 2]}] call ADVSEC_fnc_panelOpen;
