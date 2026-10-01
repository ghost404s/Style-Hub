import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _StatusHeader(order: order),
          const SizedBox(height: 24),
          _Section('Items'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: order.items
                  .map((item) => _ItemRow(item: item))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          _Section('Delivery address'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.accent, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.address.fullName,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.address.summary,
                        style: TextStyle(
                            color: AppColors.inkSoft, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.address.phone,
                        style: TextStyle(
                            color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _Section('Payment'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_outlined,
                    color: AppColors.accent, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.paymentMethod,
                    style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Text(
                  'Paid',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _Section('Order summary'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _row('Subtotal', formatPrice(order.subtotal)),
                _row('Shipping',
                    order.shipping == 0 ? 'Free' : formatPrice(order.shipping)),
                _row('Tax (8%)', formatPrice(order.tax)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _row('Total', formatPrice(order.total), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () => _reorder(context, state),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reorder All Items'),
            ),
          ),
        ],
      ),
    );
  }

  void _reorder(BuildContext context, AppState state) {
    for (final item in order.items) {
      state.addToCart(
        item.product,
        quantity: item.quantity,
        size: item.size,
        color: item.color,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Items added back to your cart')),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                order.status.label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Placed on ${_date(order.placedAt)}',
            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
          ),
          const SizedBox(height: 20),
          _Timeline(status: order.status),
        ],
      ),
    );
  }

  String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year} at $h:$m';
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});
  final OrderStatus status;

  static const _steps = [
    (OrderStatus.processing, Icons.inventory_2_outlined, 'Processing'),
    (OrderStatus.confirmed, Icons.verified_outlined, 'Confirmed'),
    (OrderStatus.shipped, Icons.local_shipping_outlined, 'Shipped'),
    (OrderStatus.delivered, Icons.house_outlined, 'Delivered'),
  ];

  @override
  Widget build(BuildContext context) {
    final reached = switch (status) {
      OrderStatus.cancelled => 0,
      OrderStatus.processing => 1,
      OrderStatus.confirmed => 2,
      OrderStatus.shipped => 3,
      OrderStatus.delivered => 4,
    };
    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final done = i < reached;
        final last = i == _steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: done
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      done ? step.$2 : Icons.circle_outlined,
                      size: 16,
                      color: done ? AppColors.accent : Colors.white,
                    ),
                  ),
                  if (!last)
                    Container(
                      width: 2,
                      height: 22,
                      color: done
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  step.$3,
                  style: TextStyle(
                    color: done ? Colors.white : Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: done ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 54,
              height: 64,
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
                  maxLines: 2,
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