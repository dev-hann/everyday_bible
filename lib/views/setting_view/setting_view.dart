import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:everydaybible/views/setting_view/bloc/setting_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  Widget textFactorWidget({
    required TextScaleFactor factor,
    required Function(TextScaleFactor factor) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("TextSize"),
        DropDownButton(
          title: Text(factor.toName()),
          items: [
            for (final type in TextScaleFactor.values)
              MenuFlyoutItem(
                selected: type == factor,
                onPressed: () {
                  onChanged(type);
                },
                text: Text(type.toName()),
              ),
          ],
        ),
      ],
    );
  }

  Widget darkModeWidget({
    required bool isDarkMode,
    required Function(bool isDarkMode) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("DarkMode"),
        ToggleSwitch(
          checked: isDarkMode,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<SettingBloc>(context);
        final setting = state.setting;
        return ScaffoldPage.scrollable(
          children: [
            textFactorWidget(
              factor: setting.textScaleFactor,
              onChanged: (TextScaleFactor factor) {
                bloc.add(
                  SettingOnChanged(
                    setting.copyWith(
                      textScaleFactorIndex: factor.index,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            darkModeWidget(
              isDarkMode: setting.isDarkMode,
              onChanged: (isDarkMode) {
                final index = isDarkMode ? 2 : 1;
                bloc.add(
                  SettingOnChanged(
                    setting.copyWith(themeModeIndex: index),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
