# Sunmi-M2-Toolbox (formerly Moonmi)
A script that is a toolbox for the Sunmi M2 (I don't have other Sunmi's, no testing for anything other than the M2)
### ⚠ WARNING: oldtool.sh (or Moonmi) is deprecated and will not be updated unless critical bugs are found. PR any critical issues you find.

### Proof that the Nova Launcher function works
<img width="362" height="676" alt="image" src="https://github.com/user-attachments/assets/1d429d98-8017-47a9-9065-83ed3e6609ff" />

## Features
   - Disables the regular Sunmi Launcher to prevent it returning on reboot (or not if you choose 2 in the M2 Mods menu)
   - Updates GMS and Play Store to return the Play Store (it gets hidden when connected to the Internet, due to it being out-of-date) (you do have to do this one manually, but the script will give you the commands to do it)
   - Power management (like rebooting to EDL or recovery) (will add soon if I can)
   - Installs Nova to replace the stock launcher (it is in the M2 Mods menu, in option 1 or 2)

## Info
  - The Sunmi Launcher package this script disables is: com.woyou.launcher
  - The Nova Launcher version the script installs is: 6.2.19
  - The Google Play Store version the script installs is: 44.5.23-23
  - The Google Play Services (GMS) version the script installs is: 26.09.31

## Requirements
 - A working Linux system with ```bash```
 - An Internet connection (to download the launcher)
 - A Sunmi M2 (with USB debugging enabled, and connected to ADB in normal mode)

## How to run the script
```shell
sudo apt install git -y
git clone https://github.com/MKstarFromSwitch/Sunmi-M2-Toolbox.git
cd Sunmi-M2-Toolbox
./toolbox.sh
```

### Alternative way (old Moonmi script)
```shell
sudo apt install curl -y
curl -fsSL -O https://raw.githubusercontent.com/MKstarFromSwitch/Sunmi-M2-Toolbox/HEAD/oldtool.sh
./oldtool.sh
```
