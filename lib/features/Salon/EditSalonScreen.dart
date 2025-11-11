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
  List<String> _salonPhotos = [];
  List<File> _newPhotos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final salon = widget.salonData;
    
    _nameController = TextEditingController(text: salon['salonName'] ?? '');
    _descriptionController = TextEditingController(text: salon['salonDescription'] ?? '');
    _latitudeController = TextEditingController(text: salon['salonLatitude']?.toString() ?? '');
    _longitudeController = TextEditingController(text: salon['salonLongitude']?.toString() ?? '');

    _selectedCategory = SalonCategory.fromString(salon['salonCategory'] ?? 'BARBERSHOP');
    _selectedGenderType = SalonGenderType.fromString(salon['salonGenderType'] ?? 'UNISEX');
    
    _selectedAdditionalServices = (salon['additionalService'] as List<dynamic>?)
        ?.map((e) => AdditionalService.fromString(e.toString()))
        .toList() ?? [];

    _salonPhotos = (salon['salonPhotosPaths'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .where((path) => path.isNotEmpty)
        .toList() ?? [];
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
                    _buildPhotosSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildCategorySection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildGenderTypeSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildAdditionalServicesSection(isSmallScreen),
                    const SizedBox(height: 24),
                    _buildLocationSection(isSmallScreen),
                    const SizedBox(height: 40),
                    _buildSaveButton(isSmallScreen),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotosSection(bool isSmallScreen) {
    final allPhotos = [..._salonPhotos, ..._newPhotos.map((file) => file.path)];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos du Salon',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ajoutez des photos pour présenter votre salon',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        
        if (allPhotos.isEmpty)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Ajouter des photos',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allPhotos.length + 1,
              itemBuilder: (context, index) {
                if (index == allPhotos.length) {
                  return _buildAddPhotoButton(isSmallScreen);
                }
                
                final photoPath = allPhotos[index];
                final isFile = index >= _salonPhotos.length;
                
                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: isFile 
                          ? FileImage(File(photoPath))
                          : NetworkImage('${Config.baseUrl}/$photoPath') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddPhotoButton(bool isSmallScreen) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 24, color: Colors.grey[500]),
            const SizedBox(height: 4),
            Text(
              'Ajouter',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildLocationSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
       
        const SizedBox(height: 12),
        Text(
          'Ces coordonnées seront utilisées pour localiser votre salon sur la carte',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF6B7280),
          ),
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
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _newPhotos.add(File(image.path));
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      if (index < _salonPhotos.length) {
        _salonPhotos.removeAt(index);
      } else {
        final newIndex = index - _salonPhotos.length;
        _newPhotos.removeAt(newIndex);
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updateData = {
        'salonId': widget.salonData['salonId'],
        'salonName': _nameController.text.trim(),
        'salonDescription': _descriptionController.text.trim(),
        'salonCategory': _mapSalonCategoryToBackend(_selectedCategory),
        'salonGenderType': _mapGenderTypeToBackend(_selectedGenderType),
        'additionalService': _selectedAdditionalServices.map((s) => _mapAdditionalServiceToBackend(s)).toList(),
        'salonLatitude': double.tryParse(_latitudeController.text) ?? widget.salonData['salonLatitude'],
        'salonLongitude': double.tryParse(_longitudeController.text) ?? widget.salonData['salonLongitude'],
      };

      final result = await _salonService.updateSalon(
        salonId: widget.salonData['salonId'],
        updateData: updateData,
      );

      if (result['success'] == true) {
        // Upload new photos
        for (final photoFile in _newPhotos) {
          await _salonService.addSalonPhoto(
            salonId: widget.salonData['salonId'],
            imagePath: photoFile.path,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Salon modifié avec succès',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Erreur lors de la modification',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
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
  // Si vos enums ont la propriété apiValue, utilisez-la directement
  String _mapSalonCategoryToBackend(SalonCategory category) {
    // Si SalonCategory a apiValue : return category.apiValue;
    // Sinon, utilisez ce switch:
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
    // Si SalonGenderType a apiValue : return genderType.apiValue;
    // Sinon, utilisez ce switch:
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
    // Si AdditionalService a apiValue : return service.apiValue;
    // Sinon, utilisez ce switch:
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