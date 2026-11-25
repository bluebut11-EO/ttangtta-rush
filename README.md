# 땅따 러시

선을 긋고 돌아오면, 감싼 곳이 전부 내 땅! 2분 30초 땅따먹기 게임.

## 바로 해 보기

- **파일로 열기:** `www/index.html` 을 브라우저로 엽니다.
- **Linux Mint에 설치:** 이 폴더에서 아래를 실행하면 메뉴 > 게임에 아이콘이 생깁니다.

  ```bash
  sudo apt install chromium   # 주소창 없는 앱 창으로 열기 위해 (선택)
  bash install-linux.sh       # 지울 때: bash uninstall-linux.sh
  ```

- **휴대폰에서 같은 와이파이로 테스트:**

  ```bash
  python3 -m http.server 8000 -d www
  # 휴대폰 브라우저에서 http://<이 PC의 IP>:8000
  ```

## GitHub에 올리면

`main` 브랜치에 push 하면 두 가지가 자동으로 실행됩니다.

| 작업 | 파일 | 결과 |
| --- | --- | --- |
| 게임 공개 | `.github/workflows/pages.yml` | `https://<아이디>.github.io/ttangtta-rush` 에서 플레이 (Settings > Pages > Source: GitHub Actions) |
| 안드로이드 테스트 앱 | `.github/workflows/android-apk.yml` | Actions 실행 기록의 Artifacts 에서 APK 다운로드 |

## 앱으로 만들기 (Capacitor 8)

필요: Node.js 22 이상, Android Studio(안드로이드), Mac + Xcode 26 이상(iOS)

```bash
npm install
npm run android:add    # android 폴더 생성
npm run sync           # www 의 게임 파일을 앱으로 복사 (게임을 고칠 때마다)
npm run android:open   # Android Studio 에서 열어 실행/서명/출시 파일(AAB) 만들기
npm run ios:add && npm run ios:open   # Mac 에서만
```


## 폴더 구성

```
www/                    게임 (index.html 한 파일 + 아이콘, 오프라인 설치 설정)
install-linux.sh        Linux Mint 설치
uninstall-linux.sh      제거
capacitor.config.json   앱 이름, 앱 ID
package.json            앱 포장 도구 목록과 명령
.github/workflows/      GitHub 자동 배포, APK 자동 생성
```

게임 파일을 고친 뒤에는 `www/sw.js` 의 `VERSION` 숫자를 올려야 이미 설치한 사람에게도 새 버전이 전달됩니다.

## Play 스토어 출시용 빌드 (AAB)

앱 ID: `com.bluebut11.ttangttarush` (한 번 출시하면 바꿀 수 없습니다)

1. **서명 키 만들기 (PC에서 한 번만):**

   ```bash
   sudo apt install default-jdk gh && gh auth login
   bash setup-release-key.sh
   ```

   키는 `~/android-keys` 에 저장되고 GitHub Secrets 에 자동 등록됩니다. 이 폴더는 꼭 따로 백업하세요.
2. **AAB 만들기:** GitHub > Actions > **Play 스토어 출시용 AAB 만들기** > Run workflow
3. **올리기:** 실행 기록 > Artifacts 에서 `.aab` 를 내려받아 Play Console > 내부 테스트에 업로드
   (Play App Signing 사용 권장, 버전 코드는 실행 번호로 자동 증가)

새 버전을 낼 때는 `package.json` 의 `version` 을 올리고 2번부터 반복합니다.
