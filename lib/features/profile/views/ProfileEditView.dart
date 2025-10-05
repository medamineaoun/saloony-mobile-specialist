import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/features/profile/view_models/ProfileEditViewModel.dart';

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

  void _showImageOptions(BuildContext context, ProfileEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SaloonyColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: SaloonyColors.primary),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: SaloonyColors.primary),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                viewModel.takePhoto();
              },
            ),
            if (viewModel.profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: SaloonyColors.error),
                title: const Text(
                  'Supprimer la photo',
                  style: TextStyle(color: SaloonyColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.removeProfilePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    if (viewModel.isLoadingData) {
      return const Scaffold(
        backgroundColor: SaloonyColors.background,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SaloonyColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Modifier le profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SaloonyColors.primary,
          ),
        ),
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
                    // Profile Picture
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageOptions(context, viewModel),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SaloonyColors.tertiary,
                                border: Border.all(
                                  color: SaloonyColors.secondary,
                                  width: 3,
                                ),
                                image: _buildProfileImage(viewModel),
                              ),
                              child: _buildProfileIcon(viewModel),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SaloonyColors.secondary,
                                  border: Border.all(
                                    color: SaloonyColors.background,
                                    width: 3,
                                  ),
                                ),
                                child: viewModel.isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            SaloonyColors.primary,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: SaloonyColors.primary,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // First Name
                    _InputField(
                      label: 'Prénom',
                      value: viewModel.firstName,
                      onChanged: viewModel.setFirstName,
                    ),
                    const SizedBox(height: 20),

                    // Last Name
                    _InputField(
                      label: 'Nom',
                      value: viewModel.lastName,
                      onChanged: viewModel.setLastName,
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
                    const SizedBox(height: 20),

                    // Gender
                    _DropdownField(
                      label: 'Genre',
                      value: _formatGender(viewModel.gender),
                      items: viewModel.availableGenders,
                      onChanged: viewModel.setGender,
                    ),
                    const SizedBox(height: 20),

                    // Role (Read-only)
                    _InputField(
                      label: 'Rôle',
                      value: viewModel.speciality,
                      onChanged: (_) {},
                      enabled: false,
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

  DecorationImage? _buildProfileImage(ProfileEditViewModel viewModel) {
    if (viewModel.imageFile != null) {
      return DecorationImage(
        image: FileImage(viewModel.imageFile!),
        fit: BoxFit.cover,
      );
    } else if (viewModel.profileImagePath != null &&
        viewModel.profileImagePath!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(viewModel.profileImagePath!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Widget? _buildProfileIcon(ProfileEditViewModel viewModel) {
    if (viewModel.imageFile == null &&
        (viewModel.profileImagePath == null ||
            viewModel.profileImagePath!.isEmpty)) {
      return const Icon(
        Icons.person,
        size: 60,
        color: SaloonyColors.textSecondary,
      );
    }
    return null;
  }

  String _formatGender(String gender) {
    switch (gender.toUpperCase()) {
      case 'MAN':
        return 'Homme';
      case 'WOMAN':
        return 'Femme';
      default:
        return gender;
    }
  }

  Widget _buildSaveButton(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: SaloonyColors.background,
        border: Border(
          top: BorderSide(color: SaloonyColors.tertiary, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: viewModel.isLoading
              ? null
              : () async {
                  final result = await viewModel.saveChanges();
                  if (context.mounted) {
                    if (result['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? 'Profil mis à jour avec succès'),
                          backgroundColor: SaloonyColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      // Attendre un peu avant de fermer pour que l'utilisateur voie le message
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? 'Erreur lors de la mise à jour'),
                          backgroundColor: SaloonyColors.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: SaloonyColors.secondary,
            foregroundColor: SaloonyColors.primary,
            elevation: 0,
            disabledBackgroundColor: SaloonyColors.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      SaloonyColors.primary,
                    ),
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

// === Input & Dropdown Widgets ===
class _InputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;

  const _InputField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
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
            fontWeight: FontWeight.w600,
            color: SaloonyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? SaloonyColors.tertiary : SaloonyColors.lightGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SaloonyColors.tertiary,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SaloonyColors.secondary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: TextStyle(
            fontSize: 15,
            color: enabled ? SaloonyColors.textPrimary : SaloonyColors.textSecondary,
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
            fontWeight: FontWeight.w600,
            color: SaloonyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: SaloonyColors.tertiary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SaloonyColors.tertiary,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: SaloonyColors.background,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: SaloonyColors.textSecondary,
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 15,
                            color: SaloonyColors.textPrimary,
                          ),
                        ),
                      ))
                  .toList(),
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