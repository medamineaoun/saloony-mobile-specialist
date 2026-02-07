import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:SaloonySpecialist/features/Salon/views/AdditionalServicesPage.dart';
import 'package:SaloonySpecialist/features/Salon/views/DisponibiliteView.dart';
import 'package:SaloonySpecialist/features/Salon/view_models/SalonCreationViewModel.dart';
import 'package:SaloonySpecialist/features/Salon/views/ServicesManagementPage.dart';
import 'package:SaloonySpecialist/features/Salon/views/account_info_step.dart';
import 'package:SaloonySpecialist/features/Salon/views/business_details_step.dart';
import 'package:SaloonySpecialist/features/Salon/views/confirmation_step.dart';
import 'package:SaloonySpecialist/features/Salon/views/team_members_list_view.dart';
import 'package:SaloonySpecialist/features/Salon/widgets/bottom_button.dart';
import 'package:SaloonySpecialist/features/Salon/widgets/progress_bar.dart';


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
          onPressed: () {
            // Si on est à la première étape, quitter le flow
            if (vm.currentStep == 0) {
              Navigator.pop(context);
            } else {
              // Sinon, revenir à l'étape précédente
              vm.previousStep();
            }
          },
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
          ? _buildLoadingState()
          : Column(
              children: [
                ProgressBar(vm: vm),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildStepContent(context, vm),
                    ),
                  ),
                ),
                BottomButton(vm: vm),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
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
    );
  }

  Widget _buildStepContent(BuildContext context, SalonCreationViewModel vm) {
    switch (vm.currentStep) {
      case 0:
        return AccountInfoStep(vm: vm);
      case 1:
        return BusinessDetailsStep(vm: vm);
      case 2:
        return AdditionalServicesStep(vm: vm);
      case 3:
        return AvailabilityPage(vm: vm);
      case 4:
        return ServicesManagementPage(vm: vm, salonId: null);
      case 5:
        return TeamManagementPage(vm: vm);
      case 6:
      default:
        return ConfirmationStep(vm: vm);
    }
  }
}