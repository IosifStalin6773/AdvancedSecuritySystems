// Cartera: efectivo, banco e historial; cajero (ingresar, retirar, transferir) y dar efectivo
if !([] call ADVSEC_fnc_ecoOn) exitWith {hint ("STR_ADVSEC_the_advsec_economy_is_disabled" call ADVSEC_fnc_L)};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _amounts = [10, 50, 100, 200, 500, 1000, 2000, 5000, 10000] apply {[format ["%1 %2", _x, _cur], _x]};
ADVSEC_ecoAmounts = _amounts;
private _btns = [
    [("STR_ADVSEC_deposit" call ADVSEC_fnc_L), {[("STR_ADVSEC_deposit_into_the_bank" call ADVSEC_fnc_L), [[("STR_ADVSEC_amount" call ADVSEC_fnc_L), 100, ADVSEC_ecoAmounts], [("STR_ADVSEC_other_amount_optional" call ADVSEC_fnc_L), ""]], {
        params ["_v"];
        private _n = [_v select 0, parseNumber (_v select 1)] select ((_v select 1) isNotEqualTo "");
        ["deposit", player, [_n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_withdraw" call ADVSEC_fnc_L), {[("STR_ADVSEC_withdraw_from_the_bank" call ADVSEC_fnc_L), [[("STR_ADVSEC_amount" call ADVSEC_fnc_L), 100, ADVSEC_ecoAmounts], [("STR_ADVSEC_other_amount_optional" call ADVSEC_fnc_L), ""]], {
        params ["_v"];
        private _n = [_v select 0, parseNumber (_v select 1)] select ((_v select 1) isNotEqualTo "");
        ["withdraw", player, [_n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_transfer_2" call ADVSEC_fnc_L), {[("STR_ADVSEC_bank_transfer" call ADVSEC_fnc_L), [[("STR_ADVSEC_recipient" call ADVSEC_fnc_L), objNull, "players"], [("STR_ADVSEC_amount" call ADVSEC_fnc_L), 100, ADVSEC_ecoAmounts], [("STR_ADVSEC_other_amount_optional" call ADVSEC_fnc_L), ""]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["transfer", player, [getPlayerUID (_v select 0), _n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_give_cash" call ADVSEC_fnc_L), {[("STR_ADVSEC_give_cash_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_person_within_5_m" call ADVSEC_fnc_L), objNull, "players"], [("STR_ADVSEC_amount" call ADVSEC_fnc_L), 50, ADVSEC_ecoAmounts], [("STR_ADVSEC_other_amount_optional" call ADVSEC_fnc_L), ""]], {
        params ["_v"];
        if (isNull (_v select 0)) exitWith {};
        private _n = [_v select 1, parseNumber (_v select 2)] select ((_v select 2) isNotEqualTo "");
        ["give", player, [_v select 0, _n]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}]
];
if ([player, "treasury"] call ADVSEC_fnc_perm) then {
    _btns pushBack [("STR_ADVSEC_mp_treasury_3" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoTreasuryOpen}}];
} else {
    _btns pushBack [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}];
};
["wallet", ("STR_ADVSEC_wallet_and_bank" call ADVSEC_fnc_L), _btns, {["wallet", player] remoteExecCall ["ADVSEC_fnc_ecoServer", 2]}] call ADVSEC_fnc_panelOpen;
