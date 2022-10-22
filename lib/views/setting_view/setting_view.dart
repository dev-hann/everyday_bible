import 'package:everydaybible/views/setting_view/bloc/setting_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<SettingBloc>(context);
        final setting = state.setting;
        return ScaffoldPage.scrollable(
          children: [
            Row(
              children: [
                ToggleSwitch(
                  checked: setting.isDarkMode,
                  onChanged: (bool value) {
                    bloc.add(
                      SettingOnChanged(
                        setting.copyWith(themeModeIndex: value ? 2 : 1),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
