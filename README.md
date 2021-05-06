# Every Day Bible

## Screen shot

<img src="https://user-images.githubusercontent.com/54878755/117225521-15ffe380-ae45-11eb-8099-46516c9f3897.gif" width="35%"> <img src="https://user-images.githubusercontent.com/54878755/117225514-126c5c80-ae45-11eb-9a23-fbd154c432be.gif" width="35%">


<img src="https://user-images.githubusercontent.com/54878755/117223900-4f365480-ae41-11eb-999e-ac93039b7939.png" width="35%"> <img src="https://user-images.githubusercontent.com/54878755/117224027-902e6900-ae41-11eb-9a80-92edbecdd596.png" width="35%">

<img src="https://user-images.githubusercontent.com/54878755/117224102-be13ad80-ae41-11eb-874a-b726348224d6.png" width="35%"> <img src="https://user-images.githubusercontent.com/54878755/117224106-bfdd7100-ae41-11eb-960d-4674e1e575da.png" width="35%">

<img src="https://user-images.githubusercontent.com/54878755/117224187-de436c80-ae41-11eb-9793-efd9cd1686ad.png" width="35%"> <img src="https://user-images.githubusercontent.com/54878755/117224190-e00d3000-ae41-11eb-888c-68d595861845.png" width="35%">


## Design Pattern
 [MVVM](https://morioh.com/p/065577fc11ef)
## Database
 [Hive](https://pub.dev/packages/hive)
## Source Tree
```
lib
├─generated_plugin_registrant.dart
├─main.dart
│
├─utils
│  │  hive_database.dart
│  │  bible_hive_database.dart
│  │
│  └─qt_utils
│          qt_hive_database.dart
│          qt_web_parser.dart
│          qt_audio_player.dart
│
├─views
│  ├─intro_views
│  │      intro_view.dart
│  │      intro_title_view.dart
│  │      intro_button_view.dart
│  │      intro_lib.dart
│  │
│  ├─qt_views
│  │      qt_view.dart
│  │      qt_title_view.dart
│  │      qt_list_view.dart
│  │      qt_lib.dart
│  │      qt_audio_view.dart
│  │      qt_alert.dart
│  │
│  ├─bible_views
│  │      bible_view.dart
│  │      bible_drawer_menu_view.dart
│  │      bible_chapter_list_view.dart
│  │      bible_text_selection_controls.dart
│  │      bible_lib.dart
│  │
│  └─dash_board_views
│          dash_board_view.dart
│          dash_board_tree_view.dart
│          dash_board_lib.dart
│
├─view_models
│  ├─qt_view_models
│  │      qt_audio_view_model.dart
│  │      qt_title_view_model.dart
│  │
│  └─bible_view_models
│          bible_view_model.dart
│          bible_drawer_menu_view_model.dart
│
├─models
│      bible.dart
│      quite_time.dart
│      hive_model.dart
│
├─controllers
│      qt_controller.dart
│      bible_controller.dart
│
├─widgets
│      bible_scaffold.dart
│      glasses_container.dart
│      widgets_lib.dart
│
└─constants
        bible_const.dart
```

## License
###### Copyright © 2018 [Scripture Union Korea](https://www.su.or.kr/). All rights reserved.

 
