
import 'package:flutter/material.dart';
import 'package:saloony/core/models/team_member.dart';

class TeamViewModel extends ChangeNotifier {
  List<TeamMember> _members = [
    TeamMember(
      id: '1',
      name: 'Chalo Garcia',
      specialty: 'Styliste',
      email: 'chalo.garcia@example.com',
    ),
    TeamMember(
      id: '2',
      name: 'Chalo Garcia',
      specialty: 'Styliste',
      email: 'chalo.garcia2@example.com',
    ),
    TeamMember(
      id: '3',
      name: 'Chalo Garcia',
      specialty: 'Styliste',
      email: 'chalo.garcia3@example.com',
    ),
    TeamMember(
      id: '4',
      name: 'Chalo Garcia',
      specialty: 'Styliste',
      email: 'chalo.garcia4@example.com',
    ),
  ];

  List<TeamMember> get members => _members;
  int get memberCount => _members.length;

  void addMember(TeamMember member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(TeamMember updatedMember) {
    final index = _members.indexWhere((m) => m.id == updatedMember.id);
    if (index != -1) {
      _members[index] = updatedMember;
      notifyListeners();
    }
  }

  void deleteMember(String memberId) {
    _members.removeWhere((m) => m.id == memberId);
    notifyListeners();
  }

  TeamMember? getMemberById(String id) {
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  void filterMembers(String query) {
    if (query.isEmpty) {
      notifyListeners();
      return;
    }
    // Implement filter logic if needed
    notifyListeners();
  }
}

