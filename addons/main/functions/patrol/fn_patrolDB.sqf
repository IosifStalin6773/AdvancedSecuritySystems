// (servidor) -> hashmap id -> patrulla (ver fn_patrolServer)
private _db = localNamespace getVariable "ADVSEC_patrolDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
private _seq = 0;
{
    if (_x isEqualType [] && {count _x == 2}) then {
        private _p = +(_x select 1);
        // Una misión nueva no puede seguir el cronómetro de la anterior
        if ((_p select 8) in ["assigned", "active"]) then {_p set [8, "cancelled"]; _p set [12, ("STR_ADVSEC_mission_ended" call ADVSEC_fnc_L)]};
        _db set [_x select 0, _p];
        _seq = _seq max (parseNumber ((_x select 0) select [2]));
    };
} forEach (profileNamespace getVariable [ADVSEC_repKey + "_patrols", []]);
localNamespace setVariable ["ADVSEC_patrolSeq", _seq];
localNamespace setVariable ["ADVSEC_patrolDB", _db];
_db
