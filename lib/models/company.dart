import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
    List<CompanyData> data;

    Company({
        required this.data,
    });

    factory Company.fromJson(Map<String, dynamic> json) => Company(
        data: List<CompanyData>.from(json["data"].map((x) => CompanyData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CompanyData {
    String id;
    String name;

    CompanyData({
        required this.id,
        required this.name,
    });

    factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
