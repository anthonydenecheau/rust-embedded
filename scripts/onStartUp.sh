#!/bin/bash -e

RUST_VERSION=`rustc -V`

logger_info() {
    local _msg="$1"
    echo "$_msg"
}

/lib/systemd/systemd-udevd --daemon
sudo udevadm control --reload-rules

logger_info "Rust version " ${RUST_VERSION}

# https://github.com/libusb/libusb/issues/1012
lsusb

# Take note of the bus and device numbers. Use those numbers to create a path like /dev/bus/usb/<bus>/<device>. Then use this path like so:
# ls -l /dev/bus/usb/001/018
# getfacl /dev/bus/usb/001/018 | grep user
# Je dois avoir
# user::rw-
# user:you:rw-