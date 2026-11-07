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
    [objNull, ("STR_ADVSEC_that_object_is_an_editor" call ADVSEC_fnc_L)] call BIS_fnc_showCuratorFeedbackMessage;
};
if (!isNull _target) then {[objNull, format [("STR_ADVSEC_module_on" call ADVSEC_fnc_L), getText (configOf _target >> "displayName")]] call BIS_fnc_showCuratorFeedbackMessage};
private _ctx = [_kind, _target, getPosATL _logic, getDir _logic];
deleteVehicle _logic;

if (_kind == "panel") exitWith {[] spawn {sleep 0.05; [] call ADVSEC_fnc_zeusPanelOpen}};
if (_kind == "police") exitWith {
    if !(_target isKindOf "CAManBase") exitWith {[objNull, ("STR_ADVSEC_drop_the_module_on_a" call ADVSEC_fnc_L)] call BIS_fnc_showCuratorFeedbackMessage};
    [_target] spawn {sleep 0.05; [_this select 0, "zeus"] call ADVSEC_fnc_policeMenu};
};

private _reg = missionNamespace getVariable ["ADVSEC_secObjects", []];
private _clr = [[("STR_ADVSEC_no_minimum_level" call ADVSEC_fnc_L), -1]] + ([0, 1, 2, 3, 4, 5] apply {[format [("STR_ADVSEC_level_or_higher" call ADVSEC_fnc_L), _x], _x]});
private _types = ["multi", ([] call ADVSEC_fnc_docTypes) apply {[getText (([_x] call ADVSEC_fnc_docTypeCfg) >> "displayName"), _x]}];
private _zones = [["(ninguna)", ""]];
{if ((_x select 1) == "alarm") then {_zones pushBackUnique [format ["%1 (%2)", _x select 2, _x select 3], _x select 3]}} forEach _reg;
private _nets = ["default"];
{if ((_x select 1) == "camera") then {_nets pushBackUnique (_x select 3)}} forEach _reg;
private _req = {
    params [["_c", -1], ["_t", []]];
    [[("STR_ADVSEC_minimum_level" call ADVSEC_fnc_L), _c, _clr], [("STR_ADVSEC_valid_documents" call ADVSEC_fnc_L), _t, _types], [("STR_ADVSEC_key_id_optional" call ADVSEC_fnc_L), ""]]
};

private _def = switch (_kind) do {
    case "camera": {[("STR_ADVSEC_cctv_camera" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_name" call ADVSEC_fnc_L), format ["CAM-%1", count (_reg select {(_x select 1) == "camera"}) + 1]],
        [("STR_ADVSEC_cctv_network" call ADVSEC_fnc_L), _nets select -1],
        [("STR_ADVSEC_tilt" call ADVSEC_fnc_L), -20, [["Horizontal", 0], [("STR_ADVSEC_slight_10o" call ADVSEC_fnc_L), -10], [("STR_ADVSEC_medium_20o" call ADVSEC_fnc_L), -20], [("STR_ADVSEC_steep_35o" call ADVSEC_fnc_L), -35], [("STR_ADVSEC_top_down_60o" call ADVSEC_fnc_L), -60]]]
    ]]};
    case "monitor": {[("STR_ADVSEC_cctv_monitor" call ADVSEC_fnc_L), [[("STR_ADVSEC_cctv_network" call ADVSEC_fnc_L), _nets select 0, _nets]] + ([] call _req)]};
    case "keypad": {["KEYPAD", [
        ["PIN", "1234"],
        [("STR_ADVSEC_doors_all_every_door" call ADVSEC_fnc_L), "all"],
        [("STR_ADVSEC_linked_alarm" call ADVSEC_fnc_L), "", _zones],
        [("STR_ADVSEC_screen_text" call ADVSEC_fnc_L), ("STR_ADVSEC_enter_pin" call ADVSEC_fnc_L)]
    ] + ([1] call _req)]};
    case "door": {["CERRADURA", [[("STR_ADVSEC_doors_all_every_door" call ADVSEC_fnc_L), "all"], [("STR_ADVSEC_locked" call ADVSEC_fnc_L), true, "bool"]] + ([1] call _req)]};
    case "alarm": {["ALARMA", [
        [("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_alarm" call ADVSEC_fnc_L)],
        [("STR_ADVSEC_zone_id" call ADVSEC_fnc_L), format ["zona%1", count (_zones) ]],
        [("STR_ADVSEC_radius" call ADVSEC_fnc_L), 15, [["10 m", 10], ["15 m", 15], ["25 m", 25], ["40 m", 40], ["60 m", 60]]],
        [("STR_ADVSEC_watched_doors_all_1_2" call ADVSEC_fnc_L), ""],
        [("STR_ADVSEC_armed" call ADVSEC_fnc_L), true, "bool"]
    ] + ([] call _req)]};
    case "issuer": {[("STR_ADVSEC_document_office" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_issuer" call ADVSEC_fnc_L), ("STR_ADVSEC_ministry_of_the_interior" call ADVSEC_fnc_L)],
        [("STR_ADVSEC_issuable_types_none_all" call ADVSEC_fnc_L), [], _types],
        [("STR_ADVSEC_maximum_level" call ADVSEC_fnc_L), 3, [0, 1, 2, 3, 4, 5] apply {[format [("STR_ADVSEC_level" call ADVSEC_fnc_L), _x], _x]}]
    ] + ([] call _req)]};
    case "reports": {[("STR_ADVSEC_reports_terminal" call ADVSEC_fnc_L), [[("STR_ADVSEC_department" call ADVSEC_fnc_L), "PM", [[("STR_ADVSEC_military_police" call ADVSEC_fnc_L), "PM"], [("STR_ADVSEC_internal_affairs" call ADVSEC_fnc_L), "AI"], [("STR_ADVSEC_both" call ADVSEC_fnc_L), "BOTH"]]]] + ([] call _req)]};
    case "jail": {[("STR_ADVSEC_detention_centre" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_mp_cell" call ADVSEC_fnc_L)],
        [("STR_ADVSEC_radius" call ADVSEC_fnc_L), 6, [["3 m", 3], ["6 m", 6], ["10 m", 10], ["20 m", 20]]]
    ]]};
    case "atm": {[("STR_ADVSEC_atm" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_cash_machine" call ADVSEC_fnc_L)]]]};
    case "shop": {["TIENDA", [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_shop" call ADVSEC_fnc_L)], [("STR_ADVSEC_items_empty_default" call ADVSEC_fnc_L), "", ["catalog", "items"]], [("STR_ADVSEC_black_market_hidden" call ADVSEC_fnc_L), false, "bool"]]]};
    case "dealer": {["CONCESIONARIO", [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_car_dealer" call ADVSEC_fnc_L)], [("STR_ADVSEC_vehicles_empty_default" call ADVSEC_fnc_L), "", ["catalog", "vehicles"]]]]};
    case "duty": {[("STR_ADVSEC_duty_terminal" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_duty_clock" call ADVSEC_fnc_L)]]]};
    case "speedcam": {[("STR_ADVSEC_fixed_speed_camera" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), "Radar"], [("STR_ADVSEC_limit_km_h_0_default" call ADVSEC_fnc_L), "0"], [("STR_ADVSEC_range_m" call ADVSEC_fnc_L), "40"], [("STR_ADVSEC_base_fine_0_default" call ADVSEC_fnc_L), "0"], [("STR_ADVSEC_fine_per_km_h_0" call ADVSEC_fnc_L), "0"]]]};
    case "admin": {[("STR_ADVSEC_superadmin_terminal" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_superadmin_terminal_2" call ADVSEC_fnc_L)]]]};
    case "lab": {[("STR_ADVSEC_forensic_lab" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_forensic_lab_2" call ADVSEC_fnc_L)]]]};
    case "checkpoint": {[("STR_ADVSEC_road_checkpoint_ai" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_mp_checkpoint" call ADVSEC_fnc_L)],
        [("STR_ADVSEC_radius" call ADVSEC_fnc_L), 20, [["10 m", 10], ["20 m", 20], ["35 m", 35]]],
        [("STR_ADVSEC_officers" call ADVSEC_fnc_L), 2, [[("STR_ADVSEC_create_2_officers" call ADVSEC_fnc_L), 2], [("STR_ADVSEC_create_4_officers" call ADVSEC_fnc_L), 4], [("STR_ADVSEC_group_of_the_unit_under" call ADVSEC_fnc_L), -1], [("STR_ADVSEC_no_officers_fines_and_wanted" call ADVSEC_fnc_L), 0]]]
    ]]};
    case "contract": {[("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L)]]]};
    case "armory": {[("STR_ADVSEC_pmc_armory" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_armory" call ADVSEC_fnc_L)]]]};
    case "cyber": {[("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L), [[("STR_ADVSEC_name" call ADVSEC_fnc_L), ("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L)]]]};
    case "contractOffer": {[("STR_ADVSEC_pmc_offer_title" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_pmc_type" call ADVSEC_fnc_L), "escort", (["ContractTypes"] call ADVSEC_fnc_pmcClasses) apply {[[_x, "name", configName _x] call ADVSEC_fnc_pmcVal, configName _x]}],
        [("STR_ADVSEC_pmc_client" call ADVSEC_fnc_L), "", (["Clients"] call ADVSEC_fnc_pmcClasses) apply {[[_x, "name", configName _x] call ADVSEC_fnc_pmcVal, configName _x]}],
        [("STR_ADVSEC_pmc_title" call ADVSEC_fnc_L), ""],
        [("STR_ADVSEC_radius" call ADVSEC_fnc_L), 150, [["50 m", 50], ["150 m", 150], ["300 m", 300], ["600 m", 600]]],
        [("STR_ADVSEC_pmc_pay0" call ADVSEC_fnc_L), "0"],
        [("STR_ADVSEC_pmc_minutes0" call ADVSEC_fnc_L), "0"]
    ]]};
    default {[]};
};
if (_def isEqualTo []) exitWith {};
_def params ["_title", "_fields"];
[_title, _fields, {call ADVSEC_fnc_zeusApply}, _ctx] call ADVSEC_fnc_zeusPrompt;
