import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../../../core/widgets/SaloonyInputFields.dart';
import '../viewmodels/sign_up_viewmodel.dart';
class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);
  static const String routeName = 'signUp';
  static const String routePath = '/signUp';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, _) {
          return _SignUpViewContent(viewModel: viewModel);
        },
      ),
    );
  }
}

class _SignUpViewContent extends StatelessWidget {
  final SignUpViewModel viewModel;

  const _SignUpViewContent({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.backgroundSecondary,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileImage(),
                      const SizedBox(height: 24),
                      _buildHeader(),
                      const SizedBox(height: 36),
                      _buildNameFields(),
                      const SizedBox(height: 20),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPhoneField(),
                      const SizedBox(height: 20),
                      _buildGenderSection(),
                      const SizedBox(height: 20),
                      _buildPasswordSection(),
                      const SizedBox(height: 24),
                      _buildTermsCheckbox(),
                      if (viewModel.termsError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            viewModel.termsError!,
                            style: SaloonyTextStyles.errorText,
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildSignUpButton(context),
                      const SizedBox(height: 20),
                      _buildSignInLink(context),
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
  }

  /// Construire la barre d'application
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: SaloonyColors.primary,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  /// Construire l'image de profil
  Widget _buildProfileImage() {
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
            'assets/images/bbb.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SaloonyColors.primary, SaloonyColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: SaloonyColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add_outlined,
                  size: 70,
                  color: SaloonyColors.secondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Construire l'en-tête
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: SaloonyTextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          "Sign up to get started with Saloony",
          textAlign: TextAlign.center,
          style: SaloonyTextStyles.subtitle,
        ),
      ],
    );
  }

  /// Construire les champs Prénom et Nom
  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: viewModel.firstNameController,
            enabled: !viewModel.isLoading,
            label: "First Name",
            hint: "Enter first name",
            icon: Icons.person_outline_rounded,
            validator: viewModel.validateFirstName,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: viewModel.lastNameController,
            enabled: !viewModel.isLoading,
            label: "Last Name",
            hint: "Enter last name",
            icon: Icons.person_outline_rounded,
            validator: viewModel.validateLastName,
          ),
        ),
      ],
    );
  }

  /// Construire le champ Email
  Widget _buildEmailField() {
    return _buildTextField(
      controller: viewModel.emailController,
      enabled: !viewModel.isLoading,
      label: "Email",
      hint: "Enter your email",
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: viewModel.validateEmail,
    );
  }

  /// Construire le champ Numéro de Téléphone
  Widget _buildPhoneField() {
    return _buildTextField(
      controller: viewModel.phoneController,
      enabled: !viewModel.isLoading,
      label: "Phone Number",
      hint: "Enter your phone number",
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: viewModel.validatePhone,
    );
  }

  /// Construire la section Genre
  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Gender", style: SaloonyTextStyles.labelMedium),
            const SizedBox(width: 4),
            Text("*", style: SaloonyTextStyles.errorText),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                label: "Man",
                value: "MEN",
                selectedValue: viewModel.selectedGender,
                onTap: () => viewModel.setGender("MEN"),
                isEnabled: !viewModel.isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderOption(
                label: "Woman",
                value: "WOMEN",
                selectedValue: viewModel.selectedGender,
                onTap: () => viewModel.setGender("WOMEN"),
                isEnabled: !viewModel.isLoading,
              ),
            ),
          ],
        ),
        if (viewModel.genderError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              viewModel.genderError!,
              style: SaloonyTextStyles.errorText,
            ),
          ),
      ],
    );
  }

  /// Construire la section Mot de Passe
  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Password", style: SaloonyTextStyles.labelMedium),
            const SizedBox(width: 4),
            Text("*", style: SaloonyTextStyles.errorText),
          ],
        ),
        const SizedBox(height: 8),
        SaloonyInputField(
          controller: viewModel.passwordController,
          label: '',
          hintText: "At least 8 characters",
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: !viewModel.passwordVisible,
          suffixIcon: viewModel.passwordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          onSuffixIconTap: viewModel.togglePasswordVisibility,
        ),
        const SizedBox(height: 12),
        _buildPasswordCriteriaBox(),
      ],
    );
  }

  /// Construire la boîte de critères de mot de passe
  Widget _buildPasswordCriteriaBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SaloonyColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password must contain:",
            style: SaloonyTextStyles.labelMedium,
          ),
          const SizedBox(height: 12),
          _buildPasswordCriteria(
            "At least 8 characters",
            viewModel.hasMinLength,
          ),
          const SizedBox(height: 8),
          _buildPasswordCriteria(
            "One uppercase letter (A-Z)",
            viewModel.hasUppercase,
          ),
          const SizedBox(height: 8),
          _buildPasswordCriteria(
            "One lowercase letter (a-z)",
            viewModel.hasLowercase,
          ),
          const SizedBox(height: 8),
          _buildPasswordCriteria(
            "One number (0-9)",
            viewModel.hasNumber,
          ),
          const SizedBox(height: 8),
          _buildPasswordCriteria(
            "One special character (!@#\$&*~)",
            viewModel.hasSpecialChar,
          ),
        ],
      ),
    );
  }

  /// Construire un critère de validation du mot de passe
  Widget _buildPasswordCriteria(String text, bool isValid) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? SaloonyColors.success : SaloonyColors.borderLight,
          ),
          child: Icon(
            Icons.check,
            size: 14,
            color: isValid ? Colors.white : SaloonyColors.textTertiary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isValid ? SaloonyColors.success : SaloonyColors.textTertiary,
              fontWeight: isValid ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Construire la case à cocher Conditions Générales
  Widget _buildTermsCheckbox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: viewModel.termsError != null
              ? SaloonyColors.error
              : SaloonyColors.borderLight,
          width: viewModel.termsError != null ? 2 : 1,
        ),
      ),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: SaloonyColors.textSecondary,
        ),
        child: CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          dense: true,
          title: Text.rich(
            TextSpan(
              text: "I agree to the ",
              style: SaloonyTextStyles.bodySmall.copyWith(
                color: SaloonyColors.textPrimary,
              ),
              children: [
                TextSpan(
                  text: "Terms & Conditions",
                  style: SaloonyTextStyles.bodySmall.copyWith(
                    color: SaloonyColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: SaloonyTextStyles.bodySmall.copyWith(
                    color: SaloonyColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          value: viewModel.termsAccepted,
          onChanged: viewModel.isLoading
              ? null
              : (value) => viewModel.setTermsAccepted(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: SaloonyColors.primary,
          checkColor: SaloonyColors.secondary,
        ),
      ),
    );
  }

  /// Construire le bouton d'inscription
  Widget _buildSignUpButton(BuildContext context) {
    return SaloonyPrimaryButton(
      label: "Sign Up",
      isLoading: viewModel.isLoading,
      onPressed: viewModel.isLoading 
          ? () {} 
          : () {
            viewModel.signUp(context);
          },
    );
  }

  /// Construire le lien de connexion
  Widget _buildSignInLink(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: viewModel.isLoading
            ? null
            : () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.signIn,
                );
              },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Already have an account? ",
                style: SaloonyTextStyles.bodySmall.copyWith(
                  color: SaloonyColors.textSecondary,
                ),
              ),
              TextSpan(
                text: "Sign In",
                style: SaloonyTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: viewModel.isLoading
                      ? SaloonyColors.textTertiary
                      : SaloonyColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construire un champ texte personnalisé
  Widget _buildTextField({
    required TextEditingController controller,
    required bool enabled,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: SaloonyTextStyles.labelMedium,
            ),
            const SizedBox(width: 4),
            if (!label.contains("Optional"))
              Text("*", style: SaloonyTextStyles.errorText),
          ],
        ),
        const SizedBox(height: 8),
        SaloonyInputField(
          controller: controller,
          label: '',
          hintText: hint,
          prefixIcon: icon,
          keyboardType: keyboardType ?? TextInputType.text,
        ),
      ],
    );
  }
}
class _GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final VoidCallback onTap;
  final bool isEnabled;

  const _GenderOption({
    Key? key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? SaloonyColors.primary.withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color: isSelected ? SaloonyColors.primary : SaloonyColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Utilisation d'images au lieu d'icônes
            Container(
              width: 24,
              height: 24,
              child: Image.asset(
                value == "MEN"
                    ? 'images/iconss/homme.png'
                    : 'images/iconss/woman.png',
                color: isSelected
                    ? SaloonyColors.secondary
                    : SaloonyColors.textSecondary,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si l'image n'est pas trouvée
                  return Icon(
                    value == "MEN" ? Icons.boy : Icons.girl,
                    color: isSelected
                        ? SaloonyColors.secondary
                        : SaloonyColors.textSecondary,
                    size: 30,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? SaloonyColors.primary
                    : SaloonyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
