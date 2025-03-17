import os
import platform
import subprocess
import sys
from pathlib import Path

# Colors for pretty logging
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color

# Function to log messages
def log(level : str, message : str) -> None:
    if level == "info":
        print(f"{Colors.BLUE}[INFO]{Colors.NC} {message}")
    elif level == "success":
        print(f"{Colors.GREEN}[SUCCESS]{Colors.NC} {message}")
    elif level == "warning":
        print(f"{Colors.YELLOW}[WARNING]{Colors.NC} {message}")
    elif level == "error":
        print(f"{Colors.RED}[ERROR]{Colors.NC} {message}")
    else:
        print(f"[LOG] {message}")

# ASCII Art of AtomashcoGL
def print_ascii_art() -> None:
    log("info", "Welcome to the setup script!")
    print(f"{Colors.BLUE}")
    print(r"""
    _    _    _    _    _    _    _    _    _    _    _ 
   / \  / \  / \  / \  / \  / \  / \  / \  / \  / \  / \  
  ( A )( t )( o )( m )( a )( s )( h )( c )( o )( G )( L )
   \_/  \_/  \_/  \_/  \_/  \_/  \_/  \_/  \_/  \_/  \_/  
    """)
    print(f"{Colors.NC}")

# Check if bazelisk is installed
def is_bazelisk_installed() -> bool:
    try:
        result = subprocess.run(["bazelisk", "version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return result.returncode == 0
    except FileNotFoundError:
        return False

# Install bazelisk
def install_bazelisk() -> None:
    system = platform.system().lower()
    machine = platform.machine().lower()

    if system == "linux":
        # Determine the correct binary for Linux
        if machine == "x86_64":
            url = "https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64"
        
        # Download and install bazelisk using wget, chmod, and mv
        log("warning", "bazelisk not found. Installing...")
        try:
            temp_dir = "/tmp/bazelisk_install"
            os.makedirs(temp_dir, exist_ok=True)
            temp_path = os.path.join(temp_dir, "bazelisk")

            subprocess.run(["wget", "-q", "-O", temp_path, url], check=True)

            subprocess.run(["chmod", "+x", temp_path], check=True)

            subprocess.run(["sudo", "mv", temp_path, "/usr/local/bin/bazelisk"], check=True)

            log("success", "bazelisk installed successfully at /usr/local/bin/bazelisk!")
        except subprocess.CalledProcessError as e:
            log("error", f"Failed to install bazelisk: {e}")
            sys.exit(1)
        except FileNotFoundError:
            log("error", "wget is not installed. Please install wget and try again.")
            sys.exit(1)

    elif system == "darwin":
        # Install bazelisk using Homebrew on macOS
        log("warning", "bazelisk not found. Installing using Homebrew...")
        try:
            subprocess.run(["brew", "install", "bazelisk"], check=True)
            log("success", "bazelisk installed successfully using Homebrew!")
        except subprocess.CalledProcessError as e:
            log("error", f"Failed to install bazelisk using Homebrew: {e}")
            sys.exit(1)

# Check if the OS is supported (macOS or Linux)
def is_supported_os() -> bool:
    system = platform.system().lower()
    return system in ["darwin", "linux"]

# Main function
def main() -> None:
    print_ascii_art()

    # Check if the OS is supported
    if not is_supported_os():
        log("error", "This script only supports macOS and Linux.")
        sys.exit(1)

    # Check if bazelisk is installed
    if is_bazelisk_installed():
        log("success", "bazelisk is already installed!")
    else:
        install_bazelisk()
    out = subprocess.run(["bazelisk", "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
    log("info", f"{out.stdout}")
    log("info", "Setup complete! Happy coding with AtomashcoGL! 🚀")

if __name__ == "__main__":
    main()