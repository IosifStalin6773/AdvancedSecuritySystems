// [quien] (servidor) Auditoría de inventario de la armería corporativa: informe F-PMC-02, descuadres y desaparecidas
params ["_by"];
private _w = [] call ADVSEC_fnc_wpnDB;
private _ok = []; private _bad = []; private _gone = []; private _off = [];
// Recuento por caja de lo que hay físicamente
private _boxes = createHashMap;
{
    private _e = _y;
    if ((_e param [4, ""]) == "CORP" && {(_e select 5) == "Armería"}) then {
        private _b = objectFromNetId (_e select 10);
        if (isNull _b) then {_gone pushBack _x} else {
            private _k = netId _b;
            if !(_k in _boxes) then {
                private _have = ((getWeaponCargo _b) select 0) apply {[_x] call BIS_fnc_baseWeapon};
                _boxes set [_k, _have];
            };
            private _have = _boxes get _k;
            private _i = _have find (_e select 0);
            if (_i < 0) then {_gone pushBack _x} else {_have deleteAt _i; _ok pushBack _x};
        };
    };
} forEach _w;
{
    private _e = _y;
    if ((_e param [4, ""]) == "CORP" && {(_e select 5) == "Firmada"}) then {
        private _sig = _e select 6;
        private _u = [_sig param [0, ""]] call ADVSEC_fnc_uidUnit;
        if (isNull _u) then {_off pushBack _x} else {
            if (_x in ([_u] call ADVSEC_fnc_armMissing)) then {
                _bad pushBack _x;
                [_u, "armoryMismatch", _x] call ADVSEC_fnc_heatAdd;
            } else {_ok pushBack _x};
        };
    };
} forEach _w;
{
    private _e = _w get _x;
    _e set [5, "Perdida"];
    (_e select 9) pushBack [call ADVSEC_fnc_now, ("STR_ADVSEC_pmc_arm_audit_missing" call ADVSEC_fnc_L)];
} forEach _gone;
["weapons"] call ADVSEC_fnc_dbDirty;
private _body = format [("STR_ADVSEC_pmc_audit_body" call ADVSEC_fnc_L), [name _by, "-"] select (isNull _by), call ADVSEC_fnc_now, endl,
    count _ok, count _bad, _bad joinString ", ", count _gone, _gone joinString ", ", count _off, _off joinString ", "];
private _rid = ["FPMC02", format [("STR_ADVSEC_pmc_audit_title" call ADVSEC_fnc_L), call ADVSEC_fnc_now], [], _body, ["Leve", "Grave"] select (_bad isNotEqualTo [] || {_gone isNotEqualTo []}), false] call ADVSEC_fnc_repSystem;
["armoryAudit", _by, [_rid, count _ok, count _bad, count _gone]] call ADVSEC_fnc_logEvent;
if (!isNull _by) then {(format [("STR_ADVSEC_pmc_audit_done" call ADVSEC_fnc_L), _rid, count _ok, count _bad, count _gone, count _off]) remoteExecCall ["hint", _by]};
