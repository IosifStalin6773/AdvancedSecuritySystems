/*
    [tipo, módulo] (servidor, 1.24) — construye una instalación con sus sistemas ADVSEC ya configurados
    base · station (comisaría) · stockade (prisión) · hospital · river (base fluvial) · shop (tienda)
    Cada pieza: [clase, [x, y, z] relativo al módulo, giro, init] — init: "" o [función, args tras el objeto]
*/
params ["_type", "_logic"];
if (!isServer || {isNull _logic}) exitWith {};
private _sets = createHashMapFromArray [
    ["base", [
        ["Land_Cargo_HQ_V1_F", [0, 0, 0], 0, ""],
        ["Flag_NATO_F", [8, 6, 0], 0, ""],
        ["Land_Loudspeakers_F", [-8, 6, 0], 0, ["ADVSEC_fnc_sirenInit", []]],
        ["Box_NATO_Equip_F", [6, -7, 0], 0, ["ADVSEC_fnc_crateInit", []]],
        ["Land_DataTerminal_01_F", [-6, -7, 0], 180, ["ADVSEC_fnc_dutyTermInit", []]],
        ["Land_BagFence_Long_F", [0, -12, 0], 0, ""], ["Land_BagFence_Long_F", [4, -12, 0], 0, ""], ["Land_BagFence_Long_F", [-4, -12, 0], 0, ""]
    ]],
    ["station", [
        ["CamoNet_BLUFOR_big_F", [0, 0, 0], 0, ""],
        ["Land_TableDesk_F", [0, 1.5, 0], 180, ""],
        ["Land_OfficeChair_01_F", [0, 2.5, 0], 0, ""],
        ["Land_Laptop_unfolded_F", [-0.4, 1.5, 0.82], 0, ["ADVSEC_fnc_repTerminalInit", ["PM", []]]],
        ["Land_MobilePhone_old_F", [0.5, 1.4, 0.82], 0, ["ADVSEC_fnc_phoneInit", []]],
        ["Land_DataTerminal_01_F", [3, 3, 0], 180, ["ADVSEC_fnc_dutyTermInit", []]],
        ["Box_NATO_Equip_F", [-3, 3, 0], 0, ["ADVSEC_fnc_crateInit", []]],
        ["Land_CampingChair_V2_F", [2, -2, 0], 30, ""], ["Land_CampingChair_V2_F", [-2, -2, 0], -30, ""]
    ]],
    ["stockade", [
        ["Land_PortableLight_single_F", [0, 0, 0], 0, ["ADVSEC_fnc_jailInit", [7]]],
        ["Land_Razorwire_F", [0, 8, 0], 0, ""], ["Land_Razorwire_F", [0, -8, 0], 0, ""],
        ["Land_Razorwire_F", [8, 0, 0], 90, ""], ["Land_Razorwire_F", [-8, 0, 0], 90, ""],
        ["Land_Razorwire_F", [5.7, 5.7, 0], 45, ""], ["Land_Razorwire_F", [-5.7, -5.7, 0], 45, ""],
        ["Land_Razorwire_F", [5.7, -5.7, 0], -45, ""], ["Land_Cargo_Patrol_V1_F", [-10, 10, 0], 135, ""]
    ]],
    ["hospital", [
        ["Land_Medevac_house_V1_F", [0, 0, 0], 0, ["ADVSEC_fnc_hospInit", []]],
        ["Land_HelipadSquare_F", [0, 25, 0], 0, ""],
        ["Box_NATO_Support_F", [5, -4, 0], 0, ""]
    ]],
    ["river", [
        ["Land_Cargo_Patrol_V1_F", [0, 0, 0], 0, ""],
        ["B_Boat_Transport_01_F", [0, 15, 0], 90, ""], ["B_Boat_Transport_01_F", [6, 15, 0], 90, ""],
        ["Box_NATO_Equip_F", [4, -3, 0], 0, ["ADVSEC_fnc_crateInit", []]],
        ["Land_Loudspeakers_F", [-5, -3, 0], 0, ["ADVSEC_fnc_sirenInit", []]]
    ]],
    ["shop", [
        ["Land_MarketShelter_F", [0, 0, 0], 0, ""],
        ["Land_CampingTable_F", [0, 1, 0], 0, ["ADVSEC_fnc_shopInit", []]],
        ["Land_Atm_01_F", [4, -1, 0], 0, ["ADVSEC_fnc_atmInit", []]]
    ]]
];
private _set = _sets getOrDefault [_type, []];
private _dir = getDir _logic;
private _made = [];
{
    _x params ["_c", "_off", "_rot", "_init"];
    if (isClass (configFile >> "CfgVehicles" >> _c)) then {
        private _p = _logic modelToWorld _off;
        private _o = createVehicle [_c, [_p select 0, _p select 1, 0], [], 0, "CAN_COLLIDE"];
        _o setDir (_dir + _rot);
        _o setPosATL [_p select 0, _p select 1, _off select 2];
        if ((_off select 2) == 0) then {_o setVectorUp surfaceNormal getPosATL _o};
        _made pushBack _o;
        if (_init isEqualType [] && {_init isNotEqualTo []}) then {
            _init params ["_fn", "_args"];
            // El calabozo solo se configura en el servidor; el resto se inicia en todas las máquinas (también JIP)
            if (_fn == "ADVSEC_fnc_jailInit") then {[_o, "STR_ADVSEC_mp_cell" call ADVSEC_fnc_L, _args select 0] call ADVSEC_fnc_jailInit} else {
                ([_o] + _args) remoteExecCall [_fn, 0, format ["%1_%2", _fn, netId _o]];
            };
        };
    } else {
        diag_log format ["[ADVSEC] build %1: falta la clase %2", _type, _c];
    };
} forEach _set;
["build", objNull, [_type, mapGridPosition _logic, count _made]] call ADVSEC_fnc_logEvent;
_made
