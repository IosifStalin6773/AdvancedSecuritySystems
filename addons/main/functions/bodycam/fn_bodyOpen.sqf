// AA.II.: cámaras corporales de los agentes
["bodycam", ("STR_ADVSEC_ia_body_cameras" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_view_recording" call ADVSEC_fnc_L), {params ["_uid"]; if (!isNil "_uid") then {["view", player, [_uid]] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]}}],
    [("STR_ADVSEC_view_live" call ADVSEC_fnc_L), {params ["_uid"]; closeDialog 0; [_uid] spawn {sleep 0.1; ["open", _this param [0, ""]] call ADVSEC_fnc_bodyLive}}],
    [("STR_ADVSEC_m_clip_btn" call ADVSEC_fnc_L), {params ["_uid"]; if (!isNil "_uid") then {["clip", player, [_uid]] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]}}],
    [("STR_ADVSEC_back_to_the_list" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]}] call ADVSEC_fnc_panelOpen;
