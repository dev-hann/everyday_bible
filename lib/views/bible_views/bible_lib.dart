library bible_lib;

import 'dart:math' as math;
import 'package:flutter/src/rendering/editable.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/widgets/widgets_lib.dart';
import 'package:everydaybible/controllers/bible_controller.dart';
import 'package:everydaybible/view_models/bible_view_models/bible_view_model.dart';
import 'package:everydaybible/view_models/bible_view_models/bible_drawer_menu_view_model.dart';

part 'bible_view.dart';

part 'bible_chapter_list_view.dart';

part 'bible_drawer_menu_view.dart';

part 'bible_text_selection_controls.dart';