/*
    [acción, llamador, args] (servidor, 1.24) — cajas de equipo de la PM
    "fill" [caja]: vacía y llena con mpCrateItems · "restock" [caja]: lo mismo y añade cargadores para las armas del agente
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
_args params [["_box", objNull]];
if (isNull _box) exitWith {};
private _fill = {
    clearItemCargoGlobal _box;
    clearMagazineCargoGlobal _box;
    clearWeaponCargoGlobal _box;
    {
        _x params ["_c", ["_n", 1]];
        switch (true) do {
            case (isClass (configFile >> "CfgMagazines" >> _c)): {_box addMagazineCargoGlobal [_c, _n]};
            case (isClass (configFile >> "CfgWeapons" >> _c)): {_box addItemCargoGlobal [_c, _n]};
            case (isClass (configFile >> "CfgVehicles" >> _c)): {_box addBackpackCargoGlobal [_c, _n]};
        };
    } forEach (["mpCrateItems", []] call ADVSEC_fnc_setting);
};
switch (_action) do {
    case "fill": {
        if (call ADVSEC_fnc_fromClient) exitWith {};
        call _fill;
    };
    case "restock": {
        if !([_caller, _box, 6] call ADVSEC_fnc_srvCaller) exitWith {};
        if !([_caller, "mpCrate"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_crate_restock" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
        private _last = _box getVariable ["ADVSEC_crateLast", -1e6];
        if (serverTime - _last < 300) exitWith {(format [("STR_ADVSEC_crate_wait" call ADVSEC_fnc_L), ceil ((300 - (serverTime - _last)) / 60)]) remoteExecCall ["hint", _caller]};
        _box setVariable ["ADVSEC_crateLast", serverTime];
        call _fill;
        private _n = ["mpCrateMags", 4] call ADVSEC_fnc_setting;
        if (_n > 0) then {
            {
                private _m = (getArray (configFile >> "CfgWeapons" >> _x >> "magazines")) param [0, ""];
                if (_m isNotEqualTo "") then {_box addMagazineCargoGlobal [_m, _n]};
            } forEach ([primaryWeapon _caller, handgunWeapon _caller] select {_x isNotEqualTo ""});
        };
        ("STR_ADVSEC_crate_done" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
        ["mpCrate", _caller, [mapGridPosition _box]] call ADVSEC_fnc_logEvent;
    };
};
