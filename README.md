# LEDE-SDK-ROOter

Hacked together & hard-coded example to demonstrate how to build a ROOter (from ofmodemsandmen.com) that maintains LEDE kernel compatibility.

Example target is a WRT3200ACM.   Building from the LEDE development snapshot, any LEDE >= 17.01.6 should work.

.config file is pre-generated for the above example, run `make menuconfig` to manually generate .config. 
In the menu:
Must __DE-select__ the following in __Global Build Settings__ prior to ./scripts/feeds/ update -a 
* all target specific packages by default
* all kernel module packages by default
* all userspace packages by default
Select relevant rooter packages with [M] for module (ext-rooter8).


Added rooter patches for Sierra Wireless EM7565

Stubby pulled in from 18 and snapshot packages for DNS over TLS
