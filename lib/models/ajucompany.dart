class AjuCompany {
  String name;
  String address;
  String id;
  DateTime updatedAt;
  DateTime createdAt;

  AjuCompany({
    required this.name,
    required this.address,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
  });

  factory AjuCompany.fromJson(Map<String, dynamic> json) {
    return AjuCompany(
      name: json['name'],
      address: json['address'],
      id: json['id'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
