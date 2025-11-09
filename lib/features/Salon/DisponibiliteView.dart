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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SalonCreationViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 24),
          
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
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
                  'Ajoutez votre disponibilité hebdomadaire afin que les clients sachent à quel moment vous êtes disponible ou non.',
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                ...vm.weeklyAvailability.entries.map((entry) {
                  final dayName = entry.key;
                  final dayData = entry.value;
                  final isSelected = selectedDay == dayName;
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedDay == dayName) {
                              selectedDay = null;
                            } else {
                              selectedDay = dayName;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                        child: Container(
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF1B2B3E).withOpacity(0.05)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF1B2B3E)
                                  : Colors.grey[200]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dayName,
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 14 : 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1B2B3E),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                    color: const Color(0xFF1B2B3E),
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ],
                              ),
                              if (!isSelected && dayData.isAvailable && dayData.timeRange != null) ...[
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      'Depuis',
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _formatTimeSlot(dayData.timeRange!.startTime),
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1B2B3E),
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward, size: isSmallScreen ? 12 : 14, color: Colors.grey[400]),
                                    Text(
                                      'Sélectionné z l\'heure',
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _formatTimeSlot(dayData.timeRange!.endTime),
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1B2B3E),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              
                              if (isSelected) ...[
                                SizedBox(height: isSmallScreen ? 12 : 16),
                                _buildDayTimeSelector(vm, dayName, dayData, isSmallScreen, screenHeight),
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
        ],
      ),
    );
  }

  Widget _buildDayTimeSelector(
    SalonCreationViewModel vm, 
    String day, 
    DayAvailabilityWithSlots dayData,
    bool isSmallScreen,
    double screenHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isSmallScreen
            ? Column(
                children: [
                  _buildTimeSelectorColumn(
                    'Depuis',
                    dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0),
                    (time) {
                      final end = dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0);
                      vm.setDayTimeRange(day, time, end);
                    },
                    isSmallScreen,
                  ),
                  SizedBox(height: 12),
                  _buildTimeSelectorColumn(
                    'Sélectionné z l\'heure',
                    dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0),
                    (time) {
                      final start = dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0);
                      vm.setDayTimeRange(day, start, time);
                    },
                    isSmallScreen,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildTimeSelectorColumn(
                      'Depuis',
                      dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0),
                      (time) {
                        final end = dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0);
                        vm.setDayTimeRange(day, time, end);
                      },
                      isSmallScreen,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 28, left: isSmallScreen ? 8 : 12, right: isSmallScreen ? 8 : 12),
                    child: Icon(Icons.arrow_forward, color: Colors.grey[400], size: isSmallScreen ? 16 : 18),
                  ),
                  Expanded(
                    child: _buildTimeSelectorColumn(
                      'Sélectionné z l\'heure',
                      dayData.timeRange?.endTime ?? const TimeOfDay(hour: 18, minute: 0),
                      (time) {
                        final start = dayData.timeRange?.startTime ?? const TimeOfDay(hour: 8, minute: 0);
                        vm.setDayTimeRange(day, start, time);
                      },
                      isSmallScreen,
                    ),
                  ),
                ],
              ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        
        Container(
          height: isSmallScreen ? 250 : (screenHeight * 0.35).clamp(250.0, 350.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              itemCount: 24,
              itemBuilder: (context, index) {
                final hour = index;
                final timeSlot = '${hour.toString().padLeft(2, '0')}h00';
                
                bool isInRange = false;
                if (dayData.isAvailable && dayData.timeRange != null) {
                  final startHour = dayData.timeRange!.startTime.hour;
                  final endHour = dayData.timeRange!.endTime.hour;
                  isInRange = hour >= startHour && hour <= endHour;
                }
                
                return Container(
                  margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 8 : 10, 
                    horizontal: isSmallScreen ? 10 : 14
                  ),
                  decoration: BoxDecoration(
                    color: isInRange ? const Color(0xFF1B2B3E).withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                    border: Border.all(
                      color: isInRange ? const Color(0xFF1B2B3E).withOpacity(0.2) : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    timeSlot,
                    style: GoogleFonts.inter(
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: isInRange ? FontWeight.w600 : FontWeight.w500,
                      color: isInRange ? const Color(0xFF1B2B3E) : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelectorColumn(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onTimeSelected,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isSmallScreen ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        _buildTimeSelector(
          time,
          onTimeSelected,
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
    TimeOfDay time, 
    Function(TimeOfDay) onTimeSelected,
    bool isSmallScreen,
  ) {
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
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 12, 
            horizontal: isSmallScreen ? 12 : 14
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTimeSlot(time),
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down, 
                size: isSmallScreen ? 16 : 18, 
                color: Colors.grey[600]
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeSlot(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}h${time.minute.toString().padLeft(2, '0')}';
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
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
          ),
          child: Icon(
            Icons.calendar_month_outlined,
            color: Color(0xFF1B2B3E),
            size: isSmallScreen ? 24 : 28,
          ),
        ),
        SizedBox(width: isSmallScreen ? 10 : 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disponibilité',
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2B3E),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                'Définissez vos horaires de travail',
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