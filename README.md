# Magisk App Freezer

Magisk app provides an option to hide Magisk app by making full obfuscation of the Magisk app (Android 9+) with random package name. However some apps like Techcombank, PUBG New State can still detect stub Magisk app.  


Why not write a simple module install a simple boot script that automatically freeze magisk app if any app in DenyList is opened (except Google Play Store). Magisk app will get restored after you close all apps in DenyList.

From Android 11+, App cannot detect `/data/data/com.topjohnwu.magisk` directory so no need to use random package for Magisk before freezing Magisk

Do not add apps like Chrome and keyboard app into DenyList.
