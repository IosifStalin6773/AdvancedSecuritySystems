// Módulos Zeus: se sueltan sobre un objeto/unidad (o en el suelo) y piden los parámetros con selectores
params ["_logic"];
if (!local _logic) exitWith {};
private _kind = getText (configOf _logic >> "ADVSEC_kind");
private _target = attachedTo _logic;
if (isNull _target) then {
    curatorMouseOver params [["_type", ""], ["_obj", objNull]];
    if (_type == "OBJECT") then {_target = _obj};
};
// Objetos colocados en el editor que no son editables por Zeus (o del mapa): ni attachedTo ni curatorMouseOver los ven.
// Se busca lo que hay bajo el cursor (se ignoran árboles, rocas y demás objetos del terreno sin clase).
if (isNull _target && {!isNull curatorCamera}) then {
    private _hits = lineIntersectsSurfaces [getPosASL curatorCamera, AGLToASL (screenToWorld getMousePosition), _logic, objNull, true, 1, "VIEW", "FIRE"];
    if (_hits isNotEqualTo []) then {
        (_hits select 0) params ["", "", ["_o", objNull], ["_p", objNull]];
        _target = [_p, _o] select (isNull _p);
    };
};
if (!isNull _target && {_target isKindOf "Logic" || {typeOf _target isEqualTo ""}}) then {_target = objNull};
if (!isNull _target && {isSimpleObject _target}) exitWith {
    deleteVehicle _logic;
    [objNull, "Ese objeto es un «objeto simple» del editor: no admite interacciones. Desmarca «Objeto simple» en sus atributos."] call BIS_fnc_showCuratorFeedbackMessage;
};
if (!isNull _target) then {[objNull, format ["Módulo sobre: %1", getText (configOf _target >> "displayName")]] call BIS_fnc_showCuratorFeedbackMessage};
private _ctx = [_kind, _target, getPosATL _logic, getDir _logic];
deleteVehicle _logic;

if (_kind == "panel") exitWith {[] spawn {sleep 0.05; [] call ADVSEC_fnc_zeusPanelOpen}};
if (_kind == "police") exitWith {
    if !(_target isKindOf "CAManBase") exitWith {[objNull, "Suelta el módulo sobre una unidad."] call BIS_fnc_showCuratorFeedbackMessage};
    [_target] spawn {sleep 0.05; [_this select 0, "zeus"] call ADVSEC_fnc_policeMenu};
};

private _reg = missionNamespace getVariable ["ADVSEC_secObjects", []];
private _clr = [["Sin nivel mínimo", -1]] + ([0, 1, 2, 3, 4, 5] apply {[format ["Nivel %1 o superior", _x], _x]});
private _types = ["multi", ([] call ADVSEC_fnc_docTypes) apply {[getText (([_x] call ADVSEC_fnc_docTypeCfg) >> "displayName"), _x]}];
private _zones = [["(ninguna)", ""]];
{if ((_x select 1) == "alarm") then {_zones pushBackUnique [format ["%1 (%2)", _x select 2, _x select 3], _x select 3]}} forEach _reg;
private _nets = ["default"];
{if ((_x select 1) == "camera") then {_nets pushBackUnique (_x select 3)}} forEach _reg;
private _req = {
    params [["_c", -1], ["_t", []]];
    [["Nivel mínimo", _c, _clr], ["Documentos válidos", _t, _types], ["ID de llave (opcional)", ""]]
};

private _def = switch (_kind) do {
    case "camera": {["CÁMARA CCTV", [
        ["Nombre", format ["CAM-%1", count (_reg select {(_x select 1) == "camera"}) + 1]],
        ["Red CCTV", _nets select -1],
        ["Inclinación", -20, [["Horizontal", 0], ["Ligera (-10º)", -10], ["Media (-20º)", -20], ["Pronunciada (-35º)", -35], ["Cenital (-60º)", -60]]]
    ]]};
    case "monitor": {["MONITOR CCTV", [["Red CCTV", _nets select 0, _nets]] + ([] call _req)]};
    case "keypad": {["KEYPAD", [
        ["PIN", "1234"],
        ["Puertas (all = todas)", "all"],
        ["Alarma vinculada", "", _zones],
        ["Texto de pantalla", "INTRODUZCA PIN"]
    ] + ([1] call _req)]};
    case "door": {["CERRADURA", [["Puertas (all = todas)", "all"], ["Bloqueada", true, "bool"]] + ([1] call _req)]};
    case "alarm": {["ALARMA", [
        ["Nombre", "Alarma"],
        ["Zona (ID)", format ["zona%1", count (_zones) ]],
        ["Radio", 15, [["10 m", 10], ["15 m", 15], ["25 m", 25], ["40 m", 40], ["60 m", 60]]],
        ["Puertas vigiladas (all/1,2/vacío)", ""],
        ["Armada", true, "bool"]
    ] + ([] call _req)]};
    case "issuer": {["OFICINA DE DOCUMENTACIÓN", [
        ["Emisor", "Ministerio del Interior"],
        ["Tipos emitibles (ninguno = todos)", [], _types],
        ["Nivel máximo", 3, [0, 1, 2, 3, 4, 5] apply {[format ["Nivel %1", _x], _x]}]
    ] + ([] call _req)]};
    case "reports": {["TERMINAL DE INFORMES", [["Departamento", "PM", [["Policía Militar", "PM"], ["Asuntos Internos", "AI"], ["Ambos", "BOTH"]]]] + ([] call _req)]};
    case "jail": {["CENTRO DE DETENCIÓN", [
        ["Nombre", "Calabozo PM"],
        ["Radio", 6, [["3 m", 3], ["6 m", 6], ["10 m", 10], ["20 m", 20]]]
    ]]};
    case "atm": {["CAJERO AUTOMÁTICO", [["Nombre", "Cajero automático"]]]};
    case "shop": {["TIENDA", [["Nombre", "Tienda"], ["Artículos «clase:precio, ...» (vacío = lista por defecto)", ""], ["Mercado negro (oculta)", false, "bool"]]]};
    case "dealer": {["CONCESIONARIO", [["Nombre", "Concesionario"], ["Vehículos «clase:precio, ...» (vacío = lista por defecto)", ""]]]};
    case "duty": {["TERMINAL DE FICHAJE", [["Nombre", "Fichaje"]]]};
    case "admin": {["TERMINAL DE SUPERADMINISTRADOR", [["Nombre", "Terminal de superadministrador"]]]};
    case "lab": {["LABORATORIO FORENSE", [["Nombre", "Laboratorio forense"]]]};
    case "checkpoint": {["CONTROL DE CARRETERA (IA)", [
        ["Nombre", "Control PM"],
        ["Radio", 20, [["10 m", 10], ["20 m", 20], ["35 m", 35]]],
        ["Agentes", 2, [["Crear 2 agentes", 2], ["Crear 4 agentes", 4], ["Grupo de la unidad bajo el módulo", -1], ["Sin agentes (solo multas y buscados)", 0]]]
    ]]};
    default {[]};
};
if (_def isEqualTo []) exitWith {};
_def params ["_title", "_fields"];
[_title, _fields, {call ADVSEC_fnc_zeusApply}, _ctx] call ADVSEC_fnc_zeusPrompt;
