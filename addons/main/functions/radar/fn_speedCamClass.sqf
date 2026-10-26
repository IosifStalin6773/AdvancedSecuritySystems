// -> clase del modelo de radar: speedCamClass (por defecto cwa_Kamera de CWR²) o, si no está cargado, una cámara vanilla
private _c = ["speedCamClass", "cwa_Kamera"] call ADVSEC_fnc_setting;
[_c, "Land_HandyCam_F"] select !isClass (configFile >> "CfgVehicles" >> _c)
