// additional_services_step.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/additional_service.dart';
import 'package:saloony/features/Salon/SalonCreationViewModel.dart';
import 'package:saloony/features/Salon/widgets/StepHeader.dart';

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
        return 'Background Music';
      case AdditionalService.airConditioning:
        return 'Air Conditioning';
      case AdditionalService.heating:
        return 'Heating';
      case AdditionalService.coffeeTea:
        return 'Coffee & Tea';
      case AdditionalService.drinksSnacks:
        return 'Drinks & Snacks';
      case AdditionalService.freeParking:
        return 'Free Parking';
      case AdditionalService.paidParking:
        return 'Paid Parking';
      case AdditionalService.publicTransportAccess:
        return 'Public Transport';
      case AdditionalService.wheelchairAccessible:
        return 'Wheelchair Accessible';
      case AdditionalService.childFriendly:
        return 'Child Friendly';
      case AdditionalService.shower:
        return 'Shower';
      case AdditionalService.lockers:
        return 'Lockers';
      case AdditionalService.creditCardAccepted:
        return 'Credit Card';
      case AdditionalService.mobilePayment:
        return 'Mobile Payment';
      case AdditionalService.securityCameras:
        return 'Security Cameras';
      case AdditionalService.petFriendly:
        return 'Pet Friendly';
      case AdditionalService.noPets:
        return 'No Pets';
      case AdditionalService.smokingAllowed:
        return 'Smoking Allowed';
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

  String _getCategoryName(String category) {
    switch (category) {
      case 'comfort':
        return 'Comfort & Entertainment';
      case 'food':
        return 'Food & Beverages';
      case 'parking':
        return 'Parking & Transport';
      case 'accessibility':
        return 'Accessibility';
      case 'facilities':
        return 'Facilities';
      case 'payment':
        return 'Payment Options';
      case 'security':
        return 'Security & Safety';
      case 'policies':
        return 'Policies';
      default:
        return category;
    }
  }

  Map<String, List<AdditionalService>> _getGroupedServices() {
    return {
      'comfort': [
        AdditionalService.wifi,
        AdditionalService.tv,
        AdditionalService.backgroundMusic,
        AdditionalService.airConditioning,
        AdditionalService.heating,
      ],
      'food': [
        AdditionalService.coffeeTea,
        AdditionalService.drinksSnacks,
      ],
      'parking': [
        AdditionalService.freeParking,
        AdditionalService.paidParking,
        AdditionalService.publicTransportAccess,
      ],
      'accessibility': [
        AdditionalService.wheelchairAccessible,
        AdditionalService.childFriendly,
      ],
      'facilities': [
        AdditionalService.shower,
        AdditionalService.lockers,
      ],
      'payment': [
        AdditionalService.creditCardAccepted,
        AdditionalService.mobilePayment,
      ],
      'security': [
        AdditionalService.securityCameras,
      ],
      'policies': [
        AdditionalService.petFriendly,
        AdditionalService.noPets,
        AdditionalService.smokingAllowed,
        AdditionalService.nonSmoking,
      ],
    };
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1400) return 5;
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    if (width >= 500) return 2;
    return 1;
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1400) return 1.15;
    if (width >= 1100) return 1.2;
    if (width >= 800) return 1.25;
    if (width >= 500) return 1.3;
    return 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final groupedServices = _getGroupedServices();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final childAspectRatio = _getChildAspectRatio(screenWidth);
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    final spacing = isMobile ? 10.0 : (isTablet ? 14.0 : 16.0);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                title: 'Additional Services',
                subtitle: 'Select amenities and facilities you offer',
                icon: Icons.emoji_food_beverage_outlined,
              ),
              
              SizedBox(height: isMobile ? 24 : 32),
              
              // Selected count banner
              if (_selectedServices.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: isMobile ? 20 : 24),
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1B2B3E).withOpacity(0.03),
                        const Color(0xFFF0CD97).withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                    border: Border.all(
                      color: const Color(0xFFF0CD97).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 10 : 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1B2B3E),
                              Color(0xFF2A3F54),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B2B3E).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFFF0CD97),
                          size: isMobile ? 20 : 24,
                        ),
                      ),
                      
                      SizedBox(width: isMobile ? 12 : 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedServices.length} ${_selectedServices.length > 1 ? 'services' : 'service'} selected',
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 15 : 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B2B3E),
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (!isMobile) ...[
                              const SizedBox(height: 2),
                              Text(
                                'These will be displayed on your salon profile',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedServices.clear();
                            widget.vm.setAdditionalServices([]);
                          });
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          size: isMobile ? 16 : 18,
                          color: const Color(0xFFF0CD97),
                        ),
                        label: Text(
                          'Clear',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 13 : 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF0CD97),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16,
                            vertical: isMobile ? 8 : 10,
                          ),
                          backgroundColor: const Color(0xFFF0CD97).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Services list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedServices.length,
                separatorBuilder: (context, index) => SizedBox(height: isMobile ? 28 : 36),
                itemBuilder: (context, index) {
                  final category = groupedServices.keys.elementAt(index);
                  final services = groupedServices[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category header
                      Padding(
                        padding: EdgeInsets.only(
                          left: 4,
                          bottom: isMobile ? 12 : 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: isMobile ? 20 : 24,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF1B2B3E),
                                    Color(0xFFF0CD97),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _getCategoryName(category),
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 17 : (isTablet ? 19 : 20),
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1B2B3E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Services grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, serviceIndex) {
                          final service = services[serviceIndex];
                          final isSelected = _selectedServices.contains(service);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _toggleService(service),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? const Color(0xFFF0CD97).withOpacity(0.08)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected 
                                        ? const Color(0xFFF0CD97) 
                                        : Colors.grey[200]!,
                                    width: isSelected ? 2.5 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? const Color(0xFFF0CD97).withOpacity(0.15)
                                          : Colors.black.withOpacity(0.04),
                                      blurRadius: isSelected ? 16 : 8,
                                      offset: Offset(0, isSelected ? 4 : 2),
                                      spreadRadius: isSelected ? 1 : 0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                        isMobile ? 14 : (isTablet ? 16 : 20),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 250),
                                            padding: EdgeInsets.all(
                                              isMobile ? 10 : (isTablet ? 12 : 14),
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: isSelected
                                                    ? [
                                                        const Color(0xFF1B2B3E),
                                                        const Color(0xFF2A3F54),
                                                      ]
                                                    : [
                                                        const Color(0xFFF5F5F5),
                                                        const Color(0xFFE8E8E8),
                                                      ],
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                              boxShadow: isSelected ? [
                                                BoxShadow(
                                                  color: const Color(0xFF1B2B3E).withOpacity(0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ] : [],
                                            ),
                                            child: Icon(
                                              _getServiceIcon(service),
                                              color: isSelected
                                                  ? const Color(0xFFF0CD97)
                                                  : const Color(0xFF1B2B3E).withOpacity(0.6),
                                              size: isMobile ? 22 : (isTablet ? 26 : 28),
                                            ),
                                          ),
                                          
                                          SizedBox(height: isMobile ? 10 : 12),
                                          
                                          Flexible(
                                            child: Text(
                                              _getServiceLabel(service),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: isMobile ? 12 : (isTablet ? 13 : 14),
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? const Color(0xFF1B2B3E)
                                                    : Colors.grey[700],
                                                height: 1.3,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Check mark
                                    if (isSelected)
                                      Positioned(
                                        top: isMobile ? 6 : 8,
                                        right: isMobile ? 6 : 8,
                                        child: AnimatedScale(
                                          duration: const Duration(milliseconds: 200),
                                          scale: isSelected ? 1.0 : 0.0,
                                          child: Container(
                                            padding: EdgeInsets.all(isMobile ? 4 : 5),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF1B2B3E),
                                                  Color(0xFF2A3F54),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1B2B3E).withOpacity(0.4),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: const Color(0xFFF0CD97),
                                              size: isMobile ? 12 : 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              
              SizedBox(height: isMobile ? 24 : 32),
              
              // Information section
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[50]!.withOpacity(0.5),
                      Colors.blue[50]!.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blue[100]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lightbulb_rounded,
                        size: isMobile ? 18 : 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Adding services helps customers find your salon and improves your visibility in search results.',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 13 : 14,
                          color: Colors.grey[700],
                          height: 1.5,
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