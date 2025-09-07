import re

from libqtile import layout
from libqtile.layout.bsp import _BspNode
from libqtile.config import Match

def my_shortest(self, length: int):
    if len(self.children) == 0:
        return self, length
    child0, length0 = self.children[0]._shortest(length + 1)
    child1, length1 = self.children[1]._shortest(length + 1)
    # Example: Prefer right child on tie
    if length1 <= length0:
        return child1, length1
    return child0, length0

_BspNode._shortest = my_shortest

# Define the layouts to be used in the window manager
layouts = [
    # layout.Columns(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    layout.Max(),
]

# Make sure these windows float by default
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="nm-applet"),  # nm-applet
        Match(wm_class="nm-connection-editor"),  # nm-applet
        Match(title="firewall-applet"),  # firewall applet
        Match(title=re.compile(r"Meet - .*")), # google meet popup
    ]
)
