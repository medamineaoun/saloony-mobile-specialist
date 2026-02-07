import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/SaloonyColors.dart';
import '../../../core/constants/SaloonyTextStyles.dart';
import '../../../core/widgets/SaloonyButtons.dart';
import '../../../core/widgets/SaloonyInputFields.dart';
import 'package:SaloonySpecialist/features/auth/viewmodels/VerifyEmailViewModel.dart';

class VerifyEmailWidget extends StatelessWidget {
  const VerifyEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) => VerifyEmailViewModel(email, context),
      child: Consumer<VerifyEmailViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: SaloonyColors.backgroundSecondary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Verify Email",
                  style: SaloonyTextStyles.labelLarge.copyWith(color: SaloonyColors.textPrimary),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: SaloonyColors.borderLight),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Color(0xFF1B2B3E),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            // Image de vérification email
                            Center(
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/images/code.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF1B2B3E).withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.mark_email_read_outlined,
                                          size: 70,
                                          color: Color(0xFFF0CD97),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Titre
                            Text(
                              'Check Your Email',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.heading1,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'A verification code has been sent to',
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.subtitle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              textAlign: TextAlign.center,
                              style: SaloonyTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 48),
                            // Code input avec 6 cases
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verification Code', style: SaloonyTextStyles.labelLarge),
                                const SizedBox(height: 12),
                                CodeInputField(controller: vm.codeController, enabled: !vm.isLoading),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Verify button
                            SaloonyPrimaryButton(
                              label: 'Verify Code',
                              isLoading: vm.isLoading,
                              onPressed: vm.isLoading
                                  ? () {}
                                  : () async {
                                      final success = await vm.verifyCode();
                                      if (success && context.mounted) {
                                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                                      } else if (!success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Invalid or expired code",
                                              style: SaloonyTextStyles.bodyMedium,
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                            ),
                            const SizedBox(height: 24),
                            // Resend code
                            Center(
                              child: TextButton(
                                onPressed: vm.isLoading
                                    ? null
                                    : () async {
                                        final success = await vm.resendCode();
                                        if (success && context.mounted) {
                                          vm.codeController.clear();
                                        } else if (!success && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error sending code",
                                                style: SaloonyTextStyles.bodyMedium,
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Didn't receive the code? ",
                                        style: SaloonyTextStyles.bodySmall.copyWith(color: SaloonyColors.textSecondary),
                                      ),
                                      TextSpan(
                                        text: "Resend",
                                        style: SaloonyTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: vm.isLoading ? SaloonyColors.textTertiary : SaloonyColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget personnalisé pour l'input de code à 6 chiffres
class CodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;

  const CodeInputField({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Écouter les changements du controller principal
    widget.controller.addListener(_onMainControllerChanged);
  }

  void _onMainControllerChanged() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      // Clear all fields
      for (var controller in _controllers) {
        controller.clear();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onMainControllerChanged);
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Mettre à jour le controller principal
    _updateMainController();
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _updateMainController() {
    final code = _controllers.map((c) => c.text).join();
    widget.controller.text = code;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          height: 60,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: SaloonyTextStyles.bodyLarge.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textPrimary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
                decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: SaloonyColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: SaloonyColors.borderLight, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: SaloonyColors.primary,
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: SaloonyColors.tertiaryLight),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) => _onChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}