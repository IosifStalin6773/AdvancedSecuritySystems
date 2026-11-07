# 1.18.0 — Compañía militar privada (PMC)

Aplica al mod el documento de diseño «ADVSEC PMC – Contratos, logística y células operativas». Todo es opcional: sin terminales, armerías ni roles de célula colocados, el mod funciona como en 1.17.0. Sin probar en partida.

## 1. Contratos y mercado de clientes

- **Terminal de contratos** (módulo Eden/Zeus «Terminal de contratos», o menú ACE › Policía Militar › PMC). Pestañas Contratos (Ofertas, Activos, Historial) y Clientes.
- **Ofertas automáticas** cada `contractEvery` minutos (`contractAuto`): cliente al azar de `ADVSEC_Settings >> Clients`, tipo de `ContractTypes` limitado por la reputación con ese cliente, zona en marcadores `advsec_ctr_*` o en una población cerca de un terminal, ruta automática por carretera para escoltas y VIP. Máximo `contractMax` ofertas abiertas; caducan a 2 × `contractEvery`.
- **Oferta a medida (Zeus)**: módulo «Contrato PMC a medida». Se suelta en la zona; si cae sobre un objeto, ese objeto es lo que hay que proteger o recuperar.
- **Tipos**: escolta de convoy (ruta), protección VIP (crea el VIP con un pase VIP y lo une al grupo del jefe), vigilancia de instalación (presencia en la zona), control de acceso (registros, consultas y cacheos en el registro de eventos), QRF de guardia (tiempos de respuesta) y recuperación de material (caja a devolver a la base).
- **Negociación**: contraoferta de pago (+0…30 %), anticipo y penalización. Cada cliente admite `contractRounds` rondas; si se pide demasiado puede retirar la oferta (y baja la reputación).
- **Firma** (`contractSign`): exige reputación mínima, operadores PM conectados (`minOps`) y especialidades. El anticipo entra en la tesorería; opcionalmente con seguro (`contractInsurance`, recupera el 50 % del material perdido). Los clientes de zona gris exigen `contractGrey` y suman sospecha (`contractGreyHeat`).
- **Asignación** (`contractAssign`): operadores, ROE (Verde, Ámbar, Rojo) y ruta editable en el mapa. Al iniciar, los asignados ven la zona o la ruta en su mapa.
- **Seguimiento** automático cada 3 s; evacuación ordenable; tiempo límite.
- **Liquidación** (informe F-PMC-01): anticipo + pago final (100 % cumplido, 50 % parcial), bonus de avanzadilla en VIP, penalizaciones, exposición del VIP, daños a vehículos, seguro y costes (nómina, munición, material perdido). Beneficio a la tesorería; `contractOpShare` del beneficio se reparte entre los asignados de servicio.
- **Reputación** por cliente (-100…100): sube al cumplir (`contractRepGain`), baja al fallar o rescindir (`contractRepLoss`), y con los incidentes; los rivales del cliente pierden `contractRivalLoss`. Decae hacia 0 (`contractRepDecay`). Niveles: Vetado, Neutral, Fiable, Preferente, Socio estratégico.
- **Proveedores de cliente**: `shopInit` acepta ahora `[objeto, nombre, artículos, oculta, cliente, reputaciónMínima]`; solo vende a la compañía si la reputación llega (comprobado también en el servidor).

## 2. Daños colaterales

- Civiles heridos o muertos, vehículos civiles, edificios destruidos y propiedades del cliente durante un contrato en curso se atribuyen al autor (`ADVSEC_Settings >> Collateral`: penalización al contrato, multa al autor, reputación y regla de sospecha).
- La sospecha se aplica a los 5 minutos; **declarar el incidente** en el terminal la reduce a la mitad.
- Con `collateralCaseAt` incidentes graves, o un civil muerto con ROE verde, el contrato queda **en revisión de Compliance** con un F-AI-01. AA.II. (`caseClose`) resuelve: justificado (se liquida) o negligencia (se liquida como fallido y suspende 24 h a los responsables).

## 3. Armería corporativa, desgaste y auditorías

- Módulo «Armería corporativa» sobre cualquier contenedor (también una taquilla TS_Lockers). Lo que se saca queda **firmado con número de serie** `CORP-XXX-0001` en el registro de armas; lo que se devuelve se descarga. Lo que el editor puso en la caja recibe serie la primera vez; un arma ajena entregada en la armería pasa a ser corporativa.
- Solo con `armoryCheckout` y de servicio (`armoryNeedDuty`); si no, alerta ciber y sospecha `armoryUnauthorized`. Sacar material sin contrato en curso deja una alerta ciber.
- La munición sacada se imputa como coste al contrato en curso del firmante.
- **Desgaste** por disparos (`WeaponWear`, vida en disparos por tipo). Al 60 % avisa a intendencia, a partir del 85 % puede encasquillarse (con ACE), al 100 % queda Destruida. Reparación en la armería por ingenieros (ENG) o logística (LOG) con cargo a la tesorería.
- **Pedidos** a la tesorería (`logisticsOrder`, catálogo `armoryItems`), **bajas** y **auditorías** (`armoryManage`; informe F-PMC-02 con descuadres, desaparecidas y firmadas por gente desconectada; automática cada `armoryAuditEvery` minutos).
- Al salir de servicio, recordatorio del material firmado; al desconectarse con material firmado, pasa a Perdida y se apunta una deuda (`armoryLossFactor` × valor) que se cobra como multa al volver.
- Las vainas de un arma corporativa llevan su serie: el laboratorio identifica al firmante.

## 4. Contrabando y mercado negro

- Sanción automática (`ContrabandRules`) al incautar en un cacheo, en un vehículo o en un control de carretera IA: explosivos (`contrabandExplosives`), material corporativo desviado, mercancía del mercado negro y armas sin licencia (WeaponLicense). Multa, sospecha, búsqueda y, si es corporativo, la serie pasa a Incautada.
- Lo que vende el mercado negro cuenta como ilegal en registros y controles (`blackMarketIllegal`). El perro K9 también lo marca.
- En un mercado negro se puede **vender el arma corporativa** que se lleva en la mano: la serie desaparece, se imputa como pérdida al contrato y deja rastro con probabilidad `blackMarketTrace`.

## 5. Células operativas

- Panel «Células operativas» (`cellView`; asignar roles con `cellManage`): **CP** (protección cercana), **QRF** (reacción rápida) y **SEC** (Inteligencia/Compliance). Estados Disponible, Movilizado y Descanso.
- **QRF**: un pánico, o un aviso 112 dentro de la zona de un contrato, alerta con prioridad a la QRF disponible (con la posición del VIP en vivo si el agente estaba en un contrato VIP). Al aceptar el aviso en la central se moviliza; al llegar a menos de `qrfArriveRadius` m se mide el tiempo, se paga `qrfBonus` si llega antes de `qrfTarget` minutos y la respuesta cuenta en los contratos QRF. Si nadie acepta en 3 minutos, respuesta fallida y sospecha `qrfIgnored` a la QRF disponible.
- **Plus de guardia** en la nómina (`qrfStandbyPay`) si se estuvo Disponible al menos `qrfStandbyMin` del servicio.
- Vehículos con la variable `ADVSEC_qrfVehicle = true` quedan cerrados salvo durante una respuesta.
- **CP**: la escolta asignada a un contrato VIP y la QRF ven la posición del VIP en el mapa cada 6 s.

## 6. Inteligencia y Compliance: terminal ciber

- Módulo «Terminal ciber» (`cyberView` o rol SEC). Pestañas:
  - **Alertas**: teclados forzados, intrusiones, accesos fuera de servicio, armería sin permiso o sin contrato. Se marcan como revisadas; «Restaurar sistemas» (`cyberManage`) vuelve a cerrar teclados comprometidos y levanta las redes CCTV caídas.
  - **Registros**: el registro de eventos filtrado por texto, tipo, nombre o SteamID.
  - **Cronología**: todo lo que hizo una persona (puertas, teclados, armería, contratos, multas...) y en cuántas capturas CCTV aparece.
  - **CCTV**: capturas cada `cctvSnapEvery` s de lo que ve cada cámara (`cctvSnapRange` m). «Acción» reconstruye la escena con figuras locales durante 90 s.
- **Kit de intrusión** (`ADVSEC_HackKit`): «Hackear» en teclados (abre sus puertas y desarma la alarma) y monitores CCTV (corta la red: las cámaras muestran sin señal). Probabilidad `hackChance` (+0,3 para SEC), `hackTime` s. Cada intento deja alerta; si falla, salta la alarma.
- Nuevos eventos en el registro: `keypadUse`, `doorSet`, `contract*`, `collateral`, `contraband`, `armory*`, `qrf*`, `cyber*`, `k9Contraband`.

## Configuración

- `ADVSEC_Settings`: ajustes de contratos, CP, QRF, armería, contrabando y ciber; clases `ContractTypes`, `Clients`, `Collateral`, `WeaponWear`, `ContrabandRules` (las de `description.ext` sustituyen a las del addon).
- Permisos nuevos: `contractView`, `contractAssign`, `contractSign`, `contractGrey`, `armoryCheckout`, `armoryManage`, `logisticsOrder`, `cellView`, `cellManage`, `cyberView`, `cyberManage`.
- Reglas de sospecha nuevas: `contractGrey`, `collateralHurt`, `collateralKill`, `collateralKillRoe`, `armoryMismatch`, `armoryUnauthorized`, `corpDiversion`, `qrfIgnored`, `cyberAnomaly`.
- CBA: secciones 12 (Contratos PMC), 13 (Armería y contrabando), 14 (Células) y 15 (Inteligencia y ciber), más los permisos y reglas nuevos.
- `CfgRemoteExec` (examples/description.ext): `ADVSEC_fnc_ctrServer`, `armServer`, `cellServer`, `cyServer` (servidor); `cellVipMark`, `cyReplay` (clientes); `ctrInit`, `armInit`, `cyInit` (JIP).
- Persistencia (perfil del servidor): `_contracts`, `_clients`, `_armory`, `_armseq`, `_cells`, `_qrf`, `_cyber`. Un contrato a medias al reiniciar la misión queda Rescindido.
- `heatAdd` admite un cuarto parámetro con los puntos.

## Correcciones

- Patrullas con ruta: el seguimiento no guardaba los puntos alcanzados (iteraba una copia de la base de datos).
