# 1.17.0

## Inglés y español

- Todos los textos del mod (mensajes, menús de ACE, ventanas, PDA, módulos de Eden y Zeus, objetos, documentos, informes, ajustes de CBA y teclas) están en inglés y español: 1.805 textos en `addons/main/stringtable.xml`.
- Nuevo ajuste `language` (CBA: General › Idioma / Language): automático (idioma del juego), English o Español. En un servidor dedicado «automático» es inglés para los mensajes que genera el servidor; en un servidor en español, ponlo en Español.
- Los scripts usan `ADVSEC_fnc_L` (lee `CfgLang.hpp`, que se genera desde la stringtable con `tools/stringtable_to_cfglang.py`) para que el servidor respete ese ajuste. Las configs usan `$STR_ADVSEC_*`.
- Los valores guardados en la base de datos (estados de informes y multas, gravedad, sanción, peligrosidad, estado de avisos) se siguen guardando en español, así que los datos de versiones anteriores valen tal cual; `ADVSEC_fnc_Lv` los traduce al mostrarlos. Los desplegables de gravedad y sanción del editor de informes guardan el valor, no el texto mostrado.
- Los ajustes de texto de `ADVSEC_Settings` (rangos, especialidades) aceptan `$STR_ADVSEC_*`; los que pongas en tu `description.ext` se muestran tal cual.

## Patrullas con ruta

- Policía Militar › Servicio › Patrullas con ruta. Con el permiso `patrolPlan` (PM nivel 3): nueva patrulla (nombre, agentes, radio de cada punto, tiempo máximo) y ruta marcada con clics en el mapa (Alt + clic borra el último punto, máx. 30).
- Los asignados reciben la ruta en su mapa. El cronómetro empieza en el primer punto; el sistema registra hora y agente de cada punto.
- Resultado: Cumplida, Incompleta (fuera de tiempo) o Cancelada. Se ve en el panel de patrullas y queda en el registro de eventos. Se guardan las 60 últimas (`_patrols` en el perfil del servidor).
- Ajustes: `patrolOrdered` (1), `patrolNeedDuty` (1), `patrolBonus` (0).
- Lista blanca de `CfgRemoteExec` (examples/description.ext): `ADVSEC_fnc_patrolServer` (servidor) y `ADVSEC_fnc_patrolMarkers` (clientes).

Sin probar en partida.
