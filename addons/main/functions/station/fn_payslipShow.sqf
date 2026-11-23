// (cliente, 1.24) recibo de la última nómina cobrada
private _p = player getVariable ["ADVSEC_payslip", []];
if (_p isEqualTo []) exitWith {hint ("STR_ADVSEC_pay_none" call ADVSEC_fnc_L)};
_p params ["_date", "_lines", "_total", "_bank", ["_dyn", 0]];
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _t = format ["<t size='1.1' font='PuristaBold'>%1</t><br/>%2 · %3<br/><br/>", "STR_ADVSEC_pay_slip" call ADVSEC_fnc_L, name player, _date];
{
    _x params ["_k", "_v"];
    _t = _t + format ["%1<t align='right'>%2 %3</t><br/>", _k call ADVSEC_fnc_L, _v, _cur];
} forEach _lines;
if (_dyn > 0) then {_t = _t + format ["<t color='#D0A330'>%1</t><br/>", format [("STR_ADVSEC_pay_dyn_note" call ADVSEC_fnc_L), _dyn, "%"]]};
_t = _t + format ["<br/><t font='PuristaBold'>%1</t><t align='right' font='PuristaBold'>%2 %3</t><br/>%4<t align='right'>%5 %3</t>",
    "STR_ADVSEC_pay_l_total" call ADVSEC_fnc_L, _total, _cur, "STR_ADVSEC_pay_l_bank" call ADVSEC_fnc_L, _bank];
[_t, "STR_ADVSEC_pay_slip" call ADVSEC_fnc_L] call ADVSEC_fnc_carShow;
