import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';

class AvailabilityPage extends StatefulWidget {
  final SalonCreationViewModel vm;

  const AvailabilityPage({super.key, required this.vm});
  
  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : (isMediumScreen ? 24 : 32),
          vertical: 24,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeader(isSmallScreen),
              SizedBox(height: isSmallScreen ? 20 : 24),
              
              // Info banner
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[50]!.withOpacity(0.5),
                      Colors.blue[50]!.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: isSmallScreen ? 18 : 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Define your weekly working hours for customer bookings',
                        style: GoogleFonts.inter(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isSmallScreen ? 20 : 24),
              
              // Days list
              ...vm.weeklyAvailability.entries.map((entry) {
                final dayName = entry.key;
                final dayData = entry.value;
                final isSelected = selectedDay == dayName;
                
                return Container(
                  margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedDay = isSelected ? null : dayName;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF1B2B3E).withOpacity(0.04)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF1B2B3E)
                                : Colors.grey[200]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isSelected ? 0.04 : 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day header
                            Row(
                              children: [
                                // Day name
                                Expanded(
                                  child: Text(
                                    dayName,
                                    style: GoogleFonts.inter(
                                      fontSize: isSmallScreen ? 15 : 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1B2B3E),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                
                                // Time preview when not selected
                                if (!isSelected && dayData.isAvailable && dayData.timeRange != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0CD97).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFF0CD97).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: const Color(0xFF1B2B3E),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${_formatTimeSlot(dayData.timeRange!.startTime)} - ${_formatTimeSlot(dayData.timeRange!.endTime)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1B2B3E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                
                                // Toggle icon
                                Icon(
                                  isSelected 
                                      ? Icons.keyboard_arrow_up_rounded 
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFF1B2B3E),
                                  size: isSmallScreen ? 22 : 24,
                                ),
                              ],
                            ),
                            
                            // Time selector when expanded
                            if (isSelected) ...[
                              SizedBox(height: isSmallScreen ? 16 : 20),
                              _buildTimeRangeSelector(
                                vm,
                                dayName,
                                dayData,
                                isSmallScreen,
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildTimeRangeSelector(
    SalonCreationViewModel vm,
    String day,
    DayAvailabilityWithSlots dayData,
    bool isSmallScreen,
  ) {
    final startTime = dayData.timeRange?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    final endTime = dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'Available',
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
              Switch(
                value: dayData.isAvailable,
                onChanged: (value) {
                  // Trouver l'index du jour
                  final dayIndex = vm.weeklyAvailability.keys.toList().indexOf(day);
                  if (dayIndex != -1) {
                    vm.toggleDayAvailability(dayIndex);
                  }
                },
                activeColor: const Color(0xFF1B2B3E),
                activeTrackColor: const Color(0xFFF0CD97),
              ),
            ],
          ),
          
          if (dayData.isAvailable) ...[
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Time range selector
            Row(
              children: [
                // Start time
                Expanded(
                  child: _buildTimePicker(
                    label: 'From',
                    time: startTime,
                    onTap: () async {
                      final newTime = await _selectTime(context, startTime);
                      if (newTime != null) {
                        vm.setDayTimeRange(day, newTime, endTime);
                      }
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.grey[400],
                  ),
                ),
                
                // End time
                Expanded(
                  child: _buildTimePicker(
                    label: 'To',
                    time: endTime,
                    onTap: () async {
                      final newTime = await _selectTime(context, endTime);
                      if (newTime != null) {
                        vm.setDayTimeRange(day, startTime, newTime);
                      }
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isSmallScreen ? 10 : 12),
            
            // Duration info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B3E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: const Color(0xFF1B2B3E).withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_calculateDuration(startTime, endTime)} hours',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B2B3E).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 10 : 12,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTimeSlot(time),
                    style: GoogleFonts.inter(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B2B3E),
              onPrimary: Color(0xFFF0CD97),
              surface: Colors.white,
              onSurface: Color(0xFF1B2B3E),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1B2B3E),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  String _formatTimeSlot(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _calculateDuration(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final durationMinutes = endMinutes - startMinutes;
    
    if (durationMinutes <= 0) {
      return '0';
    }
    
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    
    if (minutes == 0) {
      return hours.toString();
    }
    
    // Convertir les minutes en décimale (ex: 30 min = 0.5)
    final decimalMinutes = (minutes / 60 * 10).round();
    return '$hours.$decimalMinutes';
  }

  Widget _buildStepHeader(bool isSmallScreen) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B2B3E).withOpacity(0.1),
                const Color(0xFFF0CD97).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.calendar_month_outlined,
            color: const Color(0xFF1B2B3E),
            size: isSmallScreen ? 24 : 28,
          ),
        ),
        SizedBox(width: isSmallScreen ? 12 : 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Availability',
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                'Set your weekly working hours',
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 12 : 14,
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