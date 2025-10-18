import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d’ouvrir : $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.tertiary,
      appBar: AppBar(
        backgroundColor: SaloonyColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Politique de confidentialité",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [SaloonyColors.secondary, SaloonyColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: SaloonyColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 48,
                    color: SaloonyColors.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Votre vie privée est importante pour nous',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Veuillez lire attentivement notre politique de confidentialité.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Cards
            _buildPrivacyCard(
              title: "Collecte de données",
              content:
                  "Nous collectons uniquement les informations nécessaires pour améliorer votre expérience utilisateur.",
            ),
            _buildPrivacyCard(
              title: "Utilisation des données",
              content:
                  "Vos données sont utilisées pour fournir les services et ne seront jamais partagées sans votre consentement.",
            ),
            _buildPrivacyCard(
              title: "Cookies",
              content:
                  "Notre application utilise des cookies pour améliorer la navigation et personnaliser votre expérience.",
            ),
            _buildPrivacyCard(
              title: "Liens externes",
              content:
                  "Nous pouvons inclure des liens vers des sites externes. Nous ne sommes pas responsables de leurs politiques de confidentialité.",
            ),

            const SizedBox(height: 24),

            // Button to visit website
            ElevatedButton(
              onPressed: () => _launchURL("https://www.saloony.tn/"),
              style: ElevatedButton.styleFrom(
                backgroundColor: SaloonyColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Visitez notre site",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCard({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: SaloonyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: SaloonyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


