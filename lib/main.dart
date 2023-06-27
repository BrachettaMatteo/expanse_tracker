import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Application/BusinessLogic/bloc/expanse_tracker_bloc.dart';
import 'Data/Repositories/expanse_traker_repository.dart';
import 'app.dart';

late ExpanseTrakerRepository globalDB;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ExpanseTrackerBloc(),
      )
    ],
    child: const MyApp(),
  ));
}
