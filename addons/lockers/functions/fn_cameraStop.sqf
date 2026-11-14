['clear'] call TSL_fnc_editorDraw;
['close'] call TSL_fnc_themeUI;['shutdown'] call TSL_fnc_editorPreview;['close'] call TSL_fnc_editorObjects;['close'] call TSL_fnc_presetUI;['close'] call TSL_fnc_editorCatalogUI;uiNamespace setVariable ['TSL_presets',createHashMap];['cancel'] call TSL_fnc_editorInput;uiNamespace setVariable ['TSL_editor',createHashMap];
private _s=uiNamespace getVariable ['TSL_camera',createHashMap];
{private _id=_s getOrDefault [_x select 0,-1];if (_id>=0) then {removeMissionEventHandler [_x select 1,_id];};} forEach [['frame','EachFrame'],['draw','Draw3D']];
private _cam=_s getOrDefault ['camera',objNull];
private _returnCamera=_s getOrDefault ['returnCamera',player];if (isNull _returnCamera) then {_returnCamera=player;};if (!isNull _cam) then {_returnCamera switchCamera (_s getOrDefault ['returnView','INTERNAL']);camDestroy _cam;};
private _player=_s getOrDefault ['player',objNull];if (!isNull _player) then {_player hideObject (_s getOrDefault ['playerHidden',false]);};
uiNamespace setVariable ['TSL_camera',createHashMap];
