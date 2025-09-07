from libqtile import hook
from libqtile.utils import send_notification

from .screens import call_generate_screens
from .utils import finalize_uwsm #run_script

@hook.subscribe.screen_change
def screen_change(_):
    send_notification("Screen change detected", "Reconfiguring screens...")
    call_generate_screens()

@hook.subscribe.startup_once
def autostart():
    """Run once on startup"""
    send_notification("Qtile starting", "Running autostart script...")
    finalize_uwsm()
