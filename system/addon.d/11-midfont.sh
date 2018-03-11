#!/sbin/sh
# 
# /system/addon.d/11-midfont.sh

. /tmp/backuptool.functions

save_files() {
cat <<EOF
fonts/*
EOF
}

case "$1" in
  backup)
    save_files | while read FILE DUMMY; do
      backup_file $S/"$FILE"
    done
    # Backup custom system fonts manually since files can differ across devices
    cp -rpf /system/fonts /tmp/fonts
  ;;
  restore)
    save_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/"$FILE" "$R"
    done
  ;;
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
  ;;
  post-restore)
    # Wipe ROM system fonts then restore custom
    rm -rf /system/fonts
    cp -rpf /tmp/fonts /system/
    rm -rf /tmp/fonts
  ;;
esac
