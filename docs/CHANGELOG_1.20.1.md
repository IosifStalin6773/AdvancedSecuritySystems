# ADVSEC 1.20.1

## Interfaces
- `UIF` vuelve a ser geometría sin ampliar; el 12 % extra solo se aplica al texto con la macro nueva `UIT` (`sizeEx`, `size`, `rowHeight`). En 1.19.2-1.20.0 los anchos y altos crecían un 12 % y no casaban con sus posiciones: cajas solapadas o fuera del marco.
- Tarjeta de documento: tamaños en la misma escala que su posición (`DOC_S`). La foto y la columna derecha ya no se salen de la tarjeta.

## NPC de los encargos
- **Documentos duplicados**: en un jugador o en el editor, `netId` es igual para todas las IA, así que todas compartían el mismo almacén de documentos («cuatro DNI» con nombres de otros). Ahora la clave usa `BIS_fnc_netId` y los civiles reciben su DNI como único; al retirarlos se borra su entrada.
- Contratos y células usan `BIS_fnc_netId`/`BIS_fnc_objectFromNetId`: el VIP, la carga, el camión y la QRF funcionan también en un jugador.
- **Bajar del vehículo**: nueva acción «Ordenar que baje del vehículo» sobre civiles IA sin esposar (permiso de registrar vehículos; validada en el servidor). Antes «Sacar del vehículo» solo salía con la persona esposada.

## Menú de interacción (Ctrl+Win)
- Dos niveles como máximo: Mi personaje, I.V.M. (con el perfil PMC), Policía Militar y Superadministrador, y dentro acciones directas sin submenús.
- Sin duplicados: lo de la compañía (contratos, células, servicio, central, patrullas, consultas, registrar vehículo, ORBAT, tesorería) solo en I.V.M.; la PM lleva lo propio del cuerpo y AA.II. Sin perfil PMC, la PM lo lleva todo.
- El menú de acciones sobre otra persona se llama como la compañía con el perfil PMC.

## Módulo de Eden «Encargo a medida (PMC)»
- Crea la oferta al empezar la misión, configurada desde el propio módulo:
  - Tipo de encargo
  - Nombre del cliente
  - Tipo de cliente (reputación)
  - Facción/bando de los NPC (East, West, Independent, Civiles)
  - **Selector de NPC**: catálogo por bando y facción de todas las unidades cargadas, multiselección, con peso por clase
  - **Nº de NPC**
  - **Área** (el área del módulo en Eden, redimensionable)
  - Pago
  - Minutos
  - Título
- Sincronizado con un objeto, ese objeto es el VIP o la carga.
- Con bando «Civiles» no hay enemigos y las clases elegidas son los civiles del encargo.
- Lo vacío usa la configuración. Las ofertas de Eden no caducan y no se duplican al reiniciar la misión.

Sin probar en partida.
