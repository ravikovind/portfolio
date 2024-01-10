import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/bloc/theme/theme_bloc.dart';
import 'package:me/data/repositories/api_repository.dart';
import 'package:me/data/services/api_service.dart';
import 'package:me/debug/application_bloc_observer.dart';
import 'package:me/core/utils/contants.dart';
import 'core/utils/color_schemes.dart';
import 'view/pages/home_page.dart';

Future<void> main() async {
  /// initialize flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  /// register license assets/fonts/OFL.txt
  /// for font Urbanist
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['urbanist'], license);
  });

  /// use url_strategy to remove # from url
  setUrlStrategy(PathUrlStrategy());

  /// initialize bloc observer
  Bloc.observer = ApplicationBlocObserver();

  /// initialize hydrated bloc storage
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorage.webStorageDirectory,
  );

  /// initialize hydrated bloc delegate
  HydratedBloc.storage = storage;

  /// run app with MyApp
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ProjectCubit>(
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
                useMaterial3: true,
                fontFamily: kFontFamily,
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
                useMaterial3: true,
                fontFamily: kFontFamily,
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
