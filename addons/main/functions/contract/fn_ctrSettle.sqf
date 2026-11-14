/*
    [id, contrato, resultado] (servidor) Liquida un contrato: pago final, penalizaciones, costes, reparto y reputación.
    Solo se llama desde ADVSEC_fnc_ctrServer (usa sus variables locales _repAdd, _notify, _fmt, _clName, _cfgOf).
*/
params ["_id", "_c", "_res"];
private _m = _c get "metrics";
_c set ["state", _res];
private _pay = _c get "pay";
private _adv = round (_pay * (_c get "adv"));
private _factor = switch (_res) do {case "Cumplido": {1}; case "Parcial": {0.5}; default {0}};
// 1.22: pagos por hitos. Con la ruta dividida en puntos, un contrato parcial o fallido cobra la parte de la ruta cumplida.
private _rch = _c get "reached";
private _ms = (["contractMilestones", 0] call ADVSEC_fnc_setting) isEqualTo 1;
private _hit = count (_rch select {_x});
if (_ms && {_res in ["Parcial", "Fallido"]} && {_rch isNotEqualTo []}) then {_factor = _hit / (count _rch)};
private _final = round ((_pay - _adv) * _factor);
private _pen = 0; {_pen = _pen + (_x select 1)} forEach (_m get "penal");
if (_res in ["Fallido", "Rescindido"]) then {_pen = _pen + round (_pay * (_c get "penal"))};
// Bonus de avanzada (protección VIP)
private _bonus = 0;
if ((_c get "type") == "vip" && {_res == "Cumplido"} && {_m get "advance"}) then {_bonus = round (_pay * (["cpAdvanceBonus", 0.1] call ADVSEC_fnc_setting))};
// Exposición del VIP: -1 % por cada 10 s a pie sin escolta
private _expo = round (_pay * (["cpExposurePenalty", 0.01] call ADVSEC_fnc_setting) * floor ((_m get "exposure") / 10));
_pen = _pen + _expo;
// Vehículo corporativo dañado (el del VIP)
private _veh = ((_c getOrDefault ["vipVeh", ""]) call BIS_fnc_objectFromNetId);
if (!isNull _veh) then {
    private _val = _veh getVariable ["ADVSEC_vehValue", 20000];
    private _cost = round ((damage _veh) * _val * 0.5);
    if (!alive _veh) then {_cost = _val};
    if (_cost > 0) then {(_m get "costs") pushBack [("STR_ADVSEC_pmc_cost_vehicle" call ADVSEC_fnc_L), _cost]};
};
// 1.22: comisión de la subcontrata, que cobra el firmante original
private _sf = _c getOrDefault ["subFrom", []];
if (_sf isNotEqualTo []) then {
    private _fee = round (_pay * (_sf select 2));
    if (_fee > 0) then {
        (_m get "costs") pushBack [("STR_ADVSEC_pmc_cost_subfee" call ADVSEC_fnc_L), _fee];
        [-_fee, format [("STR_ADVSEC_pmc_treasury_sub" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_ecoTreasury;
        [_sf select 0, _sf select 1, _fee, format [("STR_ADVSEC_pmc_sub_paid" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_pmcPay;
    };
};
private _costs = 0; {_costs = _costs + (_x select 1)} forEach (_m get "costs");
// Material perdido con seguro: se recupera la mitad
private _lost = 0; {if ((_x select 0) == ("STR_ADVSEC_pmc_cost_lost" call ADVSEC_fnc_L)) then {_lost = _lost + (_x select 1)}} forEach (_m get "costs");
private _ins = [0, round (_lost * 0.5)] select (_c get "insured");
// Tesorería: el anticipo ya entró al firmar
[_final + _bonus + _ins - _pen, format [("STR_ADVSEC_pmc_treasury_settle" call ADVSEC_fnc_L), _id, _res call ADVSEC_fnc_Lv]] call ADVSEC_fnc_ecoTreasury;
private _profit = _adv + _final + _bonus + _ins - _pen - _costs;
// Reparto entre los asignados conectados y de servicio, solo si hay beneficio
private _share = 0;
private _who = (_c get "assigned") select {private _u = [_x select 0] call ADVSEC_fnc_uidUnit; !isNull _u && {_u getVariable ["ADVSEC_onDuty", false]}};
if (_profit > 0 && {_who isNotEqualTo []} && {[] call ADVSEC_fnc_ecoOn}) then {
    _share = floor (_profit * (["contractOpShare", 0.4] call ADVSEC_fnc_setting) / count _who);
    if (_share > 0) then {
        [-(_share * count _who), format [("STR_ADVSEC_pmc_treasury_share" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_ecoTreasury;
        {[_x select 0, _x select 1, _share, format [("STR_ADVSEC_pmc_share" call ADVSEC_fnc_L), _id]] call ADVSEC_fnc_pmcPay} forEach _who;
    };
};
// Reputación: cliente propio y rivales
private _client = _c get "client";
private _d = switch (_res) do {
    case "Cumplido": {["contractRepGain", 10] call ADVSEC_fnc_setting};
    case "Parcial": {3};
    case "Rescindido": {-25};
    default {-(["contractRepLoss", 20] call ADVSEC_fnc_setting)};
};
[_client, _d, format ["%1 · %2", _id, _res call ADVSEC_fnc_Lv]] call _repAdd;
private _incRep = 0;
{
    private _k = _x select 0;
    private _cc = ["Collateral", _k] call _cfgOf;
    if (!isNull _cc) then {
        _incRep = _incRep + ([_cc, "rep", 0] call ADVSEC_fnc_pmcVal) + round (([_cc, "repPer1000", 0] call ADVSEC_fnc_pmcVal) * (_x select 4) / 1000);
    };
} forEach (_m get "incidents");
if (_incRep != 0) then {[_client, _incRep, format [("STR_ADVSEC_pmc_rep_incidents" call ADVSEC_fnc_L), _id]] call _repAdd};
private _rv = switch (_res) do {case "Cumplido": {-(["contractRivalLoss", 4] call ADVSEC_fnc_setting)}; case "Parcial": {-2}; case "Fallido": {2}; default {0}};
private _ccl = ["Clients", _client] call _cfgOf;
{[_x, _rv, format [("STR_ADVSEC_pmc_rep_rival" call ADVSEC_fnc_L), _id, _client call _clName]] call _repAdd} forEach ([_ccl, "rivals", []] call ADVSEC_fnc_pmcVal);
private _ce = _cl getOrDefault [_client, [0, 0, 0, 0, []]];
if (_res in ["Cumplido", "Parcial"]) then {_ce set [1, (_ce select 1) + 1]} else {_ce set [2, (_ce select 2) + 1]};
_ce set [3, call ADVSEC_fnc_utcMin];
// Hoja de liquidación
private _lines = [
    format [("STR_ADVSEC_pmc_settle_head" call ADVSEC_fnc_L), _res call ADVSEC_fnc_Lv],
    format [("STR_ADVSEC_pmc_settle_advance" call ADVSEC_fnc_L), _adv call _fmt],
    format [("STR_ADVSEC_pmc_settle_final" call ADVSEC_fnc_L), _final call _fmt, round (_factor * 100)]
];
if (_ms && {_rch isNotEqualTo []} && {_res in ["Parcial", "Fallido"]}) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_milestones" call ADVSEC_fnc_L), _hit, count _rch]};
if (_bonus > 0) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_bonus" call ADVSEC_fnc_L), _bonus call _fmt]};
if (_ins > 0) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_insurance" call ADVSEC_fnc_L), _ins call _fmt]};
{_lines pushBack format ["− %1: %2", (format ["STR_ADVSEC_pmc_inc_%1", _x select 0]) call ADVSEC_fnc_L, (_x select 1) call _fmt]} forEach (_m get "penal");
if (_res in ["Fallido", "Rescindido"]) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_penalty" call ADVSEC_fnc_L), (round (_pay * (_c get "penal"))) call _fmt]};
if (_expo > 0) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_exposure" call ADVSEC_fnc_L), _expo call _fmt, round (_m get "exposure")]};
{_lines pushBack format ["− %1: %2", _x select 0, (_x select 1) call _fmt]} forEach (_m get "costs");
_lines pushBack format [("STR_ADVSEC_pmc_settle_profit" call ADVSEC_fnc_L), _profit call _fmt, [0, round (100 * _profit / (_pay max 1))] select (_pay > 0)];
if (_share > 0) then {_lines pushBack format [("STR_ADVSEC_pmc_settle_share" call ADVSEC_fnc_L), _share call _fmt, count _who]};
if ((_c get "result") isNotEqualTo "" && {(_c get "result") isNotEqualTo _res}) then {_lines pushBack ((_c get "result") call ADVSEC_fnc_repEsc)};
_c set ["sheet", (_lines joinString "<br/>") + ([ "", "<br/>" + ((_c get "sheet") call ADVSEC_fnc_repEsc)] select ((_c get "sheet") isNotEqualTo ""))];
_c set ["profit", _profit];
// Informe F-PMC-01
private _rid = ["FPMC01", format [("STR_ADVSEC_pmc_report_title" call ADVSEC_fnc_L), _id, _c get "title"], (_c get "assigned") apply {format ["%1 [%2]", _x select 1, _x select 0]},
    format [("STR_ADVSEC_pmc_report_body" call ADVSEC_fnc_L), _id, _client call _clName, _c get "type", _c get "start", _c get "end", (_c get "roe") call ADVSEC_fnc_Lv, endl,
        ((_lines apply {_x regexReplace ["<[^>]*>", ""]}) joinString endl), count (_m get "incidents")],
    ["Leve", "Grave"] select (_res in ["Fallido", "Rescindido"] || {(_m get "incidents") isNotEqualTo []}), false] call ADVSEC_fnc_repSystem;
_c set ["report", _rid];
[_c, format [("STR_ADVSEC_pmc_closed_msg" call ADVSEC_fnc_L), _id, toUpper (_res call ADVSEC_fnc_Lv), _profit call _fmt, [("STR_ADVSEC_pmc_none" call ADVSEC_fnc_L), _share call _fmt] select (_share > 0)]] call _notify;
["contractClose", objNull, [_id, _res, _profit, _share, count (_m get "incidents")]] call ADVSEC_fnc_logEvent;
["contracts"] call ADVSEC_fnc_dbDirty;
["clients"] call ADVSEC_fnc_dbDirty;
