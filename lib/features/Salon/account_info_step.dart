// views/account_info_step.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';


class AccountInfoStep extends StatelessWidget {
  final SalonCreationViewModel vm;

  const AccountInfoStep({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Account Information',
          subtitle: 'Tell us about yourself and your business',
          icon: Icons.account_circle_outlined,
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
}