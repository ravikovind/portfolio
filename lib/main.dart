import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/bloc/theme/theme_bloc.dart';
import 'package:me/data/repositories/api_repository.dart';
import 'package:me/data/services/api_service.dart';
import 'package:me/debug/application_bloc_observer.dart';
import 'package:me/core/utils/contants.dart';
import 'core/utils/color_schemes.dart';
import 'view/pages/home.dart';

Future<void> main() async {
  /// initialize flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  /// use url_strategy to remove # from url
  setUrlStrategy(PathUrlStrategy());

  /// initialize bloc observer
  Bloc.observer = ApplicationBlocObserver();

  /// initialize hydrated bloc storage
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory.web,
  );

  /// initialize hydrated bloc delegate
  HydratedBloc.storage = storage;

  /// run app with MyApp
  return runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ProjectCubit>(
            lazy: false,
            create: (context) => ProjectCubit(APIRepository(
              service: APIService(),
            ))
              ..getProjects(),
          ),
          BlocProvider<MessageCubit>(
            create: (context) => MessageCubit(APIRepository(
              service: APIService(),
            )),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp(
              themeMode: mode,
              title: kName,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                textTheme: GoogleFonts.urbanistTextTheme(
                  Theme.of(context).textTheme,
                ),
                colorScheme: lightColorScheme,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              darkTheme: ThemeData(
                textTheme: GoogleFonts.urbanistTextTheme(
                  Theme.of(context).textTheme.apply(
                        bodyColor: darkColorScheme.onSurface,
                        displayColor: darkColorScheme.onSurface,
                        decorationColor: darkColorScheme.onSurface,
                      ),
                ),
                colorScheme: darkColorScheme,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              home: const HomePage(),
            );
          },
        ),
      );
}
