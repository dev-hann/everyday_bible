import 'package:everydaybible/enum/mobile_menu_type.dart';
import 'package:everydaybible/platform/mobile/bible_view/bible_view.dart';
import 'package:everydaybible/platform/mobile/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/mobile/memo_view/memo_view.dart';
import 'package:everydaybible/platform/mobile/quite_time_view/quite_time_view.dart';
import 'package:everydaybible/platform/mobile/setting_view/setting_view.dart';
import 'package:everydaybible/widgets/bible_loading.dart';
import 'package:flutter/material.dart';
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

  Widget body({
    required MobileMenuType currentType,
  }) {
    switch (currentType) {
      case MobileMenuType.bible:
        return const BibleView();
      case MobileMenuType.quiteTime:
        return const QuiteTimeView();
      case MobileMenuType.setting:
        return const SettingView();
      case MobileMenuType.memo:
        return const MemoView();
    }
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
        final currentType = state.menuType;
        return Scaffold(
          body: body(
            currentType: currentType,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentType.index,
            onTap: (index) {
              bloc.add(
                HomeEventUpdatedMenu(MobileMenuType.values[index]),
              );
            },
            items: MobileMenuType.values.map((e) {
              return BottomNavigationBarItem(
                icon: Icon(e.toIcons()),
                label: e.toTitle(),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
