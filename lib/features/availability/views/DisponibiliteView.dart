import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisponibiliteView extends StatefulWidget {
  const DisponibiliteView({Key? key}) : super(key: key);

  @override
  State<DisponibiliteView> createState() => _DisponibiliteViewState();
}

class _DisponibiliteViewState extends State<DisponibiliteView> {
  // État du mode vacances
  bool _modeVacances = false;

  // États de disponibilité pour chaque jour
  Map<String, DayAvailability> _availability = {
    'Lundi': DayAvailability(
      isAvailable: true,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Mardi': DayAvailability(
      isAvailable: true,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Mercredi': DayAvailability(
      isAvailable: true,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Jeudi': DayAvailability(
      isAvailable: true,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Vendredi': DayAvailability(
      isAvailable: false,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Samedi': DayAvailability(
      isAvailable: false,
      startTime: '9h00',
      endTime: '18h00',
    ),
    'Dimanche': DayAvailability(
      isAvailable: false,
      startTime: '9h00',
      endTime: '18h00',
    ),
  };

  // Options d'heures
  final List<String> _timeOptions = [
    '8h00', '8h30', '9h00', '9h30', '10h00', '10h30', '11h00', '11h30',
    '12h00', '12h30', '13h00', '13h30', '14h00', '14h30', '15h00', '15h30',
    '16h00', '16h30', '17h00', '17h30', '18h00', '18h30', '19h00', '19h30',
    '20h00', '20h30', '21h00', '21h30', '22h00',
  ];

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Modifications enregistrées avec succès',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1B2B3E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Disponibilité',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B2B3E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Mode vacances
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mode vacances',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                        Switch(
                          value: _modeVacances,
                          onChanged: (value) {
                            setState(() {
                              _modeVacances = value;
                            });
                          },
                          activeColor: const Color(0xFF6B7280),
                          inactiveThumbColor: const Color(0xFFE1E2E2),
                          inactiveTrackColor: const Color(0xFFE1E2E2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Liste des jours
                  ..._availability.entries.map((entry) {
                    return _buildDayCard(entry.key, entry.value);
                  }).toList(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bouton d'enregistrement
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB388FF), Color(0xFF9C27B0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB388FF).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Enregistrer les modifications',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(String day, DayAvailability availability) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête du jour
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Available',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: availability.isAvailable
                            ? const Color(0xFFB388FF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: availability.isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _availability[day]!.isAvailable = value;
                        });
                      },
                      activeColor: const Color(0xFFB388FF),
                      inactiveThumbColor: const Color(0xFFE1E2E2),
                      inactiveTrackColor: const Color(0xFFE1E2E2),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sélecteurs d'heures (si disponible)
          if (availability.isAvailable)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  // Depuis
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Depuis',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE1E2E2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: availability.startTime,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B2B3E)),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF1B2B3E),
                              ),
                              items: _timeOptions.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text('Sélectionner l\'heure'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _availability[day]!.startTime = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Flèche
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),

                  // À
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'À',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE1E2E2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: availability.endTime,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B2B3E)),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF1B2B3E),
                              ),
                              items: _timeOptions.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text('Sélectionner l\'heure'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _availability[day]!.endTime = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Classe pour gérer la disponibilité d'un jour
class DayAvailability {
  bool isAvailable;
  String startTime;
  String endTime;

  DayAvailability({
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });
}