// [unidad] — PM: retirar una licencia
params ["_u"];
["RETIRAR LICENCIA · " + name _u, [["Licencia", "WeaponLicense", (["licensePrices", []] call ADVSEC_fnc_setting) apply {[getText (([_x select 0] call ADVSEC_fnc_docTypeCfg) >> "displayName"), _x select 0]}]], {
    params ["_v", "_u"];
    ["revoke", player, [_u, _v select 0]] remoteExecCall ["ADVSEC_fnc_licServer", 2];
}, _u] call ADVSEC_fnc_zeusPrompt;
