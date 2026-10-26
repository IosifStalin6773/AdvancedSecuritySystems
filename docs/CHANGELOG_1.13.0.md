# ADVSEC 1.13.0: cámara corporal en directo y menú ACE ordenado

- Cámara corporal en tiempo real (`ADVSEC_fnc_bodyLive`, diálogo `ADVSEC_BodyLive`): lista de agentes grabando, anterior/siguiente, rótulo REC, hora y cuadrícula, "SIN SEÑAL" si se apaga. Cada visionado se registra (`bodycamLive`). Desde la PDA, el menú PM › Asuntos Internos y el panel de grabaciones («Ver en directo»). Requiere PiP.
- Menú propio de ACE reducido a 3 entradas (Mi personaje, Policía Militar, Superadmin) con submenús (`ADVSEC_fnc_aceKids`, `ADVSEC_fnc_selfChildren`). Sin ACE se muestran aplanados.
- Eliminada la opción `reportsSelfAction` (los informes están en Policía Militar › Informes y pruebas).
