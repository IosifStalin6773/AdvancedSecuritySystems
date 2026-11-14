/*
    [] (servidor) — caducidad de pruebas (1.22). Arranca una sola vez desde rpInit.
    Sangre en el suelo: se degrada y desaparece a los evBloodDecayMin minutos.
    Pruebas guardadas en bolsa: se destruyen con registro de auditoría a los evDestroyMin minutos (0 = nunca).
*/
if (!isServer || {!isNil "ADVSEC_evDecayOn"}) exitWith {};
ADVSEC_evDecayOn = true;
[] spawn {
    while {true} do {
        sleep 60;
        private _bloodMin = ["evBloodDecayMin", 0] call ADVSEC_fnc_setting;
        private _destroyMin = ["evDestroyMin", 0] call ADVSEC_fnc_setting;
        private _db = [] call ADVSEC_fnc_evDB;
        private _now = serverTime;
        {
            private _e = _y;
            if (_bloodMin > 0 && {(_e get "type") == "blood"} && {(_e get "state") == "field"} && {_now - (_e get "t") > _bloodMin * 60}) then {
                _db deleteAt _x;
                ["evDecay", objNull, [_x, "blood"]] call ADVSEC_fnc_logEvent;
                ["ev"] call ADVSEC_fnc_dbDirty;
            } else {
                if (_destroyMin > 0 && {(_e get "state") == "bagged"} && {_now - (_e get "t") > _destroyMin * 60}) then {
                    _db deleteAt _x;
                    ["evDestroy", objNull, [_x, _e get "grid"]] call ADVSEC_fnc_logEvent;
                    ["ev"] call ADVSEC_fnc_dbDirty;
                };
            };
        } forEach +_db;
    };
};
