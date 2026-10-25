// [unidad, esposar (bool), agente] — con ace_captives si está cargado; si no, lógica propia
params ["_unit", "_state", ["_by", objNull]];
if (isNull _unit) exitWith {};
if (!_state && {!isNull attachedTo _unit}) then {detach _unit};
if (isClass (configFile >> "CfgPatches" >> "ace_captives") && {!isNil "CBA_fnc_targetEvent"}) exitWith {
    ["ace_captives_setHandcuffed", [_unit, _state], _unit] call CBA_fnc_targetEvent;
};
[_unit, "restrain", [_state]] call ADVSEC_fnc_policeLocal;
