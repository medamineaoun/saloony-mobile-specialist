import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileEditViewModel(),
      child: const _ProfileEditContent(),
    );
  }
}

class _ProfileEditContent extends StatelessWidget {
  const _ProfileEditContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(context, viewModel),
                
                // Tabs
                _buildTabs(context, viewModel),
                
                // Content
                Expanded(
                  child: viewModel.activeTab == 0
                      ? _buildAccountDetails(context, viewModel)
                      : _buildBusinessDetails(context, viewModel),
                ),
                
                // Save Button
                _buildSaveButton(context, viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: SaloonyColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Modifier le profil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: SaloonyColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Détails du compte',
              isActive: viewModel.activeTab == 0,
              onTap: () => viewModel.setActiveTab(0),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _TabButton(
              label: 'Détails de l\'entreprise',
              isActive: viewModel.activeTab == 1,
              onTap: () => viewModel.setActiveTab(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, ProfileEditViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SaloonyColors.tertiary,
                    image: viewModel.profileImagePath != null
                        ? DecorationImage(
                            image: AssetImage(viewModel.profileImagePath!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: viewModel.profileImagePath == null
                      ? const Icon(Icons.person, size: 50, color: SaloonyColors.textSecondary)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFD946EF), Color(0xFFA855F7)],
                      ),
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Full Name
          _InputField(
            label: 'Nom et prénom',
            value: viewModel.fullName,
            onChanged: viewModel.setFullName,
          ),
          const SizedBox(height: 20),
          
          // Speciality
          _InputField(
            label: 'Spécialité',
            value: viewModel.speciality,
            onChanged: viewModel.setSpeciality,
          ),
          const SizedBox(height: 20),
          
          // Platform Role
          _DropdownField(
            label: 'Rôle de la plateforme',
            value: viewModel.platformRole,
            items: viewModel.availableRoles,
            onChanged: viewModel.setPlatformRole,
          ),
          const SizedBox(height: 20),
          
          // Email
          _InputField(
            label: 'E-mail',
            value: viewModel.email,
            onChanged: viewModel.setEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          
          // Phone
          _InputField(
            label: 'Numéro de téléphone',
            value: viewModel.phoneNumber,
            onChanged: viewModel.setPhoneNumber,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetails(BuildContext context, ProfileEditViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ces informations apparaîtront sur votre profil public.',
            style: TextStyle(
              fontSize: 13,
              color: SaloonyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Business Name
          _InputField(
            label: 'Nom de l\'entreprise',
            value: viewModel.businessName,
            onChanged: viewModel.setBusinessName,
          ),
          const SizedBox(height: 20),
          
          // About
          _InputField(
            label: 'À propos',
            value: viewModel.aboutBusiness,
            onChanged: viewModel.setAboutBusiness,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          
          // Email
          _InputField(
            label: 'E-mail',
            value: viewModel.businessEmail,
            onChanged: viewModel.setBusinessEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          
          // Phone
          _InputField(
            label: 'Numéro de téléphone',
            value: viewModel.businessPhone,
            onChanged: viewModel.setBusinessPhone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          
          // Website
          _InputField(
            label: 'Site web',
            value: viewModel.website,
            onChanged: viewModel.setWebsite,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: viewModel.isLoading ? null : () => viewModel.saveChanges(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD946EF),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Enregistrer les modifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFFD946EF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFFD946EF) : SaloonyColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SaloonyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: SaloonyColors.tertiary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: SaloonyColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SaloonyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: SaloonyColors.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: SaloonyColors.textSecondary),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ViewModel (same as before)
class ProfileEditViewModel extends ChangeNotifier {
  String _fullName = 'Jean Dupont';
  String _speciality = 'Maquilleur';
  String _platformRole = 'Sélectionnez le rôle';
  String _email = 'exemple@domaine.com';
  String _phoneNumber = '+123 456 789 000';
  String _businessName = 'Salon de coiffure XYZ';
  String _aboutBusiness = 'Brève description';
  String _businessEmail = 'exemple@domaine.com';
  String _businessPhone = '+123 456 789 000';
  String _website = 'www.mybarbershop.com';
  int _activeTab = 0;
  String? _profileImagePath;
  bool _isLoading = false;
  String? _errorMessage;

  String get fullName => _fullName;
  String get speciality => _speciality;
  String get platformRole => _platformRole;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get businessName => _businessName;
  String get aboutBusiness => _aboutBusiness;
  String get businessEmail => _businessEmail;
  String get businessPhone => _businessPhone;
  String get website => _website;
  int get activeTab => _activeTab;
  String? get profileImagePath => _profileImagePath;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setSpeciality(String value) {
    _speciality = value;
    notifyListeners();
  }

  void setPlatformRole(String value) {
    _platformRole = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setBusinessName(String value) {
    _businessName = value;
    notifyListeners();
  }

  void setAboutBusiness(String value) {
    _aboutBusiness = value;
    notifyListeners();
  }

  void setBusinessEmail(String value) {
    _businessEmail = value;
    notifyListeners();
  }

  void setBusinessPhone(String value) {
    _businessPhone = value;
    notifyListeners();
  }

  void setWebsite(String value) {
    _website = value;
    notifyListeners();
  }

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void setProfileImage(String? path) {
    _profileImagePath = path;
    notifyListeners();
  }

  bool validateAccountDetails() {
    if (_fullName.isEmpty) {
      _errorMessage = 'Le nom est requis';
      notifyListeners();
      return false;
    }
    if (_email.isEmpty || !_email.contains('@')) {
      _errorMessage = 'Email invalide';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  bool validateBusinessDetails() {
    if (_businessName.isEmpty) {
      _errorMessage = 'Le nom de l\'entreprise est requis';
      notifyListeners();
      return false;
    }
    if (_businessEmail.isEmpty || !_businessEmail.contains('@')) {
      _errorMessage = 'Email invalide';
      notifyListeners();
      return false;
    }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<void> saveChanges() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      bool isValid = _activeTab == 0 
          ? validateAccountDetails() 
          : validateBusinessDetails();
      
      if (!isValid) {
        _isLoading = false;
        return;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors de la sauvegarde: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> get availableRoles => [
    'Sélectionnez le rôle',
    'Coiffeur',
    'Barbier',
    'Esthéticien',
    'Maquilleur',
    'Styliste',
    'Masseur',
  ];
}

// Colors
class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color navy = Color(0xFF243441);
  static const Color gold = Color(0xFFEDC087);
  static const Color lightGray = Color(0xFFD4D4D4);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
}