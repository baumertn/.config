#!/usr/bin/env python3


import argparse
import subprocess
from typing import Final


STANDARD_PACKAGES: Final = [
    "7zip",
    "alsa",
    "bash",
    "breeze6",
    "dolphin",
    "ffmpeg-6",
    "fish",
    "flatpak",
    "fzf",
    "google-carlito-fonts",
    "google-noto-coloremoji-fonts",
    "google-noto-sans-fonts",
    "google-opensans-fonts",
    "google-poppins-fonts",
    "google-roboto-fonts",
    "hack-fonts",
    "htop",
    "hyprland",
    "hyprland-devel",
    "hyprland-qt-support",
    "hyprland-qtutils",
    "hyprlock",
    "hyprpolkitagent",
    "krita",
    "mako",
    "Mesa",
    "MozillaFirefox",
    "neovim",
    "NetworkManager",
    "nextcloud-desktop",
    "nextcloud-desktop-dolphin",
    "opi",
    "pipewire",
    "polkit",
    "polkit-default-privs",
    "polkit-kde-agent-6",
    "qt5ct",
    "qt6ct",
    "ripgrep",
    "rsync",
    "sqlite3",
    "tofi",
    "vlc",
    "wayland-utils",
    "wezterm",
    "wireplumber",
    "wl-clipboard",
    "xclip",
    "xdg-dbus-proxy",
    "xdg-desktop-portal",
    "xdg-desktop-portal-gtk",
    "xdg-desktop-portal-hyprland",
    "xdg-desktop-portal-kde6",
    "xdg-menu",
    "xdg-user-dirs",
    "xdg-utils",
    "xwayland",
    "zstd",
]
""" Packages used on every system"""

PERSONAL_PACKAGES: Final = [
    "AusweisApp",
    "fooyin",
    "hugo",
    "kdeconnect-kde",
    "steam",
    "syncthing",
    "wine",
]
""" Packages used only on personal machines"""

FLATPAK_STANDARD_PACKAGES: Final = [
    "app.zen_browser.zen",
]
""" Flatpak packages used on every system"""

FLATPAK_PERSONAL_PACKAGES: Final = []
""" Flatpak packages used only on personal machines"""


def run() -> None:
    parser = get_parser()
    args = parser.parse_args()

    if args.type == "personal":
        packages = STANDARD_PACKAGES + PERSONAL_PACKAGES
        flatpak_packages = FLATPAK_STANDARD_PACKAGES + FLATPAK_PERSONAL_PACKAGES
    else:
        packages = STANDARD_PACKAGES
        flatpak_packages = FLATPAK_STANDARD_PACKAGES

    match args.module:
        case "install":
            print("installing packages")
            print("="*20)
            install(packages, flatpak_packages)
        case "check":
            print("Checking the diff between listed and actually installed packages is not implemented yet")
        case "clean":
            print("Removing packages not listed is not implemented yet")

def install(packages: list[str], flatpack_packages: list[str]):
    _ = subprocess.run(["sudo", "zypper", "install", "--no-recommends"] + packages, check=True)
    _ = subprocess.run(["opi", "codecs"], check=True)
    _ = subprocess.run(["flatpak", "install", "--user"] + flatpack_packages, check=True)


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="prog")
    install_type = parser.add_argument(
        "--type",
        choices=["personal", "standard"],
        default="standard",
    )

    modules = parser.add_subparsers(dest="module", required=True)
    _ = modules.add_parser("install", help="Install packages")
    _ = modules.add_parser("check")
    _ = modules.add_parser("clean")

    return parser


if __name__ == "__main__":
    run()
