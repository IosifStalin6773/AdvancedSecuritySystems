/*
    [npc, acción, parámetro] (cliente) — lo que hace una respuesta del diálogo.
    "code" código SQF (_player, _npc) · "setVar" nombre=valor (variable de misión, compartida) · "giveItem"/"takeItem" clase
    "join" el NPC se une al grupo del jugador · "contracts" abre el terminal de contratos · "hint" texto en pantalla
*/
params ["_npc", ["_ac", ""], ["_pr", ""]];
private _player = player;
switch (_ac) do {
    case "code": {if (_pr isNotEqualTo "") then {call compile _pr}};
    case "setVar": {
        private _i = _pr find "=";
        if (_i > 0) then {
            private _k = (_pr select [0, _i]) trim [" ", 0];
            private _v = (_pr select [_i + 1]) trim [" ", 0];
            private _val = switch (true) do {
                case (toLower _v == "true"): {true};
                case (toLower _v == "false"): {false};
                case ((parseNumber _v) != 0 || {_v == "0"}): {parseNumber _v};
                default {_v};
            };
            missionNamespace setVariable [_k, _val, true];
        };
    };
    case "giveItem": {if (isClass (configFile >> "CfgWeapons" >> _pr) || {isClass (configFile >> "CfgMagazines" >> _pr)} || {isClass (configFile >> "CfgGlasses" >> _pr)}) then {if (player canAdd _pr) then {player addItem _pr} else {player addItemToUniform _pr}}};
    case "takeItem": {player removeItem _pr; player removeMagazine _pr};
    case "join": {[_npc] joinSilent group player};
    case "contracts": {[] call ADVSEC_fnc_ctrOpen};
    case "hint": {hint _pr};
};
