#!/usr/bin/env bash
# 땅따 러시 제거. 게임 기록(코인, 레벨)도 함께 지워집니다.
set -euo pipefail
APP_ID="ttangtta-rush"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DESKTOP_DIR="$(command -v xdg-user-dir >/dev/null 2>&1 && xdg-user-dir DESKTOP || echo "$HOME/Desktop")"

rm -rf "$DATA_HOME/$APP_ID" "$DATA_HOME/$APP_ID-profile"
rm -f "$HOME/.local/bin/$APP_ID" "$DATA_HOME/applications/$APP_ID.desktop" "$DESKTOP_DIR/$APP_ID.desktop"
rm -f "$DATA_HOME/icons/hicolor/192x192/apps/$APP_ID.png" "$DATA_HOME/icons/hicolor/512x512/apps/$APP_ID.png"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$DATA_HOME/applications" >/dev/null 2>&1 || true
echo "땅따 러시를 제거했어요."
