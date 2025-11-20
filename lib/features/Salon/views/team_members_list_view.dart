import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/services/TokenHelper.dart';
import 'package:saloony/features/Salon/view_models/SalonCreationViewModel.dart';
import 'package:saloony/core/models/TeamMember.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class TeamManagementPage extends StatefulWidget {
  final SalonCreationViewModel vm;

  const TeamManagementPage({super.key, required this.vm});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddMemberSection(context, vm),
            const SizedBox(height: 16),
            _buildTeamMembersList(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMemberSection(BuildContext context, SalonCreationViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B3E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  color: Color(0xFF1B2B3E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Team Member',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                    Text(
                      'Search specialist by email',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddMemberDialog(context, vm),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.search, size: 18),
              label: Text(
                'Search',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersList(SalonCreationViewModel vm) {
    if (vm.teamMembers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: vm.teamMembers.map((member) =>
        _buildMemberCard(context, vm, member)
      ).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 40,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No Team Members',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add specialists to get started',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, SalonCreationViewModel vm, TeamMember member) {
    final String status = member.status.toUpperCase();
    final Color statusColor = status == 'ACTIVE' ? Colors.green : 
                             status == 'PENDING' ? Colors.orange : Colors.red;
    final String statusText = status == 'ACTIVE' ? 'Active' : 
                             status == 'PENDING' ? 'Pending' : 'Blocked';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: member.profilePhotoPath != null && member.profilePhotoPath!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(member.profilePhotoPath!),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: member.profilePhotoPath == null || member.profilePhotoPath!.isEmpty
                  ? const LinearGradient(
                      colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                    )
                  : null,
            ),
            child: member.profilePhotoPath == null || member.profilePhotoPath!.isEmpty
                ? Center(
                    child: Text(
                      _getInitials(member.fullName),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF0CD97),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        member.email ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Delete button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () => _confirmDeleteMember(context, vm, member.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, SalonCreationViewModel vm) {
    final emailController = TextEditingController();
    bool isVerifying = false;
    bool isVerified = false;
    String? verificationMessage;
    Map<String, dynamic>? specialistData;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B2B3E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          color: Color(0xFF1B2B3E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add Team Member',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: Icon(Icons.close, color: Colors.grey.shade600, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Address',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email Input
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isVerified 
                                        ? Colors.green.shade400
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.inter(fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'specialist@example.com',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.grey.shade400,
                                      fontSize: 13,
                                    ),
                                    prefixIcon: Icon(
                                      isVerified ? Icons.check_circle : Icons.email_outlined,
                                      color: isVerified ? Colors.green : Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, 
                                      vertical: 12,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (isVerified) {
                                      setDialogState(() {
                                        isVerified = false;
                                        verificationMessage = null;
                                        specialistData = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: isVerifying
                                  ? null
                                  : () async {
                                      if (emailController.text.trim().isEmpty) {
                                        ToastService.showError(context, 'Please enter an email');
                                        return;
                                      }

                                      setDialogState(() {
                                        isVerifying = true;
                                        verificationMessage = null;
                                        isVerified = false;
                                        specialistData = null;
                                      });

                                      try {
                                        final result = await vm.verifySpecialistByEmail(
                                          emailController.text.trim(),
                                        );

                                        setDialogState(() {
                                          isVerifying = false;
                                          if (result['success'] == true && result['specialist'] != null) {
                                            isVerified = true;
                                            specialistData = result['specialist'];
                                            verificationMessage = 'Specialist found';
                                          } else {
                                            isVerified = false;
                                            verificationMessage = result['message'] ?? 'Not found';
                                          }
                                        });
                                      } catch (e) {
                                        setDialogState(() {
                                          isVerifying = false;
                                          isVerified = false;
                                          verificationMessage = 'Error verifying';
                                        });
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B2B3E),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 12,
                                ),
                                disabledBackgroundColor: Colors.grey.shade300,
                              ),
                              child: isVerifying
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Verify',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),

                        // Message
                        if (verificationMessage != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isVerified 
                                  ? Colors.green.shade50 
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isVerified ? Icons.check_circle : Icons.error_outline,
                                  size: 16,
                                  color: isVerified ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    verificationMessage!,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isVerified ? Colors.green.shade900 : Colors.red.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Specialist Card
                        if (isVerified && specialistData != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: _getSpecialistValue(specialistData, 'profilePhotoPath').isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(_getSpecialistValue(specialistData, 'profilePhotoPath')),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    gradient: _getSpecialistValue(specialistData, 'profilePhotoPath').isEmpty
                                        ? const LinearGradient(
                                            colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                                          )
                                        : null,
                                  ),
                                  child: _getSpecialistValue(specialistData, 'profilePhotoPath').isEmpty
                                      ? Center(
                                          child: Text(
                                            _getInitials(_getFullName(specialistData)),
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFF0CD97),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getFullName(specialistData),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1B2B3E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        emailController.text.trim(),
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (!isVerified || specialistData == null)
                              ? null
                              : () async {
                                  final userId = _getSpecialistValue(specialistData, 'userId');
                                  
                                  if (vm.teamMembers.any((m) => m.userId == userId)) {
                                    Navigator.pop(dialogContext);
                                    ToastService.showWarning(context, 'Specialist already in team');
                                    return;
                                  }
                                  
                                  final String? currentUserId = await _getCurrentUserId();
                                  if (userId == currentUserId) {
                                    Navigator.pop(dialogContext);
                                    ToastService.showWarning(context, 'Cannot add yourself');
                                    return;
                                  }
                                  
                                  final member = TeamMember(
                                    id: userId,
                                    fullName: _getFullName(specialistData),
                                    email: emailController.text.trim(),
                                    userId: userId,
                                    profilePhotoPath: _getSpecialistValue(specialistData, 'profilePhotoPath').isNotEmpty 
                                        ? _getSpecialistValue(specialistData, 'profilePhotoPath') 
                                        : null,
                                    status: _getSpecialistValue(specialistData, 'userStatus', 'PENDING'),
                                  );
                                  
                                  vm.addTeamMember(member);
                                  Navigator.pop(dialogContext);
                                  ToastService.showSuccess(context, 'Member added successfully');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B2B3E),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteMember(BuildContext context, SalonCreationViewModel vm, String memberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Remove Member',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Remove this member from team?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(fontSize: 14)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.removeTeamMember(memberId);
              Navigator.pop(context);
              ToastService.showSuccess(context, 'Member removed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text('Remove', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _getSpecialistValue(Map<String, dynamic>? data, String key, [String defaultValue = '']) {
    if (data == null) return defaultValue;
    final value = data[key];
    if (value is String) return value.isNotEmpty ? value : defaultValue;
    if (value == null) return defaultValue;
    return value.toString();
  }

  String _getFullName(Map<String, dynamic>? data) {
    if (data == null) return 'Unknown';
    
    if (data.containsKey('fullName') && data['fullName'] != null) {
      final fullName = data['fullName'].toString().trim();
      if (fullName.isNotEmpty) return fullName;
    }
    
    final firstName = _getSpecialistValue(data, 'userFirstName');
    final lastName = _getSpecialistValue(data, 'userLastName');
    final combinedName = '$firstName $lastName'.trim();
    
    return combinedName.isNotEmpty ? combinedName : 'Unknown';
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Future<String?> _getCurrentUserId() async {
    try {
      final authService = AuthService();
      final token = await authService.getAccessToken();
      return TokenHelper.getUserId(token);
    } catch (e) {
      debugPrint('Error getting current user ID: $e');
      return null;
    }
  }
}