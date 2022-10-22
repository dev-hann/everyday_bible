import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Setting extends Equatable {
  const Setting({
    this.brightness = Brightness.dark,
  });

  final Brightness brightness;

  @override
  List<Object?> get props => [
        brightness,
      ];
}
