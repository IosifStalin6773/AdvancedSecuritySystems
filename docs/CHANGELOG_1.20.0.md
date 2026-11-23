# ADVSEC 1.20.0: perfil PMC (la compañía por delante de la PM)

Para clanes milsim con temática PMC. **La PM y AA.II. conservan todo lo que tienen**; la compañía se pone delante.

## Cuerpo «Compañía» (`PMC`)
- Con `pmcProfile = 1` (por defecto), es operador de la compañía quien tenga **rango en el ORBAT** (rango global de la base de datos), además de todos los que tengan placa PM o credencial AA.II.
- Nivel de compañía por rango (`pmcRankLevels`): Tropa (Rct., Sdo., Sdo 1º.) 1 · Cabos (Cbo., Cbo 1º., Cbo M.) 2 · Sargentos (Sgt., Sgt 1º., Sgt M.) 3 · Brigada y Teniente 4 · Capitán 5. Si la placa PM da más nivel, cuenta la placa.
- `ADVSEC_fnc_repAccess` y `ADVSEC_fnc_rankLevel` aceptan el cuerpo `"PMC"`. Con `pmcProfile = 0`, `"PMC"` equivale a `"PM"`: todo funciona como en 1.19.

## Permisos que pasan a la compañía
- Contratos (ver 1, asignar 3, firmar 4, zona gris 5), armería (sacar 1, intendencia 3, pedidos 4), células (ver 1, gestionar 4), central de despacho (1), control de servicio (3), alerta de base (4), patrullas (3), tesorería (5), base de datos y ORBAT (4), rangos globales (5).
- Controles básicos para los encargos de control de acceso: esposar, cachear, registrar vehículos, consultar a la central y matrículas (1).
- Fichar, pánico, la central, las patrullas y las células admiten a la compañía.
- Siguen siendo de la PM/AA.II.: multas, buscados, arrestos, calabozo, radar, K9, licencias, pruebas, expedientes, sospecha, suspensiones y auditoría bancaria.

## Menú
- Nuevo menú propio con el nombre de la compañía (`companyName`, por defecto «I.V.M.») antes del de Policía Militar: Contratos PMC, Servicio, Controles (consulta, matrícula, registrar el vehículo cercano), ORBAT y Tesorería según el rango.
- Ajustes CBA (1 · General): «Perfil PMC» y «Nombre de la compañía» (requieren reiniciar la misión).

## ORBAT
- El rango global ya coincide con el de I.V.M.: Oficial (Cap., Tte., Brig.), Suboficial (Sgt M., Sgt 1º., Sgt., Cbo M., Cbo 1º., Cbo.) y Tropa (Sdo 1º., Sdo., Rct.).

Incluye 1.19.5 (vida en los encargos). Sin probar en partida.
