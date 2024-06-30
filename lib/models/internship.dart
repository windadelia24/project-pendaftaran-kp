class Internship {
  String status;
  String message;
  List<InternshipElement> internships;

  Internship({
    required this.status,
    required this.message,
    required this.internships,
  });

  factory Internship.fromJson(Map<String, dynamic> json) => Internship(
    status: json["status"],
    message: json["message"],
    internships: List<InternshipElement>.from(json["internships"].map((x) => InternshipElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "internships": List<dynamic>.from(internships.map((x) => x.toJson())),
  };
}

class InternshipElement {
  String id;
  String? title;
  String company;
  DateTime? startAt;
  DateTime? endAt;
  String status;
  DateTime? seminarDate;
  String grade;
  String lecturer;

  InternshipElement({
    required this.id,
    this.title,
    required this.company,
    this.startAt,
    this.endAt,
    required this.status,
    this.seminarDate,
    required this.grade,
    required this.lecturer,
  });

  factory InternshipElement.fromJson(Map<String, dynamic> json) => InternshipElement(
    id: json["id"],
    title: json["title"],
    company: json["company"],
    startAt: json["start_at"] == null ? null : DateTime.parse(json["start_at"]),
    endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
    status: json["status"],
    seminarDate: json["seminar_date"] == null ? null : DateTime.parse(json["seminar_date"]),
    grade: json["grade"],
    lecturer: json["lecturer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "company": company,
    "start_at": startAt?.toIso8601String(),
    "end_at": endAt?.toIso8601String(),
    "status": status,
    "seminar_date": seminarDate?.toIso8601String(),
    "grade": grade,
    "lecturer": lecturer,
  };
}
