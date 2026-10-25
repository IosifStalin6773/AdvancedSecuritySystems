# Advanced Security Systems 1.8.0 — notas de versión (producción)

## Instalación en servidor
1. Copia `@AdvancedSecuritySystems` al servidor y cárgalo con `-mod=@AdvancedSecuritySystems` (o `-serverMod` no: el mod es necesario también en los clientes).
2. Copia `@AdvancedSecuritySystems\keys\advsec_1.8.0.bikey` a la carpeta `keys` del servidor y **borra las claves advsec_1.5.0 … 1.7.1** si estaban.
3. Ahora **los dos PBO están firmados** (también el del edificio), así que funciona con `verifySignatures = 2`.
4. En la misión, añade la plantilla `CfgRemoteExec` de `description.ext` si usas lista blanca.
5. Dependencias: ninguna obligatoria. ACE y CBA son opcionales (con CBA: ajustes y teclas dentro del juego).

## Correcciones de esta versión
- **Jugadores que entran a mitad de partida (JIP)**: los módulos de Eden solo se aplicaban a los conectados al empezar; ahora llegan también a los JIP (isGlobal = 2).
- **Eden y Zeus se comportan igual**: sin objeto sincronizado, Eden crea el mismo objeto que Zeus (tablet del keypad, altavoces, TV del monitor, mesa de la oficina/laboratorio, portátil de informes). Antes algunos módulos de Eden no hacían nada y el laboratorio quedaba en un objeto invisible sin interacción.
- **Reaplicar un módulo ya no duplica acciones** en el mismo objeto (ACE y sin ACE).
- **Seguridad**: los init de objetos (puertas, keypads, alarmas, etc.) solo se aceptan en el servidor si vienen del propio servidor o de un Zeus/administrador. Antes cualquier cliente podía reconfigurar una cerradura.
- **Cola JIP de Zeus** con clave por objeto: al reaplicar un módulo se sustituye la configuración anterior en vez de acumularse; funciona con edificios del mapa.
- Zeus: el monitor CCTV soltado en el suelo crea una TV (como el resto de módulos).
- Comprobación de vehículos cercanos de la acción «Doble fondo» más ligera (nearEntities).
- Cámara de Eden: inclinación por defecto coherente (-20º).
- mod.cpp con logo e imagen para el lanzador.

## Pendiente / no verificado
- No se ha probado en un servidor dedicado ni con varios jugadores; se recomienda una sesión de prueba antes de abrirlo.
- El edificio se recompila desde ahora con el proyecto HEMTT (addon `buildings`); si se vuelve a exportar desde Blender, hay que copiar el .p3d binarizado ahí.
