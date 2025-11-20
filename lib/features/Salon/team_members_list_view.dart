import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/services/TokenHelper.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/core/models/TeamMember.dart';
import 'package:saloony/core/services/AuthService.dart';

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
            _buildStepHeader(),
            const SizedBox(height: 24),
            _buildAddMemberSection(context, vm),
            const SizedBox(height: 24),
            _buildTeamMembersList(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMemberSection(BuildContext context, SalonCreationViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2B3E).withOpacity(0.05),
            const Color(0xFFF0CD97).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B3E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  color: Color(0xFF1B2B3E),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Add Team Member',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for a specialist by email to add them to your team',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddMemberDialog(context, vm),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              icon: const Icon(Icons.search_outlined, size: 20),
              label: Text(
                'Search Specialist',
                style: GoogleFonts.inter(
                  fontSize: 15,
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
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Team Members',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Add specialists to your team to get started',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, SalonCreationViewModel vm, TeamMember member) {
    // ✅ CORRECTION: Utiliser le statut réel du membre
    final String status = member.status.toUpperCase();
    
    // ✅ CORRECTION: Utiliser des couleurs concrètes
    final Color statusBackgroundColor = status == 'ACTIVE' ? Colors.green.shade50 : 
                                        status == 'PENDING' ? Colors.orange.shade50 : 
                                        Colors.red.shade50;
    
    final Color statusTextColor = status == 'ACTIVE' ? Colors.green.shade700 : 
                                  status == 'PENDING' ? Colors.orange.shade700 : 
                                  Colors.red.shade700;
    
    final String statusText = status == 'ACTIVE' ? 'Active' : 
                              status == 'PENDING' ? 'Pending' : 'Blocked';
    
    final IconData statusIcon = status == 'ACTIVE' ? Icons.check_circle : 
                                status == 'PENDING' ? Icons.schedule : Icons.block;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0CD97).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 400;

          return Row(
            children: [
              // ✅ CORRECTION: Photo du spécialiste ou image par défaut
              Container(
                width: isSmallScreen ? 50 : 60,
                height: isSmallScreen ? 50 : 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: member.profilePhotoPath != null && member.profilePhotoPath!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(member.profilePhotoPath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  gradient: member.profilePhotoPath != null && member.profilePhotoPath!.isNotEmpty
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                        ),
                ),
                child: member.profilePhotoPath != null && member.profilePhotoPath!.isNotEmpty
                    ? null
                    : Center(
                        child: Text(
                          _getInitials(member.fullName),
                          style: GoogleFonts.inter(
                            fontSize: isSmallScreen ? 16 : 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF0CD97),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B2B3E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // ✅ CORRECTION: Status badge avec couleur dynamique
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Specialty
                   
                  ],
                ),
              ),
              
              // Actions
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade600,
                        size: 18,
                      ),
                    ),
                    onPressed: () => _confirmDeleteMember(context, vm, member.id),
                  ),
                ],
              ),
            ],
          );
        },
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
    if (data == null) return 'Unknown Specialist';
    
    if (data.containsKey('fullName') && data['fullName'] != null) {
      final fullName = data['fullName'].toString().trim();
      if (fullName.isNotEmpty) return fullName;
    }
    
    final firstName = _getSpecialistValue(data, 'userFirstName');
    final lastName = _getSpecialistValue(data, 'userLastName');
    final combinedName = '$firstName $lastName'.trim();
    
    return combinedName.isNotEmpty ? combinedName : 'Unknown Specialist';
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2B3E).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        color: Color(0xFF1B2B3E),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Team Member',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B2B3E),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Search for a specialist by email',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Input Section
                      Text(
                        'Email Address',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Email Input with Verify Button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isVerified 
                                      ? Colors.green.shade400
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade100,
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1B2B3E),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'specialist@example.com',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    isVerified ? Icons.check_circle_rounded : Icons.email_outlined,
                                    color: isVerified ? Colors.green.shade600 : Colors.grey.shade400,
                                    size: 22,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, 
                                    vertical: 16,
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
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: isVerifying
                                ? null
                                : () async {
                                    if (emailController.text.trim().isEmpty) {
                                      setDialogState(() {
                                        verificationMessage = 'Please enter an email address';
                                      });
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
                                          verificationMessage = 'Specialist found successfully';
                                        } else {
                                          isVerified = false;
                                          verificationMessage = result['message'] ?? 'No specialist found with this email';
                                        }
                                      });
                                    } catch (e) {
                                      setDialogState(() {
                                        isVerifying = false;
                                        isVerified = false;
                                        verificationMessage = 'Error: Unable to verify specialist';
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B2B3E),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24, 
                                vertical: 16,
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            child: isVerifying
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Verify',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ],
                      ),

                      // Verification Message
                      if (verificationMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isVerified 
                                ? Colors.green.shade50 
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isVerified 
                                  ? Colors.green.shade200 
                                  : Colors.red.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isVerified 
                                    ? Icons.check_circle_rounded 
                                    : Icons.error_outline_rounded,
                                size: 20,
                                color: isVerified 
                                    ? Colors.green.shade700 
                                    : Colors.red.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  verificationMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isVerified 
                                        ? Colors.green.shade900 
                                        : Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Specialist Card
                      if (isVerified && specialistData != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Photo
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  image: _getSpecialistValue(specialistData, 'profilePhotoPath').isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(_getSpecialistValue(specialistData, 'profilePhotoPath')),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  gradient: _getSpecialistValue(specialistData, 'profilePhotoPath').isEmpty
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xFF1B2B3E),
                                            const Color(0xFF2A3F54),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  border: Border.all(
                                    color: const Color(0xFFF0CD97),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: const Offset(0, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: _getSpecialistValue(specialistData, 'profilePhotoPath').isEmpty
                                    ? Center(
                                        child: Text(
                                          _getInitials(_getFullName(specialistData)),
                                          style: GoogleFonts.inter(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFF0CD97),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),

                              // Specialist Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getFullName(specialistData),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B2B3E),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Email
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            emailController.text.trim(),
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Phone
                                    if (specialistData!['phoneNumber'] != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _getSpecialistValue(specialistData, 'phoneNumber'),
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],

                                    const SizedBox(height: 12),
                                    _buildSpecialistStatus(specialistData!),
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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      offset: const Offset(0, -1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: (!isVerified || specialistData == null)
                          ? null
                          : () async {
                              final userId = _getSpecialistValue(specialistData, 'userId');
                              
                              final bool alreadyAdded = vm.teamMembers.any((m) => m.userId == userId);
                              
                              if (alreadyAdded) {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.info_outline_rounded, color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'This specialist is already in your team',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.orange.shade600,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                                return;
                              }
                              
                              final String? currentUserId = await _getCurrentUserId();
                              if (userId == currentUserId) {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.info_outline_rounded, color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'You cannot add yourself to the team',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.orange.shade600,
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                                return;
                              }
                              
                              final fullName = _getFullName(specialistData);
                              final email = emailController.text.trim();
                              final profilePhotoPath = _getSpecialistValue(specialistData, 'profilePhotoPath');
                              final status = _getSpecialistValue(specialistData, 'userStatus', 'PENDING');
                              
                              final member = TeamMember(
                                id: userId,
                                fullName: fullName,
                                email: email,
                                userId: userId,
                                profilePhotoPath: profilePhotoPath.isNotEmpty ? profilePhotoPath : null,
                                status: status,
                              );
                              
                              vm.addTeamMember(member);
                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '$fullName added successfully',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green.shade600,
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2B3E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Add to Team',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
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
  Widget _buildSpecialistStatus(Map<String, dynamic> specialistData) {
    final String status = _getSpecialistValue(specialistData, 'userStatus', 'PENDING').toUpperCase();
    
    final Color statusColor = status == 'ACTIVE' ? Colors.green : 
                             status == 'PENDING' ? Colors.orange : 
                             Colors.red;
    
    final String statusText = status == 'ACTIVE' ? 'Active' : 
                             status == 'PENDING' ? 'Pending' : 'Blocked';
    
    final IconData statusIcon = status == 'ACTIVE' ? Icons.check_circle : 
                               status == 'PENDING' ? Icons.schedule : Icons.block;

    return Row(
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildStepHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(children: []);
      },
    );
  }

  void _confirmDeleteMember(BuildContext context, SalonCreationViewModel vm, String memberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Member',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to remove this member from the team?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              vm.removeTeamMember(memberId);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Member removed from the team',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.orange.shade600,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text('Remove', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer l'ID de l'utilisateur connecté
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