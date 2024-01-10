part of 'project_cubit.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;
  const ProjectLoaded({required this.projects});
  @override
  List<Object> get props => [projects];
  @override
  String toString() => 'ProjectLoaded { projects: $projects }';
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError({required this.message});
  @override
  List<Object> get props => [message];
  @override
  String toString() => 'ProjectError { message: $message }';
}
