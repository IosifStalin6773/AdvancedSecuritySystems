// -> posición de la base de la PM (1.24): marcador advsec_base, sirena, calabozo, teléfono o centro del mapa
if (markerType "advsec_base" != "") exitWith {markerPos "advsec_base"};
private _o = ((missionNamespace getVariable ["ADVSEC_sirens", []]) + (missionNamespace getVariable ["ADVSEC_jails", []]) + (missionNamespace getVariable ["ADVSEC_phones", []])) select {!isNull _x};
if (_o isNotEqualTo []) exitWith {getPosATL (_o select 0)};
[worldSize / 2, worldSize / 2, 0]
