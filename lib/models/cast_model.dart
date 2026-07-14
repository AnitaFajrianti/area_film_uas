class Cast {
  final int id;
  final String name;
  final String character;
  final String profilePath;
  final int order;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      character: json['character'] ?? 'N/A',
      profilePath: json['profile_path'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}

class Crew {
  final int id;
  final String name;
  final String job;
  final String department;
  final String profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    required this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      job: json['job'] ?? 'N/A',
      department: json['department'] ?? 'N/A',
      profilePath: json['profile_path'] ?? '',
    );
  }
}

class Video {
  final String key;
  final String name;
  final String site;
  final String type;

  Video({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      key: json['key'] ?? '',
      name: json['name'] ?? 'Video',
      site: json['site'] ?? 'YouTube',
      type: json['type'] ?? 'Trailer',
    );
  }
}
