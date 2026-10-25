// [unidad, modo, args] — se ejecuta donde la unidad es local. Los clientes pasan por ADVSEC_fnc_policeServer.
params ["_unit", "_mode", ["_args", []]];
if (isNull _unit) exitWith {};
if (!local _unit) exitWith {
    if (isServer) then {_this remoteExecCall ["ADVSEC_fnc_policeLocal", _unit]} else {[_mode, player, _unit, _args] remoteExecCall ["ADVSEC_fnc_policeServer", 2]};
};
if (isMultiplayer && {!(remoteExecutedOwner in [0, 2])}) exitWith {};

switch (_mode) do {
    case "restrain": {
        _args params ["_state"];
        _unit setVariable ["ADVSEC_restrained", _state, true];
        if (_state) then {
            if (!isPlayer _unit) then {{_unit disableAI _x} forEach ["MOVE", "TARGET", "AUTOTARGET"]};
            if (isNil {_unit getVariable "ADVSEC_invEH"}) then {
                _unit setVariable ["ADVSEC_invEH", _unit addEventHandler ["InventoryOpened", {[_this select 0] call ADVSEC_fnc_isRestrained}]];
            };
            _unit action ["SwitchWeapon", _unit, _unit, 100];
            [_unit] spawn {
                params ["_u"];
                while {alive _u && {_u getVariable ["ADVSEC_restrained", false]}} do {
                    if (isNull objectParent _u && {toLower animationState _u != "amovpercmstpsnonwnondnon_ease"} && {time > (_u getVariable ["ADVSEC_animSent", 0])}) then {
                        _u setVariable ["ADVSEC_animSent", time + 3];
                        [_u, "AmovPercMstpSnonWnonDnon_Ease"] remoteExecCall ["switchMove", 0];
                    };
                    sleep 0.5;
                };
                if (alive _u && {isNull objectParent _u}) then {[_u, ""] remoteExecCall ["switchMove", 0]};
            };
            if (isPlayer _unit) then {hint "Has sido esposado."};
        } else {
            if (!isPlayer _unit) then {{_unit enableAI _x} forEach ["MOVE", "TARGET", "AUTOTARGET"]};
        };
    };
    case "load": {
        _args params ["_veh"];
        detach _unit;
        _unit assignAsCargo _veh;
        _unit moveInCargo _veh;
    };
    case "unload": {
        unassignVehicle _unit;
        moveOut _unit;
    };
    case "teleport": {
        _args params ["_pos"];
        detach _unit;
        if (!isNull objectParent _unit) then {moveOut _unit};
        _unit setPosATL _pos;
    };
    case "seize": {
        _args params ["_kind", "_class"];
        switch (_kind) do {
            case "W": {_unit removeWeapon _class};
            case "M": {_unit removeMagazine _class};
            default {
                if (_class in assignedItems _unit) then {_unit unlinkItem _class} else {_unit removeItem _class};
                private _s = _unit getVariable ["ADVSEC_seized", []];
                _s pushBackUnique _class;
                _unit setVariable ["ADVSEC_seized", _s];
            };
        };
    };
};
