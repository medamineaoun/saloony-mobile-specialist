import 'package:flutter/material.dart';

enum SalonStatus {
  PENDING,
  ACTIVE,
  INACTIVE,
  SUSPENDED,
  CLOSED;

  String toJson() {
    return name;
  }

  static SalonStatus fromString(String value) {
    try {
      return SalonStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () => SalonStatus.PENDING,
      );
    } catch (e) {
      return SalonStatus.PENDING;
    }
  }

  String get displayName {
    switch (this) {
      case SalonStatus.PENDING:
        return 'En attente';
      case SalonStatus.ACTIVE:
        return 'Actif';
      case SalonStatus.INACTIVE:
        return 'Inactif';
      case SalonStatus.SUSPENDED:
        return 'Suspendu';
      case SalonStatus.CLOSED:
        return 'Fermé';
    }
  }

  String get displayNameEn {
    switch (this) {
      case SalonStatus.PENDING:
        return 'Pending';
      case SalonStatus.ACTIVE:
        return 'Active';
      case SalonStatus.INACTIVE:
        return 'Inactive';
      case SalonStatus.SUSPENDED:
        return 'Suspended';
      case SalonStatus.CLOSED:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case SalonStatus.PENDING:
        return Colors.orange;
      case SalonStatus.ACTIVE:
        return Colors.green;
      case SalonStatus.INACTIVE:
        return Colors.grey;
      case SalonStatus.SUSPENDED:
        return Colors.red;
      case SalonStatus.CLOSED:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case SalonStatus.PENDING:
        return Icons.pending;
      case SalonStatus.ACTIVE:
        return Icons.check_circle;
      case SalonStatus.INACTIVE:
        return Icons.pause_circle;
      case SalonStatus.SUSPENDED:
        return Icons.block;
      case SalonStatus.CLOSED:
        return Icons.cancel;
    }
  }

  bool get canAcceptBookings {
    return this == SalonStatus.ACTIVE;
  }

  bool get isVisibleInSearch {
    return this == SalonStatus.ACTIVE || this == SalonStatus.INACTIVE;
  }
}