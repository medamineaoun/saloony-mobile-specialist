import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';

class ServicesManagementPage extends StatelessWidget {
  const ServicesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(),
        const SizedBox(height: 24),
        
        // Bouton pour ajouter un service personnalisé
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showAddServiceDialog(context, vm),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2B3E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: Text(
              'Ajouter un service personnalisé',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Liste des services existants (depuis l'API)
        if (vm.availableTreatments.isNotEmpty) ...[
          Text(
            'Services disponibles',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B2B3E),
            ),
          ),
          const SizedBox(height: 12),
          ...vm.availableTreatments.map((treatment) {
            final isSelected = vm.selectedTreatmentIds.contains(treatment.treatmentId);
            return _buildServiceCard(
              context: context,
              name: treatment.treatmentName,
              description: treatment.treatmentDescription,
              price: treatment.treatmentPrice?.toDouble() ?? 0.0,
              imagePath: treatment.treatmentPhotosPaths?.isNotEmpty == true 
                  ? treatment.treatmentPhotosPaths!.first 
                  : null,
              isSelected: isSelected,
              onTap: () => vm.toggleTreatmentSelection(treatment.treatmentId),
              isCustom: false,
            );
          }),
        ],
        
        // Liste des services personnalisés
        if (vm.customServices.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Vos services personnalisés',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B2B3E),
            ),
          ),
          const SizedBox(height: 12),
          ...vm.customServices.map((service) {
            return _buildServiceCard(
              context: context,
              name: service.name,
              description: service.description,
              price: service.price,
              gender: service.specificGender,
              imagePath: service.photoPath,
              isSelected: true,
              isCustom: true,
              onTap: () {},
              onEdit: () => _showEditServiceDialog(context, vm, service),
              onDelete: () => _confirmDelete(context, vm, service.id),
            );
          }),
        ],
        
        const SizedBox(height: 100), // Espace pour le bouton en bas
      ],
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    String? gender,
    String? imagePath,
    required bool isSelected,
    required bool isCustom,
    required VoidCallback onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF1B2B3E).withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image du service
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    image: imagePath != null
                        ? DecorationImage(
                            image: imagePath.startsWith('http')
                                ? NetworkImage(imagePath) as ImageProvider
                                : FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null
                      ? Icon(Icons.image_outlined, size: 32, color: Colors.grey[400])
                      : null,
                ),
                const SizedBox(width: 12),
                
                // Informations du service
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B2B3E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCustom && onEdit != null) ...[
                            IconButton(
                              icon: Icon(Icons.edit_outlined, size: 18, color: Colors.blue[600]),
                              onPressed: onEdit,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (gender != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: gender == 'Man' 
                                ? Colors.blue[50] 
                                : gender == 'Woman' 
                                    ? Colors.pink[50] 
                                    : Colors.purple[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            gender,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: gender == 'Man' 
                                  ? Colors.blue[700] 
                                  : gender == 'Woman' 
                                      ? Colors.pink[700] 
                                      : Colors.purple[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF0CD97),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Actions à droite
                Column(
                  children: [
                    if (!isCustom) ...[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF1B2B3E) 
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF1B2B3E) 
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: isSelected ? const Color(0xFFF0CD97) : Colors.transparent,
                          size: 16,
                        ),
                      ),
                    ] else if (onDelete != null) ...[
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[600], size: 22),
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context, SalonCreationViewModel vm) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String? selectedGender;
    String? imagePath;
    final categoryController = TextEditingController(text: vm.selectedCategory?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1B2B3E).withOpacity(0.1),
                      const Color(0xFFF0CD97).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_business, color: Color(0xFF1B2B3E), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Ajouter un service',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload photo
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        imagePath = image.path;
                      });
                    }
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, 
                                   size: 48, 
                                   color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Service Photo',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Nom du service
                _buildDialogTextField(
                  label: 'Service Type Name',
                  hint: 'Undercut, etc...',
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                
                // Gender spécifique
                Text(
                  'Specific Gender',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      hintText: 'Select gender',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: ['Man', 'Woman', 'Mixed'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender,
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                _buildDialogTextField(
                  label: 'Description (optional)',
                  hint: 'Describe your service type',
                  controller: descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Prix
                _buildDialogTextField(
                  label: 'Price',
                  hint: '\$0.99',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty &&
                    priceController.text.trim().isNotEmpty) {
                  final service = CustomService(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    price: double.tryParse(priceController.text) ?? 0.0,
                    photoPath: imagePath,
                    specificGender: selectedGender,
                    category: categoryController.text,
                  );
                  vm.addCustomService(service);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditServiceDialog(BuildContext context, SalonCreationViewModel vm, CustomService service) {
    final nameController = TextEditingController(text: service.name);
    final descriptionController = TextEditingController(text: service.description);
    final priceController = TextEditingController(text: service.price.toString());
    String? selectedGender = service.specificGender;
    String? imagePath = service.photoPath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          title: Text(
            'Modifier le service',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B2B3E),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload photo
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        imagePath = image.path;
                      });
                    }
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imagePath == null
                        ? Icon(Icons.add_photo_alternate_outlined, 
                               size: 48, 
                               color: Colors.grey[400])
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDialogTextField(
                  label: 'Nom',
                  hint: 'Nom du service',
                  controller: nameController,
                ),
                const SizedBox(height: 16),
                Text(
                  'Genre spécifique',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      hintText: 'Sélectionner',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: ['Man', 'Woman', 'Mixed'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender, style: GoogleFonts.inter(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Description',
                  hint: 'Description du service',
                  controller: descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Prix',
                  hint: '0.00',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty &&
                    priceController.text.trim().isNotEmpty) {
                  final updatedService = CustomService(
                    id: service.id,
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    price: double.tryParse(priceController.text) ?? 0.0,
                    photoPath: imagePath,
                    specificGender: selectedGender,
                    category: service.category,
                  );
                  vm.updateCustomService(updatedService);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2B3E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Sauvegarder',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, SalonCreationViewModel vm, String serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Supprimer le service',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ce service ?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              vm.removeCustomService(serviceId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: Text('Supprimer', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B2B3E).withOpacity(0.1),
                const Color(0xFFF0CD97).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.spa_outlined,
            color: Color(0xFF1B2B3E),
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services & Traitements',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ajoutez les services que vous proposez',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}