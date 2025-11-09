import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/additional_service.dart';


class AdditionalServicesPage extends StatefulWidget {
  final List<AdditionalService>? initialServices;
  
  const AdditionalServicesPage({
    super.key,
    this.initialServices,
  });

  @override
  State<AdditionalServicesPage> createState() => _AdditionalServicesPageState();
}

class _AdditionalServicesPageState extends State<AdditionalServicesPage> {
  final Set<AdditionalService> _selectedServices = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialServices != null) {
      _selectedServices.addAll(widget.initialServices!);
    }
  }

  void _toggleService(AdditionalService service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
    });
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
        return 'Public Transport Access';
      case AdditionalService.wheelchairAccessible:
        return 'Wheelchair Accessible';
      case AdditionalService.childFriendly:
        return 'Child Friendly';
      case AdditionalService.shower:
        return 'Shower';
      case AdditionalService.lockers:
        return 'Lockers';
      case AdditionalService.creditCardAccepted:
        return 'Credit Card Accepted';
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
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2;
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1200) return 1.3;
    if (width >= 900) return 1.4;
    if (width >= 600) return 1.5;
    return 1.4;
  }

  @override
  Widget build(BuildContext context) {
    final groupedServices = _getGroupedServices();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final childAspectRatio = _getChildAspectRatio(screenWidth);
    final horizontalPadding = screenWidth > 600 ? 32.0 : 20.0;
    final spacing = screenWidth > 600 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Color(0xFF1B2B3E),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Additional Services',
          style: GoogleFonts.inter(
            fontSize: screenWidth > 600 ? 22 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B2B3E),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth > 600 ? 16 : 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedServices.clear();
                });
              },
              child: Text(
                'Clear',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF0CD97),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selected count banner
          if (_selectedServices.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1B2B3E).withOpacity(0.05),
                    const Color(0xFFF0CD97).withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2B3E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFF0CD97),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_selectedServices.length} service${_selectedServices.length > 1 ? 's' : ''} selected',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B2B3E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Services list
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final contentWidth = maxWidth > 1200 ? 1200.0 : maxWidth;
                
                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(horizontalPadding),
                      itemCount: groupedServices.length,
                      itemBuilder: (context, index) {
                        final category = groupedServices.keys.elementAt(index);
                        final services = groupedServices[category]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0) SizedBox(height: spacing * 2),
                            
                            // Category header
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 12),
                              child: Text(
                                _getCategoryName(category),
                                style: GoogleFonts.inter(
                                  fontSize: screenWidth > 600 ? 18 : 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1B2B3E),
                                  letterSpacing: -0.3,
                                ),
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

                                return GestureDetector(
                                  onTap: () => _toggleService(service),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected 
                                            ? const Color(0xFFF0CD97) 
                                            : Colors.grey[200]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? const Color(0xFF1B2B3E).withOpacity(0.08)
                                              : Colors.black.withOpacity(0.03),
                                          blurRadius: isSelected ? 12 : 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(screenWidth > 600 ? 20 : 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(screenWidth > 600 ? 14 : 12),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: isSelected
                                                        ? [
                                                            const Color(0xFF1B2B3E),
                                                            const Color(0xFF2A3F54),
                                                          ]
                                                        : [
                                                            const Color(0xFF1B2B3E).withOpacity(0.1),
                                                            const Color(0xFFF0CD97).withOpacity(0.1),
                                                          ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  _getServiceIcon(service),
                                                  color: isSelected
                                                      ? const Color(0xFFF0CD97)
                                                      : const Color(0xFF1B2B3E),
                                                  size: screenWidth > 600 ? 28 : 24,
                                                ),
                                              ),
                                              SizedBox(height: screenWidth > 600 ? 14 : 12),
                                              Flexible(
                                                child: Text(
                                                  _getServiceLabel(service),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                    fontSize: screenWidth > 600 ? 14 : 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? const Color(0xFF1B2B3E)
                                                        : Colors.grey[700],
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        // Check mark
                                        if (isSelected)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1B2B3E),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF1B2B3E).withOpacity(0.3),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Color(0xFFF0CD97),
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom button
          Container(
            padding: EdgeInsets.all(horizontalPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  height: screenWidth > 600 ? 60 : 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2B3E), Color(0xFF2A3F54)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B2B3E).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedServices.toList());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Services',
                          style: GoogleFonts.inter(
                            fontSize: screenWidth > 600 ? 17 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFF0CD97),
                          size: 20,
                        ),
                      ],
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
}