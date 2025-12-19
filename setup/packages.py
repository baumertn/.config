#!/usr/bin/env python3


import argparse
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

    print(args)
    print(args.module)
    if args.type == "personal":
        packages = STANDARD_PACKAGES.extend(PERSONAL_PACKAGES)
        flatpak_packages = FLATPAK_STANDARD_PACKAGES.extend(FLATPAK_PERSONAL_PACKAGES)
    else:
        packages = STANDARD_PACKAGES
        flatpak_packages = FLATPAK_STANDARD_PACKAGES

    match args.module:
        case "install":
            print("installing packages")
            print(packages)
            print(flatpak_packages)
        case "check":
            print("checking for packages not in the list or missing packages")
        case "clean":
            print("Removing packages not in the list")


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="prog")
    install_type = parser.add_argument(
        "--type",
        choices=["personal", "standard"],
        default="standard",
    )

    modules = parser.add_subparsers(dest="module", required=True)
    install_parser = modules.add_parser("install", help="Install packages")

    check_parser = modules.add_parser("check")

    clean_parser = modules.add_parser("clean")

    # # MODULE: user
    # user = modules.add_parser("user")
    #
    # user_actions = user.add_subparsers(dest="action", required=True)
    #
    # user_add = user_actions.add_parser("add")
    # user_add.add_argument("--name", required=True)
    #
    # user_delete = user_actions.add_parser("delete")
    # user_delete.add_argument("--id", required=True)

    return parser


if __name__ == "__main__":
    run()
