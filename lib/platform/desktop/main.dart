import 'package:everydaybible/platform/desktop/bible_view/bloc/bible_bloc.dart';
import 'package:everydaybible/platform/desktop/home_view/bloc/home_bloc.dart';
import 'package:everydaybible/platform/desktop/home_view/home_view.dart';
import 'package:everydaybible/platform/desktop/quite_time_view/bloc/quite_time_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Everyday Bible",
      debugShowCheckedModeBanner: false,
      darkTheme: FluentThemeData.dark(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => HomeBloc(),
          ),
          BlocProvider(
            create: (_) => QuiteTimeBloc(),
          ),
          BlocProvider(
            create: (_) => BibleBloc(),
          ),
        ],
        child: const HomeView(),
      ),
    );
  }
}
