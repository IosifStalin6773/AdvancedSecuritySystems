while {true} do {
    {
        private _alarm = _x;
        if (alive _alarm && {_alarm getVariable ["ADVSEC_armed", false]} && {!(_alarm getVariable ["ADVSEC_active", false])}) then {
            (_alarm getVariable ["ADVSEC_alarmCfg", [15, [], []]]) params ["_radius", "_req", "_doors"];
            private _reason = "";

            if (_req isNotEqualTo []) then {
                private _near = _alarm nearEntities ["CAManBase", _radius];
                private _i = _near findIf {alive _x && {isPlayer _x} && {!([_x, _req] call ADVSEC_fnc_accessCheck)}};
                if (_i > -1) then {_reason = format ["intruso sin documentación (%1)", name (_near select _i)]};
            };
            if (_reason isEqualTo "" && {_doors findIf {_x params ["_b", "_n"]; (_b animationSourcePhase format ["Door_%1_source", _n]) > 0.1} > -1}) then {
                _reason = "puerta abierta";
            };
            if (_reason isNotEqualTo "") then {[_alarm, "trigger", _reason] call ADVSEC_fnc_alarmSet};
        };
    } forEach ADVSEC_alarms;
    sleep 2;
};
