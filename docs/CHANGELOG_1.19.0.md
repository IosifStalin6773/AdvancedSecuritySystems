# 1.19.0

## Base de datos de jugadores (superadministrador)
- Dos pestañas nuevas, con todo editable:
  - **PMC**: célula (asignar CP/QRF/SEC, estado, sacar de la célula), estadísticas QRF (reiniciar), deuda con la armería (fijar o perdonar), armas corporativas firmadas por el jugador (estado y desgaste, devolver a la armería), contratos en los que firma o está asignado (título y estado, quitarle del contrato), equipo completo guardado en la taquilla (borrar) y alertas ciber del jugador (revisada / borrar).
  - **Servicio**: tiempo de servicio (fijar minutos o poner a cero), suspensión de AA.II. (levantar) y patrullas en las que participa (quitarle).
- Las pestañas pasan a dos filas para que no se corten los nombres.
- Cambiar el estado de un contrato desde aquí no lo liquida (no hay pagos ni reputación); queda anotado como cambio de la administración.

## Enemigos en los contratos
- Al iniciar un contrato se buscan los enemigos ya colocados en la zona (o a menos de 400 m de la ruta) y se generan los grupos que falten.
- Una unidad con `this setVariable ["ADVSEC_ctrHostile", true]` (o el id/tipo del contrato) cuenta como enemiga del contrato esté donde esté.
- Cómo aparecen: escolta y VIP, emboscadas a lo largo de la ruta; guardia y QRF, oleadas que llegan a la zona durante el contrato; recuperación, patrullas alrededor de la carga; limpieza de zona, patrullas dentro de la zona.
- Nuevo tipo **Limpieza de zona** (`clear`): cumplido cuando no queda ningún enemigo del contrato con vida; fuera de tiempo, parcial si se abatió al menos la mitad.
- La ficha del contrato muestra enemigos localizados y abatidos. Los generados se retiran cuando no queda ningún jugador cerca (máx. 10 min después de cerrar).
- Ajustes: `contractHostiles` (0 ninguno, 1 generar, 2 solo los colocados, 3 ambos; por defecto 3), `contractHostileSide` ("east"), `contractHostileScale` (1), `contractHostileClasses[]`, y `hostiles` en cada `ContractTypes`. El módulo Zeus «Contrato PMC a medida» permite elegir modo y número de grupos por contrato.

## Armas del Arsenal con nº de serie
- Al cerrar el Arsenal de ACE o el vanilla, cada arma que lleva el jugador recibe su nº de serie (el mismo de los casquillos) y queda registrada a su nombre (origen «ARS»). Aparecen en la ficha del jugador. No toca las armas corporativas firmadas en la armería PMC.
- Ajuste `arsenalSerial` (1; 0 lo desactiva).

## Taquillas: equipo completo
- Nueva acción ACE en la taquilla propia: **Equipo completo › Guardar todo mi equipo / Equiparme lo guardado (intercambiar) / ¿Qué tengo guardado?**
- Guardar se lleva armas, chaleco, mochila, casco, gafas, prismáticos, objetos enlazados y el contenido del uniforme; el jugador se queda con el uniforme puesto y su documentación y credenciales ADVSEC.
- Equiparse pone lo guardado (con la documentación que lleve encima); si llevaba equipo, ese pasa a la taquilla.
- Se guarda por SteamID en el perfil del servidor (clave `_lkit`), así que sobrevive a cambios de misión.

## Controles de carretera
- El aviso «Alto / Puede continuar» y la ventana «Documentación, por favor» crecen con el texto: ya no se cortan. El título se reduce si no cabe.

## Interfaces
- Todas las ventanas, el PDA, el HUD y los carteles se miden respecto a la zona segura de la pantalla: ocupan lo mismo con cualquier tamaño de interfaz del juego (con «Pequeño» o «Muy pequeño» ya no salen diminutas).
- Las ventanas centradas son hasta un 25 % más anchas (según la pantalla) para que quepan los textos; las imágenes y el PDA conservan su proporción.
- Macros nuevas en `ui\defines.hpp` (UIX, UIY, UIW, UIH, UIF…) y `ADVSEC_fnc_uiRect` para lo que se coloca por script.

## Lista blanca (examples/description.ext)
- `ADVSEC_fnc_lockerKit` (servidor), `ADVSEC_fnc_lockerKitMenu` (clientes), `ADVSEC_fnc_wpnArsenal` (servidor).

Sin probar en partida.
