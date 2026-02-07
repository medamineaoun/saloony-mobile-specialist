import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
}

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() => _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen> {
  final List<ServiceCategory> _categories = [
    ServiceCategory(
      name: 'Coupes de cheveux',
      emoji: '💇',
      serviceCount: 5,
      color: const Color(0xFF8B5CF6),
      services: [
        Service(
          name: 'Coupe Homme Classique',
          description: 'Coupe traditionnelle avec finitions précises',
          price: 25.0,
          duration: 30,
          isSelected: true,
        ),
        Service(
          name: 'Coupe Femme Moderne',
          description: 'Coupe tendance avec mise en forme',
          price: 35.0,
          duration: 45,
          isSelected: true,
        ),
        Service(
          name: 'Coupe Enfant',
          description: 'Coupe adaptée aux plus jeunes',
          price: 20.0,
          duration: 25,
          isSelected: false,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Coloration',
      emoji: '🎨',
      serviceCount: 3,
      color: const Color(0xFFF59E0B),
      services: [
        Service(
          name: 'Coloration Complète',
          description: 'Coloration uniforme sur toute la chevelure',
          price: 45.0,
          duration: 60,
          isSelected: true,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Soins Barbe',
      emoji: '🧔',
      serviceCount: 4,
      color: const Color(0xFF78716C),
      services: [
        Service(
          name: 'Taille Barbe Premium',
          description: 'Taille précise avec soin hydratant',
          price: 20.0,
          duration: 25,
          isSelected: true,
        ),
      ],
    ),
    ServiceCategory(
      name: 'Soins Visage',
      emoji: '✨',
      serviceCount: 6,
      color: const Color(0xFF14B8A6),
      services: [
        Service(
          name: 'Nettoyage Profond',
          description: 'Soin purifiant et hydratant',
          price: 40.0,
          duration: 45,
          isSelected: false,
        ),
      ],
    ),
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final totalServices = _categories.fold(0, (sum, category) => sum + category.serviceCount);

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
          'Nos services',
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
            onPressed: _addNewService,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
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
                        hintText: 'Service de recherche',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500], size: isSmallScreen ? 18 : 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          // Services Count
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
                  'Services disponibles ($totalServices)',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: SaloonyColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Categories List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildCategoryCard(category, isSmallScreen);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewService,
        backgroundColor: SaloonyColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryCard(ServiceCategory category, bool isSmallScreen) {
    final filteredServices = _searchQuery.isEmpty 
        ? category.services 
        : category.services.where((service) => 
            service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            service.description.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 40 : 48,
                  height: isSmallScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      category.emoji,
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
                        category.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        '${category.serviceCount} types de services ajoutés',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: SaloonyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: isSmallScreen ? 16 : 18,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),

          // Services List
          if (filteredServices.isNotEmpty)
            Column(
              children: filteredServices.map((service) => _buildServiceItem(service, category.color, isSmallScreen)).toList(),
            )
          else if (_searchQuery.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
              child: Text(
                'Aucun service trouvé',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Service service, Color categoryColor, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _editService(service),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: isSmallScreen ? 20 : 24,
                  height: isSmallScreen ? 20 : 24,
                  decoration: BoxDecoration(
                    color: service.isSelected ? categoryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: service.isSelected ? categoryColor : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: service.isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: isSmallScreen ? 14 : 16,
                        )
                      : null,
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),

                // Service Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 17,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: SaloonyColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                              '${service.price.toStringAsFixed(0)} TND',
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
                              '${service.duration} min',
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

                // Actions
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[500], size: isSmallScreen ? 20 : 24),
                  onSelected: (value) => _handleServiceAction(value, service),
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
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            service.isSelected ? Icons.toggle_off : Icons.toggle_on,
                            size: isSmallScreen ? 18 : 20,
                            color: service.isSelected ? Colors.grey : categoryColor,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            service.isSelected ? 'Désactiver' : 'Activer',
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                          ),
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

  void _addNewService() {
    showDialog(
      context: context,
      builder: (context) => _buildServiceDialog(null),
    );
  }

  void _editService(Service service) {
    showDialog(
      context: context,
      builder: (context) => _buildServiceDialog(service),
    );
  }

  Widget _buildServiceDialog(Service? existingService) {
    final isEditing = existingService != null;
    final nameController = TextEditingController(text: existingService?.name);
    final descriptionController = TextEditingController(text: existingService?.description);
    final priceController = TextEditingController(text: existingService?.price.toStringAsFixed(0));
    final durationController = TextEditingController(text: existingService?.duration.toString());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Modifier le service' : 'Ajouter un service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildDialogTextField('Nom du service', 'Ex: Coupe Homme Classique', nameController),
            const SizedBox(height: 16),
            _buildDialogTextField('Description', 'Description du service...', descriptionController, maxLines: 3),
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
                  onPressed: () {
                    if (nameController.text.isNotEmpty && 
                        priceController.text.isNotEmpty && 
                        durationController.text.isNotEmpty) {
                      // TODO: Save service logic
                      Navigator.pop(context);
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
    );
  }

  Widget _buildDialogTextField(String label, String hint, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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

  void _handleServiceAction(String action, Service service) {
    switch (action) {
      case 'edit':
        _editService(service);
        break;
      case 'toggle':
        setState(() {
          service.isSelected = !service.isSelected;
        });
        break;
      case 'delete':
        _confirmDelete(service);
        break;
    }
  }

  void _confirmDelete(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le service'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${service.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete service logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class ServiceCategory {
  final String name;
  final String emoji;
  final int serviceCount;
  final Color color;
  final List<Service> services;

  ServiceCategory({
    required this.name,
    required this.emoji,
    required this.serviceCount,
    required this.color,
    required this.services,
  });
}

class Service {
  String name;
  String description;
  double price;
  int duration;
  bool isSelected;

  Service({
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.isSelected,
  });
}