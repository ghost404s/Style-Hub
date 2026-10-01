import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../screens/splash_screen.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _orderUpdates = true;
  bool _offers = false;
  bool _biometrics = false;
  String _currency = 'USD';
  String _language = 'English (US)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _GroupLabel('Appearance'),
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) => _SettingsGroup(
              children: [
                _Tile(
                  icon: AppState.instance.darkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  trailing: Switch(
                    value: AppState.instance.darkMode,
                    onChanged: (v) => AppState.instance.setDarkMode(v),
                    activeThumbColor: Colors.white,
                  ),
                  onTap: () => AppState.instance
                      .setDarkMode(!AppState.instance.darkMode),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _GroupLabel('Account'),
          _SettingsGroup(
            children: [
              _Tile(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                subtitle: 'Cards & wallets linked to StyleHub',
                onTap: () => _info(
                    'Payment Methods',
                    'You can change your default payment method at checkout. '
                    'Linked cards and wallets are stored securely.'),
              ),
              _Divider(),
              _Tile(
                icon: Icons.lock_outline_rounded,
                title: 'Biometric Sign-in',
                subtitle: 'Use Face ID / fingerprint to sign in',
                trailing: Switch(
                  value: _biometrics,
                  onChanged: (v) => setState(() => _biometrics = v),
                  activeThumbColor: AppColors.accent,
                ),
                onTap: () => setState(() => _biometrics = !_biometrics),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SettingsGroup(
            children: [
              _Tile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                subtitle: 'Manage your data & permissions',
                onTap: () => _info('Privacy',
                    'StyleHub safeguards your personal data. You can request '
                    'a copy or delete your account anytime from this screen.'),
              ),
              _Divider(),
              _Tile(
                icon: Icons.security_outlined,
                title: 'Security',
                subtitle: 'Password and sign-in protection',
                onTap: () => _info('Security',
                    'Use a strong, unique password and enable biometric '
                    'sign-in for faster, safer access.'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SettingsGroup(
            children: [
              _Tile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _language,
                onTap: () => _pickOptions(
                  'Language',
                  _language,
                  ['English (US)', 'English (UK)', 'Español', 'Français', 'Deutsch'],
                  (v) => setState(() => _language = v!),
                ),
              ),
              _Divider(),
              _Tile(
                icon: Icons.currency_exchange_rounded,
                title: 'Currency',
                subtitle: _currency,
                onTap: () => _pickOptions(
                  'Currency',
                  _currency,
                  ['USD', 'EUR', 'GBP', 'INR', 'AED'],
                  (v) => setState(() => _currency = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SettingsGroup(
            children: [
              _Tile(
                icon: _notifications ? Icons.notifications_rounded : Icons.notifications_off_outlined,
                title: 'Push Notifications',
                subtitle: 'Order and general updates',
                trailing: Switch(
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                onTap: () => setState(() => _notifications = !_notifications),
              ),
              _Divider(),
              _Tile(
                icon: Icons.mark_chat_unread_outlined,
                title: 'Order Updates',
                subtitle: 'Status and shipping alerts',
                enabled: _notifications,
                trailing: Switch(
                  value: _orderUpdates,
                  activeThumbColor: AppColors.accent,
                  onChanged: _notifications
                      ? (v) => setState(() => _orderUpdates = v)
                      : null,
                ),
                onTap: _notifications
                    ? () => setState(() => _orderUpdates = !_orderUpdates)
                    : null,
              ),
              _Divider(),
              _Tile(
                icon: Icons.local_offer_outlined,
                title: 'Offers & Deals',
                subtitle: 'Promotional emails about sales',
                enabled: _notifications,
                trailing: Switch(
                  value: _offers,
                  activeThumbColor: AppColors.accent,
                  onChanged: _notifications
                      ? (v) => setState(() => _offers = v)
                      : null,
                ),
                onTap: _notifications
                    ? () => setState(() => _offers = !_offers)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SettingsGroup(
            children: [
              _Tile(
                icon: Icons.restart_alt_rounded,
                title: 'Reset App',
                subtitle: 'Clear local preferences and start over',
                onTap: () => _confirmReset(),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'StyleHub v1.0.0',
              style: TextStyle(
                color: AppColors.muted.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _info(String title, String body) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _pickOptions(
    String title,
    String current,
    List<String> options,
    ValueChanged<String?> onSelected,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (dialogContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            ...options.map((option) => ListTile(
                  title: Text(option),
                  trailing: option == current
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.accent)
                      : null,
                  onTap: () {
                    onSelected(option);
                    Navigator.of(dialogContext).pop();
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmReset() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset app?'),
        content: const Text(
            'This clears preferences and signs you out. Your catalog and '
            'demo data will reload on next launch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 60, endIndent: 16);
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.enabled = true,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.accentLight
              : AppColors.accentLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon,
            color: enabled ? AppColors.accent : AppColors.muted, size: 19),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? AppColors.ink : AppColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: enabled ? AppColors.muted : AppColors.muted.withValues(alpha: 0.6),
          fontSize: 12,
        ),
      ),
      trailing: trailing ??
          Icon(Icons.chevron_right_rounded,
              color: AppColors.muted, size: 20),
    );
  }
}