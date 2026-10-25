// [oficina] — comprar licencias y registrar armas
params ["_o"];
ADVSEC_licOffice = _o;
["lic", "Licencias y registro de armas", [
    ["Comprar licencia", {params ["_t"]; if (!isNil "_t") then {["buy", player, [ADVSEC_licOffice, _t]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}}],
    ["Registrar mis armas", {["regWeapons", player, [ADVSEC_licOffice]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player, [ADVSEC_licOffice]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}] call ADVSEC_fnc_panelOpen;
