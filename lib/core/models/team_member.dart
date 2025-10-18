// models/team_member.dart
class TeamMember {
  final String id;
  String name;
  String specialty;
  String email;
  String? profileImageUrl;

  TeamMember({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    this.profileImageUrl,
  });

  TeamMember copyWith({
    String? id,
    String? name,
    String? specialty,
    String? email,
    String? profileImageUrl,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'email': email,
    'profileImageUrl': profileImageUrl,
  };

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    id: json['id'],
    name: json['name'],
    specialty: json['specialty'],
    email: json['email'],
    profileImageUrl: json['profileImageUrl'],
  );
}
