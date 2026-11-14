// [id, estado, tipo] (cliente): acciones posibles sobre el contrato elegido en el terminal
params ["_id", "_state", "_type"];
private _opts = [];
private _can = {[player, _this] call ADVSEC_fnc_perm};
switch (_state) do {
    case "Ofertado": {
        if ("contractSign" call _can) then {
            _opts append [[("STR_ADVSEC_pmc_act_counter" call ADVSEC_fnc_L), "counter"], [("STR_ADVSEC_pmc_act_sign" call ADVSEC_fnc_L), "sign"], [("STR_ADVSEC_pmc_act_sign_ins" call ADVSEC_fnc_L), "signIns"]];
        };
    };
    case "Firmado": {
        if ("contractAssign" call _can) then {
            _opts pushBack [("STR_ADVSEC_pmc_act_assign" call ADVSEC_fnc_L), "assign"];
            if (_type in ["escort", "vip"]) then {_opts pushBack [("STR_ADVSEC_pmc_act_route" call ADVSEC_fnc_L), "route"]};
            _opts pushBack [("STR_ADVSEC_pmc_act_start" call ADVSEC_fnc_L), "start"];
        };
        if ("contractSign" call _can) then {_opts pushBack [("STR_ADVSEC_pmc_act_cancel" call ADVSEC_fnc_L), "cancel"]};
    };
    case "En curso": {
        if ("contractAssign" call _can && {_type in ["escort", "vip"]}) then {_opts pushBack [("STR_ADVSEC_pmc_act_evac" call ADVSEC_fnc_L), "evac"]};
        if ("contractAssign" call _can) then {_opts pushBack [("STR_ADVSEC_pmc_act_assign" call ADVSEC_fnc_L), "assign"]};
        if ("contractSign" call _can) then {_opts pushBack [("STR_ADVSEC_pmc_act_cancel" call ADVSEC_fnc_L), "cancel"]};
    };
    case "Revisión": {
        if ("caseClose" call _can) then {_opts append [[("STR_ADVSEC_pmc_act_justified" call ADVSEC_fnc_L), "justified"], [("STR_ADVSEC_pmc_act_negligence" call ADVSEC_fnc_L), "negligence"]]};
    };
};
_opts pushBack [("STR_ADVSEC_show_route_on_the_map" call ADVSEC_fnc_L), "show"];
[format [("STR_ADVSEC_pmc_action_title" call ADVSEC_fnc_L), _id], [[("STR_ADVSEC_pmc_action" call ADVSEC_fnc_L), (_opts select 0) select 1, _opts]], {
    params ["_v", "_a"];
    _a params ["_id", "_type"];
    private _do = _v select 0;
    switch (_do) do {
        case "counter": {
            [_id] spawn {
                params ["_id"];
                sleep 0.1;
                [format [("STR_ADVSEC_pmc_counter_title" call ADVSEC_fnc_L), _id], [
                    [("STR_ADVSEC_pmc_counter_pay" call ADVSEC_fnc_L), 10, [["+0 %", 0], ["+5 %", 5], ["+10 %", 10], ["+15 %", 15], ["+20 %", 20], ["+30 %", 30]]],
                    [("STR_ADVSEC_pmc_counter_adv" call ADVSEC_fnc_L), 30, [["10 %", 10], ["20 %", 20], ["30 %", 30], ["40 %", 40], ["50 %", 50]]],
                    [("STR_ADVSEC_pmc_counter_pen" call ADVSEC_fnc_L), 50, [["0 %", 0], ["25 %", 25], ["50 %", 50], ["75 %", 75], ["100 %", 100]]]
                ], {params ["_v", "_id"]; ["counter", player, [_id] + _v] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}, _id] call ADVSEC_fnc_zeusPrompt;
            };
        };
        case "sign": {["sign", player, [_id, false]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "signIns": {["sign", player, [_id, true]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "assign": {
            [_id] spawn {
                params ["_id"];
                sleep 0.1;
                private _pm = ((allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PMC"] call ADVSEC_fnc_repAccess}}) apply {[format ["%1%2", name _x, ["", " ●"] select (_x getVariable ["ADVSEC_onDuty", false])], getPlayerUID _x]};
                [format [("STR_ADVSEC_pmc_assign_title" call ADVSEC_fnc_L), _id], [
                    [("STR_ADVSEC_assigned_officers" call ADVSEC_fnc_L), [], ["multi", _pm]],
                    [("STR_ADVSEC_pmc_roe" call ADVSEC_fnc_L), "Ámbar", ["Verde", "Ámbar", "Rojo"]]
                ], {params ["_v", "_id"]; ["assign", player, [_id, _v select 0, _v select 1]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]}, _id] call ADVSEC_fnc_zeusPrompt;
            };
        };
        case "route": {closeDialog 0; [_id] spawn ADVSEC_fnc_ctrRoute};
        case "start": {["start", player, [_id]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "cancel": {["cancel", player, [_id]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "evac": {["evac", player, [_id]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "justified": {["review", player, [_id, "Justificado"]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        case "negligence": {["review", player, [_id, "Negligencia"]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
        default {["show", player, [_id]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]};
    };
}, [_id, _type]] call ADVSEC_fnc_zeusPrompt;
