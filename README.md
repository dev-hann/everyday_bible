# Everyday Bible

<p align="center">
<img src="https://github.com/yoehwan/everyday_bible/blob/main/assets/logo.png?raw=true" width="150" height="150" >
</p>

Let's read `Bible` Everyday

## Getting Started

```text
git clone https://github.com/dev-hann/everyday_bible.git
cd everyday_bible
flutter run 
```

## Screen shot

![Mobile Screen](https://github.com/yoehwan/everyday_bible/assets/54878755/98b81fd7-459d-40a6-a964-031ba1d3f988)

## Technology

* [Flutter](https://flutter.dev) (mobile only — Android / iOS)
* [Bloc pattern](https://bloclibrary.dev/#/) for state management
* [Clean Architecture](https://itnext.io/flutter-clean-architecture-b53ce9e19d5a) — view → bloc → use_case → repo
* [drift](https://drift.simonbinder.eu/) (SQLite) for local storage
* [fpdart](https://pub.dev/packages/fpdart) for functional error handling (`Either<Failure, T>`)
* [just_audio](https://pub.dev/packages/just_audio) for audio playback

## Development

```bash
flutter pub get     # install dependencies
flutter analyze     # lint (very_good_analysis) — must be clean
flutter test        # run tests
```

> **Firebase setup (required to build/run):** `lib/firebase_options.dart` and
> `android/app/google-services.json` contain API keys and are **gitignored**
> (see `google-services.json.example` for the expected shape). Restore them
> locally with:
>
> ```bash
> dart pub global activate flutterfire_cli
> flutterfire configure
> ```

- Lint preset: [very_good_analysis](https://pub.dev/packages/very_good_analysis) — strict mode; every public member is documented.
- CI runs analyze + test on every push/PR (`.github/workflows/ci.yml`).
- Architecture decisions are recorded in [`docs/adr/`](docs/adr/).
- Agent/human contributor guide: [`AGENTS.md`](AGENTS.md).

## Feature

* AI Chat ( scripture-grounded explanations via Firebase AI Logic )
* Bible
* Quite Time
* Memo ( 🚧 Work In Progress..)
* Setting
  * Dark Mode
  * Font Size

## Source Tree

```text
📁 lib
├── 📁 data_base
│   └── drift database (app_database.dart + generated .g.dart)
├── 📁 model
├── 📁 platform
│   └── 📁 mobile
│       ├── 📁 audio_player_view
│       ├── 📁 bible_drawer_view
│       ├── 📁 bible_view
│       ├── 📁 chat_view
│       ├── 📁 home_view
│       ├── 📁 memo_edit_view ( 🚧 Work In Progress.. )
│       ├── 📁 memo_view
│       ├── 📁 quite_time_dash_board_view
│       ├── 📁 quite_time_view
│       └── 📁 setting_view
├── 📁 repo
│   ├── 📁 audio_repo
│   ├── 📁 bible_repo
│   ├── 📁 chat_repo
│   ├── 📁 memo_repo
│   ├── 📁 quite_time_repo
│   └── 📁 setting_repo
├── 📁 service
├── 📁 use_case
│   ├── 📁 audio_use_case
│   ├── 📁 bible_use_case
│   ├── 📁 chat_use_case
│   ├── 📁 memo_use_case
│   ├── 📁 quite_time_use_case
│   └── 📁 setting_use_case
└── 📁 widgets
```

## License

 Copyright © 2018 [Scripture Union Korea](https://www.su.or.kr/). All rights reserved.
