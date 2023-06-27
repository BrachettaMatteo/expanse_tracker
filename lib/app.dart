import 'package:expanse_tracker/Application/Presentation/edit_page.dart';
import 'package:expanse_tracker/Application/Presentation/home_page.dart';
import 'package:expanse_tracker/Domain/Model/edit_page_args.dart';
import 'package:expanse_tracker/theme_costum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Application/BusinessLogic/bloc/expanse_tracker_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<ExpanseTrackerBloc>(context)
        .add(ExpanseTrackerEventInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeCostum().ligthThem,
      initialRoute: HomePage.route,
      onGenerateRoute: (settings) {
        final routes = {
          HomePage.route: (_) => const HomePage(),
          EditPage.route: (_) =>
              EditPage(args: settings.arguments as EditiPageArg)
        };

        return MaterialPageRoute(builder: routes[settings.name]!);
      },
    );
  }
}
