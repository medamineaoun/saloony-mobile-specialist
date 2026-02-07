// views/account_info_step.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';

class AccountInfoStep extends StatelessWidget {
  final SalonCreationViewModel vm;

  const AccountInfoStep({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'Account Information',
            subtitle: 'Tell us about yourself and your salon',
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 32),
          _buildTextField(
            label: 'Salon Name',
            hint: 'Enter your salon name',
            icon: Icons.storefront_outlined,
            controller: vm.salonNameController,
          ),
          const SizedBox(height: 24),
          _buildCategoryDropdown(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Salon Category'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<SalonCategory>(
            value: vm.selectedCategory,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            items: SalonCategory.values.map((category) {
              return DropdownMenuItem<SalonCategory>(
                value: category,
                child: Row(
                  children: [
                    Image.asset(
                      category.imagePath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.displayName,
                      style: const TextStyle(fontSize: 16),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}