import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  String? selectedDay;
  
  // Générer les créneaux horaires de 00h00 à 23h00
  List<String> generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 0; hour < 24; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}h00');
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);
    final timeSlots = generateTimeSlots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(),
        const SizedBox(height: 24),
        
        // Liste des jours de la semaine
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajoutez votre disponibilité hebdomadaire afin que les clients sachent à vous êtes disponible ou non.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              
              // Jours de la semaine
              ...vm.weeklyAvailability.entries.map((entry) {
                final dayName = entry.key;
                final dayData = entry.value;
                final isSelected = selectedDay == dayName;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedDay = dayName;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF1B2B3E).withOpacity(0.05)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF1B2B3E)
                                : Colors.grey[200]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dayName,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                            ),
                            if (dayData.isAvailable && dayData.timeRange != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[700]),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Sélectionné',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'z ${_formatTimeSlot(dayData.timeRange!.startTime)} - ${_formatTimeSlot(dayData.timeRange!.endTime)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1B2B3E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 12),
                            Icon(
                              isSelected ? Icons.arrow_drop_down : Icons.arrow_right,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        
        // Time slots pour le jour sélectionné
        if (selectedDay != null) ...[
          const SizedBox(height: 24),
          _buildTimeSlotSelector(vm, selectedDay!, timeSlots),
        ],
      ],
    );
  }

  Widget _buildTimeSlotSelector(SalonCreationViewModel vm, String day, List<String> timeSlots) {
    final dayData = vm.weeklyAvailability[day]!;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2B3E).withOpacity(0.05),
            const Color(0xFFF0CD97).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: const Color(0xFF1B2B3E), size: 20),
              const SizedBox(width: 12),
              Text(
                'Disponibilité',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    'Available',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dayData.isAvailable ? const Color(0xFF1B2B3E) : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: dayData.isAvailable,
                  onChanged: (value) {
  final entries = vm.weeklyAvailability.entries.toList();
  final index = entries.indexWhere((entry) => entry.key == day);
  if (index != -1) {
    vm.toggleDayAvailability(index);
  }
},
                    activeColor: const Color(0xFFF0CD97),
                    activeTrackColor: const Color(0xFF1B2B3E),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (dayData.isAvailable) ...[
            // Sélection des heures de début et fin
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTimeSelector(
                        context,
                        dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0),
                        (time) {
                          final end = dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0);
                          vm.setDayTimeRange(day, time, end);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
                  child: Icon(Icons.arrow_forward, color: Colors.grey[400], size: 20),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sélectionné',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTimeSelector(
                        context,
                        dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0),
                        (time) {
                          final start = dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0);
                          vm.setDayTimeRange(day, start, time);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Liste des créneaux horaires disponibles
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = timeSlots[index];
                  final hour = index;
                  
                  // Vérifier si ce créneau est dans la plage sélectionnée
                  bool isInRange = false;
                  if (dayData.timeRange != null) {
                    final startHour = dayData.timeRange!.startTime.hour;
                    final endHour = dayData.timeRange!.endTime.hour;
                    isInRange = hour >= startHour && hour <= endHour;
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isInRange ? const Color(0xFF1B2B3E).withOpacity(0.1) : Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            timeSlot,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isInRange ? const Color(0xFF1B2B3E) : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (isInRange)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Available',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              'Not available',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'Jour non disponible',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activez pour définir les horaires',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context, TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final newTime = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF1B2B3E),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF1B2B3E),
                  ),
                ),
                child: child!,
              );
            },
          );
          
          if (newTime != null) {
            onTimeSelected(newTime);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTimeSlot(time),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const Icon(Icons.access_time, size: 20, color: Color(0xFFF0CD97)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeSlot(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
            Icons.calendar_month_outlined,
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
                'Disponibilité',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Définissez vos horaires de travail',
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