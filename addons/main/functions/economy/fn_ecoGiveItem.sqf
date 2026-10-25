// [clase, cantidad] (cliente que compra): mete el objeto en uniforme, chaleco o mochila; si no cabe, lo deja en el suelo
params ["_c", ["_n", 1]];
private _kind = switch (true) do {
    case (isClass (configFile >> "CfgMagazines" >> _c)): {"mag"};
    case (isClass (configFile >> "CfgVehicles" >> _c)): {"bag"};
    case (isClass (configFile >> "CfgWeapons" >> _c) && {getNumber (configFile >> "CfgWeapons" >> _c >> "type") in [1, 2, 4]}): {"weapon"};
    default {"item"};
};
private _add = {
    params ["_cont"];
    switch (_kind) do {
        case "mag": {_cont addMagazineCargoGlobal [_c, 1]};
        case "bag": {_cont addBackpackCargoGlobal [_c, 1]};
        case "weapon": {_cont addWeaponCargoGlobal [_c, 1]};
        default {_cont addItemCargoGlobal [_c, 1]};
    };
};
private _ground = 0;
for "_i" from 1 to _n do {
    private _done = false;
    if (_kind == "bag" && {backpack player isEqualTo ""}) then {player addBackpack _c; _done = true};
    if (!_done && {_kind != "bag"}) then {
        {
            if (!isNull _x && {_x canAdd _c}) exitWith {[_x] call _add; _done = true};
        } forEach [uniformContainer player, vestContainer player, backpackContainer player];
    };
    if (!_done) then {
        private _h = createVehicle ["GroundWeaponHolder", getPosATL player, [], 0, "CAN_COLLIDE"];
        _h setPosATL getPosATL player;
        [_h] call _add;
        _ground = _ground + 1;
    };
};
hint parseText format ["Comprado: %1 × %2%3", _n, [_c] call ADVSEC_fnc_ecoItemName, ["", format ["<br/>%1 no cabían y están en el suelo.", _ground]] select (_ground > 0)];
