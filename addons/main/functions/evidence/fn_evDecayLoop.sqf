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
        // 1.22: prescripción de multas pendientes (finePrescriptionDays días de juego; 0 = nunca)
        private _presc = ["finePrescriptionDays", 0] call ADVSEC_fnc_setting;
        if (_presc > 0) then {
            private _changed = false;
            {
                {
                    if ((_x select 6) == "Pendiente" && {_now - (_x param [9, _now]) > _presc * 86400}) then {
                        _x set [6, "Anulada"];
                        _x set [8, "prescrita"];
                        _changed = true;
                        ["finePrescribed", objNull, [_x select 0, _x select 2]] call ADVSEC_fnc_logEvent;
                    };
                } forEach _y;
            } forEach ([] call ADVSEC_fnc_fineDB);
            if (_changed) then {["fines"] call ADVSEC_fnc_dbDirty};
        };
    };
};
