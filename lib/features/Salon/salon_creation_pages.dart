import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/LocalisationPage.dart' hide LocationResult;

class SalonCreationFlow extends StatelessWidget {
  const SalonCreationFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalonCreationViewModel(),
      child: const SalonCreationScreen(),
    );
  }
}

class SalonCreationScreen extends StatelessWidget {
  const SalonCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFF1B2B3E),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Your Salon',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isCreatingSalon
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B2B3E)),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Creating your salon...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildProgressBar(vm),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildStepContent(context, vm),
                    ),
                  ),
                ),
                _buildBottomButton(context, vm),
              ],
            ),
    );
  }

  Widget _buildProgressBar(SalonCreationViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Step ${vm.currentStep + 1} of 7',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const Spacer(),
              Text(
                '${(vm.progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF0CD97),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: vm.progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE1E2E2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1B2B3E)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, SalonCreationViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: vm.canContinue
                  ? [const Color(0xFF1B2B3E), const Color(0xFF243441)]
                  : [Colors.grey[400]!, Colors.grey[400]!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: vm.canContinue
                ? [
                    BoxShadow(
                      color: const Color(0xFF1B2B3E).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: vm.canContinue ? () => vm.nextStep(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              vm.currentStep == 6 ? 'Finish' : 'Continue',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF0CD97),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, SalonCreationViewModel vm) {
    switch (vm.currentStep) {
      case 0:
        return _accountTypeStep(context, vm);
      case 1:
        return _accountInfoStep(context, vm);
      case 2:
        return _businessDetailsStep(context, vm);
      case 3:
        return _availabilityStep(context, vm);
      case 4:
        return _treatmentsStep(context, vm); // Nouveau: sélection des traitements
      case 5:
        return _teamStep(context, vm);
      case 6:
      default:
        return _confirmationStep(context, vm);
    }
  }

  Widget _accountTypeStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the type of account that suits your business',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        _buildAccountTypeCard(
          title: 'Solo Barber',
          subtitle: 'Perfect for independent professionals',
          icon: Icons.person_outline_rounded,
          isSelected: vm.accountType == AccountType.solo,
          onTap: () => vm.setAccountType(AccountType.solo),
        ),
        const SizedBox(height: 16),
        _buildAccountTypeCard(
          title: 'Salon with Team',
          subtitle: 'Manage multiple staff members',
          icon: Icons.groups_outlined,
          isSelected: vm.accountType == AccountType.team,
          onTap: () => vm.setAccountType(AccountType.team),
        ),
      ],
    );
  }

  Widget _buildAccountTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1B2B3E).withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1B2B3E).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFF0CD97) : Colors.grey[600],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1B2B3E),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _accountInfoStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about yourself and your business',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        _buildTextField(
          label: 'First Name',
          hint: 'Enter your first name',
          icon: Icons.person_outline_rounded,
          controller: vm.firstNameController,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Last Name',
          hint: 'Enter your last name',
          icon: Icons.person_outline_rounded,
          controller: vm.lastNameController,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Business Name',
          hint: 'Enter your business name',
          icon: Icons.store_outlined,
          controller: vm.businessNameController,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          controller: vm.emailController,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Phone Number',
          hint: 'Enter your phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          controller: vm.phoneController,
        ),
      ],
    );
  }

  Widget _businessDetailsStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Details',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add photos and location information',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        
        // Photo Upload
        GestureDetector(
          onTap: () => vm.pickImage(),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: vm.businessImagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B2B3E).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: Color(0xFFF0CD97),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Upload Photo/Logo',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      vm.businessImagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Description
        _buildTextField(
          label: 'About',
          hint: 'Tell us about your salon',
          icon: Icons.description_outlined,
          maxLines: 4,
          controller: vm.descriptionController,
        ),
        const SizedBox(height: 20),
        
        // Salon Category Dropdown
        _buildDropdownField(
          label: 'Salon Category',
          hint: 'Select category',
          icon: Icons.category_outlined,
          items: ['BARBERSHOP', 'BEAUTY_SALON', 'SPA', 'NAIL_SALON'],
          onChanged: (value) => vm.setSalonCategory(value!),
        ),
        const SizedBox(height: 20),
        
        // Gender Type
        _buildDropdownField(
          label: 'Customer Gender',
          hint: 'Select gender type',
          icon: Icons.wc_outlined,
          items: ['MALE', 'FEMALE', 'UNISEX'],
          onChanged: (value) => vm.setGenderType(value!),
        ),
        const SizedBox(height: 20),
        
        // Additional Services (Multi-select chips)
        Text(
          'Additional Services',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['WIFI', 'PARKING', 'AIR_CONDITIONING', 'COFFEE']
              .map((service) => _buildServiceChip(service, vm))
              .toList(),
        ),
        const SizedBox(height: 20),
        
        // Address
        _buildTextField(
          label: 'Address',
          hint: 'Enter your business address',
          icon: Icons.location_on_outlined,
          controller: vm.addressController,
        ),
        const SizedBox(height: 16),
        
        // Map Picker Button
        OutlinedButton.icon(
          onPressed: () async {
            final result = await Navigator.push<LocationResult?>(
              context,
              MaterialPageRoute(builder: (_) =>  LocalisationPage()),
            );
            if (result != null) {
              vm.setLocation(result);
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1B2B3E)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.map_outlined, color: Color(0xFF1B2B3E)),
          label: Text(
            vm.location == null ? 'Choose Location on Map' : 'Location Selected ✓',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B2B3E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceChip(String service, SalonCreationViewModel vm) {
    final isSelected = vm.selectedAdditionalServices.contains(service);
    return FilterChip(
      label: Text(service.replaceAll('_', ' ')),
      selected: isSelected,
      onSelected: (_) => vm.toggleAdditionalService(service),
      selectedColor: const Color(0xFF1B2B3E).withOpacity(0.2),
      checkmarkColor: const Color(0xFFF0CD97),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[700],
      ),
    );
  }

  Widget _availabilityStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set your working days',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(vm.availability.length, (index) {
          final day = vm.availability[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: day.isAvailable
                        ? const Color(0xFF1B2B3E).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: day.isAvailable ? const Color(0xFFF0CD97) : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    day.day,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                ),
                Switch(
                  value: day.isAvailable,
                  onChanged: (_) => vm.toggleDayAvailability(index),
                  activeColor: const Color(0xFF1B2B3E),
                  activeTrackColor: const Color(0xFFF0CD97),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // NOUVEAU: Étape de sélection des traitements
  Widget _treatmentsStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services & Treatments',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the treatments you offer',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        
        if (vm.availableTreatments.isEmpty)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          ...vm.availableTreatments.map((treatment) {
            final isSelected = vm.selectedTreatmentIds.contains(treatment.treatmentId);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1B2B3E).withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: CheckboxListTile(
                value: isSelected,
                onChanged: (_) => vm.toggleTreatmentSelection(treatment.treatmentId),
                title: Text(
                  treatment.treatmentName,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                subtitle: Text(
                  treatment.treatmentDescription,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1B2B3E).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.spa_outlined,
                    color: isSelected ? const Color(0xFFF0CD97) : Colors.grey,
                  ),
                ),
                activeColor: const Color(0xFF1B2B3E),
                checkColor: const Color(0xFFF0CD97),
              ),
            );
          }),
      ],
    );
  }

  Widget _teamStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Members',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          vm.accountType == AccountType.solo
              ? 'Optional: Add team members'
              : 'Add your team members',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => vm.showAddTeamMemberDialog(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1B2B3E), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.person_add_outlined, color: Color(0xFFF0CD97)),
          label: Text(
            'Add Team Member',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B2B3E),
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (vm.teamMembers.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.people_outline, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No team members added yet',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          ...vm.teamMembers.map((member) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF1B2B3E).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFF0CD97),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.fullName,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                          Text(
                            member.specialty,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => vm.removeTeamMember(member.id),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _confirmationStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmation',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Review your salon information',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B2B3E).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 60,
                color: Color(0xFFF0CD97),
              ),
              const SizedBox(height: 16),
              Text(
                'Almost Done!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Click finish to create your salon',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSummaryItem('Account Type', vm.accountType == AccountType.solo ? 'Solo Barber' : 'Salon with Team'),
        _buildSummaryItem('Business Name', vm.businessNameController.text),
        _buildSummaryItem('Treatments', '${vm.selectedTreatmentIds.length} treatments selected'),
        _buildSummaryItem('Team Members', '${vm.teamMembers.length} members'),
        _buildSummaryItem('Location', vm.location != null ? 'Location set ✓' : 'Not set'),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B2B3E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFF0CD97),
              size: 22,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF1B2B3E),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFF0CD97),
              size: 22,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF1B2B3E),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.replaceAll('_', ' '),
                style: GoogleFonts.poppins(fontSize: 15),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}