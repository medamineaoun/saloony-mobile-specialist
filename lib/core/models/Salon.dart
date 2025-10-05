import 'package:flutter/material.dart';

// Enum pour le type de compte
enum AccountType {
  solo,
  team,
}

// Enum pour le rôle de membre
enum TeamMemberRole {
  barber,
  coiffeur,
  estheticienne,
  maquilleuse,
}

// Modèle pour les informations du compte
class AccountInfo {
  final String firstName;
  final String lastName;
  final String businessName;
  final String email;
  final String phoneNumber;

  AccountInfo({
    required this.firstName,
    required this.lastName,
    required this.businessName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'businessName': businessName,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}

// Modèle pour les détails de l'entreprise
class BusinessDetails {
  final String? logoPath;
  final String description;
  final String address;

  BusinessDetails({
    this.logoPath,
    required this.description,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'logoPath': logoPath,
    'description': description,
    'address': address,
  };
}

// Modèle pour la disponibilité
class DayAvailability {
  final String day;
  bool isAvailable;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DayAvailability({
    required this.day,
    this.isAvailable = false,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'day': day,
    'isAvailable': isAvailable,
    'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
    'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
  };
}

// Modèle pour un service
class SalonService {
  final String id;
  final String? imagePath;
  final String name;
  final String description;
  final List<ServiceType> serviceTypes;

  SalonService({
    required this.id,
    this.imagePath,
    required this.name,
    required this.description,
    this.serviceTypes = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'name': name,
    'description': description,
    'serviceTypes': serviceTypes.map((st) => st.toJson()).toList(),
  };
}

// Modèle pour un type de service
class ServiceType {
  final String name;
  final double price;
  final int durationMinutes;

  ServiceType({
    required this.name,
    required this.price,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'durationMinutes': durationMinutes,
  };
}

// Modèle pour un membre de l'équipe
class TeamMember {
  final String id;
  final String? imagePath;
  final String fullName;
  final String specialty;
  final TeamMemberRole? platformRole;
  final String email;
  final bool invitationPending;

  TeamMember({
    required this.id,
    this.imagePath,
    required this.fullName,
    required this.specialty,
    this.platformRole,
    required this.email,
    this.invitationPending = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'fullName': fullName,
    'specialty': specialty,
    'platformRole': platformRole?.toString(),
    'email': email,
    'invitationPending': invitationPending,
  };
}

// Modèle complet pour la création du salon
class SalonCreationData {
  AccountType accountType;
  AccountInfo? accountInfo;
  BusinessDetails? businessDetails;
  List<DayAvailability> availability;
  List<SalonService> services;
  List<TeamMember> teamMembers;

  SalonCreationData({
    this.accountType = AccountType.solo,
    this.accountInfo,
    this.businessDetails,
    List<DayAvailability>? availability,
    this.services = const [],
    this.teamMembers = const [],
  }) : availability = availability ?? _getDefaultAvailability();

  static List<DayAvailability> _getDefaultAvailability() {
    return [
      DayAvailability(day: 'Lundi'),
      DayAvailability(day: 'Mardi'),
      DayAvailability(day: 'Mercredi'),
      DayAvailability(day: 'Jeudi'),
      DayAvailability(day: 'Vendredi'),
      DayAvailability(day: 'Samedi'),
      DayAvailability(day: 'Dimanche'),
    ];
  }

  Map<String, dynamic> toJson() => {
    'accountType': accountType.toString(),
    'accountInfo': accountInfo?.toJson(),
    'businessDetails': businessDetails?.toJson(),
    'availability': availability.map((a) => a.toJson()).toList(),
    'services': services.map((s) => s.toJson()).toList(),
    'teamMembers': teamMembers.map((tm) => tm.toJson()).toList(),
  };
}