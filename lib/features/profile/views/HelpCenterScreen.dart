import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:url_launcher/url_launcher.dart';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color navy = Color(0xFF243441);
  static const Color gold = Color(0xFFEDC087);
  static const Color lightGray = Color(0xFFD4D4D4);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
}

class HelpCenterScreenP extends StatelessWidget {
  const HelpCenterScreenP({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open: $url';
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri uri = Uri.parse('https://wa.me/$phone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open WhatsApp with number $phone';
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
          "Help Center",
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
                    Icons.help_outline_rounded,
                    size: 40,
                    color: SaloonyColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our support team is here to assist you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contact Section
            Text(
              'Contact Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            _buildContactCard(
              icon: Icons.phone_outlined,
              title: 'Phone Support',
              subtitle: 'Call us directly',
              onTap: () => _launchURL('tel:+21626320130'),
            ),

            _buildContactCard(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'Send us an email',
              onTap: () => _launchURL('mailto:support@saloony.tn'),
            ),

            _buildContactCard(
              icon: FontAwesomeIcons.whatsapp,
              title: 'WhatsApp',
              subtitle: 'Instant messaging',
              onTap: () => _launchWhatsApp('+21626320130'),
            ),

            _buildContactCard(
              icon: Icons.language_outlined,
              title: 'Website',
              subtitle: 'Visit our website',
              onTap: () => _launchURL('https://www.saloony.tn/'),
            ),

            const SizedBox(height: 32),

            // Social Media Section
            Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.facebook,
                    color: const Color(0xFF1877F2),
                    onTap: () => _launchURL('https://www.facebook.com/saloonyfacebook'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.camera_alt,
                    color: const Color(0xFFE4405F),
                    onTap: () => _launchURL('https://www.instagram.com/saloonyinsta'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSocialButton(
                    icon: Icons.music_note,
                    color: Colors.black,
                    onTap: () => _launchURL('https://www.tiktok.com/@saloonytiktok'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // FAQ Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: SaloonyColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SaloonyColors.primary.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need more help?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check our FAQ section for common questions and answers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _launchURL('https://www.saloony.tn/faq'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: SaloonyColors.primary),
                      ),
                      child: Text(
                        'View FAQ',
                        style: TextStyle(
                          color: SaloonyColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SaloonyColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: SaloonyColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
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
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: SaloonyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: SaloonyColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}