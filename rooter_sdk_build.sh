#!/bin/bash

wget -N --content-disposition https://downloads.lede-project.org/snapshots/targets/mvebu/generic/lede-sdk-mvebu_gcc-5.5.0_musl_eabi.Linux-x86_64.tar.xz

wget -N --content-disposition https://downloads.lede-project.org/snapshots/targets/mvebu/generic/lede-imagebuilder-mvebu.Linux-x86_64.tar.xz

wget -N --content-disposition https://ofmodemsandmen.com/download/rooter.zip

unzip rooter.zip
tar -xf lede-sdk*.tar.xz
tar -xf lede-imagebuilder*.tar.xz
rm *.tar.xz *.zip
mv ./rooter/* lede-sdk*/package
#If manually executing for different hardware/LEDE version, run make menuconfig and select options per README.
#.config could be pre-generated for automated builds
cp .config lede-sdk*
cd lede-sdk*
scripts/feeds update -a
scripts/feeds install libubox wireless-regdb
make
find . -name "*.ipk" -exec mv {} ../lede-imagebuilder*/packages \;
cd ../lede-imagebuilder*
DEFAULT_PACKAGES=$(wget -qO - https://downloads.lede-project.org/snapshots/targets/mvebu/generic/lede-mvebu.manifest | sed  's/ - .*/ /' | sed  's/dnsmasq//' | tr '\n' ' ')

make image PROFILE="linksys-wrt3200acm" PACKAGES="$DEFAULT_PACKAGES luci-ssl ext-rooter8 rmbim rqmi luci-proto-mbim -dnsmasq dnsmasq-full dnscrypt-proxy luci-app-openvpn luci-theme-darkmatter luci-theme-rooter"
