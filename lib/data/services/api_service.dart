import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:me/core/utils/contants.dart';
import 'package:me/data/models/message.dart';
import 'package:me/data/models/project.dart';

class APIService {
  Future<List<Project>> projects() async {
    try {
      final response = await http.get(
        Uri.parse(
          kProjectURL,
        ),
      );
      if (response.statusCode == 200) {
        final projects = List<Project>.from(
          json.decode(response.body)?.map((x) => Project.fromJson(x)) ??
              <Project>[],
        );
        return projects;
      } else {
        return <Project>[];
      }
    } on Exception {
      return <Project>[];
    }
  }

  Future<bool> sendMessage(Message message) async {
    try {
      final response = await http.post(
        Uri.parse(
          kMessageURL,
        ),
        body: message.toJson(),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }
}
