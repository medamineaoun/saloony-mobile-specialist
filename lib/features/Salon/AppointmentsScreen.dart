import 'package:flutter/material.dart';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedFilter = 'Prochain';
  final List<String> _filters = [
    'Prochain',
    'En cours',
    'Complété',
    'Annulé'
  ];

  final List<Appointment> _appointments = [
    Appointment(
      clientName: 'Michael DeMoya',
      totalAmount: 402.00,
      serviceCount: 5,
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      status: AppointmentStatus.upcoming,
      services: [
        'Coupe de cheveux',
        'Coloration',
        'Soin barbe',
        'Massage cuir chevelu',
        'Brushing'
      ],
      clientAvatar: 'MD',
    ),
    Appointment(
      clientName: 'Michael DeMoya',
      totalAmount: 402.00,
      serviceCount: 5,
      dateTime: DateTime.now().add(const Duration(hours: 4)),
      status: AppointmentStatus.upcoming,
      services: [
        'Coupe de cheveux',
        'Coloration',
        'Soin barbe',
      ],
      clientAvatar: 'MD',
    ),
    Appointment(
      clientName: 'Michael DeMoya',
      totalAmount: 402.00,
      serviceCount: 5,
      dateTime: DateTime.now().add(const Duration(hours: 6)),
      status: AppointmentStatus.upcoming,
      services: [
        'Coupe de cheveux',
        'Coloration',
      ],
      clientAvatar: 'MD',
    ),
    Appointment(
      clientName: 'Sophie Martin',
      totalAmount: 150.00,
      serviceCount: 2,
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      status: AppointmentStatus.inProgress,
      services: [
        'Coupe femme',
        'Brushing'
      ],
      clientAvatar: 'SM',
    ),
    Appointment(
      clientName: 'Pierre Dubois',
      totalAmount: 85.00,
      serviceCount: 1,
      dateTime: DateTime.now().subtract(const Duration(hours: 3)),
      status: AppointmentStatus.completed,
      services: [
        'Coupe homme'
      ],
      clientAvatar: 'PD',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final filteredAppointments = _getFilteredAppointments();
    final upcomingCount = _appointments.where((a) => a.status == AppointmentStatus.upcoming).length;

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
          'Mes rendez-vous',
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
          // Filter Chips
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
                    selectedColor: _getFilterColor(filter),
                    side: BorderSide(
                      color: isSelected ? _getFilterColor(filter) : Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
            child: Divider(
              color: Colors.grey[300],
              height: 20,
            ),
          ),

          // Appointments Count
          if (_selectedFilter == 'Prochain')
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
                    'Prochains rendez-vous ($upcomingCount)',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

          // Appointments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return _buildAppointmentCard(appointment, isSmallScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewAppointmentDetails(appointment),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Client Avatar
                    Container(
                      width: isSmallScreen ? 40 : 48,
                      height: isSmallScreen ? 40 : 48,
                      decoration: BoxDecoration(
                        color: SaloonyColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
                      ),
                      child: Center(
                        child: Text(
                          appointment.clientAvatar,
                          style: TextStyle(
                            color: SaloonyColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),

                    // Client Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.clientName,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w600,
                              color: SaloonyColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            '${appointment.serviceCount} service${appointment.serviceCount > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: SaloonyColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount
                    Text(
                      '${appointment.totalAmount.toStringAsFixed(2)} \$',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w700,
                        color: SaloonyColors.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Services Preview
                if (appointment.services.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: appointment.services.take(3).map((service) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 10,
                          vertical: isSmallScreen ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 12,
                            color: SaloonyColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                if (appointment.services.length > 3)
                  Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
                    child: Text(
                      '+ ${appointment.services.length - 3} autres services',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date & Time
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 12,
                        vertical: isSmallScreen ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getStatusColor(appointment.status).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: isSmallScreen ? 14 : 16,
                            color: _getStatusColor(appointment.status),
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 6),
                          Text(
                            _formatDateTime(appointment.dateTime),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 13,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(appointment.status),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Button
                    if (appointment.status == AppointmentStatus.upcoming)
                      ElevatedButton(
                        onPressed: () => _markAsReady(appointment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SaloonyColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Marquer comme prêt',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else if (appointment.status == AppointmentStatus.inProgress)
                      ElevatedButton(
                        onPressed: () => _markAsCompleted(appointment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SaloonyColors.success,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Terminer',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 13,
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
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Prochain':
        return SaloonyColors.primary;
      case 'En cours':
        return SaloonyColors.warning;
      case 'Complété':
        return SaloonyColors.success;
      case 'Annulé':
        return SaloonyColors.error;
      default:
        return SaloonyColors.primary;
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return SaloonyColors.primary;
      case AppointmentStatus.inProgress:
        return SaloonyColors.warning;
      case AppointmentStatus.completed:
        return SaloonyColors.success;
      case AppointmentStatus.cancelled:
        return SaloonyColors.error;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (appointmentDate == today) {
      return "Aujourd'hui ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (appointmentDate == today.add(const Duration(days: 1))) {
      return "Demain ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  List<Appointment> _getFilteredAppointments() {
    switch (_selectedFilter) {
      case 'Prochain':
        return _appointments.where((a) => a.status == AppointmentStatus.upcoming).toList();
      case 'En cours':
        return _appointments.where((a) => a.status == AppointmentStatus.inProgress).toList();
      case 'Complété':
        return _appointments.where((a) => a.status == AppointmentStatus.completed).toList();
      case 'Annulé':
        return _appointments.where((a) => a.status == AppointmentStatus.cancelled).toList();
      default:
        return _appointments;
    }
  }

  void _viewAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails du rendez-vous'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Client', appointment.clientName),
              _buildDetailRow('Date', _formatDetailedDate(appointment.dateTime)),
              _buildDetailRow('Montant', '${appointment.totalAmount.toStringAsFixed(2)} \$'),
              _buildDetailRow('Nombre de services', appointment.serviceCount.toString()),
              SizedBox(height: 16),
              Text(
                'Services:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...appointment.services.map((service) => 
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• $service'),
                )
              ).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label :',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDetailedDate(DateTime dateTime) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    
    return '${days[dateTime.weekday - 1]} ${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} à ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _markAsReady(Appointment appointment) {
    setState(() {
      appointment.status = AppointmentStatus.inProgress;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rendez-vous marqué comme prêt'),
        backgroundColor: SaloonyColors.success,
      ),
    );
  }

  void _markAsCompleted(Appointment appointment) {
    setState(() {
      appointment.status = AppointmentStatus.completed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rendez-vous terminé'),
        backgroundColor: SaloonyColors.success,
      ),
    );
  }
}

enum AppointmentStatus {
  upcoming,
  inProgress,
  completed,
  cancelled,
}

class Appointment {
  String clientName;
  double totalAmount;
  int serviceCount;
  DateTime dateTime;
  AppointmentStatus status;
  List<String> services;
  String clientAvatar;

  Appointment({
    required this.clientName,
    required this.totalAmount,
    required this.serviceCount,
    required this.dateTime,
    required this.status,
    required this.services,
    required this.clientAvatar,
  });
}