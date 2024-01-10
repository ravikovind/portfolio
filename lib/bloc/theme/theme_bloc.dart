import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system) {
    on<ToggleTheme>((event, emit) {
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    });
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values.firstWhere(
      (element) => element.toString() == json['theme']?.toString(),
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'theme': state.toString(),
    };
  }
}

sealed class ThemeEvent {
  const ThemeEvent();
}

class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}
