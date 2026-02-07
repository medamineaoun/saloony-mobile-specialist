import 'package:flutter/material.dart';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
}

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final List<Client> _clients = [
    Client(
      name: 'André Sébastien',
      email: 'andre.sebastien@email.com',
      phone: '+216 12 345 678',
      totalBookings: 57,
      totalSpent: 425.0,
      isFavorite: true,
      isNew: false,
      lastVisit: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Client(
      name: 'Marie Dubois',
      email: 'marie.dubois@email.com',
      phone: '+216 12 345 679',
      totalBookings: 23,
      totalSpent: 189.0,
      isFavorite: false,
      isNew: true,
      lastVisit: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Client(
      name: 'Pierre Martin',
      email: 'pierre.martin@email.com',
      phone: '+216 12 345 680',
      totalBookings: 12,
      totalSpent: 95.0,
      isFavorite: true,
      isNew: false,
      lastVisit: DateTime.now().subtract(const Duration(days: 5)),
    ),
    // ... plus de clients
  ];

  String _selectedFilter = 'Tous les clients';
  final List<String> _filters = [
    'Tous les clients',
    'Favoris',
    'Nouveaux clients'
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 1200;

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
          'Nos clients',
          style: TextStyle(
            color: SaloonyColors.textPrimary,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar - Responsive
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
                        hintText: 'Rechercher un nom, un email, un téléphone...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500], size: isSmallScreen ? 18 : 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          // Filter Chips - Responsive
          SizedBox(
            height: isSmallScreen ? 50 : 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : SaloonyColors.textPrimary,
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: SaloonyColors.primary,
                    side: BorderSide(
                      color: isSelected ? SaloonyColors.primary : Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Clients Count - Responsive
          Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 20, 
              isSmallScreen ? 16 : 20, 
              isSmallScreen ? 16 : 20, 
              8
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clients (${_clients.length})',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: SaloonyColors.textPrimary,
                  ),
                ),
                if (_selectedFilter != 'Tous les clients')
                  Text(
                    _selectedFilter,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
            child: Divider(
              color: Colors.grey[300],
              height: 1,
            ),
          ),

          // Clients List - Responsive Layout
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isLargeScreen) {
                  // Grid layout for large screens
                  return _buildGridLayout();
                } else {
                  // List layout for small/medium screens
                  return _buildListLayout(isSmallScreen);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListLayout(bool isSmallScreen) {
    final filteredClients = _getFilteredClients();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      itemCount: filteredClients.length,
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return _buildClientCard(client, isSmallScreen);
      },
    );
  }

  Widget _buildGridLayout() {
    final filteredClients = _getFilteredClients();
    
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3.0,
      ),
      itemCount: filteredClients.length,
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return _buildClientCard(client, false);
      },
    );
  }

  Widget _buildClientCard(Client client, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewClientDetails(client, isSmallScreen),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                // Avatar with status
                Stack(
                  children: [
                    Container(
                      width: isSmallScreen ? 50 : 60,
                      height: isSmallScreen ? 50 : 60,
                      decoration: BoxDecoration(
                        color: SaloonyColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 25 : 30),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(client.name),
                          style: TextStyle(
                            color: SaloonyColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 16 : 18,
                          ),
                        ),
                      ),
                    ),
                    if (client.isFavorite)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: isSmallScreen ? 20 : 24,
                          height: isSmallScreen ? 20 : 24,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),

                // Client Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              client.name,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: SaloonyColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (client.isNew) ...[
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 10,
                                vertical: isSmallScreen ? 2 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: SaloonyColors.secondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: SaloonyColors.secondary),
                              ),
                              child: Text(
                                'Nouveau',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: SaloonyColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        '${client.totalBookings} réservations | ${client.totalSpent.toStringAsFixed(0)} \$ dépensés',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: SaloonyColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        'Dernière visite: ${_formatDate(client.lastVisit)}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      client.isFavorite = !client.isFavorite;
                    });
                  },
                  icon: Icon(
                    client.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: client.isFavorite ? Colors.red : Colors.grey[400],
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Client> _getFilteredClients() {
    List<Client> filtered = _clients;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((client) =>
          client.name.toLowerCase().contains(query) ||
          client.email.toLowerCase().contains(query) ||
          client.phone.contains(query)).toList();
    }

    switch (_selectedFilter) {
      case 'Favoris':
        filtered = filtered.where((client) => client.isFavorite).toList();
        break;
      case 'Nouveaux clients':
        filtered = filtered.where((client) => client.isNew).toList();
        break;
      case 'Tous les clients':
      default:
        break;
    }

    return filtered;
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.length >= 2 ? name.substring(0, 2) : name;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _viewClientDetails(Client client, bool isSmallScreen) {
    showDialog(
      context: context,
      builder: (context) => ResponsiveDialog(
        isSmallScreen: isSmallScreen,
        title: 'Détails de ${client.name}',
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', client.email, isSmallScreen),
              _buildDetailRow('Téléphone', client.phone, isSmallScreen),
              _buildDetailRow('Total réservations', client.totalBookings.toString(), isSmallScreen),
              _buildDetailRow('Total dépensé', '${client.totalSpent.toStringAsFixed(2)} \$', isSmallScreen),
              _buildDetailRow('Dernière visite', _formatDate(client.lastVisit), isSmallScreen),
              _buildDetailRow('Statut', client.isNew ? 'Nouveau client' : 'Client régulier', isSmallScreen),
              _buildDetailRow('Favori', client.isFavorite ? 'Oui' : 'Non', isSmallScreen),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement edit client
              Navigator.pop(context);
            },
            child: Text(
              'Modifier',
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isSmallScreen ? 120 : 140,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveDialog extends StatelessWidget {
  final bool isSmallScreen;
  final String title;
  final Widget child;
  final List<Widget> actions;

  const ResponsiveDialog({
    super.key,
    required this.isSmallScreen,
    required this.title,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: screenWidth * (isSmallScreen ? 0.9 : 0.6),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            child,
            SizedBox(height: isSmallScreen ? 16 : 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}

class Client {
  String name;
  String email;
  String phone;
  int totalBookings;
  double totalSpent;
  bool isFavorite;
  bool isNew;
  DateTime lastVisit;

  Client({
    required this.name,
    required this.email,
    required this.phone,
    required this.totalBookings,
    required this.totalSpent,
    required this.isFavorite,
    required this.isNew,
    required this.lastVisit,
  });
}