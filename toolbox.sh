#!/usr/bin/env bash
set -euo pipefail
# Some parts were remade or improved by ChatGPT

cleanup() {
  [[ -n "${tmpdir:-}" && -d "$tmpdir" && "$tmpdir" != "/" ]] && rm -rf "$tmpdir"
}

trap cleanup EXIT SIGINT SIGTERM

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# URLs
nova_url="https://archive.org/download/nova-launcher-6.2.19/NovaLauncher_6.2.19.apk"
gms_url="https://www.apkmirror.com/apk/google-inc/google-play-services/google-play-services-26-09-31-release/google-play-services-26-09-31-040300-877989800-2-android-apk-download/"
playstore_url="https://www.apkmirror.com/apk/google-inc/google-play-store/google-play-store-44-5-23-release/google-play-store-44-5-23-23-0-pr-715840561-android-apk-download/"

# Logging functions
error() { printf "${RED}[Error] %s${RESET}\n" "$*" >&2; }
log() { printf "${GREEN}[Log] %s${RESET}\n" "$*"; }
warn() { printf "${YELLOW}[Warning] %s${RESET}\n" "$*"; }
inform() { printf "${BLUE}[Info] %s${RESET}\n" "$*"; }

# Colored input function
ask_input() {
  local prompt="$1"
  local varname="$2"
  printf "${YELLOW}[Input] %s${RESET} " "$prompt"
  read -r "$varname"
}

# Pauses
pause() { printf "${YELLOW}Press ENTER to continue...${RESET}"; read -r; }
pause_exit() { printf "${YELLOW}Press ENTER to exit...${RESET}"; read -r; }

# Install Nova Launcher
install_nova() {
  local disable=true
  [[ "${1:-}" == "--no-disable" ]] && disable=false

  log "Downloading Nova Launcher..."
  tmpdir=$(mktemp -d)
  curl -fsSL -o "$tmpdir/nova.apk" "$nova_url" || wget -O "$tmpdir/nova.apk" "$nova_url"

  log "Installing Nova Launcher APK..."
  adb install "$tmpdir/nova.apk"

  $disable && adb shell pm disable-user --user 0 com.woyou.launcher
  adb shell input keyevent 3

  log "Install successful."
}

# Remove Nova Launcher
remove_nova() {
  log "Removing Nova Launcher..."
  adb uninstall com.teslacoilsw.launcher
  log "Enabling Sunmi Launcher..."
  adb shell pm enable com.woyou.launcher
  log "Install successful."
}

header() {
  clear
  printf "${BLUE}=== Sunmi-M2-Toolbox ===${RESET}\n"
  printf "${BLUE}A toolbox for your Sunmi M2${RESET}\n"
  inform "There is an option to fix Play Store as it is hidden when you are connected to the Internet."
}

main() {
  while true; do
    header
    echo
    printf "${GREEN}1. M2 Mods${RESET}\n"
    printf "${GREEN}2. M2 Mod Management${RESET}\n"
    printf "${GREEN}3. Power Management${RESET}\n"
    inform "More will be added later, I'm just lazy for now."
    ask_input "Choose your option:" main_menu_opt

    case "$main_menu_opt" in
      1)
        header
        echo
        printf "${GREEN}1. Install Nova Launcher while disabling Sunmi Launcher${RESET}\n"
        printf "${GREEN}2. Install Nova Launcher without disabling Sunmi Launcher${RESET}\n"
        printf "${GREEN}3. Update Google services to enable Play Store${RESET}\n"
        inform "Other mods will be added later."
        echo
        ask_input "Choose an option:" sub_menu_opt

        case "$sub_menu_opt" in
          1)
            header
            echo
            inform "You will now install Nova Launcher on your Sunmi M2."
            inform "This will also disable the default Sunmi Launcher to make it persist reboots."
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                install_nova
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          2)
            header
            echo
            inform "You will now install Nova Launcher on your Sunmi M2."
            inform "This will NOT disable the Sunmi Launcher."
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                install_nova --no-disable
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          3)
            header
            echo
            inform "Manual download required for Google services."
            log "GMS: $gms_url"
            log "Play Store: $playstore_url"
            ask_input "Press ENTER after reading instructions" _dummy
            ;;
          *)
            error "Invalid sub-menu option."
            pause
            ;;
        esac
        ;;
      2)
        header
        echo
        printf "${GREEN}1. Remove Nova Launcher and re-enable Sunmi Launcher${RESET}\n"
        inform "More will be added later."
        ask_input "Choose an option:" sub2_opt
        case "$sub2_opt" in
          1)
            header
            echo
            inform "This will remove Nova Launcher from your Sunmi M2."
            inform "It will also enable the stock launcher again."
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                remove_nova
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          *)
            error "Invalid sub-menu option."
            pause
            ;;
        esac
        ;;
      3)
        header
        echo
        printf "${GREEN}1. Reboot to recovery${RESET}\n"
        printf "${GREEN}2. Reboot to EDL${RESET}\n"
        printf "${GREEN}3. Reboot normally${RESET}\n"
        ask_input "Choose an option:" sub3_opt
        case "$sub3_opt" in
          1)
            header
            echo
            inform "This will reboot your device into recovery mode (Phoenix Recovery normally)."
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                adb reboot recovery
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          2)
            header
            echo
            inform "This will reboot your device into EDL mode."
            warn "This tool has no support for EDL mode yet. Please use EDL without using this tool."
            warn "Do NOT reboot to EDL if you don't know what you are doing!"
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                adb reboot edl
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          3)
            header
            echo
            inform "This will reboot normally."
            ask_input "Are you sure? [y/N]" yes_no
            case "$yes_no" in
              [Yy]*)
                adb reboot
                pause
                ;;
              *)
                log "Nothing done."
                pause
                ;;
            esac
            ;;
          *)
            error "Invalid sub-menu option."
            pause
            ;;
        esac
        ;;
      *)
        error "Invalid main menu option."
        pause
        ;;
    esac
  done
}

# Dependency check
header
echo
log "Performing dependency check..."
for cmd in curl wget adb lsusb; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error "Required command $cmd is not installed."
    inform "Please install the package that provides it."
    exit 1
  fi
done

log "Waiting for Sunmi M2..."
until device_found=$(lsusb | grep -E '05c6:(9008|9091|9039)' | sed -E 's/(9008|9091|9039)//' | xargs); do
  sleep 1
done

if lsusb | grep -q '05c6:9008'; then
  error "Your Sunmi M2 is in EDL mode."
  inform "Hold the Power button for 15-20 seconds to exit EDL mode."
  exit 1
fi

log "Sunmi M2 detected as: $device_found"
main
