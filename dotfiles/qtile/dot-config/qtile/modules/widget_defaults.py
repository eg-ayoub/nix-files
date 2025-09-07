from .utils import parse_title

# TODO:
# - colors
# - fonts
# - sizes and spacing

# define some default widget settings
widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)

# add more defaults for extension widgets
extension_defaults = widget_defaults.copy()

group_box_options = {
        "disabe_drag": True,
        "rounded": False,
        "highlight_method": "block",
        "urgent_alert_method": "border",
        "mouse_callbacks": {
            # effectively disable left click
            "Button1": lambda: None
        },
}

task_list_options = {
        "rounded": False,
        "highlight_method": "block",
        "theme_mode": "preferred",
        "parse_text": parse_title,
}

status_notifier_options = {}

clock_options = {
        "format": "%I:%M",
}

current_layout_options = {
        "mode": "icon",
}

keyboard_layout_options = {
        "configured_keyboards": ["us", "fr"]
}
