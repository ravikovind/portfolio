import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';
import 'package:me/data/services/api_service.dart';

abstract class IAPIRepository {
  Future<List<Project>> getProjects();
  Future<bool> sendThanks(Message message);
}

class APIRepository implements IAPIRepository {
  APIRepository({required this.service});
  final APIService service;
  @override
  Future<List<Project>> getProjects() => service.projects();
  @override
  Future<bool> sendThanks(Message message) => service.sendMessage(message);
}
