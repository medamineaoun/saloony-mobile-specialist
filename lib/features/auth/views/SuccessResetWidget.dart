import 'package:flutter/material.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../../../core/constants/app_routes.dart';

class SuccessResetWidget extends StatelessWidget {
  const SuccessResetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: SaloonyColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: SaloonyColors.success,
                  size: 80,
                ),
                const SizedBox(height: 32),
                Text(
                  'Password Reset',
                  style: SaloonyTextStyles.heading1,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your password has been reset successfully',
                  textAlign: TextAlign.center,
                  style: SaloonyTextStyles.bodyMedium.copyWith(color: SaloonyColors.textSecondary),
                ),
                const SizedBox(height: 40),
                SaloonyPrimaryButton(
                  label: 'Sign in',
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
