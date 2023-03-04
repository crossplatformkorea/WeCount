## 컨트리뷰팅

### Issue

1. 만들고자 하는 이슈가 이미 있는지 검색하고 등록해 주세요. 비슷한 문제가 있는 경우 추가 의견을 달아주세요.
1. 이슈에 문제점이나 건의사항을 적어주세요. 문제에 하나 이상의 항목을 포함하지 말아주세요.
1. 가능한 자세하고 간결하게 작성해 주세요.
1. 필요시 스크린샷을 찍어 이미지를 올려주세요.

### Pull Request

1. 기여를 위해서 프로젝트를 `fork` 해주세요.
1. [포크 동기화](https://help.github.com/articles/configuring-a-remote-for-a-fork)를 통해 `main` 프로젝트와 주기적으로 동기화를 해주세요.
   - `git remote add upstream https://github.com/crossplatformkorea/wecount` 명령을 수행하여 업스트림 저장소를 등록합니다.
   - 잘 등록이 되었는지 `git remove -v` 명령어를 수행하여 확인해주세요.
1. 등록한 `upstream`에 있는 브랜치들을 받아오기 위해 `git fetch upstream` 명령을 수행합니다.
1. Pull request를 날리실 때는 아래 스탭을 염두해주세요.
   1. `git switch -c [브랜치명]`. 브랜치명은 `feat/`, `docs/` 등 적절한 `prefix` 붙여주세요.
   1. 작업을 수행합니다.
   1. `git fetch upstream && git rebase upstream/main`을 수행합니다.
   1. `main` 브랜치에 pull request를 날립니다.


## Contributing

1. 기본적인 행동강령을 아래 링크를 통해 확인해주세요.
   - [Vision and mission](https://dooboolab.com/vision_and_mission)
   - [Code of conduct](https://dooboolab.com/code_of_conduct)
   - [Contributing](CONTRIBUTING.md)

## 코드 스타일

[플러터 스타일 가이드](https://github.com/hyochan/style-guide/blob/main/docs/ko/FLUTTER.md)를 준수해주세요.

## 프로젝트 설정

### 1. Firebase

[문서](https://firebase.google.com/docs/flutter)를 따라 `flutterfire configure`를 실행합니다.

### 2. 환경 변수

```
cp .env.sample dotenv
```

> 왜 `.env`로 복사하지 않는지 의아하시는 분들을 위해 [관련 이슈](https://github.com/java-james/flutter_dotenv/issues/28)를 링크합니다.

| Name                   | Description                | required?    |
|------------------------|----------------------------|--------------|
| ENV                    | Environment                | no           |
| GEO_API_KEY            | Google map api key         | no           |
| PLACE_API_KEY          | Google place api key       | no           |
| EMULATOR_IP_ADDRESS    | firebase emulator ip addr  | no           |
| WEB_PUSH_TOKEN         | firebase web push token    | no           |
| GOOGLE_WEB_CLIENT_ID   | google web client id       | no           |
| PAYPAL_CLIENT_ID       | paypal client id           | no           |
| PAYPAL_SECRET          | paypal secret              | no           |

> 참고: 현재 위 변수들은 모두 필수가 아니므로 로컬에서 `dotenv` 파일만 생성하면 빌드가 가능합니다.

- Google API KEY수
  * [Installation](https://developers.google.com/maps/documentation/geocoding/get-api-key)
  * [Android](https://developers.google.com/maps/documentation/android-sdk/get-api-key)
  * [iOS](https://developers.google.com/maps/documentation/ios-sdk/get-api-key)

- PLACE_API_KEY
  * `GEO_API_KEY`와 동일하지만 사용량을 별도로 추적하려면 다른 `API_KEY`를 생성하는 것이 좋습니다. 특정 플랫폼 상관없이 사용 가능합니다.

- EMULATOR_IP_ADDRESS
  * [파이어베이스 에뮬레이터](https://firebase.google.com/docs/emulator-suite)를 사용한다면 로컬 IP 주소를 입력합니다.

- WEB_PUSH_TOKEN
  * [FCM push token](https://firebase.google.com/docs/cloud-messaging/js/client) 입니다.

- GOOGLE_WEB_CLIENT_ID
  * 구글 로그인을 위한 [web client id](https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid) 입니다.

### 3. Freezed 모델

현 프로젝트에서 [Remi](https://github.com/rrousselGit)님이 만들어준 여러 패키지들을 활용하고 있습니다. 대표적으로 [Freezed](https://github.com/rrousselGit/freezed) 모델입니다.

Freezed 모델을 생성하거나 수정하면 매번 아래 명령어를 통해 generated 파일들을 갱신해주어야 합니다. 갱신된 생성 파일들도 `git`에 같이 반영합니다.

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

**윈도우 사용자**
`Freezed`에서 생성된 파일은 OS별로 기본으로 생성되는 파일 형식이 다릅니다. 자세한 내용은 [stackoverflow](https://stackoverflow.com/questions/1552749/difference-between-cr-lf-lf-and-cr-line-break-types)를 참조하세요.

윈도우는 기본으로 `CRLF` 포맷으로 파일을 생성하기 때문에 생성된 파일들이 `git`에서 충돌이 날 수 있습니다. 이를 방지하기 위해서 윈도우에서는 깃 설정을 아래와 같이 변경합니다.

```
git config --global core.eol lf
git config --global core.autoclrl true
```

> `core.autocrlf`를 `true`로 설정하면 Git은 파일을 체크아웃하고 커밋할 때 줄 끝을 플랫폼별 형식으로 변환합니다. 이것은 다른 기여자가 다른 운영 체제나 텍스트 편집기를 사용할 수 있는 팀 환경에서 작업하는 경우 모든 플랫폼에서 줄 끝이 일관되도록 하는 데 도움이 됩니다. 그러나 이진 파일이나 특정 파일 형식으로 작업할 때와 같이 자동 줄 끝 변환이 때때로 문제를 일으킬 수 있다는 점은 주목할 필요가 있습니다. 이러한 경우 `core.autocrlf`를 `false` 또는 `input`으로 설정하여 자동 줄 끝 변환을 비활성화할 수 있습니다.

따라서 맥 유저들은 아래와 같이 설정해주는 것을 권장합니다.

```
git config --global core.autoclrl input
```

> `core.autocrlf`를 `input`으로 설정하면 파일을 체크아웃할 때 줄 끝을 그대로 두도록 Git에 지시합니다. 이것은 서로 다른 텍스트 편집기나 운영 체제가 서로 다른 줄 끝을 사용할 수 있는 환경에서 작업하는 경우에 유용합니다. 줄 끝을 변환하지 않으면 한 환경에서 작동하는 코드가 줄 끝 차이로 인해 다른 환경에서는 작동하지 않는 문제를 피할 수 있습니다.

### 4. 국제화

국제화 작업은 `lib/l10n/*` 파일에서 진행됩니다. 가끔 `l10n`이 자동으로 생성되는 파일을 생성하지 않는 경우 아래 명령어들을 수행하면 도움이 됩니다. 

```sh
dart pub global activate intl_utils
dart pub global run intl_utils:generate
```

> [관련 질의](https://stackoverflow.com/questions/65182393/why-is-flutter-not-generating-the-internationalization-files)

### 알면 좋은 것들

#### 1. 플러그인 업그레이드

플러그인을 업그레이드는 아래와 같이 수행합니다. 메인테이너가 아니시면 가급적 안하시는 것이 좋습니다.

```
flutter pub upgrade
```

> 플러터 버전 3.7이하 버전에서는 `pubspec.yaml`의 값을 업데이트하려면 `--null-safety`를 추가하여야 했지만 3.8부터는 없어졌습니다.

#### 2. Firestore security rules
현재 `firestore.rules` 파일에 보안 규칙이 작성되어 있습니다. 데이터베이스를 추가로 설계하면 반드시 [firebase security rules](https://firebase.google.com/docs/firestore/security/get-started)를 작성해야 합니다.

#### 3. Android SHA certificate
소셜 로그인 등에서 안드로이드 사용자에게 요구되는 값입니다. 디버그 환경에서 이를 추출하여 파이어베이스 프로젝트에서 소셜 로그인에 추가해주셔야 해당 인증을 테스트 해보실 수 있습니다.

```sh
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

> 위 명령어를 수행할 수 없으면 아래 명령어를 통해 `java 11`을 설치해주세요. 아래 명령어들은 데비안 리눅스 기준입니다.
```
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install openjdk-11-jdk
```

- 윈도우 유저시면 아래 명령어를 통해 진행해주시면 됩니다.
  ```sh
  keytool -list -v -keystore 'C:\Users\[유저명]\.android\debug.keystore'-alias androiddebugkey -storepass android -keypass android
  ```
