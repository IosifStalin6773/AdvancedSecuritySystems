/*
    [] (servidor) — mantenimiento de vehículos de la PM (1.22). Cada vehMaintMin minutos cobra vehMaintFee de la tesorería
    por cada vehículo cuyo conductor o pasajero es PM. Arranca una sola vez desde rpInit.
*/
if (!isServer || {!isNil "ADVSEC_hrLoopOn"}) exitWith {};
ADVSEC_hrLoopOn = true;
[] spawn {
    private _min = 0;
    while {true} do {
        sleep 60;
        _min = _min + 1;
        private _every = ["vehMaintMin", 0] call ADVSEC_fnc_setting;
        if (_every > 0 && {_min >= _every}) then {
            _min = 0;
            private _fee = ["vehMaintFee", 0] call ADVSEC_fnc_setting;
            if (_fee > 0) then {
                {
                    private _v = _x;
                    if ({isPlayer _x && {[_x, "PM"] call ADVSEC_fnc_repAccess}} count crew _v > 0) then {
                        [-_fee, format [("STR_ADVSEC_hr_maint_treasury" call ADVSEC_fnc_L), getText (configFile >> "CfgVehicles" >> typeOf _v >> "displayName")]] call ADVSEC_fnc_ecoTreasury;
                    };
                } forEach (vehicles select {alive _x && {_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}}});
            };
        };
    };
};
