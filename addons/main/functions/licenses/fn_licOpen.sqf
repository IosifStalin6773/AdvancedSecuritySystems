// [oficina] — comprar licencias y registrar armas
params ["_o"];
ADVSEC_licOffice = _o;
["lic", ("STR_ADVSEC_licences_and_weapon_registry" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_buy_licence" call ADVSEC_fnc_L), {params ["_t"]; if (!isNil "_t") then {["buy", player, [ADVSEC_licOffice, _t]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}}],
    [("STR_ADVSEC_register_my_weapons" call ADVSEC_fnc_L), {["regWeapons", player, [ADVSEC_licOffice]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player, [ADVSEC_licOffice]] remoteExecCall ["ADVSEC_fnc_licServer", 2]}] call ADVSEC_fnc_panelOpen;
