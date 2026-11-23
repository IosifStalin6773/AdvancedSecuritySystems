// (servidor): guardado periódico y al terminar la misión
addMissionEventHandler ["MPEnded", {[] call ADVSEC_fnc_dbFlush}];
addMissionEventHandler ["Ended", {[] call ADVSEC_fnc_dbFlush}];
private _every = (["saveInterval", 60] call ADVSEC_fnc_cfg);
// 1.22: copia de seguridad periódica (backupMin minutos; 0 = desactivada) de las bases principales
private _bkLast = serverTime;
while {true} do {
    sleep _every;
    [] call ADVSEC_fnc_dbFlush;
    private _bk = ["backupMin", 0] call ADVSEC_fnc_cfg;
    if (_bk > 0 && {serverTime - _bkLast >= _bk * 60}) then {
        _bkLast = serverTime;
        if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
        {
            private _v = profileNamespace getVariable [ADVSEC_repKey + _x, nil];
            if (!isNil "_v") then {profileNamespace setVariable [ADVSEC_repKey + _x + "_bk", _v]};
        } forEach ["", "_log", "_fines", "_eco", "_treasury", "_cases", "_contracts", "_wanted", "_jail"];
        profileNamespace setVariable [ADVSEC_repKey + "_bkTime", call ADVSEC_fnc_now];
        diag_log format ["[ADVSEC] copia de seguridad %1", call ADVSEC_fnc_now];
    };
};
