##########################################################################
#    Copyright 2017, 2017 Matthew Kunkel
##########################################################################
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/bin/bash

OPENWRT_VERSION=17.01.6

wget -N --content-disposition https://downloads.openwrt.org/releases/$OPENWRT_VERSION/targets/mvebu/generic/lede-sdk-$OPENWRT_VERSION-mvebu_gcc-5.4.0_musl-1.1.16_eabi.Linux-x86_64.tar.xz

wget -N --content-disposition https://downloads.openwrt.org/releases/$OPENWRT_VERSION/targets/mvebu/generic/lede-imagebuilder-$OPENWRT_VERSION-mvebu.Linux-x86_64.tar.xz

wget -N --content-disposition  https://ofmodemsandmen.com/download/GoldenOrb2017-12-15-8meg.zip

unzip GoldenOrb2017-12-15-8meg.zip
patch -p0 <rooter.patch

tar -xf lede-sdk-$OPENWRT_VERSION*.tar.xz
tar -xf lede-imagebuilder-$OPENWRT_VERSION*.tar.xz
rm *.tar.xz *.zip
mv ./rooter/* lede-sdk-$OPENWRT_VERSION*/package
#If manually executing for different hardware/LEDE version, run make menuconfig and select options per README.
#.config could be pre-generated for automated builds
cp .config lede-sdk*
#exit
cd lede-sdk-$OPENWRT_VERSION*
scripts/feeds update -a
scripts/feeds install libubox 
make
find . -name "*.ipk" -exec mv {} ../lede-imagebuilder-$OPENWRT_VERSION*/packages \;
cd ../lede-imagebuilder-$OPENWRT_VERSION*
wget -N --content-disposition -P ./packages/ https://downloads.openwrt.org/snapshots/packages/arm_cortex-a9_vfpv3/packages/stubby_0.2.3-3_arm_cortex-a9_vfpv3.ipk
wget -N --content-disposition -P ./packages/ https://downloads.openwrt.org/releases/18.06.1/packages/arm_cortex-a9_vfpv3/packages/getdns_1.4.2-1_arm_cortex-a9_vfpv3.ipk
DEFAULT_PACKAGES=$(wget -qO - https://downloads.openwrt.org/releases/$OPENWRT_VERSION/targets/mvebu/generic/lede-$OPENWRT_VERSION-mvebu.manifest | sed  's/ - .*/ /' | sed  's/dnsmasq//' | tr '\n' ' ')

make image PROFILE="linksys-wrt3200acm" PACKAGES="$DEFAULT_PACKAGES luci-ssl ext-rooter8 rmbim rqmi luci-proto-mbim -dnsmasq dnsmasq-full getdns stubby ca-certificates luci-app-openvpn luci-theme-darkmatter luci-theme-rooter bind-dig"
