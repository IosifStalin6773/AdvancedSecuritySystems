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
{
    private _uid = getPlayerUID _x;
    if (_uid isNotEqualTo "") then {
        private _g = (_pdb getOrDefault [_uid, []]) param [7, 0];
        if !(_g isEqualType 0) then {_g = 0};
        // Plus PM/AA.II. solo de servicio (salaryDutyOnly)
        private _plus = (_pmT param [[_x, "PM"] call ADVSEC_fnc_rankLevel, 0]) + (_aiT param [[_x, "AI"] call ADVSEC_fnc_rankLevel, 0]);
        if ((["salaryDutyOnly", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {!(_x getVariable ["ADVSEC_onDuty", false])}) then {_plus = 0};
        private _amt = round (_base + _plus + _g * _gStep);
        if (_amt > 0 && {!_fromT || {([] call ADVSEC_fnc_ecoTreasuryNow) >= _amt}}) then {
            if (_fromT) then {[-_amt, format [("STR_ADVSEC_payroll" call ADVSEC_fnc_L), name _x]] call ADVSEC_fnc_ecoTreasury};
            private _a = [_uid, name _x] call ADVSEC_fnc_ecoAcc;
            _a set [1, (_a select 1) + _amt];
            _x setVariable ["ADVSEC_bank", _a select 1, true];
            [_a, ("STR_ADVSEC_payroll_2" call ADVSEC_fnc_L), _amt] call ADVSEC_fnc_ecoHist;
            (format [("STR_ADVSEC_salary_paid_in" call ADVSEC_fnc_L), _amt, _cur]) remoteExecCall ["hintSilent", _x];
        };
    };
} forEach (allPlayers - entities "HeadlessClient_F");
