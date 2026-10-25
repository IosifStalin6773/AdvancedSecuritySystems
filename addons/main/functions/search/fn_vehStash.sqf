// [vehículo] — esconder un objeto propio en los bajos del vehículo (o recuperar lo escondido)
params ["_veh"];
private _opts = [["(recuperar lo escondido)", ""]];
{
    private _mag = isClass (configFile >> "CfgMagazines" >> _x);
    private _c = configFile >> (["CfgWeapons", "CfgMagazines"] select _mag) >> _x;
    if (isClass _c) then {_opts pushBackUnique [getText (_c >> "displayName"), _x]};
} forEach (items player + magazines player);
["DOBLE FONDO", [["Objeto", "", _opts]], {
    params ["_v", "_veh"];
    if ((_v select 0) isEqualTo "") exitWith {["unstash", player, [_veh]] remoteExecCall ["ADVSEC_fnc_vehServer", 2]};
    ["stash", player, [_veh, _v select 0]] remoteExecCall ["ADVSEC_fnc_vehServer", 2];
}, _veh] call ADVSEC_fnc_zeusPrompt;
