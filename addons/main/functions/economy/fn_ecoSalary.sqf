/*
    (servidor) Nómina a cada jugador conectado, ingresada en el banco:
    salaryBase + salaryPM[nivel PM] + salaryAI[nivel AA.II.] + rango global × salaryGlobalStep.
    Con salaryFromTreasury = 1 la paga la tesorería de la PM (si no llega, no se paga).
*/
private _base = ["salaryBase", 100] call ADVSEC_fnc_setting;
private _pmT = ["salaryPM", [0, 150, 250, 400, 600, 900]] call ADVSEC_fnc_setting;
private _aiT = ["salaryAI", [0, 150, 250, 400, 600, 900]] call ADVSEC_fnc_setting;
private _gStep = ["salaryGlobalStep", 20] call ADVSEC_fnc_setting;
private _fromT = (["salaryFromTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1;
private _pdb = [] call ADVSEC_fnc_pdbDB;
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
// 1.24: paga dinámica (pocos agentes de servicio = plus) y tope de ahorro (el exceso va a la tesorería)
private _dyn = 0;
if ((["payDynamic", 1] call ADVSEC_fnc_setting) isEqualTo 1) then {
    private _nDuty = {_x getVariable ["ADVSEC_onDuty", false]} count allPlayers;
    private _miss = ((["payDynTarget", 4] call ADVSEC_fnc_setting) - _nDuty) max 0;
    _dyn = (_miss * (["payDynStep", 0.1] call ADVSEC_fnc_setting)) min (["payDynMax", 0.5] call ADVSEC_fnc_setting);
};
private _cap = ["bankCap", 0] call ADVSEC_fnc_setting;
{
    private _uid = getPlayerUID _x;
    if (_uid isNotEqualTo "") then {
        private _g = (_pdb getOrDefault [_uid, []]) param [7, 0];
        if !(_g isEqualType 0) then {_g = 0};
        // Plus PM/AA.II. solo de servicio (salaryDutyOnly)
        private _plus = (_pmT param [[_x, "PM"] call ADVSEC_fnc_rankLevel, 0]) + (_aiT param [[_x, "AI"] call ADVSEC_fnc_rankLevel, 0]);
        if ((["salaryDutyOnly", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {!(_x getVariable ["ADVSEC_onDuty", false])}) then {_plus = 0};
        // 1.22: incentivo por rendimiento: salaryArrestBonus por cada arresto registrado en las últimas 24 h
        private _arr = 0;
        private _bonusArr = ["salaryArrestBonus", 0] call ADVSEC_fnc_setting;
        if (_bonusArr > 0) then {
            {if ((_x select 4) == _uid && {(_x select 2) == "jail"} && {serverTime - (_x select 1) < 86400}) then {_arr = _arr + 1}} forEach (localNamespace getVariable ["ADVSEC_eventLog", []]);
        };
        private _qrf = [_uid] call ADVSEC_fnc_cellStandby;
        // El plus dinámico solo se aplica al plus de servicio
        private _dynAmt = round (_plus * _dyn);
        private _amt = round (_base + _plus + _dynAmt + _g * _gStep + _arr * _bonusArr) + _qrf;
        private _lines = [
            ["STR_ADVSEC_pay_l_base", _base], ["STR_ADVSEC_pay_l_rank", _plus], ["STR_ADVSEC_pay_l_dyn", _dynAmt], ["STR_ADVSEC_pay_l_global", _g * _gStep],
            ["STR_ADVSEC_pay_l_arrest", _arr * _bonusArr], ["STR_ADVSEC_pay_l_qrf", _qrf]
        ];
        // Pagos por informe cobrados desde la última nómina (ya ingresados al cerrar cada aviso)
        private _rep = _x getVariable ["ADVSEC_payRep", 0];
        _x setVariable ["ADVSEC_payRep", 0];
        if (_rep > 0) then {_lines pushBack ["STR_ADVSEC_pay_l_reports", _rep]};
        if (_amt > 0 && {!_fromT || {([] call ADVSEC_fnc_ecoTreasuryNow) >= _amt}}) then {
            if (_fromT) then {[-_amt, format [("STR_ADVSEC_payroll" call ADVSEC_fnc_L), name _x]] call ADVSEC_fnc_ecoTreasury};
            private _a = [_uid, name _x] call ADVSEC_fnc_ecoAcc;
            private _over = 0;
            if (_cap > 0) then {_over = (((_a select 1) + _amt) - _cap) max 0 min _amt};
            if (_over > 0) then {
                _lines pushBack ["STR_ADVSEC_pay_l_cap", -_over];
                [_over, format [("STR_ADVSEC_pay_cap_treas" call ADVSEC_fnc_L), name _x]] call ADVSEC_fnc_ecoTreasury;
            };
            _a set [1, (_a select 1) + _amt - _over];
            _x setVariable ["ADVSEC_bank", _a select 1, true];
            [_a, ("STR_ADVSEC_payroll_2" call ADVSEC_fnc_L), _amt - _over] call ADVSEC_fnc_ecoHist;
            (format [("STR_ADVSEC_salary_paid_in" call ADVSEC_fnc_L), _amt - _over, _cur]) remoteExecCall ["hintSilent", _x];
            // Recibo de nómina: solo lo recibe el propio jugador
            _x setVariable ["ADVSEC_payslip", [call ADVSEC_fnc_now, _lines select {(_x select 1) != 0}, _amt - _over, _a select 1, round (_dyn * 100)], owner _x];
        };
    };
} forEach (allPlayers - entities "HeadlessClient_F");
