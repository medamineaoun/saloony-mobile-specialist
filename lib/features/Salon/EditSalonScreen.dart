import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' hide Config;
import 'package:image_picker/image_picker.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/constants/SalonConstants.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/enum/SalonGenderType.dart';
import 'package:saloony/core/enum/additional_service.dart';
import 'package:saloony/core/services/SalonService.dart';

class EditSalonScreen extends StatefulWidget {
  final Map<String, dynamic> salonData;

  const EditSalonScreen({super.key, required this.salonData});

  @override
  State<EditSalonScreen> createState() => _EditSalonScreenState();
}

class _EditSalonScreenState extends State<EditSalonScreen> {
  final SalonService _salonService = SalonService();
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  // États
  SalonCategory _selectedCategory = SalonCategory.barbershop;
  SalonGenderType _selectedGenderType = SalonGenderType.mixed;
  List<AdditionalService> _selectedAdditionalServices = [];
  
  // Image unique
  String? _currentPhotoUrl;
  File? _newPhoto;
  bool _isLoading = false;
  
  // Données du salon original pour conserver les traitements
  late Map<String, dynamic> _originalSalonData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final salon = widget.salonData;
    _originalSalonData = Map<String, dynamic>.from(salon);
    
    _nameController = TextEditingController(text: salon['salonName'] ?? '');
    _descriptionController = TextEditingController(text: salon['salonDescription'] ?? '');
    _latitudeController = TextEditingController(text: salon['salonLatitude']?.toString() ?? '');
    _longitudeController = TextEditingController(text: salon['salonLongitude']?.toString() ?? '');
    
    _selectedCategory = SalonCategory.fromString(salon['salonCategory'] ?? 'BARBERSHOP');
    _selectedGenderType = SalonGenderType.fromString(salon['salonGenderType'] ?? 'UNISEX');
    
    _selectedAdditionalServices = (salon['additionalService'] as List<dynamic>?)
        ?.map((e) => AdditionalService.fromString(e.toString()))
        .toList() ?? [];
    
    // Récupérer la première photo ou null
    final photos = (salon['salonPhotosPaths'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .where((path) => path.isNotEmpty)
        .toList() ?? [];
    
    _currentPhotoUrl = photos.isNotEmpty ? photos.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1B2B3E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Modifier le Salon',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B2B3E),
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save, color: Color(0xFF1B2B3E)),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildCategorySection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildGenderTypeSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildAdditionalServicesSection(isSmallScreen),
                    const SizedBox(height: 40),
                    _buildSaveButton(isSmallScreen),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotoSection(bool isSmallScreen) {
    final hasPhoto = _newPhoto != null || _currentPhotoUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo du Salon',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ajoutez une photo pour présenter votre salon',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasPhoto ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
                width: hasPhoto ? 2 : 1,
              ),
            ),
            child: hasPhoto
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _newPhoto != null
                            ? Image.file(
                                _newPhoto!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                '${Config.baseUrl}/$_currentPhotoUrl',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                                onPressed: _pickImage,
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                                onPressed: _removePhoto,
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app, color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Toucher pour changer',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'Ajouter une photo',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Toucher pour sélectionner',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Nom du salon',
          'Entrez le nom de votre salon',
          _nameController,
          isRequired: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Description',
          'Décrivez votre salon...',
          _descriptionController,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildCategorySection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SalonCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return FilterChip(
              label: Text(category.displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF1B2B3E).withOpacity(0.1),
              checkmarkColor: const Color(0xFF1B2B3E),
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF1B2B3E) : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenderTypeSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de clientèle',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SalonGenderType.values.map((genderType) {
            final isSelected = _selectedGenderType == genderType;
            return FilterChip(
              label: Text(genderType.displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGenderType = genderType;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF1B2B3E).withOpacity(0.1),
              checkmarkColor: const Color(0xFF1B2B3E),
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF1B2B3E) : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalServicesSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services supplémentaires',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sélectionnez les services supplémentaires proposés',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AdditionalService.values.map((service) {
            final isSelected = _selectedAdditionalServices.contains(service);
            return FilterChip(
              label: Text(service.displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAdditionalServices.add(service);
                  } else {
                    _selectedAdditionalServices.remove(service);
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF1B2B3E).withOpacity(0.1),
              checkmarkColor: const Color(0xFF1B2B3E),
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF1B2B3E) : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B2B3E),
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Ce champ est obligatoire';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B2B3E),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: isSmallScreen ? 16 : 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Enregistrer les modifications',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (image != null) {
      setState(() {
        _newPhoto = File(image.path);
        _currentPhotoUrl = null;
      });
    }
  }

  void _removePhoto() {
    setState(() {
      _newPhoto = null;
      _currentPhotoUrl = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Photo supprimée',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Récupérer d'abord les données complètes du salon depuis le backend
      print('📥 Récupération des données complètes du salon...');
      final fullSalonData = await _salonService.getSalonById(_originalSalonData['salonId']);
      
      print('📋 Données complètes reçues: ${fullSalonData.keys}');
      
      // 2. Vérifier si des traitements existent (utiliser salonTreatmentsIds)
      final treatmentIds = fullSalonData['salonTreatmentsIds'] as List<dynamic>? ?? [];
      print('💊 Traitements IDs trouvés: ${treatmentIds.length}');
      print('💊 IDs: $treatmentIds');
      
      if (treatmentIds.isEmpty) {
        // Avertir l'utilisateur qu'il faut d'abord ajouter des traitements
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vous devez d\'abord ajouter au moins un traitement à votre salon',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      
      // 2b. Récupérer aussi les specialists IDs
      final specialistIds = fullSalonData['salonSpecialistsIds'] as List<dynamic>? ?? [];
      print('👥 Spécialistes IDs trouvés: ${specialistIds.length}');
      
      if (specialistIds.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vous devez d\'abord ajouter au moins un spécialiste à votre salon',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      
      // 2c. Récupérer les availabilities
      final availabilities = fullSalonData['salonAvailabilities'] as List<dynamic>? ?? [];
      print('📅 Disponibilités trouvées: ${availabilities.length}');
      
      if (availabilities.length != 7) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Le salon doit avoir exactement 7 disponibilités (Lundi à Dimanche)',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      
      // 3. Construire les données de mise à jour avec les IDs des traitements et spécialistes
      final updateData = {
        'salonId': fullSalonData['salonId'],
        'salonName': _nameController.text.trim(),
        'salonDescription': _descriptionController.text.trim(),
        'salonCategory': _mapSalonCategoryToBackend(_selectedCategory),
        'salonGenderType': _mapGenderTypeToBackend(_selectedGenderType),
        'additionalService': _selectedAdditionalServices
            .map((s) => _mapAdditionalServiceToBackend(s))
            .toList(),
        'salonLatitude': double.tryParse(_latitudeController.text) ?? 
            fullSalonData['salonLatitude'],
        'salonLongitude': double.tryParse(_longitudeController.text) ?? 
            fullSalonData['salonLongitude'],
        
        // CRITIQUE: Envoyer les IDs des traitements (pas les objets)
        'salonTreatmentsIds': treatmentIds,
        
        // CRITIQUE: Envoyer les IDs des spécialistes (pas les objets)
        'salonSpecialistsIds': specialistIds,
        
        // CRITIQUE: Envoyer les disponibilités
        'salonAvailabilities': availabilities,
      };

      print('📤 Envoi des données de mise à jour...');
      print('   - Nom: ${updateData['salonName']}');
      print('   - Catégorie: ${updateData['salonCategory']}');
      print('   - Traitements IDs: ${(updateData['salonTreatmentsIds'] as List).length}');
      print('   - Spécialistes IDs: ${(updateData['salonSpecialistsIds'] as List).length}');
      print('   - Disponibilités: ${(updateData['salonAvailabilities'] as List).length}');

      final result = await _salonService.updateSalon(
        salonId: fullSalonData['salonId'],
        updateData: updateData,
      );

      if (result['success'] == true) {
        // Upload nouvelle photo si elle existe
        if (_newPhoto != null) {
          try {
            await _salonService.addSalonPhoto(
              salonId: _originalSalonData['salonId'],
              imagePath: _newPhoto!.path,
            );
            print('✅ Photo uploadée avec succès');
          } catch (photoError) {
            print('⚠️ Erreur lors de l\'upload de la photo: $photoError');
            // Continue même si l'upload de la photo échoue
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'Salon modifié avec succès',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result['message'] ?? 'Erreur lors de la modification',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e'); // Debug
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Erreur: $e',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // Méthodes de mapping pour l'API Backend
  String _mapSalonCategoryToBackend(SalonCategory category) {
    switch (category) {
      case SalonCategory.hairSalon:
        return 'HAIR_SALON';
      case SalonCategory.spaMassagesCenter:
        return 'SPA_MASSAGES_CENTER';
      case SalonCategory.barbershop:
        return 'BARBERSHOP';
      case SalonCategory.nailSalon:
        return 'NAIL_SALON';
      case SalonCategory.beautyInstitute:
        return 'BEAUTY_INSTITUTE';
    }
  }

  String _mapGenderTypeToBackend(SalonGenderType genderType) {
    switch (genderType) {
      case SalonGenderType.man:
        return 'MEN';
      case SalonGenderType.woman:
        return 'WOMEN';
      case SalonGenderType.mixed:
        return 'MIXED';
    }
  }

  String _mapAdditionalServiceToBackend(AdditionalService service) {
    switch (service) {
      case AdditionalService.wifi:
        return 'WIFI';
      case AdditionalService.tv:
        return 'TV';
      case AdditionalService.backgroundMusic:
        return 'BACKGROUND_MUSIC';
      case AdditionalService.airConditioning:
        return 'AIR_CONDITIONING';
      case AdditionalService.heating:
        return 'HEATING';
      case AdditionalService.coffeeTea:
        return 'COFFEE_TEA';
      case AdditionalService.drinksSnacks:
        return 'DRINKS_SNACKS';
      case AdditionalService.freeParking:
        return 'FREE_PARKING';
      case AdditionalService.paidParking:
        return 'PAID_PARKING';
      case AdditionalService.publicTransportAccess:
        return 'PUBLIC_TRANSPORT_ACCESS';
      case AdditionalService.wheelchairAccessible:
        return 'WHEELCHAIR_ACCESSIBLE';
      case AdditionalService.childFriendly:
        return 'CHILD_FRIENDLY';
      case AdditionalService.shower:
        return 'SHOWER';
      case AdditionalService.lockers:
        return 'LOCKERS';
      case AdditionalService.creditCardAccepted:
        return 'CREDIT_CARD_ACCEPTED';
      case AdditionalService.mobilePayment:
        return 'MOBILE_PAYMENT';
      case AdditionalService.securityCameras:
        return 'SECURITY_CAMERAS';
      case AdditionalService.petFriendly:
        return 'PET_FRIENDLY';
      case AdditionalService.noPets:
        return 'NO_PETS';
      case AdditionalService.smokingAllowed:
        return 'SMOKING_ALLOWED';
      case AdditionalService.nonSmoking:
        return 'NON_SMOKING';
    }
  }
}