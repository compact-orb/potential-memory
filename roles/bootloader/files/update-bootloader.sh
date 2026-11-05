#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

esp_boot_dir="/boot/EFI/BOOT"
mkdir --parents "${esp_boot_dir}"

systemd_boot_efi=""
if [[ -f "/usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed" ]]; then
    systemd_boot_efi="/usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed"
elif [[ -f "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" ]]; then
    systemd_boot_efi="/usr/lib/systemd/boot/efi/systemd-bootx64.efi"
fi

if [[ -f "/usr/share/shim/BOOTX64.EFI" ]]; then
    cp --force "/usr/share/shim/BOOTX64.EFI" "${esp_boot_dir}/BOOTX64.EFI"
    if [[ -f "/usr/share/shim/mmx64.efi" ]]; then
        cp --force "/usr/share/shim/mmx64.efi" "${esp_boot_dir}/mmx64.efi"
    fi
    if [[ -n "${systemd_boot_efi}" ]]; then
        cp --force "${systemd_boot_efi}" "${esp_boot_dir}/grubx64.efi"
    fi
elif [[ -n "${systemd_boot_efi}" ]]; then
    cp --force "${systemd_boot_efi}" "${esp_boot_dir}/BOOTX64.EFI"
fi
