# ADVSEC 1.21.0: diálogos por nodos en Eden

## Editor de diálogos (para cualquier objeto de Eden)
- Nueva sección **«Diálogo (ADVSEC)»** en los atributos de **todos** los objetos y unidades de Eden, no solo en los módulos del mod. El botón «Crear diálogo (editor por nodos)» abre el editor visual.
- **Lienzo**:
  - Arrastra los nodos con el ratón.
  - Doble clic en un hueco crea un nodo nuevo.
  - Las flechas numeradas son las respuestas.
  - El nodo inicial lleva ★.
- **Panel del nodo**:
  - Quién habla (NPC, jugador o narrador).
  - Nombre que se muestra.
  - Texto: `%npc%` y `%player%` se sustituyen.
- **Respuestas**:
  - Texto.
  - Destino: un nodo, «terminar» o «+ nodo nuevo», que lo crea ya enlazado.
  - Condición opcional: código SQF con `_player` y `_npc`; la respuesta solo sale si devuelve true.
  - Acción, con su parámetro:
    - ejecutar código
    - fijar variable (`nombre=valor`, compartida)
    - dar o quitar un objeto
    - el NPC se une al grupo
    - abrir el terminal de contratos
    - mostrar un mensaje
- Se guarda en la misión, en el atributo `ADVSEC_Dialog`.
- En partida, el objeto tiene la acción **«Hablar»** (ACE o rueda), que abre la ventana de conversación.
- También vale desde scripts: `[objeto, textoDelDiálogo] call ADVSEC_fnc_dlgAttach`.
- Funciones nuevas: `ADVSEC_fnc_dlgData`, `dlgEditor`, `dlgAttr`, `dlgAttach`, `dlgTalk` y `dlgAction`.

## Correcciones
- Selector de catálogo (NPC del encargo a medida): el tipo de catálogo se elegía mal por la precedencia de `find … max`.

Sin probar en partida.
