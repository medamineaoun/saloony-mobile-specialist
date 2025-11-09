// views/confirmation_step.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';


class ConfirmationStep extends StatelessWidget {
  final SalonCreationViewModel vm;

  const ConfirmationStep({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Confirmation',
          subtitle: 'Review your salon information',
          icon: Icons.fact_check_outlined,
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