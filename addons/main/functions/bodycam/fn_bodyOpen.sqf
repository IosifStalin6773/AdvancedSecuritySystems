// AA.II.: cámaras corporales de los agentes
["bodycam", "AA.II. · Cámaras corporales", [
    ["Ver grabación", {params ["_uid"]; if (!isNil "_uid") then {["view", player, [_uid]] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]}}],
    ["Ver en directo", {params ["_uid"]; closeDialog 0; [_uid] spawn {sleep 0.1; ["open", _this param [0, ""]] call ADVSEC_fnc_bodyLive}}],
    ["Volver a la lista", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]}] call ADVSEC_fnc_panelOpen;
