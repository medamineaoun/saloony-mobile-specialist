import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/enum/TreatmentCategory.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';

class ServicesManagementPage extends StatefulWidget {
  const ServicesManagementPage({super.key});

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

        // Category List (vertical)
        _buildCategoryList(vm),
        const SizedBox(height: 24),

      

        const SizedBox(height: 100),
      ],
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
              category: category,
              count: count,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedCategory = category;
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
    required TreatmentCategory category,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onAdd,
  }) {
    final categoryData = _getCategoryVisualData(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
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
                // Category Icon
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
                    child: Text(
                      category.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Category Info
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
                        '$count types',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Three dots menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                  ),
                  onSelected: (value) {
                    if (value == 'add') {
                      onAdd();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                 PopupMenuItem<String>(
  value: 'add',
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: (categoryData['gradient'] as List<Color>)[0].withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add,
          color: (categoryData['gradient'] as List<Color>)[0],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Create a Service',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1B2B3E),
          ),
        ),
      ],
    ),
  ),
),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryVisualData(TreatmentCategory category) {
    switch (category) {
      case TreatmentCategory.HAIRCUT:
        return {
          'gradient': [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
        };
      case TreatmentCategory.COLORING:
        return {
          'gradient': [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
        };
      case TreatmentCategory.BEARD:
        return {
          'gradient': [const Color(0xFF78716C), const Color(0xFF57534E)],
        };
      case TreatmentCategory.FACIAL:
        return {
          'gradient': [const Color(0xFF14B8A6), const Color(0xFF06B6D4)],
        };
      case TreatmentCategory.MASSAGE:
        return {
          'gradient': [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
        };
      case TreatmentCategory.NAILS:
        return {
          'gradient': [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
        };
      case TreatmentCategory.WAXING:
        return {
          'gradient': [const Color(0xFFEF4444), const Color(0xFFF97316)],
        };
      case TreatmentCategory.MAKEUP:
        return {
          'gradient': [const Color(0xFFF59E0B), const Color(0xFFEC4899)],
        };
      default:
        return {
          'gradient': [const Color(0xFF64748B), const Color(0xFF475569)],
        };
    }
  }

  int _getServiceCountForCategory(SalonCreationViewModel vm, TreatmentCategory category) {
    final apiCount = vm.availableTreatments
        .where((t) => t.treatmentCategory?.toUpperCase() == category.value)
        .length;
    
    final customCount = vm.customServices
        .where((s) => s.category?.toUpperCase() == category.value)
        .length;
    
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
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: categoryColor.withOpacity(0.2),
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
                // Service Image
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

                // Service Info
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
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  children: [
                    if (!isCustom) ...[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? categoryColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? categoryColor : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: isSelected ? Colors.white : Colors.transparent,
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
void _showAddServiceDialog(
    BuildContext context, SalonCreationViewModel vm, TreatmentCategory category) {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  String? selectedGender;
  String? imagePath;

  final categoryData = _getCategoryVisualData(category);

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
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: categoryData['gradient'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Service',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Image Upload
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() => imagePath = image.path);
                    }
                  },
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: imagePath == null
                          ? LinearGradient(
                              colors: [
                                (categoryData['gradient'] as List<Color>)[0]
                                    .withOpacity(0.1),
                                (categoryData['gradient'] as List<Color>)[1]
                                    .withOpacity(0.1),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (categoryData['gradient'] as List<Color>)[0]
                            .withOpacity(0.3),
                        width: 2,
                      ),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color:
                                    (categoryData['gradient'] as List<Color>)[0],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Service Photo',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      (categoryData['gradient'] as List<Color>)[0],
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Input Fields
                _buildDialogTextField(
                  label: 'Service Name',
                  hint: 'e.g., Haircut, Manicure...',
                  controller: nameController,
                ),
            
           
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Description (optional)',
                  hint: 'Describe your service...',
                  controller: descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Duration (minutes)',
                  hint: '30',
                  controller: durationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Price',
                  hint: '\$0.00',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                            category: category.value,
                          );
                          vm.addCustomService(service);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (categoryData['gradient'] as List<Color>)[0],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
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

    final category = TreatmentCategory.values.firstWhere(
      (cat) => cat.value == service.category?.toUpperCase(),
      orElse: () => TreatmentCategory.HAIRCUT,
    );
    final categoryData = _getCategoryVisualData(category);

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
                    colors: categoryData['gradient'] as List<Color>,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Edit Service',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      gradient: imagePath == null 
                          ? LinearGradient(
                              colors: [
                                (categoryData['gradient'] as List<Color>)[0].withOpacity(0.1),
                                (categoryData['gradient'] as List<Color>)[1].withOpacity(0.1),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (categoryData['gradient'] as List<Color>)[0].withOpacity(0.3),
                        width: 2,
                      ),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imagePath == null
                        ? Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: (categoryData['gradient'] as List<Color>)[0],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDialogTextField(
                  label: 'Service Name',
                  hint: 'Service name',
                  controller: nameController,
                ),
                const SizedBox(height: 16),
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
                  hint: 'Service description',
                  controller: descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Price',
                  hint: '\$0.00',
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
                'Cancel',
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
                backgroundColor: (categoryData['gradient'] as List<Color>)[0],
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

  void _confirmDelete(BuildContext context, SalonCreationViewModel vm, String serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red[600], size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Service',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this service? This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              vm.removeCustomService(serviceId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                ' Treatments',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}