private _disp = findDisplay 86200;
if (isNull _disp) exitWith {};
private _cb = _disp displayCtrl 2001;
private _type = _cb lbData (lbCurSel _cb);
private _target = ADVSEC_editorTargets param [lbCurSel (_disp displayCtrl 2002), player];
if (isNull _target || {!alive _target}) exitWith {hint "El destinatario ya no está disponible."};

private _data = createHashMap;
{
    private _c = _disp displayCtrl (2101 + _forEachIndex);
    private _v = ctrlText _c;
    if (ctrlEnabled _c && {_v != ""}) then {_data set [_x, _v]};
} forEach ["name", "nationality", "dob", "number", "issuer", "", "", "keys", "notes"];
if ((_data getOrDefault ["name", ""]) isEqualTo "") exitWith {hint "El nombre es obligatorio."};

private _exp = _disp displayCtrl 2106;
if (ctrlEnabled _exp) then {_data set ["expires", _exp lbData (lbCurSel _exp)]};
private _clr = _disp displayCtrl 2107;
private _max = ADVSEC_editorIssuer getVariable ["ADVSEC_issueMaxClearance", 5];
_data set ["clearance", ((_clr lbValue (lbCurSel _clr)) min _max) max 0];
_data set ["keys", (_data getOrDefault ["keys", ""]) splitString ", "];

private _fields = getArray (([_type] call ADVSEC_fnc_docTypeCfg) >> "fields");
if ("uid" in _fields && {isPlayer _target}) then {_data set ["uid", getPlayerUID _target]};
if ("rank" in _fields) then {_data set ["rank", [_target] call ADVSEC_fnc_rankName]};
if ("unit" in _fields) then {_data set ["unit", groupId group _target]};

closeDialog 0;
["issue", player, [_target, _type, [_data] call ADVSEC_fnc_docPairs, ADVSEC_editorIssuer]] remoteExecCall ["ADVSEC_fnc_docServer", 2];
