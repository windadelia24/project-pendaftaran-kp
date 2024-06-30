import 'dart:convert';

Editproposal editproposalFromJson(String str) => Editproposal.fromJson(json.decode(str));

String editproposalToJson(Editproposal data) => json.encode(data.toJson());

class Editproposal {
    String status;
    String message;
    Proposal proposal;

    Editproposal({
        required this.status,
        required this.message,
        required this.proposal,
    });

    factory Editproposal.fromJson(Map<String, dynamic> json) => Editproposal(
        status: json["status"],
        message: json["message"],
        proposal: Proposal.fromJson(json["proposal"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "proposal": proposal.toJson(),
    };
}

class Proposal {
    String id;
    String companyId;
    int type;
    String title;
    String jobDesc;
    DateTime startAt;
    DateTime endAt;
    String status;
    dynamic note;
    int active;
    dynamic responseLetter;
    dynamic background;
    DateTime createdAt;
    DateTime updatedAt;
    List<Internship> internships;

    Proposal({
        required this.id,
        required this.companyId,
        required this.type,
        required this.title,
        required this.jobDesc,
        required this.startAt,
        required this.endAt,
        required this.status,
        required this.note,
        required this.active,
        required this.responseLetter,
        required this.background,
        required this.createdAt,
        required this.updatedAt,
        required this.internships,
    });

    factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
        id: json["id"],
        companyId: json["company_id"],
        type: json["type"],
        title: json["title"],
        jobDesc: json["job_desc"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: DateTime.parse(json["end_at"]),
        status: json["status"],
        note: json["note"],
        active: json["active"],
        responseLetter: json["response_letter"],
        background: json["background"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        internships: List<Internship>.from(json["internships"].map((x) => Internship.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "type": type,
        "title": title,
        "job_desc": jobDesc,
        "start_at": startAt.toIso8601String(),
        "end_at": endAt.toIso8601String(),
        "status": status,
        "note": note,
        "active": active,
        "response_letter": responseLetter,
        "background": background,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "internships": List<dynamic>.from(internships.map((x) => x.toJson())),
    };
}

class Internship {
    String id;
    String internshipProposalId;
    String studentId;
    dynamic advisorId;
    String status;
    dynamic startAt;
    dynamic endAt;
    dynamic reportTitle;
    dynamic seminarDate;
    dynamic seminarRoomId;
    dynamic linkSeminar;
    dynamic seminarDeadline;
    dynamic attendeesList;
    dynamic internshipScore;
    dynamic activityReport;
    dynamic seminarNotes;
    dynamic workReport;
    dynamic certificate;
    dynamic reportReceipt;
    dynamic grade;
    DateTime createdAt;
    DateTime updatedAt;

    Internship({
        required this.id,
        required this.internshipProposalId,
        required this.studentId,
        required this.advisorId,
        required this.status,
        required this.startAt,
        required this.endAt,
        required this.reportTitle,
        required this.seminarDate,
        required this.seminarRoomId,
        required this.linkSeminar,
        required this.seminarDeadline,
        required this.attendeesList,
        required this.internshipScore,
        required this.activityReport,
        required this.seminarNotes,
        required this.workReport,
        required this.certificate,
        required this.reportReceipt,
        required this.grade,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Internship.fromJson(Map<String, dynamic> json) => Internship(
        id: json["id"],
        internshipProposalId: json["internship_proposal_id"],
        studentId: json["student_id"],
        advisorId: json["advisor_id"],
        status: json["status"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        reportTitle: json["report_title"],
        seminarDate: json["seminar_date"],
        seminarRoomId: json["seminar_room_id"],
        linkSeminar: json["link_seminar"],
        seminarDeadline: json["seminar_deadline"],
        attendeesList: json["attendees_list"],
        internshipScore: json["internship_score"],
        activityReport: json["activity_report"],
        seminarNotes: json["seminar_notes"],
        workReport: json["work_report"],
        certificate: json["certificate"],
        reportReceipt: json["report_receipt"],
        grade: json["grade"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "internship_proposal_id": internshipProposalId,
        "student_id": studentId,
        "advisor_id": advisorId,
        "status": status,
        "start_at": startAt,
        "end_at": endAt,
        "report_title": reportTitle,
        "seminar_date": seminarDate,
        "seminar_room_id": seminarRoomId,
        "link_seminar": linkSeminar,
        "seminar_deadline": seminarDeadline,
        "attendees_list": attendeesList,
        "internship_score": internshipScore,
        "activity_report": activityReport,
        "seminar_notes": seminarNotes,
        "work_report": workReport,
        "certificate": certificate,
        "report_receipt": reportReceipt,
        "grade": grade,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}