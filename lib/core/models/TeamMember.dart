// Dans core/models/TeamMember.dart
class TeamMember {
  final String id;
  final String fullName;
  final String specialty;
  final String? email;
  final String? userId;

  TeamMember({
    required this.id,
    required this.fullName,
    required this.specialty,
    this.email,
    this.userId,
  });

  // Ajoutez aussi les méthodes fromJson/toJson si nécessaire
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'specialty': specialty,
      'email': email,
      'userId': userId,
    };
  }

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      specialty: json['specialty'] ?? '',
      email: json['email'],
      userId: json['userId'],
    );
  }
}