// Tesorería de la PM: saldo, movimientos y primas a agentes (permiso treasury)
if !([player, "treasury"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_your_rank_does_not_allow_4" call ADVSEC_fnc_L)};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
ADVSEC_ecoAmounts = [50, 100, 200, 500, 1000, 2000, 5000] apply {[format ["%1 %2", _x, _cur], _x]};
["treasury", ("STR_ADVSEC_military_police_treasury" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_pay_bonus" call ADVSEC_fnc_L), {[("STR_ADVSEC_bonus_from_the_treasury" call ADVSEC_fnc_L), [[("STR_ADVSEC_officer" call ADVSEC_fnc_L), objNull, "players"], [("STR_ADVSEC_amount" call ADVSEC_fnc_L), 200, ADVSEC_ecoAmounts], [("STR_ADVSEC_other_amount_optional" call ADVSEC_fnc_L), ""], [("STR_ADVSEC_reason" call ADVSEC_fnc_L), ("STR_ADVSEC_service_bonus" call ADVSEC_fnc_L)]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["bonus", player, [_v select 0, _n, _v select 3]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_my_wallet" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoOpen}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["treasury", player] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}] call ADVSEC_fnc_panelOpen;
