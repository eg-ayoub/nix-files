from enum import Enum

from libqtile import bar, widget

from .widget_defaults import *

class WidgetPlacement(Enum):
    ONLY_MAIN = 1
    ONLY_SECONDARY = 2
    BOTH = 3

# enum defines two styles of bars: main and secondary
class BarStyle(Enum):
    MAIN = 1
    SECONDARY = 2

    def supports(self, placement: WidgetPlacement) -> bool:
        if self == BarStyle.MAIN:
            return placement in (WidgetPlacement.ONLY_MAIN, WidgetPlacement.BOTH)
        elif self == BarStyle.SECONDARY:
            return placement in (WidgetPlacement.ONLY_SECONDARY, WidgetPlacement.BOTH)
        return False

status_notifier_widget = widget.StatusNotifier(**status_notifier_options)
clock_widget = widget.Clock(**clock_options)
keyboard_layout_widget = widget.KeyboardLayout(**keyboard_layout_options)

# crafts a default bar
def make_bar(style: BarStyle) -> bar.Bar:
    widgets: list[tuple[WidgetPlacement, widget._Widget]] = [
            (WidgetPlacement.BOTH, widget.GroupBox(**group_box_options)),
            (WidgetPlacement.BOTH, widget.TaskList(**task_list_options)),
            (WidgetPlacement.ONLY_MAIN, status_notifier_widget),
            (WidgetPlacement.ONLY_MAIN, clock_widget),
            (WidgetPlacement.ONLY_MAIN, keyboard_layout_widget),
            (WidgetPlacement.BOTH, widget.CurrentLayout(**current_layout_options)),
         ]

    return bar.Bar(
            [
                widget for placement, widget in widgets if style.supports(placement)
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        )

