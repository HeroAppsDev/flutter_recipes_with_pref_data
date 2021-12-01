import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'data/repository.dart';
import 'network/recipe_service.dart';
import 'network/service_interface.dart';

import 'data/moor/moor_repository.dart';

import 'ui/main_screen.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();

  final repository = MoorRepository();
  await repository.init();
  runApp(MyApp(repository: repository));
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    debugPrint('## ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  final Repository repository;
  const MyApp({Key? key, required this.repository}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //MultiProvider uses the providers property to define multiple providers.
    return MultiProvider(
      providers: [
        Provider<Repository>(
            lazy: false,
            create: (_) => repository,
            dispose: (_, Repository repository) => repository.close()),
        //You add a new provider, which will use the new mock service.
        Provider<ServiceInterface>(
          //Create the MockService and call create() to load the JSON files (notice the .. cascade operator).
          create: (_) => RecipeService.create(),
          lazy: false,
        )
      ],

      //Return MaterialApp as the child widget.
      child: MaterialApp(
        title: 'Recipes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
