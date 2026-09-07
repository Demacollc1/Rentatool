#!/usr/bin/env python3
"""Extrae el JSON embebido (const DATA=...) del portafolio HTML a seed/portafolio.json."""
import re, json, sys, pathlib

root = pathlib.Path(__file__).resolve().parent.parent
html = (root / 'seed' / 'DEMACO_portafolio_oficio_2.html').read_text(encoding='utf-8')
m = re.search(r'const DATA=(\{.*?\});', html, flags=re.S)
if not m:
    sys.exit('No se encontró const DATA= en el HTML')
data = json.loads(m.group(1))

modelos = sum(1 for tools in data.values() for t in tools
              for k in ('ind', 'diy') if (t.get(k) or {}).get('code'))
consum = {c['code'] for tools in data.values() for t in tools
          for c in (t.get('cons_codes') or []) if c.get('code')}
filas = sum(len(v) for v in data.values())
out = root / 'seed' / 'portafolio.json'
out.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print(f'oficios={len(data)} filas={filas} modelos_con_codigo={modelos} consumibles={len(consum)}')
print(f'→ {out}')
