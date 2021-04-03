library view_model;

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:everydaybible/controller/bible_controller.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


part 'main_view_model.dart';

part 'loading_view_model.dart';

part 'bottom_audio_view_model.dart';

abstract class BibleViewModel extends ChangeNotifier{}


