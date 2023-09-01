import 'package:everydaybible/enum/text_scale_factor.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  SettingBloc get bloc => BlocProvider.of(context);
  AppBar appBar() {
    return AppBar(
      title: const Text("Setting"),
    );
  }

  Widget themeWidget({
    required ThemeMode themeMode,
    required Function(ThemeMode themeMode) onChanged,
  }) {
    return Row(
      children: [
        Text("Theme : ${themeMode.name}"),
        Switch(
          value: themeMode.index == 1,
          onChanged: (value) {
            onChanged(value ? ThemeMode.light : ThemeMode.dark);
          },
        ),
      ],
    );
  }

  Widget textFactorWidget({
    required TextScaleFactor scaleFactor,
    required Function(TextScaleFactor factor) onChanged,
  }) {
    return Row(
      children: [
        const Text("TextFactor: "),
        DropdownMenu(
          initialSelection: scaleFactor,
          onSelected: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          dropdownMenuEntries: TextScaleFactor.values.map((e) {
            return DropdownMenuEntry(
              value: e,
              label: e.name,
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
        return Scaffold(
          appBar: appBar(),
          body: ListView(
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
          ),
        );
      },
    );
  }
}
