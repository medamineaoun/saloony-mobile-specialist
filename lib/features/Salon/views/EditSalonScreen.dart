import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart' hide Config;
import 'package:image_picker/image_picker.dart';
import 'package:SaloonySpecialist/core/Config/ProviderSetup.dart';
import 'package:SaloonySpecialist/core/constants/SalonConstants.dart';
import 'package:SaloonySpecialist/core/enum/SalonCategory.dart';
import 'package:SaloonySpecialist/core/enum/SalonGenderType.dart';
import 'package:SaloonySpecialist/core/enum/additional_service.dart';
import 'package:SaloonySpecialist/core/services/SalonService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';

class EditSalonScreen extends StatefulWidget {
  final Map<String, dynamic> salonData;

  const EditSalonScreen({super.key, required this.salonData});

  @override
  State<EditSalonScreen> createState() => _EditSalonScreenState();
}

class _EditSalonScreenState extends State<EditSalonScreen> {
  final SalonService _salonService = SalonService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  SalonCategory _selectedCategory = SalonCategory.barbershop;
  SalonGenderType _selectedGenderType = SalonGenderType.mixed;
  List<AdditionalService> _selectedAdditionalServices = [];
  
  String? _currentPhotoUrl;
  XFile? _newPhoto;
  Uint8List? _newPhotoBytes;
  bool _isLoading = false;
  
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
                        child: _newPhotoBytes != null
                            ? Image.memory(
                                _newPhotoBytes!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : (_currentPhotoUrl != null
                                ? Image.network(
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
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_outlined, size: 50, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text('No photo', style: GoogleFonts.poppins(color: Colors.grey[500])),
                                    ],
                                  )),
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
      final bytes = await image.readAsBytes();
      setState(() {
        _newPhoto = image;
        _newPhotoBytes = bytes;
        _currentPhotoUrl = null;
      });
    }
  }

  Future<void> _removePhoto() async {
    // If the photo is already stored on the server, attempt to delete it there first
    final salonId = _originalSalonData['salonId']?.toString();

    if (salonId != null && _currentPhotoUrl != null) {
      try {
        final del = await _salonService.deleteSalonPhoto(salonId: salonId, index: 0);
        if (del['success'] == true) {
          ToastService.showSuccess(context, 'Photo supprimée du serveur');
        } else {
          ToastService.showWarning(context, 'Impossible de supprimer la photo sur le serveur');
        }
      } catch (e) {
        ToastService.showWarning(context, 'Erreur suppression photo: $e');
      }
    }

    // Clear local selection regardless
    setState(() {
      _newPhoto = null;
      _newPhotoBytes = null;
      _currentPhotoUrl = null;
    });

    ToastService.showInfo(context, 'Photo supprimée');
  }


Future<void> _saveChanges() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    print('📥 Récupération des données complètes du salon...');
    final fullSalonData = await _salonService.getSalonById(_originalSalonData['salonId']);
    
    final treatmentIds = fullSalonData['salonTreatmentsIds'] as List<dynamic>? ?? [];
    final specialistIds = fullSalonData['salonSpecialistsIds'] as List<dynamic>? ?? [];
    final availabilities = fullSalonData['salonAvailabilities'] as List<dynamic>? ?? [];
    
    // Validations...
    if (treatmentIds.isEmpty || specialistIds.isEmpty || availabilities.length != 7) {
      setState(() => _isLoading = false);
      return;
    }
    
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
      'salonTreatmentsIds': treatmentIds,
      'salonSpecialistsIds': specialistIds,
      'salonAvailabilities': availabilities,
    };

    print('📤 Envoi des données de mise à jour...');
    final result = await _salonService.updateSalon(
      salonId: fullSalonData['salonId'],
      updateData: updateData,
    );

    if (result['success'] == true) {
      // Upload photo si nécessaire
      if (_newPhotoBytes != null) {
        try {
          await _salonService.addSalonPhotoBytes(
            salonId: _originalSalonData['salonId'],
            imageBytes: _newPhotoBytes!,
            filename: _newPhoto?.name ?? 'salon.jpg',
          );
          print('✅ Photo uploadée avec succès');
        } catch (photoError) {
          print('⚠️ Erreur upload photo: $photoError');
        }
      }

      // ✅ SOLUTION: Récupérer les données mises à jour depuis le backend
      print('🔄 Récupération des données mises à jour...');
      final updatedSalonData = await _salonService.getSalonById(
        _originalSalonData['salonId']
      );
      
      print('✅ Données fraîches récupérées');
      print('📋 Nouveau nom: ${updatedSalonData['salonName']}');
      print('📋 Nouvelle description: ${updatedSalonData['salonDescription']}');

      if (mounted) {
        ToastService.showSuccess(context, 'Salon modifié avec succès');
        
        // ✅ CRITIQUE: Retourner les données mises à jour
        Navigator.pop(context, updatedSalonData); // ← Au lieu de true
      }
    } else {
      if (mounted) {
        ToastService.showError(
          context,
          result['message'] ?? 'Erreur lors de la modification',
        );
      }
    }
  } catch (e) {
    print('❌ Erreur lors de la sauvegarde: $e');
    if (mounted) {
      ToastService.showError(context, 'Erreur: $e');
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