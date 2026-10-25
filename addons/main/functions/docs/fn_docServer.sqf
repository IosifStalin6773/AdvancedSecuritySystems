// ["sync"|"issue"|"autoissue"|"revoke", llamador, args] (servidor)
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};

switch (_action) do {
    case "sync": {
        if !(_caller getVariable ["ADVSEC_docSynced", false]) then {
            _caller setVariable ["ADVSEC_docSynced", true];
            [_caller] call ADVSEC_fnc_docAutoIssue;
        };
        [_caller] call ADVSEC_fnc_docPublish;
        {
            private _item = getText (([_x get "type"] call ADVSEC_fnc_docTypeCfg) >> "item");
            [_caller, _item] remoteExecCall ["ADVSEC_fnc_docGive", _caller];
        } forEach (([] call ADVSEC_fnc_docStore) getOrDefault [[_caller] call ADVSEC_fnc_docKey, []]);
    };
    case "issue": {
        _args params ["_unit", "_type", "_data", ["_issuer", objNull]];
        if (isNull _unit) exitWith {};
        private _ok = [_caller] call ADVSEC_fnc_isZeus;
        if (!_ok && {!isNull _issuer} && {(_caller distance _issuer) < 5} && {(_unit distance _caller) < 12}) then {
            private _types = _issuer getVariable ["ADVSEC_issueTypes", []];
            private _req = _issuer getVariable ["ADVSEC_issueReq", []];
            if (_data isEqualType []) then {_data = createHashMapFromArray _data};
            _ok = (_types isEqualTo [] || {_type in _types})
                && {_req isEqualTo [] || {[_caller, _req] call ADVSEC_fnc_accessCheck}}
                && {private _c = _data getOrDefault ["clearance", 0]; ([_c, parseNumber _c] select (_c isEqualType "")) <= (_issuer getVariable ["ADVSEC_issueMaxClearance", 5])};
        };
        if (!_ok) exitWith {[_caller, format ["emitir %1 a %2", _type, name _unit]] call ADVSEC_fnc_deny};
        private _id = [_unit, _type, _data] call ADVSEC_fnc_docCreate;
        ["docIssue", _caller, [name _unit, getPlayerUID _unit, _id]] call ADVSEC_fnc_logEvent;
        (format ["Documento emitido a %1.", name _unit]) remoteExecCall ["hint", _caller];
    };
    case "autoissue": {
        _args params ["_unit", ["_force", false]];
        if !([_caller] call ADVSEC_fnc_isZeus) exitWith {[_caller, "emitir documentación automática"] call ADVSEC_fnc_deny};
        [_unit, _force] call ADVSEC_fnc_docAutoIssue;
    };
    case "revoke": {
        _args params ["_unit", "_id"];
        if !([_caller, "revokeDoc"] call ADVSEC_fnc_perm) exitWith {[_caller, "retirar documentos"] call ADVSEC_fnc_deny};
        [_unit, _id] call ADVSEC_fnc_docRevoke;
        ["docRevoke", _caller, [name _unit, getPlayerUID _unit, _id]] call ADVSEC_fnc_logEvent;
    };
};
