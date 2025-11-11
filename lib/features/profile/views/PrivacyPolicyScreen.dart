import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: SaloonyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: SaloonyColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: SaloonyColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SaloonyColors.primary.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.security_rounded,
                    size: 40,
                    color: SaloonyColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${_getCurrentDate()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Content Sections
            _buildSection(
              title: "Information We Collect",
              content: "We collect information you provide directly to us, such as when you create an account, book appointments, or contact us for support.",
            ),

            _buildSection(
              title: "How We Use Your Information",
              content: "We use the information we collect to provide, maintain, and improve our services, communicate with you, and personalize your experience.",
            ),

            _buildSection(
              title: "Information Sharing",
              content: "We do not sell your personal information. We may share information only with your consent or to comply with legal obligations.",
            ),

            _buildSection(
              title: "Data Security",
              content: "We implement appropriate security measures to protect your personal information against unauthorized access and disclosure.",
            ),

            _buildSection(
              title: "Your Rights",
              content: "You have the right to access, correct, or delete your personal information. Contact us to exercise these rights.",
            ),

            _buildSection(
              title: "Contact Us",
              content: "If you have any questions about this Privacy Policy, please contact us at privacy@saloony.tn",
            ),

            const SizedBox(height: 32),

            // Website Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _launchURL("https://www.saloony.tn/"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: SaloonyColors.primary),
                ),
                child: Text(
                  "Visit Our Website",
                  style: TextStyle(
                    fontSize: 16,
                    color: SaloonyColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: SaloonyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: SaloonyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Colors.grey[300],
            height: 1,
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}