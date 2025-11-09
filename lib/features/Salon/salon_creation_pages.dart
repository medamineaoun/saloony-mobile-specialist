import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/enum/additional_service.dart';
import 'package:saloony/features/Salon/AdditionalServicesPage.dart';
import 'package:saloony/features/Salon/DisponibiliteView.dart';
import 'package:saloony/features/Salon/LocalisationPage.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/location_result.dart';
import 'package:saloony/features/Salon/ServicesManagementPage.dart';
import 'package:saloony/features/Salon/team_members_list_view.dart';

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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Color(0xFF1B2B3E),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Your Salon',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B2B3E),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: vm.isCreatingSalon
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B2B3E).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B2B3E)),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Creating your salon...',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait a moment',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
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
                    physics: const BouncingScrollPhysics(),
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B3E).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Step ${vm.currentStep + 1}/7',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${(vm.progress * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF0CD97),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EBF0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: vm.progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2B3E), Color(0xFFF0CD97)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B2B3E).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            gradient: vm.canContinue
                ? const LinearGradient(
                    colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[300]!],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: vm.canContinue
                ? [
                    BoxShadow(
                      color: const Color(0xFF1B2B3E).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
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
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  vm.currentStep == 6 ? 'Create Salon' : 'Continue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: vm.canContinue ? Colors.white : Colors.grey[500],
                    letterSpacing: 0.3,
                  ),
                ),
                if (vm.canContinue) ...[
                  const SizedBox(width: 8),
                  Icon(
                    vm.currentStep == 6 ? Icons.check_circle : Icons.arrow_forward_rounded,
                    color: const Color(0xFFF0CD97),
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildStepContent(BuildContext context, SalonCreationViewModel vm) {
  switch (vm.currentStep) {
    case 0:
      return _accountInfoStep(context, vm);
    case 1:
      return _businessDetailsStep(context, vm);
    case 2:
      return _additionalServicesStep(context, vm); // NOUVELLE ÉTAPE
    case 3:
      return _availabilityStep(context, vm);
    case 4:
      return _treatmentsStep(context, vm);
    case 5:
      return _teamStep(context, vm);
    case 6:
    default:
      return _confirmationStep(context, vm);
  }
}
  Widget _accountInfoStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Account Information',
          'Tell us about yourself and your business',
          Icons.account_circle_outlined,
        ),
        const SizedBox(height: 32),
        _buildTextField(
          label: 'Salon Name',
          hint: 'Enter your business name',
          icon: Icons.storefront_outlined,
          controller: vm.businessNameController,
        ),
        const SizedBox(height: 24),
        _buildLabel('Salon Category'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
     child: DropdownButtonFormField<SalonCategory>(
  value: vm.selectedCategory,
  decoration: InputDecoration(
    labelText: 'Salon Category',
    labelStyle: GoogleFonts.inter(
      color: Colors.grey[600],
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: const Icon(
      Icons.category_outlined,
      color: Color(0xFFF0CD97),
      size: 22,
    ),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFF0CD97), width: 1.8),
    ),
  ),
  icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFF0CD97)),
  dropdownColor: Colors.white,
  borderRadius: BorderRadius.circular(12),
  style: GoogleFonts.inter(
    fontSize: 15,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  ),
  items: SalonCategory.values.map((category) {
    return DropdownMenuItem<SalonCategory>(
      value: category,
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            category.displayName,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }).toList(),
  onChanged: (value) => vm.setCategory(value!),
),
        ),
      ],
    );
  }

Widget _businessDetailsStep(BuildContext context, SalonCreationViewModel vm) {
  final size = MediaQuery.of(context).size;

  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'Business Details',
            'Add salon photos, category, and location information',
            Icons.business_outlined,
          ),

          const SizedBox(height: 32),

          // --- Salon Image Upload Section ---
          GestureDetector(
            onTap: vm.pickImage,
            child: Container(
              width: double.infinity,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: vm.businessImagePath == null
                      ? Colors.grey[300]!
                      : const Color(0xFFF0CD97),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: vm.businessImagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF0CD97).withOpacity(0.1),
                                const Color(0xFF1B2B3E).withOpacity(0.05),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 42,
                            color: Color(0xFF1B2B3E),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Upload Salon Photo',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'JPG, PNG (Max 5MB)',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(vm.businessImagePath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 32),

       // --- Gender Type Dropdown ---
_buildLabel('Gender Type *'),
const SizedBox(height: 6),
Container(
  decoration: BoxDecoration(
    color: Colors.grey[50],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300, width: 1),
  ),
  child: DropdownButtonFormField<String>(
    value: vm.selectedGenderTypeString,
    decoration: InputDecoration(
      prefixIcon: const Icon(
        Icons.people_outline,
        color: Color(0xFFF0CD97),
        size: 22,
      ),
      hintText: 'Select gender type',
      hintStyle: GoogleFonts.inter(
        color: Colors.grey[500],
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Colors.grey,
      size: 22,
    ),
    style: GoogleFonts.inter(
      color: Colors.black87,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    dropdownColor: Colors.white,
    items: vm.availableGenderTypesStrings.map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(
          type,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList(),
    onChanged: (value) {
      if (value != null) vm.setGenderTypeFromString(value);
    },
  ),
),
const SizedBox(height: 28),

          // --- Description ---
          _buildTextField(
            label: 'Description',
            hint: 'Tell us about your salon',
            icon: Icons.description_outlined,
            maxLines: 4,
            controller: vm.descriptionController,
          ),

          const SizedBox(height: 28),

          // --- Location Section ---
          _buildLocationSection(context, vm),

          const SizedBox(height: 28),

          // --- Additional Address Details ---
          _buildTextField(
            label: 'Additional Address Details (Optional)',
            hint: 'Floor, Building name, Landmark, etc.',
            icon: Icons.location_city_outlined,
            controller: vm.additionalAddressController,
          ),

          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}
Widget _additionalServicesStep(BuildContext context, SalonCreationViewModel vm) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildStepHeader(
        'Additional Services',
        'Select amenities and facilities you offer',
        Icons.emoji_food_beverage_outlined,
      ),
      const SizedBox(height: 32),
      
      // Bouton pour naviguer vers la page des services additionnels
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1B2B3E).withOpacity(0.05),
              const Color(0xFFF0CD97).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0CD97).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_food_beverage_outlined,
                    color: Color(0xFF1B2B3E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ' Services',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Select WiFi, parking, amenities and other services that make your salon stand out',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<List<AdditionalService>?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdditionalServicesPage(
                        initialServices: vm.selectedAdditionalServices,
                      ),
                    ),
                  );
                  
                  if (result != null) {
                    vm.setAdditionalServices(result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2B3E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      vm.selectedAdditionalServices.isEmpty 
                          ? Icons.add_circle_outline 
                          : Icons.edit_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      vm.selectedAdditionalServices.isEmpty 
                          ? 'Select Additional Services' 
                          : 'Edit Selected Services',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Affichage des services sélectionnés
            if (vm.selectedAdditionalServices.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF0CD97).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${vm.selectedAdditionalServices.length} services selected',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: vm.selectedAdditionalServices.take(5).map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2B3E).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getAdditionalServiceLabel(service),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (vm.selectedAdditionalServices.length > 5) ...[
                      const SizedBox(height: 8),
                      Text(
                        '+ ${vm.selectedAdditionalServices.length - 5} more',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      
      const SizedBox(height: 24),
      
      // Section d'information
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B3E).withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Adding services helps customers find your salon and improves your visibility in search results.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Méthode utilitaire pour obtenir le libellé d'un service
String _getAdditionalServiceLabel(AdditionalService service) {
  switch (service) {
    case AdditionalService.wifi:
      return 'WiFi';
    case AdditionalService.tv:
      return 'TV';
    case AdditionalService.backgroundMusic:
      return 'Music';
    case AdditionalService.airConditioning:
      return 'A/C';
    case AdditionalService.heating:
      return 'Heating';
    case AdditionalService.coffeeTea:
      return 'Coffee & Tea';
    case AdditionalService.drinksSnacks:
      return 'Drinks & Snacks';
    case AdditionalService.freeParking:
      return 'Free Parking';
    case AdditionalService.paidParking:
      return 'Paid Parking';
    case AdditionalService.publicTransportAccess:
      return 'Public Transport';
    case AdditionalService.wheelchairAccessible:
      return 'Wheelchair Access';
    case AdditionalService.childFriendly:
      return 'Child Friendly';
    case AdditionalService.shower:
      return 'Shower';
    case AdditionalService.lockers:
      return 'Lockers';
    case AdditionalService.creditCardAccepted:
      return 'Credit Cards';
    case AdditionalService.mobilePayment:
      return 'Mobile Payment';
    case AdditionalService.securityCameras:
      return 'Security';
    case AdditionalService.petFriendly:
      return 'Pet Friendly';
    case AdditionalService.noPets:
      return 'No Pets';
    case AdditionalService.smokingAllowed:
      return 'Smoking Allowed';
    case AdditionalService.nonSmoking:
      return 'Non-Smoking';
  }
}
  Widget _buildLocationSection(BuildContext context, SalonCreationViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2B3E).withOpacity(0.05),
            const Color(0xFFF0CD97).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD97).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF1B2B3E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Business Location',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<LocationResult?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalisationPage(
                      initialLocation: vm.location,
                    ),
                  ),
                );
                if (result != null) {
                  vm.setLocation(result);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vm.location == null ? Icons.add_location_alt : Icons.edit_location_alt_outlined,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vm.location == null ? 'Select Location on Map' : 'Update Location',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (vm.location != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0CD97).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Confirmed',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${vm.location!.latitude.toStringAsFixed(6)}, ${vm.location!.longitude.toStringAsFixed(6)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.blue[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pin your exact location for accurate directions',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
Widget _availabilityStep(BuildContext context, SalonCreationViewModel vm) {
  return const AvailabilityPage();
}


  Widget _treatmentsStep(BuildContext context, SalonCreationViewModel vm) {
  return const ServicesManagementPage();
}

  Widget _teamStep(BuildContext context, SalonCreationViewModel vm) {
  return const TeamManagementPage();
 }

  Widget _confirmationStep(BuildContext context, SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Confirmation',
          'Review your salon information',
          Icons.fact_check_outlined,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B2B3E).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: Color(0xFFF0CD97),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Almost Done!',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your salon is ready to be created',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSummaryCard([
          _SummaryItem(
            icon: Icons.business_outlined,
            label: 'Salon Name',
            value: vm.businessNameController.text,
          ),
          _SummaryItem(
            icon: Icons.category_outlined,
            label: 'Category',
            value: vm.selectedCategory?.name.replaceAll('_', ' ') ?? 'N/A',
          ),
        ]),
        const SizedBox(height: 12),
        _buildSummaryCard([
          _SummaryItem(
            icon: Icons.spa_outlined,
            label: 'Treatments',
            value: '${vm.selectedTreatmentIds.length} selected',
            highlight: vm.selectedTreatmentIds.isNotEmpty,
          ),
          _SummaryItem(
            icon: Icons.group_outlined,
            label: 'Team Members',
            value: '${vm.teamMembers.length} members',
            highlight: vm.teamMembers.isNotEmpty,
          ),
        ]),
        const SizedBox(height: 12),
        _buildSummaryCard([
          _SummaryItem(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: vm.location != null ? 'Location set ✓' : 'Not set',
            highlight: vm.location != null,
          ),
          _SummaryItem(
            icon: Icons.calendar_today_outlined,
            label: 'Working Days',
            value: '${vm.availability.where((d) => d.isAvailable).length} days',
            highlight: vm.availability.any((d) => d.isAvailable),
          ),
        ]),
      ],
    );
  }

  Widget _buildSummaryCard(List<_SummaryItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1B2B3E).withOpacity(0.1),
                            const Color(0xFFF0CD97).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: item.highlight 
                                  ? const Color(0xFF1B2B3E) 
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.highlight)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.green[600],
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
              if (index < items.length - 1)
                Divider(height: 1, color: Colors.grey[200]),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1B2B3E).withOpacity(0.1),
                    const Color(0xFFF0CD97).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1B2B3E),
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B2B3E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1B2B3E),
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
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1B2B3E),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 15,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFF0CD97),
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines > 1 ? 16 : 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryItem {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });
}