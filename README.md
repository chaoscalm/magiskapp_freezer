# Magisk App Freezer

Magisk app provides an option to hide Magisk app by making Magisk app or even full obfuscation of the Magisk app (Android 9+) with random package name. However some apps like Techcombank, PUBG New State can still detect random package Magisk app (even stub Magisk app).  


Why not write a simple module install a simple boot script that automatically freeze magisk app if any app in DenyList is opened (except Google Play Store). Magisk app will get restored after you close all apps in DenyList.

From Android 11+, App cannot detect `/data/data/com.topjohnwu.magisk` directory so no need to use random package for Magisk before freezing Magisk

Do not add apps like Chrome and keyboard app into DenyList.

**Disclaimer**: This module only makes sure app cannot detect Magisk app. It doesn't hide root. Hiding Magisk app will never and never be meant hiding root. Why more and more apps detect some apps to detect root because root is more and more difficult to detect.  App detection for root detection is never right.  For example, if your device is not rooted but just install the Magisk application, it will be considered as root by the application. In fact, apps can detect more traces that can be related to rooting than just detect rooting.
