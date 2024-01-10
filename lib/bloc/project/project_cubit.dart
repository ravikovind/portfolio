import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:me/data/models/project.dart';
import 'package:me/data/repositories/api_repository.dart';
part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final APIRepository _apiRepository;
  ProjectCubit(this._apiRepository) : super(ProjectInitial());
  void getProjects() async {
    emit(ProjectLoading());
    try {
      final projects = await _apiRepository.getProjects();
      emit(ProjectLoaded(projects: projects));
    } catch (e) {
      emit(ProjectError(message: 'there is an error due to $e'));
    }
  }
}
