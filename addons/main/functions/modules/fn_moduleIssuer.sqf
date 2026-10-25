params ["_logic", "", ["_activated", true]];
if (!_activated) exitWith {};
private _objs = (synchronizedObjects _logic) select {!(_x isKindOf "Logic")};
private _types = [_logic getVariable ["Types", ""]] call ADVSEC_fnc_parseList;
private _req = [_logic] call ADVSEC_fnc_moduleReq;
if (_objs isEqualTo []) exitWith {[_logic, "Land_CampingTable_F", "ADVSEC_fnc_issuerInit", [_types, _logic getVariable ["Issuer", "Autoridad"], _req, _logic getVariable ["MaxClearance", 3]]] call ADVSEC_fnc_moduleSpawn};
{
    [_x, _types, _logic getVariable ["Issuer", "Autoridad"], _req, _logic getVariable ["MaxClearance", 3]] call ADVSEC_fnc_issuerInit;
} forEach _objs;
