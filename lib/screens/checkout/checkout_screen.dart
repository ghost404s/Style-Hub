import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import 'payment_screen.dart';
import 'shipping_address_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          if (state.cart.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: AppColors.muted),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              _SectionTitle('Items (${state.cartCount})'),
              const SizedBox(height: 12),
              ...state.cart.map((item) => _ItemRow(item: item)),
              const SizedBox(height: 24),
              _SectionTitle('Delivery'),
              const SizedBox(height: 12),
              _AddressCard(
                address: state.defaultAddress,
                onChange: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ShippingAddressScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle('Payment method'),
              const SizedBox(height: 12),
              _PaymentMethodCard(
                onChange: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle('Order summary'),
              const SizedBox(height: 12),
              _SummaryCard(state: state),
              const SizedBox(height: 24),
              _SectionTitle('Need help?'),
              const SizedBox(height: 8),
              Text(
                'Our support team is available 24/7 — chat with us anytime.',
                style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.5),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: state,
        builder: (context, _) => SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14111111),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                ),
                child: Text(
                  'Continue to Payment  ·  ${formatPrice(state.cartSubtotal + state.shippingCost + state.tax)}',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 62,
              height: 74,
              child: HubImage(item.product.image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Size ${item.size} · Qty ${item.quantity}',
                  style:
                      TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            formatPrice(item.total),
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onChange});
  final Address? address;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return _CardRow(
      icon: Icons.location_on_outlined,
      title: address?.summary ?? 'No shipping address selected',
      subtitle: address == null
          ? 'Add an address to continue'
          : '${address!.fullName} · ${address!.phone}',
      action: TextButton(onPressed: onChange, child: const Text('Change')),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.onChange});
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return _CardRow(
      icon: Icons.credit_card_rounded,
      title: 'Pay on delivery / card',
      subtitle: 'Choose a payment option at checkout',
      action: TextButton(onPressed: onChange, child: const Text('Change')),
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style:
                      TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          action,
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final total = state.cartSubtotal + state.shippingCost + state.tax;
    Widget row(String label, String value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: bold ? AppColors.ink : AppColors.muted,
                fontSize: bold ? 15 : 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.ink,
                fontSize: bold ? 15 : 14,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          row('Subtotal', formatPrice(state.cartSubtotal)),
          row('Shipping',
              state.shippingCost == 0 ? 'Free' : formatPrice(state.shippingCost)),
          row('Tax (8%)', formatPrice(state.tax)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1),
          ),
          row('Total', formatPrice(total), bold: true),
        ],
      ),
    );
  }
}