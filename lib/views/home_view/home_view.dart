import 'package:everydaybible/repo/audio_repo/repo_audio.dart';
import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/qt_repo/qt_repo.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/views/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/views/qt_player_view/bloc/qt_player_bloc.dart';
import 'package:everydaybible/views/qt_view/bloc/qt_bloc.dart';
import 'package:everydaybible/views/qt_view/qt_view.dart';
import 'package:everydaybible/widgets/bible_logo.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static String routeName() {
    return "HomeView";
  }

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: HomeView.routeName(),
      ),
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => HomeBloc(
                Repo.of<BibleRepo>(context),
              )..add(HomeInited()),
            ),
            BlocProvider(
              create: (_) => QTBloc(
                Repo.of<QTRepo>(context),
              )..add(QTOnInited()),
            ),
            BlocProvider(
              create: (_) => QTPlayerBloc(
                Repo.of<AudioRepo>(context),
              ),
            )
          ],
          child: const HomeView(),
        );
      },
    );
  }

  NavigationAppBar appBar() {
    return const NavigationAppBar(
      title: Text("Everyday Bible"),
      leading: BibleLogo(),
    );
  }

  PaneItem qtPaneItem() {
    return PaneItem(
      icon: const Icon(FluentIcons.shop),
      title: const Text("QuiteTime"),
      body: const QTView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // final bloc = BlocProvider.of<HomeBloc>(context);
        return NavigationView(
          appBar: appBar(),
          pane: NavigationPane(
            selected: 0,
            items: [
              qtPaneItem(),
            ],
          ),
        );
      },
    );
  }
}
