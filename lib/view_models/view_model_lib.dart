library view_model;

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:everydaybible/models/bible.dart';
import 'package:everydaybible/utils/bible_database.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';


part 'main_view_model.dart';

part 'loading_view_model.dart';

part 'bottom_audio_view_model.dart';

abstract class BibleViewModel extends ChangeNotifier{}


