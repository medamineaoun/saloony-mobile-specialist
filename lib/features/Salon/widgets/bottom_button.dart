// widgets/bottom_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/features/Salon/view_models/SalonCreationViewModel.dart';

class BottomButton extends StatelessWidget {
  final SalonCreationViewModel vm;

  const BottomButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
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
}