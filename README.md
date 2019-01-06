Yocto meta layer to compile WallE personal assistant
====================================================

Installation:
```
$ mkdir walle_yocto && cd walle_yocto
$ repo init -u https://github.com/nvl1109/yocto-manifest -b master
$ repo sync
$ . setup build_walle
$ bitbake linh-qt5-image
```