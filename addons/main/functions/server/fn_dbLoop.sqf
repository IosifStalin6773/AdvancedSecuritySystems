// (servidor): guardado periódico y al terminar la misión
addMissionEventHandler ["MPEnded", {[] call ADVSEC_fnc_dbFlush}];
addMissionEventHandler ["Ended", {[] call ADVSEC_fnc_dbFlush}];
private _every = (["saveInterval", 60] call ADVSEC_fnc_cfg);
while {true} do {
    sleep _every;
    [] call ADVSEC_fnc_dbFlush;
};
