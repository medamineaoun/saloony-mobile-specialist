import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:saloony/features/Salon/views/LocalisationPage.dart';
import 'package:saloony/features/Salon/view_models/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/views/location_result.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';

class BusinessDetailsStep extends StatelessWidget {
  final SalonCreationViewModel vm;

  const BusinessDetailsStep({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(
              title: 'salon Details',
              subtitle: 'Add salon photos, category, and location information',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 32),

            // Salon Image Upload
            GestureDetector(
              onTap: vm.pickImage,
              child: Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: vm.salonImagePath == null
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
                child: vm.salonImagePath == null
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
                              File(vm.salonImagePath!),
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

            // Gender Type Dropdown
            _buildLabel('Customer  Type *'),
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
                  hintText: 'Select Customer  type',
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

            // Description
            _buildTextField(
              label: 'Description',
              hint: 'Tell us about your salon',
              icon: Icons.description_outlined,
              maxLines: 4,
              controller: vm.descriptionController,
            ),

            const SizedBox(height: 28),

            // Location Section
            _buildLocationSection(context, vm),

            const SizedBox(height: 28),

            // Additional Address Details
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
    required TextEditingController controller,
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
                'Customer Location',
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
}