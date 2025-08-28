import pathlib
import subprocess

from libqtile.log_utils import logger

SCRIPTS_DIR = pathlib.Path("~/.config/qtile/scripts/").expanduser()

def run_script(script: str) -> None:
    """Run a script located in SCRIPTS_DIR"""
    script_path: pathlib.Path = SCRIPTS_DIR / script
    try:
        subprocess.run([str(script_path)])
    except FileNotFoundError:
        logger.warning(f"Script {script_path} not found.")
    except subprocess.CalledProcessError as e:
        logger.warning(f"Error running script {script_path}: {e}")
    except Exception as e:
        logger.warning(f"An unexpected error occurred: {e}")
