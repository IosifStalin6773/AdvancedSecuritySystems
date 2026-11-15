# ADVSEC 1.22.3

- Corrige los textos nuevos de 1.22.1 y 1.22.2, que salían como claves (`STR_ADVSEC_grp_traffic`, `STR_ADVSEC_lkit_slots_saved`…): faltaba regenerar `addons/main/CfgLang.hpp` desde `stringtable.xml` con `tools/stringtable_to_cfglang.py`. Afecta a los nombres de los submenús de la PM y de la compañía, a los avisos del equipo completo de la taquilla y a las dos acciones renombradas del menú «Equipo completo».

Sin probar en partida.
