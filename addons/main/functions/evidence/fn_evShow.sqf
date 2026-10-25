// [[ [id, tipo, pos, resumen], ... ]] — cliente: marca las pruebas en 3D durante 2 minutos y abre el panel de la escena
params ["_list"];
ADVSEC_evMarks = _list;
ADVSEC_evMarksUntil = time + 120;
if (isNil "ADVSEC_evDrawEH") then {
    ADVSEC_evDrawEH = addMissionEventHandler ["Draw3D", {
        if (time > ADVSEC_evMarksUntil) exitWith {};
        {
            _x params ["_id", "_type", "_pos"];
            if ((player distance _pos) < 25) then {
                drawIcon3D [ADVSEC_icSearch, [0.816, 0.639, 0.188, 1], _pos vectorAdd [0, 0, 0.2], 0.6, 0.6, 0, _id, 2, 0.03, "RobotoCondensed"];
            };
        } forEach ADVSEC_evMarks;
    }];
};
private _rows = _list apply {
    _x params ["_id", "_type", "_pos", "_sum"];
    [format ["%1 · %2 m", _sum, round (player distance _pos)], _id,
        format ["<t font='RobotoCondensedBold'>%1</t><br/><t color='#8C8C8C'>Distancia:</t> %2 m<br/><br/>Acércate a menos de 4 m y pulsa Recoger.", [_sum] call ADVSEC_fnc_repEsc, round (player distance _pos)]]
};
["scene", "Inspección de escena", [
    ["Recoger", {params ["_id"]; if (!isNil "_id") then {["collect", player, [_id]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]; [] spawn {sleep 0.6; ["scene", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}}}],
    ["Mis pruebas", {closeDialog 0; [objNull] call ADVSEC_fnc_evOpen}]
]] call ADVSEC_fnc_panelOpen;
["scene", format ["<t font='RobotoCondensedBold'>%1 indicios en %2 m</t><br/><t color='#8C8C8C'>Marcados en dorado durante 2 minutos.</t>", count _list, ["sceneRadius", 15] call ADVSEC_fnc_setting], _rows] call ADVSEC_fnc_panelSet;
