# ADVSEC 1.24.0

Mecánicas inspiradas en el mod 716th MP, reimplementadas con código propio (sin copiar código ni recursos). **Sin compilar con HEMTT ni probar en partida.**

## Carrera y justicia militar
- Méritos, medallas (con descuento en tienda), hoja de servicio, evaluación automática de turno, organigrama y clasificación.
- Escuela PM (módulo Eden, `requireSchool`), revista de uniforme y prioridad de avisos (supervisor).
- Artículo 15, consejo de guerra y juicios con juez y abogado IA.

## Paga, mostrador y equipo
- Paga dinámica (`payDynamic`): plus de servicio cuando faltan agentes. Tope de ahorro (`bankCap`), con el exceso a la tesorería, y recibo de nómina.
- Paga por informe (`reportPay`): el aviso atendido se paga una sola vez al presentar el informe.
- Módulos: teléfono de comisaría, sirenas de la base (alarma y toque de queda), mercado negro en los pueblos y caja de equipo PM.
- 30 objetos de la PM con iconos propios. Con `pmItemsRequired` = 1 hacen falta para esposar, soltar, multar, escena, registro y K-9.
- Bengalas, cronómetro, cinta métrica, cadena antirrobo y cortapernos (fuerza en la mitad de tiempo).

## Avisos IA y tensión social
- 27 tipos de aviso generados por IA, que entran en la central y suenan en el teléfono. Al resolverlos dan méritos.
- Tensión social de 0 a 100: sube con los fallos y las muertes de civiles.
- El Zeus (o el permiso `callLaunch`) lanza y cancela avisos.
- Autotest al arrancar.
- Teclas: alto, sirena del vehículo y megáfono.

## Instalaciones
- Hospital: triaje, quirófano y evacuación aérea.
- Vida en la prisión y en la base.
- Construir instalación (base, comisaría, prisión, hospital, base fluvial, tienda).
- Terminal de permisos (R&R).
- Club de suboficiales.
- Instrucción guiada para reclutas.

## Equipo en la mano, uniforme, material médico y radio
- **15 objetos nuevos:**
  - Material médico: bolsa médica M5, estetoscopio, tensiómetro, etiquetas de triaje, sales de amoníaco, férula, apósito para quemaduras, albúmina, morfina y camilla.
  - Equipo: cámara de pruebas, megáfono, carpeta de partes, escudo y porra antidisturbios.
- **Uniforme PM** (retexturas de piezas vanilla): casco blanco y negro, gorra, cinturón blanco y chaleco.
- **En la mano:** se sacan desde el menú de la PM. La tecla o el menú «Usar lo que llevo» hace lo siguiente:
  - Cámara: la foto queda en el registro.
  - Megáfono: los avisos llegan a 120 m.
  - Carpeta: abre el parte.
  - Porra: aturde a la persona.
  - Escudo: reduce al 30 % el daño que llega de frente.
  - El modelo visible se elige en `handProps`. Para el escudo y la porra va vacío por ahora, porque no hay modelo propio.
- **Material médico:** se usa desde el menú sobre el herido o sobre uno mismo. La camilla sirve para llevar a un inconsciente.
- **Radio:**
  - Redes PM, PMC y Mando, con códigos 10 (`radioCodes`) o mensaje libre.
  - Lo oye también quien está junto a un vehículo de la red.
  - Tráfico ambiental (`radioChatter`).
  - Comprobación de radio cada `radioCheckMin` minutos: los que no responden se avisan al Mando.

## Ajustes nuevos
`payDynamic`, `payDynTarget`, `payDynStep`, `payDynMax`, `bankCap`, `reportPay`, `phoneSound`, `curfewStart`, `curfewEnd`, `curfewTowns`, `curfewTownRadius`, `sirenSound`, `blackMarket*`, `mpCrateItems`, `mpCrateMags`, `pmItemsRequired`, `pmItemUse`, `aiCalls`, `call*`, `vehSirenSound`, `selfTest`, `selfTestCalls`, `dustoffHeli`, `jailLife`, `jailAmbient`, `lifeSoldiers`, `rnrMinutes`, `rnrDestinations`, `clubMinRank`, `clubDrinkPrice`, `trainMerit`, `handProps`, `radioCodes`, `radioChatter`, `radioCheckMin`.
