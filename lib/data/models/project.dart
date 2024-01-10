class Project {
  Project({
    this.name,
    this.description,
    this.webUrl,
    this.appUrl,
    this.demoUrl,
    this.tags,
  });

  final String? name;
  final String? description;
  final String? webUrl;
  final String? appUrl;
  final String? demoUrl;
  final List<String>? tags;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        name: json['name']?.toString(),
        description: json['description']?.toString(),
        webUrl: json['web_url']?.toString(),
        appUrl: json['app_url']?.toString(),
        demoUrl: json['demo_url']?.toString(),
        tags: List<String>.from(
          json['tags']?.toString().split(',').map((e) => e.trim()) ??
              <String>[],
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'web_url': webUrl,
        'app_url': appUrl,
        'demo_url': demoUrl,
        'tags': tags,
      };
}
