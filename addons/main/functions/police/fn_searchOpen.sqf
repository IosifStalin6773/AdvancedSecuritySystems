params ["_target"];
if (!createDialog "ADVSEC_Search") exitWith {};
if ((missionNamespace getVariable ["ADVSEC_searchTarget", objNull]) isNotEqualTo _target) then {ADVSEC_searchSeized = []; ADVSEC_searchZones = []; ADVSEC_searchFound = []};
ADVSEC_searchTarget = _target;
ADVSEC_searchBusy = nil;
["fill"] call ADVSEC_fnc_searchAction;
