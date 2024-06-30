import 'dart:convert';

Proposal proposalFromJson(String str) => Proposal.fromJson(json.decode(str));

String proposalToJson(Proposal data) => json.encode(data.toJson());

class Proposal {
    String status;
    String message;
    ProposalClass proposal;

    Proposal({
        required this.status,
        required this.message,
        required this.proposal,
    });

    factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
        status: json["status"],
        message: json["message"],
        proposal: ProposalClass.fromJson(json["proposal"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "proposal": proposal.toJson(),
    };
}

class ProposalClass {
    String companyId;
    int type;
    String title;
    String jobDesc;
    DateTime startAt;
    DateTime endAt;
    String status;
    String id;
    DateTime updatedAt;
    DateTime createdAt;

    ProposalClass({
        required this.companyId,
        required this.type,
        required this.title,
        required this.jobDesc,
        required this.startAt,
        required this.endAt,
        required this.status,
        required this.id,
        required this.updatedAt,
        required this.createdAt,
    });

    factory ProposalClass.fromJson(Map<String, dynamic> json) => ProposalClass(
        companyId: json["company_id"],
        type: json["type"],
        title: json["title"],
        jobDesc: json["job_desc"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: DateTime.parse(json["end_at"]),
        status: json["status"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "type": type,
        "title": title,
        "job_desc": jobDesc,
        "start_at": startAt.toIso8601String(),
        "end_at": endAt.toIso8601String(),
        "status": status,
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
    };
}