# ADVSEC 1.19.5

## Vida en los encargos (`ADVSEC_fnc_ctrCivil`)
- **Control de acceso**: vehículos civiles llegan desde 350-650 m por carretera al punto de control (marcado con conos), paran y esperan. Un civil queda revisado cuando un agente pasa 9 s a menos de 6 m y luego se aleja; si nadie le atiende en 3 min, se marca como no revisado y se va. Hasta 2 + riesgo a la vez, uno nuevo cada `contractCivEvery` s.
- **Vigilancia**: trabajadores que pasean por la instalación y visitantes a pie que llegan hasta el centro y esperan. Cada visitante sin revisar resta un 5 % a la presencia final.
- **Documentación y sospechosos**: los civiles llevan DNI (Registro Civil). Una fracción `contractCivSuspect` (0,3) son sospechosos: sin documentación, con requisitoria (se ve al consultar a la central) o con contrabando (cargadores en el uniforme y un arma del mercado negro en el maletero o en el doble fondo del coche). Si se esposa o se baja del vehículo a un sospechoso, cuenta como retenido.
- **Escolta**: camión de carga del cliente al inicio de la ruta. Los puntos de la ruta los tiene que alcanzar el camión; si se destruye, el contrato falla.
- **QRF**: si a un tercio del tiempo nadie ha llamado, un civil de la zona llama al 112, para que la QRF tenga una respuesta que medir.
- Se sustituye el tráfico en bucle de 1.19.3. Al terminar el encargo se retira todo y se borran las requisitorias de prueba.
- Ajustes nuevos (CBA › 12 · Contratos PMC): `contractCivilians` (1), `contractCivSuspect` (0,3), `contractCivEvery` (45 s).

Sin probar en partida.
