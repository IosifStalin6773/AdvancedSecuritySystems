/*
    [captura, [listas de entidades]] (cliente) Reconstrucción CCTV: crea objetos simples locales (fantasmas) donde estaban
    las personas y vehículos captados por la cámara en ±1 minuto, con marcas en el mapa. Se borran a los 90 s.
*/
params ["_s", "_sets"];
if (!isNil "ADVSEC_cyGhosts") then {{deleteVehicle _x} forEach ADVSEC_cyGhosts; {deleteMarkerLocal _x} forEach ADVSEC_cyMarks};
ADVSEC_cyGhosts = []; ADVSEC_cyMarks = [];
private _names = [];
{
    {
        _x params ["_cls", "_pos", "_dir", "_nm"];
        private _mdl = getText (configFile >> "CfgVehicles" >> _cls >> "model");
        if (_mdl isNotEqualTo "") then {
            if ((_mdl select [0, 1]) == "\") then {_mdl = _mdl select [1]};
            if ((_mdl find ".p3d") < 0) then {_mdl = _mdl + ".p3d"};
            private _o = createSimpleObject [_mdl, _pos, true];
            _o setDir _dir;
            ADVSEC_cyGhosts pushBack _o;
        };
        if !(_nm in _names) then {
            _names pushBack _nm;
            private _m = format ["ADVSEC_cyR_%1", count ADVSEC_cyMarks];
            createMarkerLocal [_m, _pos];
            _m setMarkerTypeLocal (["mil_triangle", "mil_dot"] select (_cls isKindOf "CAManBase"));
            _m setMarkerColorLocal "ColorPink";
            _m setMarkerTextLocal _nm;
            ADVSEC_cyMarks pushBack _m;
        };
    } forEach _x;
} forEach _sets;
hint parseText format [("STR_ADVSEC_pmc_cy_replay" call ADVSEC_fnc_L), (_s select 2) call ADVSEC_fnc_repEsc, _s select 0, (_names joinString ", ") call ADVSEC_fnc_repEsc, count ADVSEC_cyGhosts];
[] spawn {
    private _g = ADVSEC_cyGhosts;
    sleep 90;
    if (ADVSEC_cyGhosts isEqualTo _g) then {
        {deleteVehicle _x} forEach ADVSEC_cyGhosts;
        {deleteMarkerLocal _x} forEach ADVSEC_cyMarks;
        ADVSEC_cyGhosts = []; ADVSEC_cyMarks = [];
    };
};
