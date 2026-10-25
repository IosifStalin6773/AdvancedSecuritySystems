// Ocultar un objeto del uniforme o chaleco: no aparece en el cacheo normal, solo en "Piernas y escondites" con cierta probabilidad
private _h = (player getVariable ["ADVSEC_hidden", []]) select {_x in (uniformItems player + vestItems player)};
if (count _h >= 2) exitWith {hint "Ya llevas dos objetos escondidos."};
private _opts = [];
{
    private _c = configFile >> (["CfgWeapons", "CfgMagazines"] select (isClass (configFile >> "CfgMagazines" >> _x))) >> _x;
    if (isClass _c && {getNumber (_c >> "ItemInfo" >> "mass") <= 20 || {isClass (configFile >> "CfgMagazines" >> _x)}}) then {_opts pushBackUnique [getText (_c >> "displayName"), _x]};
} forEach ((uniformItems player + vestItems player) - _h);
if (_opts isEqualTo []) exitWith {hint "No llevas nada pequeño que puedas esconder (uniforme o chaleco)."};
["OCULTAR OBJETO", [["Objeto", (_opts select 0) select 1, _opts]], {
    params ["_v"];
    private _h = (player getVariable ["ADVSEC_hidden", []]) select {_x in (uniformItems player + vestItems player)};
    _h pushBack (_v select 0);
    player setVariable ["ADVSEC_hidden", _h, true];
    hint "Objeto escondido. Un cacheo a fondo puede encontrarlo.";
}] call ADVSEC_fnc_zeusPrompt;
