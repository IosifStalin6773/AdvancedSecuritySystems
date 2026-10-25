// Cartera: efectivo, banco e historial; cajero (ingresar, retirar, transferir) y dar efectivo
if !([] call ADVSEC_fnc_ecoOn) exitWith {hint "La economía de ADVSEC está desactivada en esta misión."};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _amounts = [10, 50, 100, 200, 500, 1000, 2000, 5000, 10000] apply {[format ["%1 %2", _x, _cur], _x]};
ADVSEC_ecoAmounts = _amounts;
private _btns = [
    ["Ingresar", {["INGRESAR EN EL BANCO", [["Importe", 100, ADVSEC_ecoAmounts], ["Otro importe (opcional)", ""]], {
        params ["_v"];
        private _n = [_v select 0, parseNumber (_v select 1)] select ((_v select 1) isNotEqualTo "");
        ["deposit", player, [_n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    ["Retirar", {["RETIRAR DEL BANCO", [["Importe", 100, ADVSEC_ecoAmounts], ["Otro importe (opcional)", ""]], {
        params ["_v"];
        private _n = [_v select 0, parseNumber (_v select 1)] select ((_v select 1) isNotEqualTo "");
        ["withdraw", player, [_n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    ["Transferir", {["TRANSFERENCIA BANCARIA", [["Destinatario", objNull, "players"], ["Importe", 100, ADVSEC_ecoAmounts], ["Otro importe (opcional)", ""]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["transfer", player, [getPlayerUID (_v select 0), _n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    ["Dar efectivo", {["DAR EFECTIVO", [["Persona (a menos de 5 m)", objNull, "players"], ["Importe", 50, ADVSEC_ecoAmounts], ["Otro importe (opcional)", ""]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["give", player, [_v select 0, _n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}]
];
if ([player, "treasury"] call ADVSEC_fnc_perm) then {
    _btns pushBack ["Tesorería PM", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoTreasuryOpen}}];
} else {
    _btns pushBack ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}];
};
["wallet", "Cartera y banco", _btns, {["wallet", player] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}] call ADVSEC_fnc_panelOpen;
