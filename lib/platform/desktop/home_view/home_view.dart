import 'package:everydaybible/platform/desktop/bible_view/bible_view.dart';
import 'package:everydaybible/platform/desktop/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/desktop/memo_view/memo_view.dart';
import 'package:everydaybible/platform/desktop/quite_time_view/quite_time_view.dart';
import 'package:everydaybible/platform/desktop/setting_view/setting_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:everydaybible/widgets/bible_logo.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeBloc get bloc => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    bloc.add(HomeEventInited());
  }

  NavigationAppBar appBar() {
    return NavigationAppBar(
      title: Text(
        "Everyday Bible",
        style: FluentTheme.of(context).typography.subtitle,
      ),
      leading: const BibleLogo(),
    );
  }

  PaneItem quiteTimeView() {
    return PaneItem(
      icon: const Icon(FluentIcons.storyboard),
      title: const Text("QuiteTime"),
      body: const QuiteTimeView(),
    );
  }

  PaneItem bibleView() {
    return PaneItem(
      icon: const Icon(FluentIcons.read),
      title: const Text("Bible"),
      body: const BibleView(),
    );
  }

  PaneItem memoView() {
    return PaneItem(
      icon: const Icon(FluentIcons.memo),
      title: const Text("Memo"),
      body: const MemoView(),
    );
  }

  PaneItem settingView() {
    return PaneItem(
      icon: const Icon(FluentIcons.settings),
      title: const Text("Setting"),
      body: const SettingView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final status = state.status;
        switch (status) {
          case HomeViewStatus.init:
            return const BibleLoading();
          case HomeViewStatus.loading:
          case HomeViewStatus.failure:
          case HomeViewStatus.success:
        }
        return NavigationView(
          appBar: appBar(),
          pane: NavigationPane(
            size: const NavigationPaneSize(openWidth: 160.0),
            selected: state.index,
            onChanged: (index) {
              bloc.add(HomeEventUpdatedIndex(index));
            },
            items: [
              quiteTimeView(),
              bibleView(),
              // memoView(),
              settingView(),
            ],
          ),
        );
      },
    );
  }
}
