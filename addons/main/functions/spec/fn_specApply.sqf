// [unidad] (servidor): publica sus especialidades (ADVSEC_specs) y aplica rasgos de Arma y ACE
params ["_unit"];
if (isNull _unit) exitWith {};
private _uid = getPlayerUID _unit;
private _mine = [];
private _lead = [];
{
    if (_uid in (_y select 0)) then {_mine pushBack _x};
    if (_uid in (_y select 1)) then {_lead pushBack _x};
} forEach ([] call ADVSEC_fnc_specDB);
_unit setVariable ["ADVSEC_specs", _mine, true];
_unit setVariable ["ADVSEC_specLead", _lead, true];
private _traits = createHashMapFromArray [["Medic", false], ["Engineer", false], ["ExplosiveSpecialist", false]];
private _ace = createHashMapFromArray [["ace_medical_medicClass", 0], ["ace_isEngineer", 0], ["ace_isEOD", 0]];
{
    private _c = configFile >> "ADVSEC_Specialties" >> _x;
    {_traits set [_x select 0, (_x select 1) > 0]} forEach getArray (_c >> "traits");
    {_ace set [_x select 0, (_ace get (_x select 0)) max (_x select 1)]} forEach getArray (_c >> "ace");
} forEach _mine;
[_traits toArray false] remoteExecCall ["ADVSEC_fnc_specLocal", _unit];
{_unit setVariable [_x, [_y, _y > 0] select (_x == "ace_isEOD"), true]} forEach _ace;
