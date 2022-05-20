#!/system/bin/sh


is_running(){
    if pidof "$1" &>/dev/null; then
        return 0;
     fi
     return 1;
}

is_installed(){
     /system/bin/pm path "$1" &>/dev/null && return 0
     return 1
}


is_not_running(){
     is_running "$1" && return 1
     return 0
}

fetch_denylist(){
    magisk --sqlite 'SELECT package_name from denylist' | sed "s/^package_name=//g"
}

magisk_app(){
    local STUBAPK="$(magisk --sqlite "SELECT value FROM strings WHERE key='requester'" | sed "s/^value=//g")"
    [ ! -z "$STUBAPK" ] && echo "$STUBAPK" || echo "com.topjohnwu.magisk"
}

running_denylist_app(){
    for package in $(fetch_denylist); do
        is_running "$package" && return 0
    done
    return 1
}

kill_denylist_app(){
     for package in $(fetch_denylist); do
        killall "$package"
    done
}


detect_and_hide(){ (
    while true; do
        while ! is_installed "$1"; do
            sleep 3
        done
        is_running "$1" && { /system/bin/pm hide "$(magisk_app)"; }
        [ -f "/dev/.stopme_magiskapp_freezer" ] && break
            while is_running "$1"; do sleep 1; done
        sleep 0.5
    done
) }


{
MAGISKTMP="$(magisk --path)"
[ -z "$MAGISKTMP" ] && MAGISKTMP=/sbin
while true; do
    rm -rf "$MAGISKTMP/.magisk/denied_app"
    mkdir -p "$MAGISKTMP/.magisk/denied_app"
    rm /dev/.stopme_magiskapp_freezer
    sum="$(fetch_denylist | md5sum | awk '{ print $1 }')"
    DENYLIST="$(fetch_denylist)"
    for package in $DENYLIST; do
        if [ ! -f "$MAGISKTMP/.magisk/denied_app/$package" ]; then
            [ "$package" == "com.google.android.gms" ] && continue
            [ "$package" == "com.android.vending" ] && continue
            echo -n >"$MAGISKTMP/.magisk/denied_app/$package"
            detect_and_hide "$package" &
        fi
    done
    while [ "$(fetch_denylist | md5sum | awk '{ print $1 }')" == "$sum" ]; do
        sleep 3;
    done
    touch /dev/.stopme_magiskapp_freezer
    sleep 2
done
} &

{
    while true; do
        running_denylist_app || /system/bin/pm unhide "$(magisk_app)"
        sleep 1;
    done
} &

