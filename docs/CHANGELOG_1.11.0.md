# Advanced Security Systems 1.11.0: economía (compatible con el HUD THUD)

## Instalación
1. Sustituye `@AdvancedSecuritySystems` (los dos PBO, sus `.bisign` y `mod.cpp`).
2. En el servidor, copia `keys\advsec_1.11.0.bikey` a la carpeta `keys` y borra las claves `advsec_*` anteriores.
3. Lista blanca `CfgRemoteExec`: añade `ADVSEC_fnc_ecoServer` (2), `ADVSEC_fnc_ecoGiveItem` y `ADVSEC_fnc_ecoTakeItem` (0), `ADVSEC_fnc_atmInit` y `ADVSEC_fnc_shopInit` (0, JIP). Están en el `description.ext` de ejemplo.

## Novedades
- Efectivo y banco por SteamID, persistentes en el perfil del servidor.
- Cartera (Alt + Insert): ingresar, retirar, transferir y dar efectivo. Módulo «Cajero automático» (Eden y Zeus).
- Nóminas periódicas según rango PM, AA.II. y global.
- Módulo «Tienda»: comprar y vender con lista de precios propia o `shopItems[]`.
- Tesorería de la PM: recibe las multas; el mando (permiso `treasury`) paga primas.
- Las multas se cobran del efectivo y el banco; «Marcar pagada» cobra al sancionado conectado.
- Terminal de superadministrador: categoría «Economía».
- HUD THUD: el efectivo va en `moneyX`; fuera de Antistasi se publican `resourcesFIA` (tesorería), `hr` (agentes PM) y `theBoss` (mando PM), y se desactiva la espera de THUD por Antistasi. En Antistasi se respeta su dinero.
