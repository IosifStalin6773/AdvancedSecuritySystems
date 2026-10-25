// [documento (HashMap o pares), presentadoPor, portador] -> tarjeta en el centro de la pantalla con foto del portador
params ["_doc", ["_shownBy", ""], ["_owner", objNull]];
if (!hasInterface) exitWith {};
if (_doc isEqualType []) then {_doc = createHashMapFromArray _doc};
private _cfg = [_doc get "type"] call ADVSEC_fnc_docTypeCfg;

("ADVSEC_DocLayer" call BIS_fnc_rscLayer) cutRsc ["ADVSEC_RscDocument", "PLAIN", 0.3];
private _disp = uiNamespace getVariable ["ADVSEC_docDisplay", displayNull];
if (isNull _disp) exitWith {};

private _bg = getText (_cfg >> "background");
private _dark = !isNumber (_cfg >> "dark") || {getNumber (_cfg >> "dark") > 0} || {_bg isEqualTo ""};
private _cLabel = ["#5a5446", "#b8bec6"] select _dark;
private _cValue = ["#16181c", "#ffffff"] select _dark;
(_disp displayCtrl 4005) ctrlSetBackgroundColor getArray (_cfg >> "color");
(_disp displayCtrl 4005) ctrlShow (_bg isEqualTo "");
(_disp displayCtrl 4000) ctrlSetText _bg;
(_disp displayCtrl 4001) ctrlSetText getText (_cfg >> "displayName");

private _esc = {
    private _v = _this;
    if (_v isEqualType []) then {_v = _v joinString ", "};
    if !(_v isEqualType "") then {_v = str _v};
    [_v] call ADVSEC_fnc_repEsc
};
private _labels = getArray (_cfg >> "labels");
private _rows = [];
{
    private _v = _doc getOrDefault [_x, ""];
    if (_v isNotEqualTo "" && {_v isNotEqualTo []}) then {
        _rows pushBack format [
            "<t size='0.78' font='RobotoCondensed' color='%1'>%2</t><br/><t size='1.05' font='RobotoCondensedBold' color='%3'>%4</t>",
            _cLabel, toUpper (_labels param [_forEachIndex, _x]), _cValue, _v call _esc
        ];
    };
} forEach getArray (_cfg >> "fields");
private _half = ceil (count _rows / 2);
(_disp displayCtrl 4003) ctrlSetStructuredText parseText ((_rows select [0, _half]) joinString "<br/>");
(_disp displayCtrl 4009) ctrlSetStructuredText parseText ((_rows select [_half]) joinString "<br/>");

private _exp = _doc getOrDefault ["expires", ""];
date params ["_y", "_m", "_d"];
private _expired = _exp isNotEqualTo "" && {parseNumber ((_exp splitString "-/.") joinString "") < (_y * 10000 + _m * 100 + _d)};
private _uid = _doc getOrDefault ["uid", ""];
private _foreign = _uid isNotEqualTo "" && {!isNull _owner} && {isPlayer _owner} && {_uid isNotEqualTo getPlayerUID _owner};
(_disp displayCtrl 4008) ctrlSetStructuredText parseText (switch (true) do {
    case _expired: {"<t align='right' font='RobotoCondensedBold' color='#FF4D4D'>■ CADUCADO</t>"};
    case _foreign: {"<t align='right' font='RobotoCondensedBold' color='#D96600'>■ NO COINCIDE</t>"};
    default {"<t align='right' font='RobotoCondensedBold' color='#66FF66'>■ VÁLIDO</t>"};
});

private _mrz = toUpper format ["%1<%2<<%3", _doc get "type", _doc getOrDefault ["number", ""], (_doc getOrDefault ["name", ""]) splitString " " joinString "<"];
_mrz = toString ((toArray _mrz) select {(_x >= 65 && {_x <= 90}) || {_x >= 48 && {_x <= 57}} || {_x in [45, 60]}});
while {count _mrz < 44} do {_mrz = _mrz + "<"};
(_disp displayCtrl 4004) ctrlSetStructuredText parseText format [
    "<t color='%1' size='0.85' font='RobotoCondensed'>%2</t><br/><t font='EtelkaMonospacePro' color='%3' size='0.95'>%4</t>",
    _cLabel,
    [format ["ID %1", _doc get "id"], format ["Presentado por %1  ·  ID %2", _shownBy call _esc, _doc get "id"]] select (_shownBy != ""),
    _cValue, _mrz select [0, 44]
];
playSound "FD_CP_Clear_F";

// Foto: render-to-texture de la cara del portador (requiere PiP activado; si no, queda la silueta)
if (!isNil "ADVSEC_faceCam") then {
    ADVSEC_faceCam cameraEffect ["terminate", "back", "advsec_face"];
    camDestroy ADVSEC_faceCam;
    ADVSEC_faceCam = nil;
};
private _photo = _disp displayCtrl 4006;
if (isNull _owner || {!alive _owner} || {!(_owner isKindOf "CAManBase")}) exitWith {_photo ctrlShow false};

ADVSEC_faceCam = "camera" camCreate (ASLToAGL eyePos _owner);
ADVSEC_faceCam cameraEffect ["internal", "back", "advsec_face"];
ADVSEC_faceCam camSetFov 0.12;
"advsec_face" setPiPEffect [0];
_photo ctrlSetText "#(argb,256,256,1)r2t(advsec_face,0.81)";
_photo ctrlShow true;

[_owner, _disp] spawn {
    params ["_unit", "_disp"];
    private _cam = ADVSEC_faceCam;
    private _end = time + 15;
    while {!isNull _disp && {time < _end} && {alive _unit} && {_cam isEqualTo (missionNamespace getVariable ["ADVSEC_faceCam", objNull])}} do {
        private _head = ASLToAGL eyePos _unit;
        private _dir = getDirVisual _unit;
        _cam camSetPos (_head vectorAdd [sin _dir * 1.2, cos _dir * 1.2, 0.02]);
        _cam camSetTarget _head;
        _cam camCommit 0;
        sleep 0.02;
    };
    if (_cam isEqualTo (missionNamespace getVariable ["ADVSEC_faceCam", objNull])) then {
        _cam cameraEffect ["terminate", "back", "advsec_face"];
        camDestroy _cam;
        ADVSEC_faceCam = nil;
    };
};
