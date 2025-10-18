import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe pour retourner les résultats de localisation
// IMPORTANT: Cette classe doit être dans un fichier séparé ou accessible globalement
class LocationResult {
  final double latitude;
  final double longitude;
  final String? address;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  // Méthode pour convertir en Map (utile pour la sauvegarde)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  // Méthode pour créer depuis Map
  factory LocationResult.fromMap(Map<String, dynamic> map) {
    return LocationResult(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      address: map['address'],
    );
  }
}

class LocalisationPage extends StatefulWidget {
  const LocalisationPage({Key? key}) : super(key: key);

  @override
  _LocalisationPageState createState() => _LocalisationPageState();
}

class _LocalisationPageState extends State<LocalisationPage> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double width = screenWidth;
    double height = screenHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7A400)),
              ),
            )
          : Center(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Container(
                        height: height * 0.6,
                        width: width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/localisation.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    width: width * 0.8,
                    height: height * 0.1,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Bonjour partenaire",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.07,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Entrez votre position",
                              style: TextStyle(
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.07),
                  Container(
                    height: height * 0.06,
                    width: width * 0.85,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFFF7A400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        await _getLocationPermission();
                      },
                      child: Text(
                        'Utiliser location actuelle',
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    height: height * 0.06,
                    width: width * 0.85,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(
                          color: Color(0xFFF7A400),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        _showManualEntryDialog();
                      },
                      child: Text(
                        'Entrer manuellement',
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: const Color(0xFFF7A400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _getLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    var status = await Permission.locationWhenInUse.status;
    
    if (status.isGranted) {
      await _getLocation();
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    if (status.isDenied) {
      setState(() {
        _isLoading = false;
      });
      
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.orange),
              const SizedBox(width: 10),
              const Text(
                "Autorisation requise",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "Nous avons besoin de votre localisation pour vous offrir une meilleure expérience. Veuillez accorder l'autorisation d'accéder à votre localisation.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
              ),
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                "Autoriser",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
      
      if (result != null && result) {
        setState(() {
          _isLoading = true;
        });
        
        status = await Permission.locationWhenInUse.request();
        
        if (status.isGranted) {
          await _getLocation();
        }
        
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showErrorDialog("Permission de localisation refusée");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Sauvegarder dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', latitude);
      await prefs.setDouble('longitude', longitude);

      print('Latitude: $latitude');
      print('Longitude: $longitude');

      // Retourner le résultat
      if (mounted) {
        Navigator.pop(
          context,
          LocationResult(
            latitude: latitude,
            longitude: longitude,
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
      _showErrorDialog("Erreur lors de la récupération de votre position");
    }
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final latController = TextEditingController();
        final lonController = TextEditingController();
        
        return AlertDialog(
          title: const Text(
            "Entrer les coordonnées",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                decoration: const InputDecoration(
                  labelText: "Latitude",
                  hintText: "Ex: 36.8065",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lonController,
                decoration: const InputDecoration(
                  labelText: "Longitude",
                  hintText: "Ex: 10.1815",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Ou entrez une adresse:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Adresse",
                  hintText: "Ex: Avenue Habib Bourguiba, Tunis",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7A400),
              ),
              onPressed: () {
                final lat = double.tryParse(latController.text);
                final lon = double.tryParse(lonController.text);
                
                if (lat != null && lon != null) {
                  Navigator.pop(context);
                  _returnManualLocation(lat, lon, _addressController.text);
                } else if (_addressController.text.isNotEmpty) {
                  // Pour l'instant, utiliser une position par défaut pour l'adresse
                  // Dans une vraie app, vous utiliseriez un service de géocodage
                  Navigator.pop(context);
                  _showErrorDialog(
                    "Veuillez entrer les coordonnées GPS ou utiliser la localisation automatique",
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez entrer des coordonnées valides"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Confirmer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  Future<void> _returnManualLocation(
    double latitude,
    double longitude,
    String? address,
  ) async {
    try {
      // Sauvegarder dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', latitude);
      await prefs.setDouble('longitude', longitude);

      print('Latitude manuelle: $latitude');
      print('Longitude manuelle: $longitude');

      // Retourner le résultat
      if (mounted) {
        Navigator.pop(
          context,
          LocationResult(
            latitude: latitude,
            longitude: longitude,
            address: address?.isNotEmpty == true ? address : null,
          ),
        );
      }
    } catch (e) {
      print('Erreur: $e');
      _showErrorDialog("Erreur lors de l'enregistrement de la position");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("Erreur"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}