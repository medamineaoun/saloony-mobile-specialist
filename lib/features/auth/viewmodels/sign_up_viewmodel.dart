import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class SignUpViewModel extends ChangeNotifier {
  // 🔹 Form key
  final formKey = GlobalKey<FormState>();

  // 🔹 Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // 🔹 Services
  final AuthService _authService = AuthService();

  // 🔹 UI states
  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedGender = '';
  String get selectedGender => _selectedGender;

  String? _genderError;
  String? get genderError => _genderError;

  // =====================
  // 🔹 UI Actions
  // =====================
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    _genderError = null;
    notifyListeners();
  }

  void setGenderError(String error) {
    _genderError = error;
    notifyListeners();
  }

  void clearGenderError() {
    _genderError = null;
    notifyListeners();
  }

  // =====================
  // 🔹 Validations
  // =====================

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\+?[\d\s-]{8,}$').hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Must contain at least one special character';
    }
    return null;
  }

  // =====================
  // 🔹 Sign Up Logic
  // =====================
  Future<void> signUp(BuildContext context) async {
    // Vérification du formulaire
    if (!formKey.currentState!.validate()) return;

    // Vérification du genre
    if (_selectedGender.isEmpty) {
      setGenderError('Please select your gender');
      return;
    }

    // Récupération des champs
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim().isEmpty ? "00000000" : phoneController.text.trim();

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phone,
        gender: _selectedGender, // "MAN" ou "WOMAN"
        role: "SPECIALIST",       // rôle par défaut
      );

      _isLoading = false;
      notifyListeners();

      final message = result['message'] ?? 'Registration completed successfully.';

      if (result['success']) {
        clearFields();
        _showSuccessSnackBar(context, message);
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushNamed(context, "/verifyEmail", arguments: email);
      } else {
        _showErrorSnackBar(context, message);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _showErrorSnackBar(context, "Unexpected error: $e");
    }
  }

  // =====================
  // 🔹 Helpers
  // =====================
  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    _selectedGender = '';
    _genderError = null;
    notifyListeners();
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // =====================
  // 🔹 Dispose
  // =====================
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
