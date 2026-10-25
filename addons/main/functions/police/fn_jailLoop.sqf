// Servidor: fin de condena, fugas y guardado periódico del tiempo restante
private _lastSave = time;
while {true} do {
    {
        private _until = _x getVariable ["ADVSEC_jailUntil", 0];
        if (_until > 0 && {alive _x}) then {
            private _jail = _x getVariable ["ADVSEC_jailObj", objNull];
            if (serverTime >= _until) then {
                [_x] call ADVSEC_fnc_jailRelease;
            } else {
                private _r = _jail getVariable ["ADVSEC_jailRadius", 6];
                if (!isNull _jail && {(_x distance2D _jail) > _r + 2}) then {
                    private _pos = _jail getPos [random (_r * 0.5), random 360];
                    _pos set [2, (getPosATL _jail) select 2];
                    [_x, "teleport", [_pos]] call ADVSEC_fnc_policeLocal;
                    (format ["PM: intento de fuga de %1 en %2.", name _x, _jail getVariable ["ADVSEC_jailName", ""]]) remoteExecCall ["systemChat", 0];
                    private _jx = _jail;
                    {
                        if ((_x distance _jx) < 100) then {[_x, "trigger", "fuga del calabozo"] call ADVSEC_fnc_alarmSet};
                    } forEach (ADVSEC_alarms select {!isNull _x});
                };
            };
        };
    } forEach allUnits;
    if (time - _lastSave > 30) then {
        _lastSave = time;
        {
            private _until = _x getVariable ["ADVSEC_jailUntil", 0];
            private _uid = getPlayerUID _x;
            if (_until > 0 && {_uid in ADVSEC_jailDB}) then {(ADVSEC_jailDB get _uid) set [0, (_until - serverTime) max 0]};
        } forEach allPlayers;
        if (count ADVSEC_jailDB > 0) then {["jail"] call ADVSEC_fnc_dbDirty};
    };
    sleep 2;
};
