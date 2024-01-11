import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    // print('\x1B[32m${bloc.runtimeType} : $change\x1B[0m');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // print('\x1B[32m${bloc.runtimeType} : $transition\x1B[0m');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // print('\x1B[31m${bloc.runtimeType} : $error\x1B[0m');
    super.onError(bloc, error, stackTrace);
  }
}
