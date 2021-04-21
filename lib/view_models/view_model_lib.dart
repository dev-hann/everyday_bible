library view_model;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:everydaybible/models/everyday_bible.dart';
import 'package:everydaybible/utils/bible_database.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

part 'main_view_model.dart';

part 'loading_view_model.dart';

part 'bottom_audio_view_model.dart';

abstract class BibleViewModel extends ChangeNotifier{}


