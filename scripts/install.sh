#!/bin/bash -e

logger_info() {
    local _msg="$1"
    echo "$_msg"
}

logger_info "installation environnement ... "

# Get Rust
# https://docs.rust-embedded.org/book/intro/install/linux.html
cargo install cargo-binutils

rustup component add llvm-tools-preview

cargo install cargo-generate

sudo apt install -yqq gdb-multiarch openocd qemu-system-arm

#touch /etc/udev/rules.d/70-st-link.rules
#cat <<EOF > /etc/apt/apt.conf.d/02nocache
## STM32F3DISCOVERY rev A/B - ST-LINK/V2
#ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"
#
## STM32F3DISCOVERY rev C+ - ST-LINK/V2-1
#ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", TAG+="uaccess"
#EOF

cat > /etc/udev/rules.d/70-st-link.rules << EOL
# STM32F3DISCOVERY rev A/B - ST-LINK/V2
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"

# STM32F3DISCOVERY rev C+ - ST-LINK/V2-1
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", TAG+="uaccess"
EOL

#-------------------------------------------------------------------
# Performs cleanup, ensure unnecessary packages and package lists
# are safely removed, without triggering Docker AUFS permission bug
#-------------------------------------------------------------------

apt-get autoclean -y && \
apt-get autoremove -y && \
rm -rf /var/lib/{cache,log}/ && \
rm -rf /var/lib/apt/lists/*.lz4 && \
rm -rf /tmp/* /var/tmp/* && \
rm -rf /usr/share/doc/ && \
rm -rf /usr/share/man/