// (servidor, programado) publica las variables del HUD cada 10 s y paga las nóminas
private _next = time + 60 * (["salaryInterval", 30] call ADVSEC_fnc_setting);
while {true} do {
    sleep 10;
    if ([] call ADVSEC_fnc_ecoOn) then {
        [] call ADVSEC_fnc_ecoPublish;
        private _every = ["salaryInterval", 30] call ADVSEC_fnc_setting;
        if (_every > 0 && {time >= _next}) then {
            _next = time + 60 * _every;
            [] call ADVSEC_fnc_ecoSalary;
        };
    };
};
