import 'package:everydaybible/controller/bible_controller.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class LoadingViewModel extends ChangeNotifier {
  LoadingViewModel(this.controller,{
    TickerProvider vsync,
  }) {
    _initAnimation(vsync);
    _initDataLoad();
  }
 final BibleController controller;
  bool _isLoading=true;
  bool get loadingCompleted=>!_isLoading;
  AnimationController _fadeInAnimation;

  double get titleAnimationValue {
    if (_fadeInAnimation.value < 1) {
      return _fadeInAnimation.value;
    }
    return 1;
  }

  double get subtitleAnimationValue {
    if (_fadeInAnimation.value > 0.5 && _fadeInAnimation.value < 1.5) {
      return _fadeInAnimation.value - 0.5;
    }
    if (_fadeInAnimation.value > 1.5) return 1;
    return 0;
  }

  void _initAnimation(TickerProvider tp) {
    _fadeInAnimation = AnimationController(
        vsync: tp,
        duration: Duration(milliseconds: 3000),
        lowerBound: 0.0,
        upperBound: 1.6)
      ..addListener(_animationListener)
      ..forward();
  }

  void _animationListener() {
    notifyListeners();
  }

  void dispose() {
    super.dispose();
    _fadeInAnimation.dispose();
  }

  void _initDataLoad() async{
    await controller.init();
    _isLoading=false;
    notifyListeners();
  }
}
