class Report {
  String? id;

  final String name;
  final String department;
  final String activity;

  Report(
      {this.id,
      required this.name,
      required this.department,
      required this.activity});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      name: json['name'] as String,
      department: json['department'] as String,
      activity: json['activity'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'department': department,
        'activity': activity,
      };

  Report copyWith({
    String? id,
    String? name,
    String? department,
    String? activity,
  }) {
    return Report(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      activity: activity ?? this.activity,
    );
  }
}
