# 1.16.0

## Taquillas personales (TS_Lockers integrado)

- TS_Lockers va dentro del mod como `advsec_lockers.pbo` (mismo prefijo `TS_Lockers`, mismas clases `Land_TS_Locker_F`, así que las misiones que ya las usan siguen funcionando). Necesita ACE y CBA; sin ellos no se carga y el resto de ADVSEC funciona igual.
- Quita el `TS_Lockers.pbo` suelto de la lista de mods: tenerlo dos veces duplica las clases.
- Enganches de ADVSEC (`ADVSEC_fnc_lockerGate`):
  - Quién puede reclamar una taquilla: todos, solo PM o PM y AA.II. (ajuste `lockerAccess`). Una taquilla puede pedir además un requisito propio (variable `ADVSEC_req`, mismo formato que puertas y keypads).
  - Los detenidos no pueden usar su taquilla (`lockerJailBlock`).
  - Reclamar, liberar y reiniciar quedan en el registro de eventos.
  - Los superadministradores pasan siempre.
- Base de datos de jugadores: fila «Taquilla» en el Resumen con «Liberar taquilla» (el equipo queda guardado) y «Vaciar taquilla» (borra también lo guardado).
- `lockerPersist`: las taquillas colocadas con Zeus se guardan por mapa y se vuelven a crear al reiniciar (por defecto solo en Antistasi, que no guarda los objetos de Zeus).
- Quitado `camSetBank` de la cámara del editor (comando roto en Arma, no hacía nada).

## Compatibilidad con Antistasi Ultimate (mod)

- Detección por la configuración de la misión (`class A3A`). Antes se miraba si existía `A3A_fnc_resourcesPlayer`, que con el mod Antistasi Ultimate cargado existe en cualquier misión, y ADVSEC creía estar en Antistasi aunque no lo estuviera.
- Efectivo: en Antistasi los cambios pasan por `A3A_fnc_resourcesPlayer`, que actualiza su HUD y sus estadísticas.
- Tesorería: con `a3aTreasury` (activado por defecto) multas, nóminas y compras usan el dinero de la facción rebelde (`resourcesFIA`).
- Rangos: en Antistasi ADVSEC ya no cambia el rango de Arma (`setUnitRank`); lo lleva el sistema de ascensos de Antistasi. El rango global de ADVSEC se sigue mostrando.
- Las misiones de Antistasi Ultimate van dentro del mod y no tienen `description.ext` editable: configura ADVSEC desde Opciones > Opciones de complementos (CBA). Su `CfgRemoteExec` permite todo, así que no hace falta lista blanca.
