import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import 'package:SaloonySpecialist/features/Salon/views/location_result.dart';
import 'package:SaloonySpecialist/features/Salon/views/MapPickerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalisationPage extends StatefulWidget {
  final LocationResult? initialLocation;
  const LocalisationPage({
    Key? key,
    this.initialLocation,
  }) : super(key: key);

  @override
  _LocalisationPageState createState() => _LocalisationPageState();
}

class _LocalisationPageState extends State<LocalisationPage> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation?.address != null &&
        widget.initialLocation!.address!.isNotEmpty) {
      _addressController.text = widget.initialLocation!.address!;
    }
    
    // Vérifier les permissions au démarrage
    _checkInitialPermissions();
  }

  // ✅ NOUVEAU : Vérifier les permissions dès le départ
  Future<void> _checkInitialPermissions() async {
    try {
      final status = await Permission.location.status;
      debugPrint('📍 État permission localisation: $status');
      
      if (status.isPermanentlyDenied) {
        setState(() {
          _errorMessage = "Location permission permanently denied. Please enable in settings.";
        });
      }
    } catch (e) {
      debugPrint('❌ Erreur vérification permissions: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SaloonyColors.tertiary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: SaloonyColors.primary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SaloonyColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 600;
                final contentPadding = isSmallScreen ? 20.0 : 40.0;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.all(contentPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ✅ Afficher les erreurs de permission
                            if (_errorMessage != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning, color: Colors.orange),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.orange[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // Image d'illustration
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.35,
                                maxWidth: isSmallScreen ? double.infinity : 500,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: SaloonyColors.primary.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'images/localisation.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: SaloonyColors.tertiary,
                                      child: const Icon(
                                        Icons.location_on,
                                        size: 80,
                                        color: SaloonyColors.secondary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(height: contentPadding),
                            
                            Text(
                              widget.initialLocation != null
                                  ? "Update Location"
                                  : "Welcome Partner",
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 24 : 28,
                                fontWeight: FontWeight.bold,
                                color: SaloonyColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.initialLocation != null
                                  ? "Choose a new position for your salon"
                                  : "Set your business location",
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: SaloonyColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            if (widget.initialLocation != null)
                              _buildCurrentLocationCard(isSmallScreen),
                            
                            SizedBox(height: contentPadding),
                            
                            _buildActionButton(
                              onPressed: _getLocationPermission,
                              icon: Icons.my_location,
                              label: 'Use Current Location',
                              isPrimary: true,
                              isSmallScreen: isSmallScreen,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            _buildActionButton(
                              onPressed: _showManualEntryDialog,
                              icon: Icons.edit_location_alt,
                              label: 'Enter Manually',
                              isPrimary: false,
                              isSmallScreen: isSmallScreen,
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCurrentLocationCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SaloonyColors.secondary.withOpacity(0.1),
            SaloonyColors.gold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SaloonyColors.secondary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: SaloonyColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: SaloonyColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Current Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 15 : 16,
                    color: SaloonyColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.initialLocation!.address != null &&
              widget.initialLocation!.address!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.initialLocation!.address!,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: SaloonyColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SaloonyColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Lat: ${widget.initialLocation!.latitude.toStringAsFixed(6)}, '
              'Lng: ${widget.initialLocation!.longitude.toStringAsFixed(6)}',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 11 : 12,
                color: SaloonyColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
    required bool isSmallScreen,
  }) {
    if (isPrimary) {
      return Container(
        height: isSmallScreen ? 56 : 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [SaloonyColors.primary, SaloonyColors.navy],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: SaloonyColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(icon, size: 20, color: SaloonyColors.secondary),
          label: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, isSmallScreen ? 56 : 60),
          side: const BorderSide(
            color: SaloonyColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 20, color: SaloonyColors.secondary),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 15 : 16,
            fontWeight: FontWeight.w600,
            color: SaloonyColors.primary,
          ),
        ),
      );
    }
  }

  // ✅ AMÉLIORATION : Meilleure gestion des permissions
  Future<void> _getLocationPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Vérifier le statut actuel
      PermissionStatus status = await Permission.location.status;
      debugPrint('📍 Permission status: $status');

      if (status.isGranted) {
        await _getLocation();
        setState(() => _isLoading = false);
        return;
      }

      // Si refusé définitivement, rediriger vers les paramètres
      if (status.isPermanentlyDenied) {
        setState(() => _isLoading = false);
        
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.settings, color: SaloonyColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Permission Required",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              "Location permission is permanently denied. Please enable it in app settings.",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel", style: GoogleFonts.poppins()),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SaloonyColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  openAppSettings();
                },
                child: Text("Open Settings", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );
        return;
      }

      // Si simplement refusé, demander à nouveau
      if (status.isDenied) {
        final result = await _showPermissionDialog();
        
        if (result == true) {
          setState(() => _isLoading = true);
          status = await Permission.location.request();
          
          if (status.isGranted) {
            await _getLocation();
          } else if (status.isPermanentlyDenied) {
            setState(() {
              _errorMessage = "Permission denied. Please enable in settings.";
            });
          } else {
            setState(() {
              _errorMessage = "Location permission is required.";
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur permission: $e');
      setState(() {
        _errorMessage = "Error requesting permission: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool?> _showPermissionDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SaloonyColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on,
                color: SaloonyColors.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Permission Required",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          "We need your location to provide a better experience. Please grant location access permission.",
          style: GoogleFonts.poppins(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SaloonyColors.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Allow", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ✅ AMÉLIORATION : Meilleure gestion des erreurs
  Future<void> _getLocation() async {
    try {
      debugPrint('📍 Demande de localisation...');
      
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog("Location services are disabled. Please enable them in your device settings.");
        return;
      }

      // Obtenir la position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception("Location request timed out");
        },
      );

      debugPrint('✅ Position obtenue: ${position.latitude}, ${position.longitude}');

      // Sauvegarder
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', position.latitude);
      await prefs.setDouble('longitude', position.longitude);

      if (mounted) {
        Navigator.pop(
          context,
          LocationResult(
            latitude: position.latitude,
            longitude: position.longitude,
            address: null,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur localisation: $e');
      _showErrorDialog("Error retrieving your location: ${e.toString()}");
    }
  }

  // ✅ NOUVEAU : Ouvrir la carte pour sélection manuelle
  Future<void> _showManualEntryDialog() async {
    try {
      final result = await Navigator.push<LocationResult?>(
        context,
        MaterialPageRoute(
          builder: (context) => MapPickerPage(
            initialLocation: widget.initialLocation,
          ),
        ),
      );

      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      debugPrint('❌ Erreur ouverture carte: $e');
      _showErrorDialog('Error opening map: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: SaloonyColors.error),
            const SizedBox(width: 10),
            Text("Error", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SaloonyColors.primary,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}