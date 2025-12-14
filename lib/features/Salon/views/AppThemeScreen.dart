import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:SaloonySpecialist/core/providers/ThemeProvider.dart';
import 'package:SaloonySpecialist/core/widgets/SaloonyCommonWidgets.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyTextStyles.dart';

class AppThemeScreen extends StatefulWidget {
  const AppThemeScreen({super.key});

  @override
  State<AppThemeScreen> createState() => _AppThemeScreenState();
}

class _AppThemeScreenState extends State<AppThemeScreen> {
  late String _selectedTheme;

  final List<ThemeOption> _themeOptions = [
    ThemeOption(
      title: 'Light',
      description: 'Bright and clean appearance',
      icon: Icons.light_mode_outlined,
      color: SaloonyColors.secondary,
      themeValue: 'light',
    ),
    ThemeOption(
      title: 'Dark',
      description: 'Easy on the eyes in low light',
      icon: Icons.dark_mode_outlined,
      color: SaloonyColors.primary,
      themeValue: 'dark',
    ),
    ThemeOption(
      title: 'System Default',
      description: 'Follow your device theme',
      icon: Icons.phone_iphone_outlined,
      color: Color(0xFF4CAF50),
      themeValue: 'system',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTheme = context.read<ThemeProvider>().currentTheme;
    _mapThemeToSelection();
  }

  /// Map le thème du provider à notre sélection locale
  void _mapThemeToSelection() {
    final provider = context.read<ThemeProvider>();
    switch (provider.currentTheme) {
      case 'dark':
        _selectedTheme = 'Dark';
        break;
      case 'system':
        _selectedTheme = 'System Default';
        break;
      default:
        _selectedTheme = 'Light';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: SaloonyColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'App Theme',
          style: SaloonyTextStyles.heading3,
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
                style: SaloonyTextStyles.bodyLarge.copyWith(color: SaloonyColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'The theme will change the appearance of the app',
                style: SaloonyTextStyles.bodySmall,
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
            ? Border.all(color: SaloonyColors.primary, width: 2)
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
          style: SaloonyTextStyles.heading4,
        ),
        subtitle: Text(
          theme.description,
          style: SaloonyTextStyles.bodySmall,
        ),
        trailing: isSelected
            ? Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: SaloonyColors.primary,
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
    return SaloonyPrimaryButton(
      label: 'Apply Theme',
      onPressed: _applyTheme,
      isFullWidth: true,
      height: 56,
      icon: Icons.palette_outlined,
    );
  }

  Future<void> _applyTheme() async {
    final provider = context.read<ThemeProvider>();
    final themeValue = _getThemeValue(_selectedTheme);
    
    debugPrint('Applying theme: $_selectedTheme (value: $themeValue)');
    
    // Appliquer le thème via le provider
    await provider.setTheme(themeValue);
    
    if (mounted) {
      _showSuccessMessage();
    }
  }

  /// Convertir le titre du thème à la valeur utilisée par le provider
  String _getThemeValue(String title) {
    switch (title) {
      case 'Dark':
        return 'dark';
      case 'System Default':
        return 'system';
      default:
        return 'light';
    }
  }

  void _showSuccessMessage() {
    SaloonySnackBar.show(
      context,
      message: 'Theme changed to $_selectedTheme',
      type: SnackBarType.success,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 1800), () {
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
  final String themeValue;

  ThemeOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.themeValue,
  });
}