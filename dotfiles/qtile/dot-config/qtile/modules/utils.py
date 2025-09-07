import pathlib
import subprocess

from libqtile.lazy import lazy
from libqtile.log_utils import logger

SCRIPTS_DIR = pathlib.Path("~/.config/qtile/scripts/").expanduser()

def run_script(script: str) -> None:
    """Run a script located in SCRIPTS_DIR"""
    script_path: pathlib.Path = SCRIPTS_DIR / script
    try:
        subprocess.run(["uwsp", "app", "--", str(script_path)])
    except FileNotFoundError:
        logger.warning(f"Script {script_path} not found.")
    except subprocess.CalledProcessError as e:
        logger.warning(f"Error running script {script_path}: {e}")
    except Exception as e:
        logger.warning(f"An unexpected error occurred: {e}")

def uwsm_lazy_spawn(command):
    return lazy.spawn(f"uwsm app -- {command}")

def finalize_uwsm() -> None:
    try:
        subprocess.Popen(["uwsm", "finalize"])
    except subprocess.CalledProcessError as e:
        logger.warning(f"Error finalizing uwsm: {e}")
    except Exception as e:
        logger.warning(f"An unexpected error occurred while finalizing uwsm: {e}")

def parse_title(title: str) -> str:
    """Parse a window title to make it more readable in a task list."""
    for prg in ["- Google Chrome", "- Opera", "- Slack", "- Vivaldi", "— Mozilla Firefox"]:
        if title.endswith(prg):
            title = title.removesuffix(prg)
            title = title[:20]
            return title + "…"
    return title
