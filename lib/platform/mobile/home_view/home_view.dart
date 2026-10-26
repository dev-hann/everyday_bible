import 'package:everydaybible/platform/mobile/bible_view/bible_view.dart';
import 'package:everydaybible/platform/mobile/chat_view/chat_view.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/quite_time_dash_board_view/quite_time_dash_board_view.dart';
import 'package:everydaybible/platform/mobile/setting_view/setting_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

/// Root screen of the app with bottom navigation between the Bible reader,
/// the Quiet Time dashboard, and the settings.
class HomeView extends StatefulWidget {
  /// Creates the home screen.
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeBloc get bloc => BlocProvider.of(context);

  // Recreating this per build drops input focus during keyboard insets.
  late final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    bloc.add(const HomeEventInited());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
        final currentIndex = state.menuIndex;
        return BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, next) => previous.menuIndex != next.menuIndex,
          listener: (context, state) {
            pageController.animateToPage(
              state.menuIndex,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
          child: FScaffold(
            footer: FBottomNavigationBar(
              index: currentIndex,
              onChange: (index) {
                bloc.add(
                  HomeEventUpdatedIndex(index),
                );
              },
              children: const [
                FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.messageSquare),
                  label: Text('AI'),
                ),
                FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.bookOpen),
                  label: Text('Bible'),
                ),
                FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.bookmark),
                  label: Text('QuiteTime'),
                ),
                FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.settings),
                  label: Text('Setting'),
                ),
              ],
            ),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                ChatView(),
                BibleView(),
                QuiteTimeDashBoardView(),
                SettingView(),
              ],
            ),
          ),
        );
      },
    );
  }
}
