#!/usr/bin/env bash
# 땅따 러시 - Linux Mint(및 Ubuntu 계열) 설치 스크립트
# 사용법: 이 폴더에서  bash install-linux.sh
# 관리자 권한(sudo) 없이 내 계정에만 설치합니다.
set -euo pipefail

APP_ID="ttangtta-rush"
APP_NAME="땅따 러시"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/www"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
INSTALL_DIR="$DATA_HOME/$APP_ID"
BIN_DIR="$HOME/.local/bin"
DESKTOP_FILE="$DATA_HOME/applications/$APP_ID.desktop"
ICON_DIR="$DATA_HOME/icons/hicolor"

if [ ! -f "$SRC_DIR/index.html" ]; then
  echo "www/index.html 을 찾지 못했어요. 압축을 푼 폴더 안에서 실행해 주세요." >&2
  exit 1
fi

echo "1/4 게임 파일 복사: $INSTALL_DIR"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp -r "$SRC_DIR/." "$INSTALL_DIR/"

echo "2/4 아이콘 등록"
mkdir -p "$ICON_DIR/192x192/apps" "$ICON_DIR/512x512/apps"
cp "$SRC_DIR/icons/icon-192.png" "$ICON_DIR/192x192/apps/$APP_ID.png"
cp "$SRC_DIR/icons/icon-512.png" "$ICON_DIR/512x512/apps/$APP_ID.png"

echo "3/4 실행 파일 만들기: $BIN_DIR/$APP_ID"
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/$APP_ID" <<LAUNCHER
#!/usr/bin/env bash
# 땅따 러시 실행기: 크롬 계열 브라우저가 있으면 주소창 없는 앱 창으로, 없으면 기본 브라우저로 엽니다.
GAME="file://$INSTALL_DIR/index.html"
PROFILE="$DATA_HOME/$APP_ID-profile"
for b in chromium chromium-browser google-chrome google-chrome-stable brave-browser microsoft-edge; do
  if command -v "\$b" >/dev/null 2>&1; then
    exec "\$b" --app="\$GAME" --user-data-dir="\$PROFILE" --window-size=480,860 --class=$APP_ID "\$@"
  fi
done
if command -v firefox >/dev/null 2>&1; then exec firefox --new-window "\$GAME"; fi
exec xdg-open "\$GAME"
LAUNCHER
chmod +x "$BIN_DIR/$APP_ID"

echo "4/4 메뉴에 등록"
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<DESKTOP
[Desktop Entry]
Type=Application
Version=1.0
Name=$APP_NAME
Name[en]=Ttangtta Rush
Comment=선을 긋고 돌아오면 감싼 곳이 전부 내 땅! 땅따먹기 게임
Exec=$BIN_DIR/$APP_ID
Icon=$APP_ID
Terminal=false
Categories=Game;ArcadeGame;
Keywords=game;territory;땅따먹기;
StartupWMClass=$APP_ID
DESKTOP
chmod +x "$DESKTOP_FILE"

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$DATA_HOME/applications" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -q -t "$ICON_DIR" >/dev/null 2>&1 || true

# 바탕화면 바로가기(바탕화면 폴더가 있을 때만)
DESKTOP_DIR="$(command -v xdg-user-dir >/dev/null 2>&1 && xdg-user-dir DESKTOP || echo "$HOME/Desktop")"
if [ -d "$DESKTOP_DIR" ]; then
  cp "$DESKTOP_FILE" "$DESKTOP_DIR/$APP_ID.desktop"
  chmod +x "$DESKTOP_DIR/$APP_ID.desktop"
  command -v gio >/dev/null 2>&1 && gio set "$DESKTOP_DIR/$APP_ID.desktop" metadata::trusted true 2>/dev/null || true
fi

echo
echo "설치 완료! 메뉴 > 게임에서 '$APP_NAME'을 눌러 실행하세요."
if ! command -v chromium >/dev/null 2>&1 && ! command -v google-chrome >/dev/null 2>&1; then
  echo "참고: 앱 창으로 깔끔하게 열려면 Chromium을 설치하세요:  sudo apt install chromium"
fi
