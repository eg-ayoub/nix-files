# Patch the rig_builder plugin's routes.py so "bundled" VST candidates are
# resolved against every VST search root (the writable per-user root
# CONFIG_DIR/nam_rig_builder/vst, where the platform VST pack is downloaded),
# not only against the read-only plugin dir which has no vst/ tree in
# packaged (AppImage) builds.
import sys

path = sys.argv[1]
src = open(path).read()

old = '''        bundled = cand.get("bundled")
        if bundled:
            bpath = _plugin_dir / bundled
'''
new = '''        bundled = cand.get("bundled")
        if bundled:
            _brel = bundled[4:] if bundled.startswith("vst/") else bundled
            bpath = next(
                (r / _brel for r in _vst_search_roots() if (r / _brel).exists()),
                None,
            ) or _plugin_dir / bundled
'''

assert src.count(old) == 1, "rig_builder routes.py anchor not found (upstream drift?)"
open(path, "w").write(src.replace(old, new))
