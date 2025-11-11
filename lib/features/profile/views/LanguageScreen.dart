import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<LanguageOption> _languageOptions = [
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
   
    LanguageOption(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
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
          'Language',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1B2B3E)),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B3E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1B2B3E).withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    color: const Color(0xFF1B2B3E),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select your preferred language for the app interface',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF1B2B3E).withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _languageOptions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final language = _languageOptions[index];
                return _buildLanguageOption(language);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                _applyLanguage();
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
                  const Icon(Icons.language_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Apply Language',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(LanguageOption language) {
    final isSelected = _selectedLanguage == language.name;
    
    return ListTile(
      onTap: () {
        setState(() {
          _selectedLanguage = language.name;
        });
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            language.flag,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      title: Text(
        language.name,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1B2B3E),
        ),
      ),
      subtitle: Text(
        language.nativeName,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF1B2B3E).withOpacity(0.6),
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2B3E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1B2B3E)),
              ),
              child: Text(
                'Selected',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: LanguageSearchDelegate(_languageOptions, (language) {
        setState(() {
          _selectedLanguage = language.name;
        });
      }),
    );
  }

  void _applyLanguage() {
    // TODO: Implement language change logic
    final selectedLang = _languageOptions.firstWhere(
      (lang) => lang.name == _selectedLanguage,
    );
    debugPrint('Applying language: ${selectedLang.name} (${selectedLang.code})');
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language changed to $_selectedLanguage',
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

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class LanguageSearchDelegate extends SearchDelegate {
  final List<LanguageOption> languages;
  final Function(LanguageOption) onLanguageSelected;

  LanguageSearchDelegate(this.languages, this.onLanguageSelected);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredLanguages = languages.where((language) {
      return language.name.toLowerCase().contains(query.toLowerCase()) ||
          language.nativeName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredLanguages.length,
      itemBuilder: (context, index) {
        final language = filteredLanguages[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                language.flag,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          title: Text(
            language.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1B2B3E),
            ),
          ),
          subtitle: Text(
            language.nativeName,
            style: GoogleFonts.poppins(
              color: const Color(0xFF1B2B3E).withOpacity(0.6),
            ),
          ),
          onTap: () {
            onLanguageSelected(language);
            close(context, null);
          },
        );
      },
    );
  }
}