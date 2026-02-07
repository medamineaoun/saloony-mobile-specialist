import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/features/Appointment/views/AppointmentCardWidget.dart';
import 'package:SaloonySpecialist/features/Dashboard/viewmodels/DashboardViewModel.dart';
import 'package:SaloonySpecialist/features/Menu/views/SideMenuDialog.dart';
import 'package:SaloonySpecialist/features/Menu/viewmodels/MenuViewModel.dart' hide SideMenuDialog;


class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTodayAppointmentsCard(viewModel),
                  const SizedBox(height: 24),
                  _buildUpcomingSection(viewModel),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  _buildTrialBanner(viewModel),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
               
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF1B2B3E),
              size: 20,
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const SideMenuDialog(),
            );
          },
        ),
      ),
      title: Text(
        'Dashboard',
        style: GoogleFonts.poppins(
          color: const Color(0xFF1B2B3E),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2B3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(
              Icons.workspace_premium,
              size: 16,
              color: Color(0xFFF0CD97),
            ),
            label: Text(
              'Upgrade',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF0CD97),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayAppointmentsCard(DashboardViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD97).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFFF0CD97),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Today's Appointments",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            viewModel.nextAppointmentTime,
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF0CD97),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.green,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '+${viewModel.lastWeekPercentage}%',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'from last week',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection(DashboardViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming (${viewModel.upcomingAppointmentsCount})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF0CD97),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
       
      ],
    );
  }

  Widget _buildTrialBanner(DashboardViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2B3E).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0CD97).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFF0CD97),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${viewModel.daysRemaining} days remaining',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Free Team Trial',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0CD97),
              foregroundColor: const Color(0xFF1B2B3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            icon: const Icon(Icons.arrow_upward_rounded, size: 16),
            label: Text(
              'Upgrade',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}