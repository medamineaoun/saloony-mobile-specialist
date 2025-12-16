import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/core/services/TreatmentService.dart';
import 'package:SaloonySpecialist/core/services/AuthService.dart';
import 'package:SaloonySpecialist/core/services/SalonService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SaloonySpecialist/core/enum/TreatmentCategory.dart';
import 'dart:io';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
}

class TreatmentsManagementScreen extends StatefulWidget {
  const TreatmentsManagementScreen({super.key});

  @override
  State<TreatmentsManagementScreen> createState() => _TreatmentsManagementScreenState();
}

class _TreatmentsManagementScreenState extends State<TreatmentsManagementScreen> {
  final TreatmentService _treatmentService = TreatmentService();
  final AuthService _authService = AuthService();
  final SalonService _salonService = SalonService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _allTreatments = [];
  List<Map<String, dynamic>> _filteredTreatments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final Map<String, bool> _expandedCategories = {};

  late final Map<String, CategoryInfo> _categories = _buildCategoriesFromEnum();

  Map<String, CategoryInfo> _buildCategoriesFromEnum() {
    final map = <String, CategoryInfo>{};
    for (final cat in TreatmentCategory.values) {
      final visual = _getCategoryVisualData(cat);
      final Color primary = (visual['gradient'] as List<Color>)[0];
      final imagePath = 'assets/images/treatment_categories/${cat.imagePath}';
      map[cat.displayName] = CategoryInfo(
        emoji: visual['emoji'] ?? '📋',
        color: primary,
        imagePath: imagePath,
      );
    }
    return map;
  }

  Map<String, dynamic> _getCategoryVisualData(TreatmentCategory category) {
    switch (category) {
      case TreatmentCategory.HAIRCUT:
        return {
          'gradient': [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
          'emoji': '✂️'
        };
      case TreatmentCategory.COLORING:
        return {
          'gradient': [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
          'emoji': '🎨'
        };
      case TreatmentCategory.BEARD:
        return {
          'gradient': [const Color(0xFF78716C), const Color(0xFF57534E)],
          'emoji': '🧔'
        };
      case TreatmentCategory.FACIAL:
        return {
          'gradient': [const Color(0xFF14B8A6), const Color(0xFF06B6D4)],
          'emoji': '✨'
        };
      case TreatmentCategory.MASSAGE:
        return {
          'gradient': [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
          'emoji': '💆'
        };
      case TreatmentCategory.NAILS:
        return {
          'gradient': [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
          'emoji': '💅'
        };
      case TreatmentCategory.WAXING:
        return {
          'gradient': [const Color(0xFFEF4444), const Color(0xFFF97316)],
          'emoji': '🔥'
        };
      case TreatmentCategory.MAKEUP:
        return {
          'gradient': [const Color(0xFFF59E0B), const Color(0xFFEC4899)],
          'emoji': '💄'
        };
      default:
        return {
          'gradient': [const Color(0xFF64748B), const Color(0xFF475569)],
          'emoji': '📋'
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    setState(() => _isLoading = true);

    try {
      final userResult = await _authService.getCurrentUser();
      String? salonId;

      if (userResult['success'] == true && userResult['user'] != null) {
        final user = userResult['user'];
        final userId = user['userId'] ?? user['id'];

        if (userId != null && userId.toString().isNotEmpty) {
          final salonResult = await _salonService.getSpecialistSalon(userId.toString());
          if (salonResult['success'] == true && salonResult['salon'] != null) {
            final salon = salonResult['salon'];
            salonId = salon['salonId']?.toString() ?? salon['id']?.toString();
          }
        }
      }

      Map<String, dynamic> result;

      if (salonId != null && salonId.isNotEmpty) {
        result = await _treatmentService.getTreatmentsBySalon(salonId);
      } else {
        result = await _treatmentService.getAllTreatments();
      }

      if (result['success'] == true) {
        setState(() {
          _allTreatments = List<Map<String, dynamic>>.from(result['treatments'] ?? []);
          _filteredTreatments = _allTreatments;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Erreur de chargement')),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur inattendue: $e')),
        );
      }
    }
  }

  void _filterTreatments(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTreatments = _allTreatments;
      } else {
        _filteredTreatments = _allTreatments.where((treatment) {
          final name = treatment['treatmentName']?.toString().toLowerCase() ?? '';
          final description = treatment['treatmentDescription']?.toString().toLowerCase() ?? '';
          final category = treatment['treatmentCategory']?.toString().toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          
          return name.contains(searchLower) || 
                 description.contains(searchLower) || 
                 category.contains(searchLower);
        }).toList();
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupTreatmentsByCategory() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var treatment in _filteredTreatments) {
      final raw = treatment['treatmentCategory']?.toString() ?? '';
      String key = 'Autre';
      try {
        final enumCat = TreatmentCategory.fromString(raw.toUpperCase());
        key = enumCat.displayName;
      } catch (_) {
        if (raw.isNotEmpty) key = raw;
      }

      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(treatment);
    }

    for (final cat in TreatmentCategory.values) {
      if (!grouped.containsKey(cat.displayName)) grouped[cat.displayName] = [];
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final groupedTreatments = _groupTreatmentsByCategory();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: SaloonyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nos traitements',
          style: TextStyle(
            color: SaloonyColors.textPrimary,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: SaloonyColors.primary),
            onPressed: _addNewTreatment,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Container(
                    height: isSmallScreen ? 50 : 56,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: isSmallScreen ? 16 : 20),
                        Icon(Icons.search, color: Colors.grey[500], size: isSmallScreen ? 20 : 22),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Rechercher un traitement',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: _filterTreatments,
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[500], size: isSmallScreen ? 18 : 20),
                            onPressed: () {
                              _searchController.clear();
                              _filterTreatments('');
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmallScreen ? 16 : 20, 
                    0, 
                    isSmallScreen ? 16 : 20, 
                    isSmallScreen ? 16 : 20
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Traitements disponibles (${_filteredTreatments.length})',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
                  child: _buildSelectionSummary(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _filteredTreatments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun traitement trouvé',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadTreatments,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
                            itemCount: groupedTreatments.length,
                            itemBuilder: (context, index) {
                              final category = groupedTreatments.keys.elementAt(index);
                              final treatments = groupedTreatments[category]!;
                              return _buildCategoryAccordion(category, treatments, isSmallScreen);
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTreatment,
        backgroundColor: SaloonyColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryAccordion(String category, List<Map<String, dynamic>> treatments, bool isSmallScreen) {
    final categoryInfo = _categories[category] ?? CategoryInfo(
      emoji: '📋',
      color: Colors.grey,
      imagePath: null,
    );

    String? effectiveImage = categoryInfo.imagePath;
    final expanded = _expandedCategories[category] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedCategories[category] = !expanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: expanded ? categoryInfo.color.withOpacity(0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: expanded ? categoryInfo.color : Colors.grey[200]!),
                ),
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Row(
                  children: [
                    Container(
                      width: isSmallScreen ? 44 : 52,
                      height: isSmallScreen ? 44 : 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryInfo.color,
                            categoryInfo.color.withOpacity(0.7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: effectiveImage != null
                            ? Image.asset(
                                effectiveImage,
                                width: isSmallScreen ? 24 : 28,
                                height: isSmallScreen ? 24 : 28,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stack) => Text(
                                  categoryInfo.emoji,
                                  style: TextStyle(fontSize: isSmallScreen ? 18 : 20, color: Colors.white),
                                ),
                              )
                            : Text(
                                categoryInfo.emoji,
                                style: TextStyle(fontSize: isSmallScreen ? 18 : 20),
                              ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                              color: SaloonyColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 6),
                          Text(
                            '${treatments.length} traitement${treatments.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: SaloonyColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: categoryInfo.color),
                      onPressed: () => _addNewTreatment(category),
                    ),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: EdgeInsets.only(left: isSmallScreen ? 12 : 16, top: isSmallScreen ? 8 : 12),
              child: Column(
                children: treatments.map((t) => _buildTreatmentItem(t, categoryInfo.color, isSmallScreen)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionSummary() {
    final total = _allTreatments.length;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: total > 0 ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: total > 0 ? Colors.green.shade200 : Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(total > 0 ? Icons.check_circle : Icons.info_outline, color: total > 0 ? Colors.green : Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              total > 0 ? '✓ $total traitement${total > 1 ? 's' : ''} disponibles' : 'Aucun traitement — ajoutez des services',
              style: TextStyle(color: total > 0 ? Colors.green.shade900 : Colors.orange.shade900, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentItem(Map<String, dynamic> treatment, Color categoryColor, bool isSmallScreen) {
    final treatmentName = treatment['treatmentName']?.toString() ?? 'Sans nom';
    final treatmentDescription = treatment['treatmentDescription']?.toString() ?? '';
    final treatmentPrice = (treatment['treatmentPrice'] ?? 0).toDouble();
    final treatmentDuration = (treatment['treatmentTime'] ?? 0).toDouble();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _editTreatment(treatment),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 48 : 56,
                  height: isSmallScreen ? 48 : 56,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.spa_outlined,
                    color: categoryColor,
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatmentName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 17,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                      if (treatmentDescription.isNotEmpty) ...[
                        SizedBox(height: isSmallScreen ? 4 : 6),
                        Text(
                          treatmentDescription,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: SaloonyColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${treatmentPrice.toStringAsFixed(0)} TND',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                fontWeight: FontWeight.w600,
                                color: categoryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${treatmentDuration.toInt()} min',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[500], size: isSmallScreen ? 20 : 24),
                  onSelected: (value) => _handleTreatmentAction(value, treatment),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: isSmallScreen ? 18 : 20),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text('Modifier', style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'photo',
                      child: Row(
                        children: [
                          Icon(Icons.photo_camera_outlined, size: isSmallScreen ? 18 : 20),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text('Ajouter photo', style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: isSmallScreen ? 18 : 20, color: Colors.red),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text('Supprimer', style: TextStyle(color: Colors.red, fontSize: isSmallScreen ? 14 : 16)),
                        ],
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

  void _addNewTreatment([String? preselectedCategory]) {
    showDialog(
      context: context,
      builder: (context) => _buildTreatmentDialog(null, preselectedCategory),
    );
  }

  void _editTreatment(Map<String, dynamic> treatment) {
    showDialog(
      context: context,
      builder: (context) => _buildTreatmentDialog(treatment),
    );
  }

  Widget _buildTreatmentDialog(Map<String, dynamic>? existingTreatment, [String? preselectedCategory]) {
    final isEditing = existingTreatment != null;
    final nameController = TextEditingController(
      text: existingTreatment?['treatmentName']?.toString()
    );
    final descriptionController = TextEditingController(
      text: existingTreatment?['treatmentDescription']?.toString()
    );
    final priceController = TextEditingController(
      text: existingTreatment != null 
        ? (existingTreatment['treatmentPrice'] ?? 0).toDouble().toStringAsFixed(0)
        : ''
    );
    final durationController = TextEditingController(
      text: existingTreatment != null
        ? (existingTreatment['treatmentTime'] ?? 0).toDouble().toInt().toString()
        : ''
    );
    String selectedCategory = existingTreatment?['treatmentCategory']?.toString() 
      ?? preselectedCategory
      ?? _categories.keys.first;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Modifier le traitement' : 'Ajouter un traitement',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDialogTextField('Nom du traitement', 'Ex: Coupe Homme Classique', nameController),
                  const SizedBox(height: 16),
                  _buildDialogTextField('Description', 'Description du traitement...', descriptionController, maxLines: 3),
                  const SizedBox(height: 16),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catégorie',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            items: _categories.keys.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Row(
                                  children: [
                                    Text(_categories[category]!.emoji),
                                    const SizedBox(width: 12),
                                    Text(category),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setDialogState(() {
                                  selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDialogTextField('Prix (TND)', '0', priceController, keyboardType: TextInputType.number),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDialogTextField('Durée (min)', '30', durationController, keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty || 
                              priceController.text.isEmpty || 
                              durationController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
                            );
                            return;
                          }

                          final price = double.tryParse(priceController.text) ?? 0;
                          final duration = double.tryParse(durationController.text) ?? 0;

                          Map<String, dynamic> result;
                          
                          if (isEditing) {
                            final treatmentId = existingTreatment['treatmentId']?.toString() 
                              ?? existingTreatment['id']?.toString() ?? '';
                            result = await _treatmentService.updateTreatment(
                              treatmentId: treatmentId,
                              name: nameController.text,
                              description: descriptionController.text,
                              price: price,
                              duration: duration,
                              category: selectedCategory,
                            );
                          } else {
                            result = await _treatmentService.addTreatment(
                              name: nameController.text,
                              description: descriptionController.text,
                              price: price,
                              duration: duration,
                              category: selectedCategory,
                            );
                          }

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['success'] == true
                                  ? isEditing ? 'Traitement modifié avec succès' : 'Traitement ajouté avec succès'
                                  : result['message'] ?? 'Une erreur est survenue'),
                              ),
                            );
                            
                            if (result['success'] == true) {
                              _loadTreatments();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SaloonyColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(isEditing ? 'Modifier' : 'Ajouter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildDialogTextField(
    String label, 
    String hint, 
    TextEditingController controller, 
    {int maxLines = 1, TextInputType? keyboardType}
  ) {
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
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _handleTreatmentAction(String action, Map<String, dynamic> treatment) async {
    switch (action) {
      case 'edit':
        _editTreatment(treatment);
        break;
      case 'photo':
        await _addTreatmentPhoto(treatment);
        break;
      case 'delete':
        _confirmDelete(treatment);
        break;
    }
  }

  Future<void> _addTreatmentPhoto(Map<String, dynamic> treatment) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final treatmentId = treatment['treatmentId']?.toString() 
        ?? treatment['id']?.toString() ?? '';
      
      final result = await _treatmentService.uploadTreatmentPhoto(
        treatmentId, 
        image.path
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['success'] == true 
              ? 'Photo ajoutée avec succès' 
              : result['message'] ?? 'Erreur lors de l\'ajout de la photo'),
          ),
        );
        
        if (result['success'] == true) {
          _loadTreatments();
        }
      }
    }
  }

  void _confirmDelete(Map<String, dynamic> treatment) {
    final treatmentName = treatment['treatmentName']?.toString() ?? 'ce traitement';
    final treatmentId = treatment['treatmentId']?.toString() 
      ?? treatment['id']?.toString() ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le traitement'),
        content: Text('Êtes-vous sûr de vouloir supprimer "$treatmentName" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final result = await _treatmentService.deleteTreatment(treatmentId);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['success'] == true
                      ? 'Traitement supprimé avec succès'
                      : result['message'] ?? 'Erreur lors de la suppression'),
                  ),
                );
                
                if (result['success'] == true) {
                  _loadTreatments();
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CategoryInfo {
  final String emoji;
  final Color color;
  final String? imagePath;

  CategoryInfo({
    required this.emoji,
    required this.color,
    this.imagePath,
  });
}