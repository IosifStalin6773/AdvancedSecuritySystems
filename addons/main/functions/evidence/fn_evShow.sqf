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
        format [("STR_ADVSEC_distance_mget_within_4_m" call ADVSEC_fnc_L), [_sum] call ADVSEC_fnc_repEsc, round (player distance _pos)]]
};
["scene", ("STR_ADVSEC_scene_inspection" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_collect" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["collect", player, [_id]] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]; [] spawn {sleep 0.6; ["scene", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}}}],
    [("STR_ADVSEC_my_evidence" call ADVSEC_fnc_L), {closeDialog 0; [objNull] call ADVSEC_fnc_evOpen}]
]] call ADVSEC_fnc_panelOpen;
["scene", format [("STR_ADVSEC_traces_within_mmarked_in_gold" call ADVSEC_fnc_L), count _list, ["sceneRadius", 15] call ADVSEC_fnc_setting], _rows] call ADVSEC_fnc_panelSet;
