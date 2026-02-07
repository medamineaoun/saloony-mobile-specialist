import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/features/Salon/view_models/SalonCreationViewModel.dart';

class ProgressBar extends StatelessWidget {
  final SalonCreationViewModel vm;

  const ProgressBar({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
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
}