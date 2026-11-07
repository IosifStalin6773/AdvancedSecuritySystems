#!/usr/bin/env python3
"""Regenera addons/main/CfgLang.hpp desde addons/main/stringtable.xml.

ADVSEC_fnc_L lee los textos de la clase ADVSEC_Lang (no de localize) para que el
servidor pueda generar sus mensajes en el idioma elegido en el ajuste "language".
Edita stringtable.xml (English/Spanish) y ejecuta:  python3 tools/stringtable_to_cfglang.py
Las claves STR_ADVSEC_v_* son valores guardados (estados, gravedad...) que ADVSEC_fnc_Lv traduce al mostrarlos.
"""
import os, xml.etree.ElementTree as ET
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'addons', 'main')
tree = ET.parse(os.path.join(root, 'stringtable.xml'))
def cq(x): return '"' + (x or '').replace('"', '""').replace('\n', '\\n') + '"'
L = ['// Generado por tools/stringtable_to_cfglang.py: textos de ADVSEC en inglés y español (ADVSEC_fnc_L). No editar a mano: edita stringtable.xml y regenera.', 'class ADVSEC_Lang {']
vals = []
for k in tree.iter('Key'):
    kid = k.get('ID'); en = k.findtext('English') or k.findtext('Original'); es = k.findtext('Spanish') or en
    L.append(f'    class {kid} {{ en = {cq(en)}; es = {cq(es)}; }};')
    if kid.startswith('STR_ADVSEC_v_'): vals.append((es, kid))
L.append('};')
L.append('class ADVSEC_LangValues {')
L.append('    values[] = {' + ', '.join('{' + cq(es) + ', ' + cq(k) + '}' for es, k in vals) + '};')
L.append('};')
open(os.path.join(root, 'CfgLang.hpp'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print(len(L) - 5, 'textos ->', os.path.join(root, 'CfgLang.hpp'))
