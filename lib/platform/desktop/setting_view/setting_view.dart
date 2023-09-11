import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/desktop/setting_view/bloc/setting_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  SettingBloc get bloc => BlocProvider.of(context);

  Widget themeWidget({
    required ThemeMode themeMode,
    required Function(ThemeMode themeMode) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Theme : ${themeMode.name}"),
        const Spacer(),
        const Text("Dark"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ToggleSwitch(
            checked: themeMode.index == 1,
            onChanged: (value) {
              onChanged(value ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ),
        const Text("Light"),
      ],
    );
  }

  Widget textFactorWidget({
    required TextScaleFactor scaleFactor,
    required Function(TextScaleFactor factor) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("TextFactor: "),
        DropDownButton(
          title: Text(scaleFactor.name),
          items: TextScaleFactor.values.map((e) {
            return MenuFlyoutItem(
              text: Text(e.name),
              onPressed: () {
                onChanged(e);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final setting = state.setting;
        return ScaffoldPage.scrollable(
          children: [
            themeWidget(
              themeMode: setting.themeMode,
              onChanged: (mode) {
                bloc.add(
                  SettingEventUpdatedSetting(
                    setting.copyWith(themeMode: mode),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            textFactorWidget(
              scaleFactor: setting.textScaleFactor,
              onChanged: (factor) {
                bloc.add(
                  SettingEventUpdatedSetting(
                    setting.copyWith(textScaleFactor: factor),
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
