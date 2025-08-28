# this config is wayland only, so screens are generated dynamically
from libqtile.config import Screen
from libqtile.backend.wayland.output import Output
from libqtile import qtile
from libqtile.log_utils import logger

from .bars import make_bar

screens = []

screen_matcher = {
        "Sharp Corporation 0x14BA": Screen(bottom=make_bar()),
        "Dell Inc. DELL S2421HS FFG9123": Screen(bottom=make_bar()),
        "Lenovo Group Limited R27qe UP333352": Screen(bottom=make_bar()),
}

# this is called to generate screens from a list of outputs
def generate_screens(outputs: list[Output]) -> list[Screen]:

    ret = []
    for output in outputs:
        matched_screen = None
        for match, screen in screen_matcher.items():
            if output.wlr_output.description and match in output.wlr_output.description:
                logger.info(f"Matched output {output.wlr_output.description} to screen {screen}")
                matched_screen = screen
        if matched_screen is None:
            logger.warning(f"No match for output {output.wlr_output.description}, using default screen")
            ret.append(Screen(bottom=make_bar()))
        else:
            logger.info(f"Using matched screen for output {output.wlr_output.description}")
            ret.append(matched_screen)

    return ret


# change screens dynamically
def call_generate_screens():
    global screens
    screens = generate_screens(qtile.core.get_enabled_outputs())
    qtile.config.screens = screens

screens = generate_screens(qtile.core.get_enabled_outputs())
