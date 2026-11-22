# ADVSEC 1.23.0

## Eden: cerradura o keypad en cada puerta del edificio
- Al abrir los atributos de un edificio con puertas aparece la sección **Puertas (ADVSEC)** con una casilla por puerta, como «Estados de las puertas».
- Clic en una puerta: ventana con **Tipo** (sin configurar, cerradura, keypad), **estado inicial**, **PIN** y **zona de alarma** (keypad), **nivel mínimo**, **documentos** y **ID de llave**.
- **Aplicar a todas** copia la configuración a todas las puertas; **Quitar** la borra. Las casillas se ven naranjas (C, cerradura) o azules (K, keypad).
- En partida, cerradura: la abre y cierra en la propia puerta quien cumpla el requisito (igual que el módulo Cerradura). Keypad: acciones «Usar keypad» y «Pasar tarjeta» en la puerta; usa la zona de alarma indicada.
- Forzar cerradura y asegurar puerta (PM) siguen funcionando en esas puertas. El panel Zeus las muestra.
- Solo para edificios colocados en Eden (los del mapa no tienen atributos: para esos sigue el módulo Cerradura/Keypad).
- La sección sale en todos los objetos; en los que no tienen puertas pone «Este objeto no tiene puertas».

Sin probar en partida.
