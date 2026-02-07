import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../../../core/widgets/SaloonyCommonWidgets.dart' hide SaloonyInputField, SaloonyTextButton, SaloonyPrimaryButton, SaloonySecondaryButton;
import '../../../core/widgets/SaloonyInputFields.dart';
import '../viewmodels/SignInViewModel.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Consumer<SignInViewModel>(
        builder: (context, viewModel, _) => _SignInView(viewModel: viewModel),
      ),
    );
  }
}

class _SignInView extends StatelessWidget {
  final SignInViewModel viewModel;

  const _SignInView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: SaloonyColors.backgroundSecondary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeaderImage(),
                    const SizedBox(height: 32),
                    _buildTitle(),
                    const SizedBox(height: 48),
                    _buildEmailField(),
                    const SizedBox(height: 24),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildForgotPassword(context),
                    const SizedBox(height: 32),
                    _buildSignInButton(context),
                    const SizedBox(height: 32),
                    SaloonyDividerWithText(text: 'Or continue with'),
                    const SizedBox(height: 24),
                    _buildSocialButtons(context),
                    const SizedBox(height: 32),
                    _buildSignUpLink(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Image d'en-tête avec fallback dégradé
  Widget _buildHeaderImage() {
    return Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/img.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildFallbackImage(),
          ),
        ),
      ),
    );
  }

  /// Image de remplacement avec dégradé
  Widget _buildFallbackImage() {
    return SaloonyGradientContainer(
      colors: const [SaloonyColors.primary, SaloonyColors.navy],
      padding: EdgeInsets.zero,
      child: const Icon(
        Icons.content_cut_rounded,
        size: 80,
        color: SaloonyColors.secondary,
      ),
    );
  }

  /// Titre et sous-titre
  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          textAlign: TextAlign.center,
          style: SaloonyTextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to Saloony',
          textAlign: TextAlign.center,
          style: SaloonyTextStyles.subtitle,
        ),
      ],
    );
  }

  /// Champ email
  Widget _buildEmailField() {
    return SaloonyInputField(
      controller: viewModel.emailController,
      label: 'Email',
      hintText: 'Enter your email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Email is required';
        }
        return null;
      },
    );
  }

  /// Champ mot de passe
  Widget _buildPasswordField() {
    return SaloonyInputField(
      controller: viewModel.passwordController,
      label: 'Password',
      hintText: 'Enter your password',
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: !viewModel.passwordVisible,
      suffixIcon: viewModel.passwordVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      onSuffixIconTap: viewModel.togglePasswordVisibility,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Password is required';
        }
        return null;
      },
    );
  }

  /// Lien mot de passe oublié
  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SaloonyTextButton(
        label: 'Forgot Password?',
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.forgotPassword,
        ),
      ),
    );
  }

  /// Bouton de connexion
  Widget _buildSignInButton(BuildContext context) {
    return SaloonyPrimaryButton(
      label: 'Sign In',
      isLoading: viewModel.isLoading,
      onPressed: viewModel.isLoading 
          ? () {}
          : () => viewModel.signIn(context),
    );
  }

  /// Boutons de connexion sociale
  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            icon: Icons.facebook,
            label: 'Facebook',
            onTap: () {
              // TODO: Implémenter login Facebook
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SocialButton(
            icon: Icons.mail_outline,
            label: 'Google',
            onTap: () {
              // TODO: Implémenter login Google
            },
          ),
        ),
      ],
    );
  }

  /// Lien d'inscription
  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: SaloonyTextStyles.bodySmall,
          ),
          SaloonyTextButton(
            label: 'Sign Up',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SaloonySecondaryButton(
      label: label,
      icon: icon,
      onPressed: onTap,
      isFullWidth: true,
    );
  }
}