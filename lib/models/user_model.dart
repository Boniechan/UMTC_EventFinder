class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String college;
  final String courseProgram;
  final String yearLevel;
  final String userType; // 'admin' or 'student'

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.college,
    required this.courseProgram,
    required this.yearLevel,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'college': college,
      'courseProgram': courseProgram,
      'yearLevel': yearLevel,
      'userType': userType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      college: map['college'] ?? '',
      courseProgram: map['courseProgram'] ?? '',
      yearLevel: map['yearLevel'] ?? '',
      userType: map['userType'] ?? 'student',
    );
  }
}
