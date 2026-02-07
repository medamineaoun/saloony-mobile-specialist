import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyInputFields.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../viewmodels/ForgotPasswordViewModel.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: SaloonyColors.backgroundSecondary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: SaloonyColors.borderLight),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            
                            // Image forgot password
                            Center(
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/forgot_password_illustration.jpg',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 180,
                                        height: 180,
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
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.lock_reset_rounded,
                                          size: 70,
                                          color: Color(0xFFF0CD97),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Titre
                            Text(
                              'Forgot Password?',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.heading1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enter your email address and we\'ll send you a code to reset your password',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.subtitle,
                            ),

                            const SizedBox(height: 48),

                            // Email input
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: SaloonyTextStyles.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                SaloonyInputField(
                                  controller: viewModel.emailController,
                                  label: '',
                                  hintText: 'Enter your email',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: viewModel.emailValidator,
                                  readOnly: viewModel.isLoading,
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Send Code button
                            SaloonyPrimaryButton(
                              label: 'Send Code',
                              isLoading: viewModel.isLoading,
                              onPressed: viewModel.isLoading ? () {} : () => viewModel.sendResetCode(context),
                            ),

                            const SizedBox(height: 24),

                            // Back to Sign In
                            Center(
                              child: TextButton(
                                onPressed: viewModel.isLoading ? null : () => Navigator.pop(context),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Remember your password? ",
                                        style: SaloonyTextStyles.bodySmall.copyWith(color: SaloonyColors.textSecondary),
                                      ),
                                      TextSpan(
                                        text: "Sign In",
                                        style: SaloonyTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: viewModel.isLoading ? SaloonyColors.textTertiary : SaloonyColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}