// [vehículo] — donde el vehículo es local: lo frena hasta pararlo y lo retiene mientras dure el control
params ["_veh"];
if (!local _veh || {!isNil {_veh getVariable "ADVSEC_cpBraking"}}) exitWith {};
_veh setVariable ["ADVSEC_cpBraking", true];
[_veh] spawn {
    params ["_veh"];
    while {alive _veh && {_veh getVariable ["ADVSEC_cpHold", false]} && {local _veh}} do {
        private _v = velocity _veh;
        if ((vectorMagnitude _v) > 0.3) then {_veh setVelocity (_v vectorMultiply 0.82)};
        sleep 0.05;
    };
    _veh setVariable ["ADVSEC_cpBraking", nil];
};
