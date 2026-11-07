/*
    (servidor) Armería corporativa: carga contador de series, deudas y material firmado.
    Material corporativo en _weapons: serie -> [clase, uidPortador, nombrePortador, fecha, "CORP", estado, [uidFirma, nombreFirma, fecha], desgaste 0-1, valor, historial, caja]
    Estados (en español): Armería, Firmada, Perdida, Incautada, Destruida, Retirada.
    Al cargar, lo que quedó Firmada en la sesión anterior pasa a Perdida y se apunta la deuda del firmante (se cobra al volver a conectar).
*/
if (!isNil {localNamespace getVariable "ADVSEC_armReady"}) exitWith {};
localNamespace setVariable ["ADVSEC_armReady", true];
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _w = [] call ADVSEC_fnc_wpnDB;
localNamespace setVariable ["ADVSEC_armSeq", profileNamespace getVariable [ADVSEC_repKey + "_armseq", 0]];
private _debts = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_debts set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_armory", []]);
private _f = ["armoryLossFactor", 1.5] call ADVSEC_fnc_setting;
{
    if ((_y param [4, ""]) == "CORP" && {(_y select 5) == "Firmada"}) then {
        _y set [5, "Perdida"];
        (_y select 9) pushBack [call ADVSEC_fnc_now, ("STR_ADVSEC_pmc_arm_not_returned" call ADVSEC_fnc_L)];
        private _s = (_y select 6) param [0, ""];
        if (_s isNotEqualTo "") then {
            private _d = _debts getOrDefault [_s, [0, []]];
            _d set [0, (_d select 0) + round ((_y select 8) * _f)];
            (_d select 1) pushBack _x;
            _debts set [_s, _d];
        };
    };
} forEach _w;
localNamespace setVariable ["ADVSEC_armDebts", _debts];
localNamespace setVariable ["ADVSEC_armSigned", createHashMap];
["weapons"] call ADVSEC_fnc_dbDirty;
["armory"] call ADVSEC_fnc_dbDirty;
