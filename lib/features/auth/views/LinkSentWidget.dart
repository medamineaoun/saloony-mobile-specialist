import 'package:flutter/material.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyButtons.dart';
// no local input fields needed
import '../../../core/constants/app_routes.dart';

class LinkSentWidget extends StatelessWidget {
  const LinkSentWidget({Key? key}) : super(key: key);

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
                const SizedBox(height: 32),
                Icon(
                  Icons.email_outlined,
                  color: SaloonyColors.primary,
                  size: 80,
                ),
                const SizedBox(height: 32),
                Text(
                  'Link has been sent',
                  style: SaloonyTextStyles.heading1,
                ),
                const SizedBox(height: 16),
                Text(
                  'You’ll shortly receive an email with a code to setup a new password.',
                  textAlign: TextAlign.center,
                  style: SaloonyTextStyles.bodyMedium.copyWith(color: SaloonyColors.textSecondary),
                ),
                const SizedBox(height: 40),
                SaloonyPrimaryButton(
                  label: 'Done',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.resetPassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
