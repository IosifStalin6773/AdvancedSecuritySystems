// [SteamID] -> bool (servidor): hay requisitoria, denuncia o informe no cerrado que nombra a esa persona
params ["_uid"];
if (_uid isEqualTo "") exitWith {true};
if (_uid in (missionNamespace getVariable ["ADVSEC_wantedUIDs", []])) exitWith {true};
if (isNil "ADVSEC_repDB") exitWith {false};
private _closed = ["Resuelto", "Archivado"];
private _found = false;
{
    if (!((_y get "status") in _closed) && {((_y getOrDefault ["subjects", []]) joinString " ") find _uid > -1}) exitWith {_found = true};
} forEach ADVSEC_repDB;
_found
