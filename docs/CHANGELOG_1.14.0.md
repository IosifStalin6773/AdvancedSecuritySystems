# ADVSEC 1.14.0: radares fijos

- Radares fijos visibles con el modelo `cwa_Kamera` (CWR²); sin ese mod, `Land_HandyCam_F`.
- Toda `cwa_Kamera` colocada en la misión funciona como radar (`speedCamAuto = 1`). Módulos Eden `ADVSEC_ModuleSpeedCam` y Zeus `ADVSEC_ZeusSpeedCam`.
- Multa automática por exceso (límite, alcance, multa base y por km/h configurables), destello y aviso al conductor. Un aviso por vehículo y minuto. PM de servicio exenta (`speedCamExemptDuty`).
- La PM (permiso `radar`) lo configura interactuando con él y ve las últimas 30 capturas.
- Nuevas funciones en CfgRemoteExec: `speedCamInit` (JIP), `speedCamFlash` (clientes), `speedCamServer` (servidor).
