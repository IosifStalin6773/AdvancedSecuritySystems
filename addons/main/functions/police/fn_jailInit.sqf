// [objeto, nombre, radio] — centro de detención (calabozo)
params ["_obj", ["_name", "Calabozo"], ["_radius", 6]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj || {!isServer}) exitWith {};
_obj setVariable ["ADVSEC_jailName", _name, true];
_obj setVariable ["ADVSEC_jailRadius", _radius, true];
ADVSEC_jails = ((missionNamespace getVariable ["ADVSEC_jails", []]) select {!isNull _x}) - [_obj];
ADVSEC_jails pushBack _obj;
publicVariable "ADVSEC_jails";
[_obj, "jail", _name] call ADVSEC_fnc_register;
if (isNil "ADVSEC_jailLoopH") then {ADVSEC_jailLoopH = [] spawn ADVSEC_fnc_jailLoop};
