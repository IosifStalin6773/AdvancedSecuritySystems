// ["type"|"target"] — adapta el editor al tipo de documento y al destinatario
params ["_mode"];
private _disp = findDisplay 86200;
if (isNull _disp) exitWith {};
private _cb = _disp displayCtrl 2001;
private _type = _cb lbData (lbCurSel _cb);
private _cfg = [_type] call ADVSEC_fnc_docTypeCfg;
private _target = ADVSEC_editorTargets param [lbCurSel (_disp displayCtrl 2002), player];

if (_mode == "target") exitWith {
    (_disp displayCtrl 2101) ctrlSetText name _target;
};

private _fields = getArray (_cfg >> "fields");
{
    private _on = _x in _fields || {_x isEqualTo "name"};
    (_disp displayCtrl (2101 + _forEachIndex)) ctrlEnable _on;
    (_disp displayCtrl (2202 + _forEachIndex)) ctrlSetTextColor ([[0.4, 0.42, 0.45, 1], [0.72, 0.76, 0.80, 1]] select _on);
} forEach ["name", "nationality", "dob", "number", "issuer", "expires", "clearance", "keys", "notes"];

private _clr = _disp displayCtrl 2107;
_clr lbSetCurSel (((getNumber (_cfg >> "clearance")) max 0) min ((lbSize _clr) - 1));

private _uidBound = "uid" in _fields;
(_disp displayCtrl 2003) ctrlSetStructuredText parseText format [
    "<img image='%1'/> <t font='RobotoCondensedBold'>%2</t><br/><t color='#8C8C8C' size='0.9'>Objeto: %3%4</t>",
    getText (_cfg >> "icon"),
    getText (_cfg >> "displayName"),
    getText (configFile >> "CfgWeapons" >> getText (_cfg >> "item") >> "displayName"),
    ["", "<br/>Vinculado al SteamID del destinatario: solo es válido para él."] select _uidBound
];
