# Advanced Security Systems 1.9.0: base de datos de jugadores

## Instalación
1. Sustituye `@AdvancedSecuritySystems` (los dos PBO, sus `.bisign` y `mod.cpp`).
2. En el servidor, copia `keys\advsec_1.9.0.bikey` a la carpeta `keys` y borra `advsec_1.8.0.bikey`.
3. Si la misión usa `CfgRemoteExec` en lista blanca, añade `ADVSEC_fnc_pdbServer` (destino 2) y `ADVSEC_fnc_pdbSet` (destino 0). Están en el `description.ext` de ejemplo.

## Novedad: base de datos de la Policía Militar
- **Registro automático.** Se apunta a todo jugador que entra en el servidor. Se guardan:
  - Nombre y nombres anteriores.
  - SteamID.
  - Primera y última conexión.
  - Número de conexiones y tiempo jugado.
  - Rangos, notas e historial de cambios.

  Todo esto se guarda en el perfil del servidor, así que se conserva entre misiones.
- **Panel en el juego.** Se abre con **Alt + Fin**, desde «Base de datos de jugadores» en el menú propio de PM, o desde la acción ACE propia. Incluye:
  - Buscador por nombre o SteamID.
  - Filtros: en línea, PM, AA.II. y con rango global.
  - Ficha completa del jugador, con historial.
- **Gestión de rangos:**
  - **Rango PM (1-5):** las opciones son «Según lista de la misión» (lo de siempre, `ADVSEC_pmUIDs`), «Sin rango» (retira la placa aunque esté en la lista) o un nivel.
  - **Rango AA.II. (1-5):** funciona igual que el rango PM.
  - **Rango global:** lista `ranksGlobal` (Soldado … General). Se muestra en el ID militar y en la PDA, y cambia el rango de Arma (`ranksGlobalArma`, se puede desactivar con `globalRankSetUnit = 0`).
- **Aplicación inmediata.** Si el jugador está conectado, recibe o pierde la placa al momento y un aviso. Si no, se aplica cuando vuelva a aparecer.
- **Permisos.** Se pueden ajustar en `ADVSEC_Settings >> Permissions` o en CBA.
  - `playerDB`: ver el panel (PM 4 por defecto).
  - `rankPM`: cambiar rangos PM (PM 5).
  - `rankAI`: cambiar rangos AA.II. (AA.II. 5).
  - `rankGlobal`: cambiar rangos globales (PM 5).
  - Un mando solo puede asignar o tocar rangos PM/AA.II. **inferiores al suyo** y no puede cambiarse el suyo propio.
  - Zeus y los administradores no tienen límite.
- **Registro de eventos.** Cada cambio queda registrado (`rankChange`).

## Pendiente
No se ha probado en el juego. Compila limpio en HEMTT y los dos PBO están firmados y verificados.
