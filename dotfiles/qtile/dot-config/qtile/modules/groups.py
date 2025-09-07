from libqtile.config import Group, Key, ScratchPad, DropDown
from libqtile.lazy import lazy

from . import constants

group_names = [ "₁", "₂", "3", "4", "5", "6", "7", "8", "₉" ]
group_shortcuts_fr = [ 'ampersand', 'eacute', 'quotedbl', 'apostrophe', 'parenleft', 'minus', 'egrave', 'underscore', 'ccedilla' ]
group_shortcuts_en = [ '1', '2', '3', '4', '5', '6', '7', '8', '9' ]

groups: list[Group] = [
        ScratchPad(
            "dropdown",
            [
                DropDown(
                    "terminal",
                    constants.TERMINAL,
                    x=0.1,
                    y=0,
                    width=0.8,
                    height=0.4,
                    opacity=1,
                ),
                DropDown(
                    "filemanager",
                    constants.FILE_MANAGER,
                    x=0.25,
                    y=0.25,
                    width=0.5,
                    height=0.5,
                    opacity=1,
                ),
            ],
        ),
        *[Group(name) for name in group_names]
    ]
# this can be added to keys list in keys.py
def make_group_keys(mod) -> list[Key]:
    group_keys = []
    # add keybindings for scratchpad
    group_keys.extend([
        Key([mod], "g", lazy.group["dropdown"].dropdown_toggle("terminal")),
        Key([mod], "e", lazy.group["dropdown"].dropdown_toggle("files")),
    ])
    for i, group in enumerate(groups[1:]):
        group_keys.extend([
            # fr keyboard bindings
            Key([mod], group_shortcuts_fr[i], lazy.group[group.name].toscreen(), desc=f"Switch to group {group.name}"),
            Key([mod, "shift"], group_shortcuts_fr[i], lazy.window.togroup(group.name, switch_group=False), desc=f"Switch to & move focused window to group {group.name}"),
            # us keyboard bindings
            Key([mod], group_shortcuts_en[i], lazy.group[group.name].toscreen(), desc=f"Switch to group {group.name}"),
            Key([mod, "shift"], group_shortcuts_en[i], lazy.window.togroup(group.name, switch_group=False), desc=f"Switch to & move focused window to group {group.name}"),
        ])
    return group_keys
