import 'dart:convert';

Students studentsFromJson(String str) => Students.fromJson(json.decode(str));

String studentsToJson(Students data) => json.encode(data.toJson());

class Students {
    List<Student> data;

    Students({
        required this.data,
    });

    factory Students.fromJson(Map<String, dynamic> json) => Students(
        data: List<Student>.from(json["data"].map((x) => Student.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Student {
    String id;
    String nim;
    String name;

    Student({
        required this.id,
        required this.nim,
        required this.name,
    });

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        nim: json["nim"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nim": nim,
        "name": name,
    };
}
