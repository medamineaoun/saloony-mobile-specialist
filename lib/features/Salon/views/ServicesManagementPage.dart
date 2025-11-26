import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:SaloonySpecialist/core/enum/TreatmentCategory.dart';
import 'package:SaloonySpecialist/features/Salon/view_models/SalonCreationViewModel.dart';

class ServicesManagementPage extends StatefulWidget {
  final SalonCreationViewModel vm;

  const ServicesManagementPage({super.key, required this.vm});
  
  @override
  State<ServicesManagementPage> createState() => _ServicesManagementPageState();
}

class _ServicesManagementPageState extends State<ServicesManagementPage> {
  TreatmentCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(),
        const SizedBox(height: 24),
        _buildSelectionSummary(vm),
        const SizedBox(height: 16),
        _buildCategoryList(vm),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSelectionSummary(SalonCreationViewModel vm) {
    final totalSelected = vm.selectedTreatmentIds.length + vm.customServices.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: totalSelected > 0 ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: totalSelected > 0 ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            totalSelected > 0 ? Icons.check_circle : Icons.info_outline,
            color: totalSelected > 0 ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              totalSelected > 0
                  ? '✓ $totalSelected service${totalSelected > 1 ? 's' : ''} selected'
                  : 'Please select at least one service to continue',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: totalSelected > 0 ? Colors.green.shade900 : Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(SalonCreationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: TreatmentCategory.values.length,
          itemBuilder: (context, index) {
            final category = TreatmentCategory.values[index];
            final count = _getServiceCountForCategory(vm, category);
            final isSelected = selectedCategory == category;

            return _buildCategoryListItem(
              vm: vm,
              category: category,
              count: count,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (selectedCategory == category) {
                    selectedCategory = null;
                  } else {
                    selectedCategory = category;
                  }
                });
              },
              onAdd: () => _showAddServiceDialog(context, vm, category),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryListItem({
    required SalonCreationViewModel vm,
    required TreatmentCategory category,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onAdd,
  }) {
    final categoryData = _getCategoryVisualData(category);
    final apiTreatments = vm.availableTreatments
        .where((t) => t.treatmentCategory.toUpperCase() == category.value)
        .toList();
    final customServices = vm.customServices
        .where((s) => s.category.toUpperCase() == category.value)
        .toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? (categoryData['gradient'] as List<Color>)[0].withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? (categoryData['gradient'] as List<Color>)[0] : Colors.grey[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: categoryData['gradient'] as List<Color>,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        // Remplacé l'emoji par l'image
                        child: Image.asset(
                          category.imagePath,
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.spa, size: 24, color: Colors.white);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$count service${count != 1 ? 's' : ''} available',
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                 IconButton(
  icon: const Icon(Icons.add_circle_outline, color: Colors.black),
  onPressed: onAdd,
),

                    Icon(
                      isSelected ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelected) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                ...apiTreatments.map((treatment) => _buildServiceCard(
                  context: context,
                  name: treatment.treatmentName,
                  description: treatment.treatmentDescription,
                  price: treatment.treatmentPrice ?? 0.0,
                  imagePath: treatment.treatmentPhotosPaths?.isNotEmpty == true ? treatment.treatmentPhotosPaths!.first : null,
                  isSelected: vm.selectedTreatmentIds.contains(treatment.treatmentId),
                  isCustom: false,
                  onTap: () => vm.toggleTreatmentSelection(treatment.treatmentId),
                  categoryColor: (categoryData['gradient'] as List<Color>)[0],
                )),
                ...customServices.map((service) => _buildServiceCard(
                  context: context,
                  name: service.name,
                  description: service.description,
                  price: service.price,
                  imagePath: service.photoPath,
                  isSelected: true,
                  isCustom: true,
                  onTap: () {},
                  onEdit: () => _showEditServiceDialog(context, vm, service),
                  onDelete: () => _confirmDelete(context, vm, service.id),
                  categoryColor: (categoryData['gradient'] as List<Color>)[0],
                )),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic> _getCategoryVisualData(TreatmentCategory category) {
  switch (category) {
    case TreatmentCategory.HAIRCUT:
      return {'gradient': [const Color(0x00FDFDFE), const Color(0x006366F1)]};
    case TreatmentCategory.COLORING:
      return {'gradient': [const Color(0x00F59E0B), const Color(0x00EF4444)]};
    case TreatmentCategory.BEARD:
      return {'gradient': [const Color(0x0078716C), const Color(0x0057534E)]};
    case TreatmentCategory.FACIAL:
      return {'gradient': [const Color(0x0014B8A6), const Color(0x0006B6D4)]};
    case TreatmentCategory.MASSAGE:
      return {'gradient': [const Color(0x003B82F6), const Color(0x0006B6D4)]};
    case TreatmentCategory.NAILS:
      return {'gradient': [const Color(0x00EC4899), const Color(0x00F43F5E)]};
    case TreatmentCategory.WAXING:
      return {'gradient': [const Color(0x00EF4444), const Color(0x00F97316)]};
    case TreatmentCategory.MAKEUP:
      return {'gradient': [const Color(0x00F59E0B), const Color(0x00EC4899)]};
    default:
      return {'gradient': [const Color(0x0064748B), const Color(0x00475569)]};
  }
}


  int _getServiceCountForCategory(SalonCreationViewModel vm, TreatmentCategory category) {
    final apiCount = vm.availableTreatments.where((t) => t.treatmentCategory.toUpperCase() == category.value).length;
    final customCount = vm.customServices.where((s) => s.category.toUpperCase() == category.value).length;
    return apiCount + customCount;
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
    required Color categoryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? categoryColor : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [BoxShadow(color: categoryColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))] : [],
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    image: imagePath != null
                        ? DecorationImage(
                            image: imagePath.startsWith('http') ? NetworkImage(imagePath) as ImageProvider : FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null ? Icon(Icons.image_outlined, size: 32, color: Colors.grey[400]) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E)),
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
                      Text(
                        description,
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${price.toStringAsFixed(2)} TND',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: categoryColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (!isCustom) ...[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? categoryColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? categoryColor : Colors.grey[300]!, width: 2),
                        ),
                        child: Icon(Icons.check, color: isSelected ? Colors.white : Colors.transparent, size: 16),
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

  void _showAddServiceDialog(BuildContext context, SalonCreationViewModel vm, TreatmentCategory category) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String? selectedDuration;
    String? imagePath;
    final categoryData = _getCategoryVisualData(category);

    // Options de durée prédéfinies
    final durationOptions = [
      {'display': '30 min', 'value': '30'},
      {'display': '1h', 'value': '60'},
      {'display': '1h 30min', 'value': '90'},
      {'display': '2h', 'value': '120'},
      {'display': '2h 30min', 'value': '150'},
      {'display': '3h', 'value': '180'},
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: categoryData['gradient'] as List<Color>),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
                        ),
                        // Remplacé l'emoji par l'image
                        child: Image.asset(
                          category.imagePath,
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.spa, size: 24, color: Colors.white);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Service', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1B2B3E))),
                            const SizedBox(height: 4),
                            Text(category.displayName, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Section image avec bouton amélioré
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Service Photo (Optional)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E))),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() => imagePath = image.path);
                          }
                        },
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: imagePath == null
                                ? LinearGradient(colors: [
                                    (categoryData['gradient'] as List<Color>)[0].withOpacity(0.05),
                                    (categoryData['gradient'] as List<Color>)[1].withOpacity(0.05),
                                  ])
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: imagePath == null ? Colors.grey[300]! : (categoryData['gradient'] as List<Color>)[0],
                              width: imagePath == null ? 1.5 : 2,
                            ),
                            image: imagePath != null ? DecorationImage(image: FileImage(File(imagePath!)), fit: BoxFit.cover) : null,
                          ),
                          child: imagePath == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text('Add Photo (Optional)', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(Icons.edit, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  _buildDialogTextField(label: 'Service Name', hint: 'e.g., Haircut, Manicure...', controller: nameController),
                  const SizedBox(height: 16),
                  _buildDialogTextField(label: 'Description (optional)', hint: 'Describe your service...', controller: descriptionController, maxLines: 3),
                  
                  // Sélecteur de durée amélioré
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E))),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDuration,
                            isExpanded: true,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Select duration', style: GoogleFonts.inter(color: Colors.grey[400])),
                            ),
                            items: durationOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option['value'],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(option['display']!, style: GoogleFonts.inter(fontSize: 14)),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDuration = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  _buildDialogTextField(label: 'Price (TND)', hint: '0.00', controller: priceController, keyboardType: TextInputType.number),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text('Cancel', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.trim().isNotEmpty && 
                              priceController.text.trim().isNotEmpty &&
                              selectedDuration != null) {
                            final service = CustomService(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text.trim(),
                              description: descriptionController.text.trim(),
                              price: double.tryParse(priceController.text) ?? 0.0,
                              duration: double.tryParse(selectedDuration!),
                              photoPath: imagePath,
                              category: category.value,
                            );
                            vm.addCustomService(service);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (categoryData['gradient'] as List<Color>)[0],
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        child: Text('Save Service', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
    final category = TreatmentCategory.values.firstWhere((cat) => cat.value == service.category.toUpperCase(), orElse: () => TreatmentCategory.HAIRCUT);
    final categoryData = _getCategoryVisualData(category);

    // Options de durée prédéfinies
    final durationOptions = [
      {'display': '30 min', 'value': '30'},
      {'display': '1h', 'value': '60'},
      {'display': '1h 30min', 'value': '90'},
      {'display': '2h', 'value': '120'},
      {'display': '2h 30min', 'value': '150'},
      {'display': '3h', 'value': '180'},
    ];
    
    String? selectedDuration = service.duration?.toString();

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
                decoration: BoxDecoration(gradient: LinearGradient(colors: categoryData['gradient'] as List<Color>), borderRadius: BorderRadius.circular(10)),
                // Remplacé l'icône par l'image de la catégorie
                child: Image.asset(
                  category.imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.edit_outlined, color: Colors.white, size: 24);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('Edit Service', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1B2B3E)))),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section image améliorée
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Photo', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E))),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() => imagePath = image.path);
                        }
                      },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: imagePath == null
                              ? LinearGradient(colors: [
                                  (categoryData['gradient'] as List<Color>)[0].withOpacity(0.05),
                                  (categoryData['gradient'] as List<Color>)[1].withOpacity(0.05),
                                ])
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: imagePath == null ? Colors.grey[300]! : (categoryData['gradient'] as List<Color>)[0],
                            width: imagePath == null ? 1.5 : 2,
                          ),
                          image: imagePath != null ? DecorationImage(image: FileImage(File(imagePath!)), fit: BoxFit.cover) : null,
                        ),
                        child: imagePath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text('Add Photo', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                                ],
                              )
                            : Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                _buildDialogTextField(label: 'Service Name', hint: 'Service name', controller: nameController),
                const SizedBox(height: 16),
                _buildDialogTextField(label: 'Description', hint: 'Service description', controller: descriptionController, maxLines: 3),
                
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E))),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDuration,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Select duration', style: GoogleFonts.inter(color: Colors.grey[400])),
                          ),
                          items: durationOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(option['display']!, style: GoogleFonts.inter(fontSize: 14)),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDuration = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                _buildDialogTextField(label: 'Price (TND)', hint: '0.00', controller: priceController, keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Cancel', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600]))
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty && 
                    priceController.text.trim().isNotEmpty &&
                    selectedDuration != null) {
                  final updatedService = CustomService(
                    id: service.id,
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    price: double.tryParse(priceController.text) ?? 0.0,
                    duration: double.tryParse(selectedDuration!),
                    photoPath: imagePath,
                    specificGender: selectedGender,
                    category: service.category,
                  );
                  vm.updateCustomService(updatedService);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (categoryData['gradient'] as List<Color>)[0],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Save Changes', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.delete_outline, color: Colors.red[600], size: 24),
            ),
            const SizedBox(width: 12),
            Text('Delete Service', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        content: Text('Are you sure you want to delete this service? This action cannot be undone.', style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600))
          ),
          ElevatedButton(
            onPressed: () {
              vm.removeCustomService(serviceId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600], 
              foregroundColor: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: Text('Delete', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1B2B3E))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50], 
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(color: Colors.grey[200]!)
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
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Services',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select services from our catalog or create your own',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}