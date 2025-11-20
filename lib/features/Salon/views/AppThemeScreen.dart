import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeScreen extends StatefulWidget {
  const AppThemeScreen({super.key});

  @override
  State<AppThemeScreen> createState() => _AppThemeScreenState();
}

class _AppThemeScreenState extends State<AppThemeScreen> {
  String _selectedTheme = 'Light';

  final List<ThemeOption> _themeOptions = [
    ThemeOption(
      title: 'Light',
      description: 'Bright and clean appearance',
      icon: Icons.light_mode_outlined,
      color: const Color(0xFFF0CD97),
    ),
    ThemeOption(
      title: 'Dark',
      description: 'Easy on the eyes in low light',
      icon: Icons.dark_mode_outlined,
      color: const Color(0xFF1B2B3E),
    ),
    ThemeOption(
      title: 'System Default',
      description: 'Follow your device theme',
      icon: Icons.phone_iphone_outlined,
      color: const Color(0xFF4CAF50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1B2B3E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'App Theme',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your preferred theme',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF1B2B3E).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The theme will change the appearance of the app',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1B2B3E).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: ListView.separated(
                  itemCount: _themeOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final theme = _themeOptions[index];
                    return _buildThemeOption(theme);
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeOption theme) {
    final isSelected = _selectedTheme == theme.title;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected 
            ? Border.all(color: const Color(0xFF1B2B3E), width: 2)
            : Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedTheme = theme.title;
          });
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: theme.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            theme.icon,
            color: theme.color,
            size: 24,
          ),
        ),
        title: Text(
          theme.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        subtitle: Text(
          theme.description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1B2B3E).withOpacity(0.6),
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2B3E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              )
            : Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!),
                ),
              ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        _applyTheme();
        _showSuccessMessage();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B2B3E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.palette_outlined, size: 20),
          const SizedBox(width: 8),
          Text(
            'Apply Theme',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _applyTheme() {
    // TODO: Implement theme change logic
    debugPrint('Applying theme: $_selectedTheme');
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme changed to $_selectedTheme',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF1B2B3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    
    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}

class ThemeOption {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ThemeOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}