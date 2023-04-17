class Report {
  String? id;

  final String projectName;
  final String siteLocation;
  final String teamLeader;
  final DateTime date;
  final int workHours;
  final List<String> completedTasks;
  final List<String> pendingTasks;
  final List<String> materialsUsed;
  final List<String> issuesChallenges;
  final List<String> safetyIncidents;
  final List<String> progressPhotos;
  final String nextDayPlan;

  Report({
    this.id,
    required this.projectName,
    required this.siteLocation,
    required this.teamLeader,
    required this.date,
    required this.workHours,
    required this.completedTasks,
    required this.pendingTasks,
    required this.materialsUsed,
    required this.issuesChallenges,
    required this.safetyIncidents,
    required this.progressPhotos,
    required this.nextDayPlan,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      projectName: json['projectName'] as String,
      siteLocation: json['siteLocation'] as String,
      teamLeader: json['teamLeader'] as String,
      date: DateTime.parse(json['date'] as String),
      workHours: json['workHours'] as int,
      completedTasks: List<String>.from(json['completedTasks']),
      pendingTasks: List<String>.from(json['pendingTasks']),
      materialsUsed: List<String>.from(json['materialsUsed']),
      issuesChallenges: List<String>.from(json['issuesChallenges']),
      safetyIncidents: List<String>.from(json['safetyIncidents']),
      progressPhotos: List<String>.from(json['progressPhotos']),
      nextDayPlan: json['nextDayPlan'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'siteLocation': siteLocation,
        'teamLeader': teamLeader,
        'date': date.toIso8601String(),
        'workHours': workHours,
        'completedTasks': completedTasks,
        'pendingTasks': pendingTasks,
        'materialsUsed': materialsUsed,
        'issuesChallenges': issuesChallenges,
        'safetyIncidents': safetyIncidents,
        'progressPhotos': progressPhotos,
        'nextDayPlan': nextDayPlan,
      };

  Report copyWith({
    String? id,
    String? projectName,
    String? siteLocation,
    String? teamLeader,
    DateTime? date,
    int? workHours,
    List<String>? completedTasks,
    List<String>? pendingTasks,
    List<String>? materialsUsed,
    List<String>? issuesChallenges,
    List<String>? safetyIncidents,
    List<String>? progressPhotos,
    String? nextDayPlan,
  }) {
    return Report(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      siteLocation: siteLocation ?? this.siteLocation,
      teamLeader: teamLeader ?? this.teamLeader,
      date: date ?? this.date,
      workHours: workHours ?? this.workHours,
      completedTasks: completedTasks ?? this.completedTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      issuesChallenges: issuesChallenges ?? this.issuesChallenges,
      safetyIncidents: safetyIncidents ?? this.safetyIncidents,
      progressPhotos: progressPhotos ?? this.progressPhotos,
      nextDayPlan: nextDayPlan ?? this.nextDayPlan,
    );
  }
}
