import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../main.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../checkout/shipping_address_screen.dart';
import '../notifications/notifications_screen.dart';
import '../orders/order_history_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _ProfileHeader(state: state),
              const SizedBox(height: 20),
              _StatsRow(state: state),
              const SizedBox(height: 24),
              _MenuGroup(
                items: [
                  _MenuItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Order History',
                    trailing: '${state.orders.length} orders',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'Shipping Addresses',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShippingAddressScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    trailing: state.unreadCount > 0
                        ? '${state.unreadCount} new'
                        : null,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _MenuGroup(
                items: [
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => _info(context, 'Help & Support',
                        'Our 24/7 support team is here to help. Email us at '
                        'support@stylehub.app or use the in-app chat.'),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About StyleHub',
                    trailing: 'v1.0.0',
                    onTap: () => _info(context, 'About StyleHub',
                        'StyleHub is a modern e-commerce demo powered by the '
                        'DummyJSON catalogue. Built with Flutter.'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log Out'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
            'You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AppState.instance.logout();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RootGate()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _info(BuildContext context, String title, String body) {
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
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient(),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: HubImage(state.user.avatarUrl),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.user.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                state.user.email,
                style:
                    TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                state.user.phone,
                style:
                    TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    Widget stat(int value, String label, {VoidCallback? onTap}) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style:
                      TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        stat(state.orders.length, 'Orders'),
        const SizedBox(width: 12),
        stat(state.wishlistProducts.length, 'Wishlist'),
        const SizedBox(width: 12),
        stat(state.cartCount, 'Cart'),
      ],
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              if (i > 0)
                const Divider(height: 1, indent: 60, endIndent: 16),
              items[i],
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: AppColors.accent, size: 19),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style:
                  TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.muted, size: 20),
        ],
      ),
    );
  }
}