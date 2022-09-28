import 'package:everydaybible/repo/bible_repo/bible_repo.dart';
import 'package:everydaybible/repo/repo.dart';
import 'package:everydaybible/views/home_view/bloc/home_bloc.dart';
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
              create: (_) =>
                  HomeBloc(Repo.of<BibleRepo>(context))..add(HomeInited()),
            )
          ],
          child: const HomeView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      final bloc = BlocProvider.of<HomeBloc>(context);
      return Text("Hello");
    });
  }
}
