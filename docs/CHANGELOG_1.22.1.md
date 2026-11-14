# ADVSEC 1.22.1

## Taquillas: el equipo completo va a su hueco
- **Equipo completo › Guardar todo mi equipo en su hueco** coloca cada pieza en su hueco de la taquilla, igual que si la guardaras una a una:
  - Casco: hueco del casco.
  - Visión nocturna: NVG 1, sobre el casco. Si está ocupado, NVG 2.
  - Fusil: el primer hueco libre de los cinco de armas principales.
  - Pistola: pistola 1 o 2.
  - Lanzador, chaleco, gafas y prismáticos: su hueco.
  - Mochila: el primer hueco libre de mochila. El tercero es solo para la Eagle.
- Se hace en un solo traspaso. Si el hueco de una pieza está ocupado, esa pieza se queda contigo y el aviso dice cuántas.
- Te quedas con el uniforme y la documentación ADVSEC. La que llevaras en el chaleco o la mochila pasa al uniforme.
- **Equiparme lo de los huecos** saca cada pieza cuyo sitio en el cuerpo está libre. Lo que ya llevas puesto no se cambia.
- **¿Qué tengo guardado?** lista lo que hay en los huecos.
- Equipos completos guardados con versiones anteriores (aparte, en el perfil del servidor): se recuperan con **Equiparme lo de los huecos**. Si llevas equipo puesto, guárdalo antes, que irá a los huecos.

## Compilación
- Se recuperan los `$PBOPREFIX$` de `buildings` (`advsec_buildings`) y `lockers` (`TS_Lockers`). Los modelos binarizados, el config y los scripts usan esas rutas; con `x\advsec\addons\...` los edificios salían sin texturas y las taquillas no cargaban modelos ni funciones. HEMTT vuelve a avisar INVALID-PBOPREFIX para esos dos addons: es intencionado.

Sin probar en partida.
