# ADVSEC 1.15.1

- Corregido: error «isNull: Type Array» en el bucle de radares (fn_speedCamServer, línea 43). El registro ADVSEC_secObjects guarda [objeto, tipo, ...] y el bucle lo trataba como lista de objetos; ningún radar multaba.
