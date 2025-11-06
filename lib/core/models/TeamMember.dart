/// Modèle pour un membre de l'équipe
class TeamMember {
  final String id;
  final String fullName;
  final String specialty;
  final String? email;
  final String? phoneNumber;
  final String? profilePhoto;
  final bool isPending; // En attente d'acceptation
  final DateTime? invitedAt;

  TeamMember({
    required this.id,
    required this.fullName,
    required this.specialty,
    this.email,
    this.phoneNumber,
    this.profilePhoto,
    this.isPending = true,
    this.invitedAt,
  });

  /// Créer depuis JSON
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      specialty: json['specialty'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePhoto: json['profilePhoto'],
      isPending: json['isPending'] ?? true,
      invitedAt: json['invitedAt'] != null
          ? DateTime.parse(json['invitedAt'])
          : null,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'specialty': specialty,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'isPending': isPending,
      'invitedAt': invitedAt?.toIso8601String(),
    };
  }

  /// Copier avec modifications
  TeamMember copyWith({
    String? id,
    String? fullName,
    String? specialty,
    String? email,
    String? phoneNumber,
    String? profilePhoto,
    bool? isPending,
    DateTime? invitedAt,
  }) {
    return TeamMember(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isPending: isPending ?? this.isPending,
      invitedAt: invitedAt ?? this.invitedAt,
    );
  }

  @override
  String toString() {
    return 'TeamMember(id: $id, fullName: $fullName, specialty: $specialty, isPending: $isPending)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamMember && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}