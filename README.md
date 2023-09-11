# Everyday Bible

<p align="center">
<img src="https://github.com/yoehwan/everyday_bible/blob/main/assets/logo.png?raw=true" width="150" height="150" >
</p>

Let's read `Bible` Everyday

## Getting Started

```text
git clone https://guthub.com/yoehwan/everyday_bible.git
cd everyday_bible
flutter run 
```

## Screen shot

![Mobile Screen](https://github.com/yoehwan/everyday_bible/assets/54878755/98b81fd7-459d-40a6-a964-031ba1d3f988)

![Desktop Screen](https://github.com/yoehwan/everyday_bible/assets/54878755/af6ee6d6-ed0a-45b7-8f8c-96ed8a666e24)

## Technology

* [Bloc pattern](https://bloclibrary.dev/#/)
* [Clean Architecture](https://itnext.io/flutter-clean-architecture-b53ce9e19d5a)
* [Functional Programming](https://pub.dev/packages/dartz)

## Feature

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
│   ├── 📁 data (🙈 Not Choose Yet..)
│   └── 📁 service
├── 📁 model
├── 📁 platform
│   ├── 📁 desktop
│   │   ├── 📁 audio_player_view
│   │   ├── 📁 bible_view
│   │   ├── 📁 home_view
│   │   ├── 📁 memo_edit_view ( 🚧 Work In Progress.. )
│   │   ├── 📁 memo_view
│   │   ├── 📁 quite_time_view
│   │   └── 📁 setting_view
│   └── 📁 mobile
│       ├── 📁 audio_player_view
│       ├── 📁 bible_view
│       ├── 📁 home_view
│       ├── 📁 memo_edit_view ( 🚧 Work In Progress.. )
│       ├── 📁 memo_view
│       ├── 📁 quite_time_view
│       └── 📁 setting_view
├── 📁 repo
│   ├── 📁 audio_repo
│   ├── 📁 bible_repo
│   ├── 📁 memo_repo
│   ├── 📁 quite_time_repo
│   └── 📁 setting_repo
├── 📁 use_case
│   ├── 📁 audio_use_case
│   ├── 📁 bible_use_case
│   ├── 📁 memo_use_case
│   ├── 📁 quite_time_use_case
│   └── 📁 setting_use_case
└── 📁 widgets
```

## License

 Copyright © 2018 [Scripture Union Korea](https://www.su.or.kr/). All rights reserved.
