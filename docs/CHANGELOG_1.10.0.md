# Advanced Security Systems 1.10.0: terminal de superadministrador

## Instalación
1. Sustituye `@AdvancedSecuritySystems` (los dos PBO, sus `.bisign` y `mod.cpp`).
2. En el servidor, copia `keys\advsec_1.10.0.bikey` a la carpeta `keys` y borra las claves `advsec_*` anteriores.
3. Si la misión usa `CfgRemoteExec` en lista blanca, añade `ADVSEC_fnc_adminServer` (destino 2), `ADVSEC_fnc_adminSet` (destino 0) y `ADVSEC_fnc_adminInit` (destino 0, JIP). Están en el `description.ext` de ejemplo.

## Novedad: terminal de superadministrador
- Acceso: Zeus/administradores, los SteamID de `superAdmins[]` y los que se den de alta desde el propio terminal (persistente).
- Se abre con **Ctrl + Alt + Fin**, con la acción propia «Terminal de superadministrador» o desde un ordenador con el módulo de Eden/Zeus.
- Borra informes, buscados, detenidos, multas, pruebas, índices de sospecha, documentos y el registro de eventos, uno a uno o todos.
- Retira rangos PM, AA.II. y globales (a un jugador o a todos), los devuelve a los de la misión, borra fichas y gestiona superadministradores.
- Doble confirmación en las acciones destructivas. Todo se valida en el servidor y queda registrado como `superAdmin`.

## Cambios de 1.9.1 y 1.9.2
- 1.9.1: controles de carretera más robustos (frenado en la máquina dueña del vehículo, límite de 40 s en el servidor, limpieza al borrar el módulo).
- 1.9.2: corregido el error que impedía registrar vehículos (`parseNumber` sobre ajustes numéricos de CBA).
