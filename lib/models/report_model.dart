import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReportModel {
  String id;
  String title;
  String date;
  String description;
  String location;
  ReportModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.location,
  });

  ReportModel copyWith({
    String? id,
    String? title,
    String? date,
    String? description,
    String? location,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'location': location,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      title: map['title'] as String,
      date: map['date'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) => ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReportModel(id: $id, title: $title, date: $date, description: $description, location: $location)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.description == description &&
      other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      description.hashCode ^
      location.hashCode;
  }
}
