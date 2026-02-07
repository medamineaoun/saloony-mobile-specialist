import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/core/enum/additional_service.dart';
import 'package:SaloonySpecialist/features/Salon/view_models/SalonCreationViewModel.dart';
import 'package:SaloonySpecialist/features/Salon/widgets/StepHeader.dart';

class AdditionalServicesStep extends StatefulWidget {
  final SalonCreationViewModel vm;

  const AdditionalServicesStep({super.key, required this.vm});

  @override
  State<AdditionalServicesStep> createState() => _AdditionalServicesStepState();
}

class _AdditionalServicesStepState extends State<AdditionalServicesStep> {
  final Set<AdditionalService> _selectedServices = {};

  @override
  void initState() {
    super.initState();
    _selectedServices.addAll(widget.vm.selectedAdditionalServices);
  }

  void _toggleService(AdditionalService service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
    });
    widget.vm.setAdditionalServices(_selectedServices.toList());
  }

  String _getServiceLabel(AdditionalService service) {
    switch (service) {
      case AdditionalService.wifi:
        return 'WiFi';
      case AdditionalService.tv:
        return 'TV';
      case AdditionalService.backgroundMusic:
        return 'Music';
      case AdditionalService.airConditioning:
        return 'AC';
      case AdditionalService.heating:
        return 'Heating';
      case AdditionalService.coffeeTea:
        return 'Coffee/Tea';
      case AdditionalService.drinksSnacks:
        return 'Snacks';
      case AdditionalService.freeParking:
        return 'Free Parking';
      case AdditionalService.paidParking:
        return 'Paid Parking';
      case AdditionalService.publicTransportAccess:
        return 'Public Transport';
      case AdditionalService.wheelchairAccessible:
        return 'Wheelchair';
      case AdditionalService.childFriendly:
        return 'Kid Friendly';
      case AdditionalService.shower:
        return 'Shower';
      case AdditionalService.lockers:
        return 'Lockers';
      case AdditionalService.creditCardAccepted:
        return 'Credit Card';
      case AdditionalService.mobilePayment:
        return 'Mobile Pay';
      case AdditionalService.securityCameras:
        return 'Security';
      case AdditionalService.petFriendly:
        return 'Pet Friendly';
      case AdditionalService.noPets:
        return 'No Pets';
      case AdditionalService.smokingAllowed:
        return 'Smoking OK';
      case AdditionalService.nonSmoking:
        return 'Non-Smoking';
    }
  }

  IconData _getServiceIcon(AdditionalService service) {
    switch (service) {
      case AdditionalService.wifi:
        return Icons.wifi;
      case AdditionalService.tv:
        return Icons.tv;
      case AdditionalService.backgroundMusic:
        return Icons.music_note;
      case AdditionalService.airConditioning:
        return Icons.ac_unit;
      case AdditionalService.heating:
        return Icons.local_fire_department;
      case AdditionalService.coffeeTea:
        return Icons.coffee;
      case AdditionalService.drinksSnacks:
        return Icons.local_cafe;
      case AdditionalService.freeParking:
        return Icons.local_parking;
      case AdditionalService.paidParking:
        return Icons.paid;
      case AdditionalService.publicTransportAccess:
        return Icons.directions_bus;
      case AdditionalService.wheelchairAccessible:
        return Icons.accessible;
      case AdditionalService.childFriendly:
        return Icons.child_care;
      case AdditionalService.shower:
        return Icons.shower;
      case AdditionalService.lockers:
        return Icons.lock;
      case AdditionalService.creditCardAccepted:
        return Icons.credit_card;
      case AdditionalService.mobilePayment:
        return Icons.phone_android;
      case AdditionalService.securityCameras:
        return Icons.security;
      case AdditionalService.petFriendly:
        return Icons.pets;
      case AdditionalService.noPets:
        return Icons.pets_outlined;
      case AdditionalService.smokingAllowed:
        return Icons.smoking_rooms;
      case AdditionalService.nonSmoking:
        return Icons.smoke_free;
    }
  }

  List<AdditionalService> _getAllServices() {
    return [
      AdditionalService.wifi,
      AdditionalService.tv,
      AdditionalService.backgroundMusic,
      AdditionalService.airConditioning,
      AdditionalService.heating,
      AdditionalService.coffeeTea,
      AdditionalService.drinksSnacks,
      AdditionalService.freeParking,
      AdditionalService.paidParking,
      AdditionalService.publicTransportAccess,
      AdditionalService.wheelchairAccessible,
      AdditionalService.childFriendly,
      AdditionalService.shower,
      AdditionalService.lockers,
      AdditionalService.creditCardAccepted,
      AdditionalService.mobilePayment,
      AdditionalService.securityCameras,
      AdditionalService.petFriendly,
      AdditionalService.noPets,
      AdditionalService.smokingAllowed,
      AdditionalService.nonSmoking,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final allServices = _getAllServices();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    
    // 3 colonnes sur desktop, 2 sur tablet, 1 sur mobile
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 3);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                title: 'Additional Services',
                subtitle: 'Select amenities and facilities you offer',
                icon: Icons.emoji_food_beverage_outlined,
              ),
              
              SizedBox(height: isMobile ? 16 : 20),
              
              // Selected count banner
              if (_selectedServices.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0CD97).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFF0CD97).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B2B3E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Color(0xFFF0CD97),
                          size: 12,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Text(
                        '${_selectedServices.length} selected',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedServices.clear();
                            widget.vm.setAdditionalServices([]);
                          });
                        },
                        child: Text(
                          'Clear',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF0CD97),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Grid de petites cartes - 3 par ligne
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: isMobile ? 2.2 : 2.5,
                  crossAxisSpacing: isMobile ? 8 : 10,
                  mainAxisSpacing: isMobile ? 8 : 10,
                ),
                itemCount: allServices.length,
                itemBuilder: (context, index) {
                  final service = allServices[index];
                  final isSelected = _selectedServices.contains(service);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggleService(service),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 10,
                          vertical: isMobile ? 8 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFF0CD97).withOpacity(0.12)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFFF0CD97) 
                                : Colors.grey[200]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFFF0CD97).withOpacity(0.1)
                                  : Colors.black.withOpacity(0.02),
                              blurRadius: isSelected ? 6 : 3,
                              offset: Offset(0, isSelected ? 2 : 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1B2B3E)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getServiceIcon(service),
                                color: isSelected
                                    ? const Color(0xFFF0CD97)
                                    : Colors.grey[600],
                                size: 16,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Label
                            Expanded(
                              child: Text(
                                _getServiceLabel(service),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF1B2B3E)
                                      : Colors.grey[700],
                                  height: 1.2,
                                ),
                              ),
                            ),
                            
                            // Check mark
                            if (isSelected) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B2B3E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Color(0xFFF0CD97),
                                  size: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: isMobile ? 16 : 20),
              
              // Information section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue[100]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select services that apply to your salon to help customers find you.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}