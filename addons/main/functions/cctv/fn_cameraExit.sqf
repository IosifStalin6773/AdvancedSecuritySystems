if (isNil "ADVSEC_camObj") exitWith {};
(findDisplay 46) displayRemoveEventHandler ["KeyDown", ADVSEC_camKeyEH];
ADVSEC_camObj cameraEffect ["terminate", "back"];
camDestroy ADVSEC_camObj;
camUseNVG false;
false setCamUseTI 0;
ADVSEC_camObj = nil;
("ADVSEC_CamLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
