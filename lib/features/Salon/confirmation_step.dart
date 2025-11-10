// views/confirmation_step.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/additional_service.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';

class ConfirmationStep extends StatelessWidget {
  final SalonCreationViewModel vm;

  const ConfirmationStep({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'Confirmation',
            subtitle: 'Review your salon information',
            icon: Icons.fact_check_outlined,
          ),
          const SizedBox(height: 32),
          
          // Success Banner
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
          
          // Basic Info
          _buildSummaryCard([
            _SummaryItem(
              icon: Icons.business_outlined,
              label: 'Salon Name',
              value: vm.businessNameController.text,
            ),
            _SummaryItem(
              icon: Icons.category_outlined,
              label: 'Category',
              value: vm.selectedCategory?.displayName ?? 'N/A',
            ),
            _SummaryItem(
              icon: Icons.people_outline,
              label: 'Gender Type',
              value: vm.selectedGenderTypeForUI ?? 'N/A',
            ),
          ]),
          
          const SizedBox(height: 12),
          
          // Location & Availability
          _buildSummaryCard([
            _SummaryItem(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: vm.location?.address ?? 'Not set',
              highlight: vm.location != null,
            ),
            _SummaryItem(
              icon: Icons.calendar_today_outlined,
              label: 'Working Days',
              value: '${vm.availability.where((d) => d.isAvailable).length} days',
              highlight: vm.availability.any((d) => d.isAvailable),
            ),
          ]),
          
          const SizedBox(height: 12),
          
          // ✅ Additional Services Section
          if (vm.selectedAdditionalServices.isNotEmpty) ...[
            _buildSectionHeader('Additional Services', Icons.add_business_outlined),
            const SizedBox(height: 12),
            _buildAdditionalServicesCard(),
            const SizedBox(height: 12),
          ],
          
          // ✅ Treatments Section
          if (vm.selectedTreatmentIds.isNotEmpty) ...[
            _buildSectionHeader('Selected Treatments', Icons.spa_outlined),
            const SizedBox(height: 12),
            _buildTreatmentsCard(),
            const SizedBox(height: 12),
          ],
          
          // ✅ Custom Services Section
          if (vm.customServices.isNotEmpty) ...[
            _buildSectionHeader('Custom Services', Icons.star_outline),
            const SizedBox(height: 12),
            _buildCustomServicesCard(),
            const SizedBox(height: 12),
          ],
          
          // Team Members
          if (vm.teamMembers.isNotEmpty) ...[
            _buildSectionHeader('Team Members', Icons.group_outlined),
            const SizedBox(height: 12),
            _buildTeamMembersCard(),
            const SizedBox(height: 12),
          ],
          
          // Summary Stats
          _buildSummaryCard([
            _SummaryItem(
              icon: Icons.spa_outlined,
              label: 'Total Services',
              value: '${vm.selectedTreatmentIds.length + vm.customServices.length}',
              highlight: (vm.selectedTreatmentIds.length + vm.customServices.length) > 0,
            ),
            _SummaryItem(
              icon: Icons.group_outlined,
              label: 'Team Size',
              value: '${vm.teamMembers.length + 1} ${vm.teamMembers.isEmpty ? 'specialist' : 'specialists'}',
              highlight: true,
            ),
          ]),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B2B3E).withOpacity(0.1),
                const Color(0xFFF0CD97).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1B2B3E), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B2B3E),
          ),
        ),
      ],
    );
  }

  // ✅ Additional Services Card
  Widget _buildAdditionalServicesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${vm.selectedAdditionalServices.length}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'services selected',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: vm.selectedAdditionalServices.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1B2B3E).withOpacity(0.08),
                      const Color(0xFFF0CD97).withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFF0CD97).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getServiceIcon(service),
                      size: 16,
                      color: const Color(0xFF1B2B3E),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getServiceLabel(service),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ✅ Treatments Card (API treatments)
  Widget _buildTreatmentsCard() {
    final selectedTreatments = vm.availableTreatments
        .where((t) => vm.selectedTreatmentIds.contains(t.treatmentId))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${selectedTreatments.length}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'treatments selected',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...selectedTreatments.map((treatment) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.spa,
                      color: Color(0xFFF0CD97),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treatment.treatmentName ?? 'N/A',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        if (treatment.treatmentDescription != null &&
                            treatment.treatmentDescription!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            treatment.treatmentDescription!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (treatment.treatmentPrice != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2B3E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$${treatment.treatmentPrice!.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF0CD97),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ✅ Custom Services Card
  Widget _buildCustomServicesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${vm.customServices.length}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'custom services',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...vm.customServices.map((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF0CD97).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: service.photoPath == null
                          ? const LinearGradient(
                              colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                            )
                          : null,
                      image: service.photoPath != null
                          ? DecorationImage(
                              image: FileImage(File(service.photoPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: service.photoPath == null
                        ? const Icon(
                            Icons.star,
                            color: Color(0xFFF0CD97),
                            size: 24,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0CD97).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'CUSTOM',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (service.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            service.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2B3E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF0CD97),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Team Members Card
  Widget _buildTeamMembersCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${vm.teamMembers.length}',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'team members',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...vm.teamMembers.map((member) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        member.fullName.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 18,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.specialty,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
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

  // Helper methods for Additional Services
  IconData _getServiceIcon(AdditionalService service) {
    switch (service) {
      case AdditionalService.wifi:
        return Icons.wifi;
      case AdditionalService.tv:
        return Icons.tv;
      case AdditionalService.backgroundMusic:
        return Icons.music_note;
      case AdditionalService.airConditioning:
        return Icons.ac_unit;
      case AdditionalService.heating:
        return Icons.local_fire_department;
      case AdditionalService.coffeeTea:
        return Icons.coffee;
      case AdditionalService.drinksSnacks:
        return Icons.local_cafe;
      case AdditionalService.freeParking:
        return Icons.local_parking;
      case AdditionalService.paidParking:
        return Icons.paid;
      case AdditionalService.publicTransportAccess:
        return Icons.directions_bus;
      case AdditionalService.wheelchairAccessible:
        return Icons.accessible;
      case AdditionalService.childFriendly:
        return Icons.child_care;
      case AdditionalService.shower:
        return Icons.shower;
      case AdditionalService.lockers:
        return Icons.lock;
      case AdditionalService.creditCardAccepted:
        return Icons.credit_card;
      case AdditionalService.mobilePayment:
        return Icons.phone_android;
      case AdditionalService.securityCameras:
        return Icons.security;
      case AdditionalService.petFriendly:
        return Icons.pets;
      case AdditionalService.noPets:
        return Icons.pets_outlined;
      case AdditionalService.smokingAllowed:
        return Icons.smoking_rooms;
      case AdditionalService.nonSmoking:
        return Icons.smoke_free;
    }
  }

  String _getServiceLabel(AdditionalService service) {
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
        return 'Drinks';
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
        return 'Credit Card';
      case AdditionalService.mobilePayment:
        return 'Mobile Pay';
      case AdditionalService.securityCameras:
        return 'Security';
      case AdditionalService.petFriendly:
        return 'Pet Friendly';
      case AdditionalService.noPets:
        return 'No Pets';
      case AdditionalService.smokingAllowed:
        return 'Smoking OK';
      case AdditionalService.nonSmoking:
        return 'Non-Smoking';
    }
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