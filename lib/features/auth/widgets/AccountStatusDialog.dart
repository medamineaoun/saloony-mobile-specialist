import 'package:flutter/material.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyColors.dart';
import 'package:SaloonySpecialist/core/constants/SaloonyTextStyles.dart';
import 'package:SaloonySpecialist/core/widgets/SaloonyButtons.dart';
import 'package:SaloonySpecialist/core/services/UserService.dart';
import 'package:SaloonySpecialist/core/services/ToastService.dart';

class AccountStatusDialog extends StatefulWidget {
  final String accountStatus; // 'DEACTIVATE' or 'BLOCKED'
  final VoidCallback onAccountActivated;

  const AccountStatusDialog({
    Key? key,
    required this.accountStatus,
    required this.onAccountActivated,
  }) : super(key: key);

  @override
  State<AccountStatusDialog> createState() => _AccountStatusDialogState();
}

class _AccountStatusDialogState extends State<AccountStatusDialog> {
  final UserService _userService = UserService();
  bool _isLoading = false;

  void _handleActivateAccount() async {
    setState(() => _isLoading = true);

    try {
      final result = await _userService.activateAccount();

      if (mounted) {
        setState(() => _isLoading = false);

        if (result['success'] == true) {
          ToastService.showSuccess(context, 'Account activated successfully');
          
          // Wait a moment then call the callback
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            Navigator.of(context).pop();
            widget.onAccountActivated();
          }
        } else {
          ToastService.showError(
            context,
            result['message'] ?? 'Failed to activate account',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Error activating account: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeactivated = widget.accountStatus == 'DEACTIVATE';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: SaloonyColors.backgroundSecondary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDeactivated
                      ? Colors.amber.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                ),
                child: Icon(
                  isDeactivated ? Icons.lock_outline : Icons.block_rounded,
                  size: 40,
                  color: isDeactivated ? Colors.amber[700] : Colors.red[700],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                isDeactivated
                    ? 'Account Desactivated'
                    : 'Account Blocked',
                style: SaloonyTextStyles.heading2.copyWith(
                  color: SaloonyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                isDeactivated
                    ? 'Your account has been desactivated. You can reactivate it anytime.'
                    : 'Your account has been blocked by the administrator. Please contact Saloony support for assistance.',
                style: SaloonyTextStyles.bodySmall.copyWith(
                  color: SaloonyColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Buttons
              if (isDeactivated) ...[
                SaloonyPrimaryButton(
                  label: 'Reactivate Account',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? () {} : _handleActivateAccount,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Later',
                    style: SaloonyTextStyles.bodySmall.copyWith(
                      color: SaloonyColors.primary,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Saloony Support:',
                        style: SaloonyTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: support@saloony.com\nPhone: +1 (555) 000-0000',
                        style: SaloonyTextStyles.bodySmall.copyWith(
                          color: SaloonyColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SaloonyPrimaryButton(
                  label: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
