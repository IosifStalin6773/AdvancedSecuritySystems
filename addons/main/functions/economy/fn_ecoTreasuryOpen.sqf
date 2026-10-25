// Tesorería de la PM: saldo, movimientos y primas a agentes (permiso treasury)
if !([player, "treasury"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite gestionar la tesorería."};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
ADVSEC_ecoAmounts = [50, 100, 200, 500, 1000, 2000, 5000] apply {[format ["%1 %2", _x, _cur], _x]};
["treasury", "Tesorería de la Policía Militar", [
    ["Pagar prima", {["PRIMA DESDE LA TESORERÍA", [["Agente", objNull, "players"], ["Importe", 200, ADVSEC_ecoAmounts], ["Otro importe (opcional)", ""], ["Motivo", "Prima por servicio"]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["bonus", player, [_v select 0, _n, _v select 3]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    ["Mi cartera", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoOpen}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["treasury", player] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}] call ADVSEC_fnc_panelOpen;
