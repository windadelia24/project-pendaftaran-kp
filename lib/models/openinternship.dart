class OpenInternship {
  String status;
  String message;
  List<Proposal> proposals;

  OpenInternship({
    required this.status,
    required this.message,
    required this.proposals,
  });

  factory OpenInternship.fromJson(Map<String, dynamic> json) {
    var list = json['proposals'] as List;
    List<Proposal> proposalsList = list.map((i) => Proposal.fromJson(i)).toList();
    return OpenInternship(
      status: json['status'],
      message: json['message'],
      proposals: proposalsList,
    );
  }
}

class Proposal {
  String companyName;
  String title;
  String jobDesc;
  DateTime startAt;
  DateTime endAt;

  Proposal({
    required this.companyName,
    required this.title,
    required this.jobDesc,
    required this.startAt,
    required this.endAt,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      companyName: json['company_name'],
      title: json['title'],
      jobDesc: json['job_desc'],
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
    );
  }
}
