import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyTextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SaloonySpecialist/features/profile/view_models/ProfileEditViewModel.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileEditViewModel(context),
      child: const _ProfileEditContent(),
    );
  }
}

class _ProfileEditContent extends StatelessWidget {
  const _ProfileEditContent();

  void _showImageOptions(BuildContext context, ProfileEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: SaloonyColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: SaloonyColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),
            Text('Profile Photo', style: SaloonyTextStyles.heading3),
            const SizedBox(height: 28),
            _ImageOptionTile(
              icon: Icons.photo_library_outlined,
              title: 'Gallery',
              subtitle: 'Choose from gallery',
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage();
              },
            ),
            const SizedBox(height: 16),
            _ImageOptionTile(
              icon: Icons.camera_alt_outlined,
              title: 'Camera',
              subtitle: 'Take a photo',
              onTap: () {
                Navigator.pop(context);
                viewModel.takePhoto();
              },
            ),
            if (viewModel.profileImageUrl != null) ...[
              const SizedBox(height: 16),
              _ImageOptionTile(
                icon: Icons.delete_outline,
                title: 'Remove',
                subtitle: 'Delete profile photo',
                onTap: () {
                  Navigator.pop(context);
                  viewModel.removeProfilePhoto();
                },
                isDestructive: true,
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    if (viewModel.isLoadingData) {
      return Scaffold(
        backgroundColor: SaloonyColors.backgroundSecondary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.gold),
              ),
              const SizedBox(height: 20),
              Text('Loading...', style: SaloonyTextStyles.bodyMedium),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SaloonyColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: SaloonyColors.primary, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Profile', style: SaloonyTextStyles.heading3),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showImageOptions(context, viewModel),
                            child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        SaloonyColors.gold.withOpacity(0.2),
                                        SaloonyColors.secondary.withOpacity(0.1),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: SaloonyColors.primary.withOpacity(0.1),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _buildProfileImage(viewModel),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          SaloonyColors.gold,
                                          SaloonyColors.secondary,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: SaloonyColors.gold.withOpacity(0.4),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: viewModel.isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                SaloonyColors.primary,
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 22,
                                            color: SaloonyColors.primary,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Change Photo',
                            style: SaloonyTextStyles.labelLarge.copyWith(
                              color: SaloonyColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Form Section Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: SaloonyColors.secondaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              size: 20,
                              color: SaloonyColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Personal Information',
                            style: SaloonyTextStyles.heading4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // First Name
                    _ModernInputField(
                      label: 'First Name',
                      value: viewModel.firstName,
                      onChanged: viewModel.setFirstName,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 20),

                    // Last Name
                    _ModernInputField(
                      label: 'Last Name',
                      value: viewModel.lastName,
                      onChanged: viewModel.setLastName,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    _ModernDropdownField(
                      label: 'Gender',
                      value: _formatGenderForDisplay(viewModel.gender),
                      items: const ['Male', 'Female'],
                      onChanged: (displayValue) {
                        final backendValue = _formatGenderForBackend(displayValue);
                        viewModel.setGender(backendValue);
                      },
                      icon: Icons.wc_outlined,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildSaveButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  /// ✅ MÉTHODE CORRIGÉE pour afficher l'image (Web & Mobile compatible)
  Widget _buildProfileImage(ProfileEditViewModel viewModel) {
    // Priorité 1: Image en bytes (nouveau upload en cours)
    if (viewModel.imageBytes != null) {
      return Image.memory(
        viewModel.imageBytes!,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Error loading image from bytes: $error');
          return _buildDefaultAvatar();
        },
      );
    }

    // Priorité 2: Image depuis URL (image existante sur le serveur)
    if (viewModel.profileImageUrl != null && viewModel.profileImageUrl!.isNotEmpty) {
      return Image.network(
        viewModel.profileImageUrl!,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Error loading network image: $error');
          debugPrint('❌ URL was: ${viewModel.profileImageUrl}');
          return _buildDefaultAvatar();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation<Color>(
                SaloonyColors.gold,
              ),
            ),
          );
        },
      );
    }

    // Priorité 3: Placeholder par défaut
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SaloonyColors.backgroundTertiary,
            const Color.fromARGB(255, 166, 195, 224),
          ],
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 70,
        color: SaloonyColors.textTertiary,
      ),
    );
  }

  String _formatGenderForDisplay(String gender) {
    switch (gender.toUpperCase()) {
      case 'MEN':
        return 'Male';
      case 'WOMEN':
        return 'Female';
      default:
        return gender;
    }
  }

  String _formatGenderForBackend(String displayGender) {
    switch (displayGender) {
      case 'Male':
        return 'MEN';
      case 'Female':
        return 'WOMEN';
      default:
        return displayGender;
    }
  }

  Widget _buildSaveButton(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SaloonyColors.background,
        boxShadow: [
          BoxShadow(
            color: SaloonyColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SaloonyColors.gold,
              SaloonyColors.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: SaloonyColors.gold.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: viewModel.isLoading
              ? null
              : () async {
                  final result = await viewModel.saveChanges();
                  if (context.mounted) {
                    if (result['success'] == true) {
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: SaloonyColors.disabled,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      SaloonyColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 22,
                      color: SaloonyColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Save Changes',
                      style: SaloonyTextStyles.buttonLarge.copyWith(
                        color: SaloonyColors.primary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// === Modern Input Field ===
class _ModernInputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool enabled;

  const _ModernInputField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: SaloonyTextStyles.labelLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: SaloonyColors.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: SaloonyColors.primary.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            onChanged: onChanged,
            keyboardType: keyboardType,
            enabled: enabled,
            style: SaloonyTextStyles.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  icon,
                  color: SaloonyColors.gold,
                  size: 22,
                ),
              ),
              filled: true,
              fillColor: enabled ? SaloonyColors.background : SaloonyColors.backgroundTertiary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: SaloonyColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: SaloonyColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: SaloonyColors.gold,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: SaloonyColors.borderLight),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// === Modern Dropdown Field ===
class _ModernDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final IconData icon;

  const _ModernDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: SaloonyTextStyles.labelLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: SaloonyColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SaloonyColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: SaloonyColors.primary.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              dropdownColor: SaloonyColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: SaloonyColors.gold,
                size: 24,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: SaloonyColors.gold,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(item, style: SaloonyTextStyles.bodyMedium),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// === Image Option Tile ===
class _ImageOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ImageOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDestructive 
              ? SaloonyColors.errorLight
              : SaloonyColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? SaloonyColors.error.withOpacity(0.2)
                : SaloonyColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDestructive
                    ? SaloonyColors.error.withOpacity(0.15)
                    : SaloonyColors.secondaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isDestructive 
                    ? SaloonyColors.error 
                    : SaloonyColors.gold,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SaloonyTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive 
                          ? SaloonyColors.error 
                          : SaloonyColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: SaloonyTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: SaloonyColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}