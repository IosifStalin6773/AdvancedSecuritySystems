/*
    (servidor) -> hashmap id -> contrato (hashmap). Carga también la reputación de clientes (ADVSEC_ctrClients).
    Contrato: id, client, type, title, pos, radius, route, minutes, pay, adv, penal, repMin, specs, minOps, grey, risk, rounds,
              state, signer [uid, nombre], assigned [[uid, nombre]], roe, insured, created, expires, t0, start, end, home,
              evac, reached, metrics (hashmap), result, sheet, report, review
    Estados (se guardan en español): Ofertado, Firmado, En curso, Revisión, Cumplido, Parcial, Fallido, Rescindido, Retirado
*/
private _db = localNamespace getVariable "ADVSEC_ctrDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
private _seq = 0;
{
    if (_x isEqualType []) then {
        private _c = createHashMapFromArray _x;
        private _id = _c getOrDefault ["id", ""];
        if (_id isNotEqualTo "") then {
            _c set ["metrics", createHashMapFromArray (_c getOrDefault ["metrics", []])];
            // Una misión nueva no puede seguir un contrato a medias
            if ((_c get "state") in ["Firmado", "En curso"]) then {
                _c set ["state", "Rescindido"];
                _c set ["end", call ADVSEC_fnc_now];
                _c set ["result", ("STR_ADVSEC_pmc_mission_ended" call ADVSEC_fnc_L)];
            };
            if ((_c get "state") == "Ofertado") then {_c set ["state", "Retirado"]};
            _db set [_id, _c];
            _seq = _seq max (parseNumber (_id select [2]));
        };
    };
} forEach (profileNamespace getVariable [ADVSEC_repKey + "_contracts", []]);
localNamespace setVariable ["ADVSEC_ctrSeq", _seq];
localNamespace setVariable ["ADVSEC_ctrDB", _db];
private _cl = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_cl set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_clients", []]);
{
    if !(configName _x in _cl) then {_cl set [configName _x, [0, 0, 0, call ADVSEC_fnc_utcMin, []]]};
} forEach (["Clients"] call ADVSEC_fnc_pmcClasses);
localNamespace setVariable ["ADVSEC_ctrClients", _cl];
_db
