params ["_logic"];
[_logic getVariable ["Clearance", -1], _logic getVariable ["DocTypes", ""], _logic getVariable ["KeyId", ""]] call ADVSEC_fnc_buildReq
