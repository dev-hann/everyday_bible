import 'package:everydaybible/model/setting.dart';
import 'package:everydaybible/platform/mobile/setting_view/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>
    with AutomaticKeepAliveClientMixin {
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Theme :"),
        const Spacer(),
        const Text("Dark"),
        Switch(
          value: themeMode.index == 1,
          onChanged: (value) {
            onChanged(value ? ThemeMode.light : ThemeMode.dark);
          },
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
    super.build(context);
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final setting = state.setting;
        return Scaffold(
          appBar: appBar(),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
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

  @override
  bool get wantKeepAlive => true;
}
