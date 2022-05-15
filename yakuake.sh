#!/bin/sh

# Custom wrapper script for calling yakuake.

LOCKFILE=/tmp/yakuake.sh.lock
[ -f "$LOCKFILE" ] && exit 1
touch "$LOCKFILE"
trap 'rm $LOCKFILE' 0

QDBUS=/usr/lib64/qt5/bin/qdbus

if [ -n "$(pgrep '^yakuake$')" ]; then
  "$QDBUS" org.kde.yakuake /yakuake/window org.kde.yakuake.toggleWindowState
else
  yakuake --im "$(which fcitx)" --inputstyle onthespot >/dev/null 2>&1 & 
  TERMINAL_ID_0=$("$QDBUS" org.kde.yakuake /yakuake/sessions org.kde.yakuake.terminalIdsForSessionId 0)
  "$QDBUS" org.kde.yakuake /yakuake/tabs setTabTitle 0 "Main"
  "$QDBUS" org.kde.yakuake /yakuake/sessions org.kde.yakuake.splitTerminalLeftRight "$TERMINAL_ID_0"
  "$QDBUS" org.kde.yakuake /yakuake/sessions org.kde.yakuake.nextTerminal "$TERMINAL_ID_0"
  "$QDBUS" org.kde.yakuake /yakuake/sessions runCommandInTerminal 1 " cd ~ ; clear"
  "$QDBUS" org.kde.yakuake /yakuake/sessions runCommandInTerminal 0 " cd ~ ; clear"
  "$QDBUS" org.kde.yakuake /yakuake/window org.kde.yakuake.toggleWindowState
fi
