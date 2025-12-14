import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String college;
  final String category;
  final String organizer;
  final int capacity;
  final String? imageUrl;
  final List<String> tags;
  final List<String> attendees;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.college,
    required this.category,
    required this.organizer,
    required this.capacity,
    this.imageUrl,
    this.tags = const [],
    this.attendees = const [],
    required this.createdAt,
  });

  int get availableSpots => capacity - attendees.length;
  bool get isFull => attendees.length >= capacity;
  double get fillPercentage =>
      capacity > 0 ? (attendees.length / capacity) * 100 : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'college': college,
      'category': category,
      'organizer': organizer,
      'capacity': capacity,
      'imageUrl': imageUrl,
      'tags': tags,
      'attendees': attendees,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: _parseDateTime(map['date']),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      location: map['location'] ?? '',
      college: map['college'] ?? '',
      category: map['category'] ?? '',
      organizer: map['organizer'] ?? '',
      capacity: map['capacity'] ?? 0,
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      attendees: List<String>.from(map['attendees'] ?? []),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue is Timestamp) {
      return dateValue.toDate();
    } else if (dateValue is String) {
      return DateTime.parse(dateValue);
    } else {
      return DateTime.now();
    }
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? college,
    String? category,
    String? organizer,
    int? capacity,
    String? imageUrl,
    List<String>? tags,
    List<String>? attendees,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      college: college ?? this.college,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      capacity: capacity ?? this.capacity,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      attendees: attendees ?? this.attendees,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
