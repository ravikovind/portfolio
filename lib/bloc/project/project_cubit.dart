import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:me/data/models/project.dart';
import 'package:me/data/repositories/api_repository.dart';
part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final APIRepository _apiRepository;
  ProjectCubit(this._apiRepository) : super(ProjectInitial());
  FutureOr<void> getProjects() async {
    emit(ProjectLoading());
    try {
      final projects = await _apiRepository.getProjects();
      emit(ProjectLoaded(projects: projects));
    } catch (_) {
      emit(const ProjectError(message: 'There is an error'));
    }
  }
}
