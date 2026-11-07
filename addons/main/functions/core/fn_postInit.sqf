if (isServer) then {
    [] call ADVSEC_fnc_repLoad;
    [] call ADVSEC_fnc_policeDBLoad;
    if (isNil "ADVSEC_dbLoopH") then {ADVSEC_dbLoopH = [] spawn ADVSEC_fnc_dbLoop};
    [] call ADVSEC_fnc_evDB;
    [] call ADVSEC_fnc_heatDB;
    [] call ADVSEC_fnc_fineDB;
    [] call ADVSEC_fnc_pdbInit;
    [] call ADVSEC_fnc_adminLoad;
    [] call ADVSEC_fnc_ecoDB;
    if (isNil "ADVSEC_ecoLoopH") then {ADVSEC_ecoLoopH = [] spawn ADVSEC_fnc_ecoLoop};
    [] call ADVSEC_fnc_rpInit;
};
if (!hasInterface) exitWith {};

addMissionEventHandler ["Draw3D", {call ADVSEC_fnc_zeusDraw}];
[] call ADVSEC_fnc_pdaInit;

[] spawn {
    waitUntil {!isNull player && {time > 0}};
    [player] call ADVSEC_fnc_addSelfActions;
    [] call ADVSEC_fnc_ecoClient;
    [player] call ADVSEC_fnc_evClient;
    [player] call ADVSEC_fnc_armClient;
    [] call ADVSEC_fnc_docLoad;
    ["check", player] remoteExecCall ["ADVSEC_fnc_jailServer", 2];

    // Al cerrar el Arsenal: documentos que falten y nº de serie de las armas sacadas
    ADVSEC_arsClosed = {
        [] spawn {
            sleep 0.5;
            [] call ADVSEC_fnc_docRestore;
            private _ws = [primaryWeapon player, secondaryWeapon player, handgunWeapon player] select {_x isNotEqualTo ""};
            {if (!isNull _x) then {_ws append ((getWeaponCargo _x) select 0)}} forEach [uniformContainer player, vestContainer player, backpackContainer player];
            _ws = _ws apply {[_x] call BIS_fnc_baseWeapon};
            if (_ws isNotEqualTo []) then {[player, _ws] remoteExecCall ["ADVSEC_fnc_wpnArsenal", 2]};
        };
    };
    [missionNamespace, "arsenalClosed", {call ADVSEC_arsClosed}] call BIS_fnc_addScriptedEventHandler;
    if (isClass (configFile >> "CfgPatches" >> "cba_events")) then {
        ["ace_arsenal_displayClosed", {call ADVSEC_arsClosed}] call CBA_fnc_addEventHandler;
        ["loadout", {[] spawn {sleep 0.5; [] call ADVSEC_fnc_docRestore}}] call CBA_fnc_addPlayerEventHandler;
    };

    player addEventHandler ["Respawn", {
        params ["_unit"];
        [_unit] call ADVSEC_fnc_addSelfActions;
        [] call ADVSEC_fnc_ecoClient;
        [_unit] call ADVSEC_fnc_evClient;
        [_unit] call ADVSEC_fnc_armClient;
        [] call ADVSEC_fnc_docLoad;
        ["check", _unit] remoteExecCall ["ADVSEC_fnc_jailServer", 2];
        [] spawn {sleep 3; [] call ADVSEC_fnc_docRestore};
    }];

    // ACE no tiene addActionToClass permitido aquí: se registran por objeto
    while {true} do {
        {
            if (isNil {_x getVariable "ADVSEC_unitAct"}) then {
                _x setVariable ["ADVSEC_unitAct", true];
                [_x] call ADVSEC_fnc_addUnitActions;
            };
        } forEach (allUnits - [player]);
        sleep 5;
    };
};
