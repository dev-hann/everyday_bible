import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Settings screen: dark mode toggle and text size factor selection.
class SettingView extends StatefulWidget {
  /// Creates the settings screen.
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>
    with AutomaticKeepAliveClientMixin {
  SettingBloc get bloc => BlocProvider.of(context);

  Widget themeWidget({
    required ThemeMode themeMode,
    required void Function(ThemeMode themeMode) onChanged,
  }) {
    return FSwitch(
      label: const Text('Theme'),
      description: const Text('Dark / Light'),
      value: themeMode == ThemeMode.light,
      onChange: (value) {
        onChanged(value ? ThemeMode.light : ThemeMode.dark);
      },
    );
  }

  Widget textFactorWidget({
    required TextScaleFactor scaleFactor,
    required void Function(TextScaleFactor factor) onChanged,
  }) {
    return FSelect<TextScaleFactor>(
      control: FSelectControl.lifted(
        value: scaleFactor,
        onChange: (factor) {
          if (factor != null) {
            onChanged(factor);
          }
        },
      ),
      hint: 'TextFactor',
      items: {
        for (final factor in TextScaleFactor.values) factor.name: factor,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final setting = state.setting;
        return FScaffold(
          header: const FHeader(title: Text('Setting')),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              themeWidget(
                themeMode: setting.themeMode,
                onChanged: (brightness) {
                  bloc.add(
                    SettingEventUpdatedSetting(
                      setting.copyWith(themeMode: brightness),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
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
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
