import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/quantity_stepper.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedColor = 0;
  int _selectedSize = 0;
  int _galleryIndex = 0;

  List<String> get _gallery => widget.product.gallery.isNotEmpty
      ? widget.product.gallery
      : [widget.product.image];

  List<Product> get _related {
    final list = AppState.instance.products
        .where((p) => p.id != widget.product.id)
        .toList()
      ..sort((a, b) {
        final aSame = a.categoryId == widget.product.categoryId ? 0 : 1;
        final bSame = b.categoryId == widget.product.categoryId ? 0 : 1;
        return aSame.compareTo(bSame);
      });
    return list.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final state = AppState.instance;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: _RoundIcon(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              _RoundIcon(icon: Icons.share_outlined, onTap: () {}),
              ListenableBuilder(
                listenable: state,
                builder: (context, _) => _RoundIcon(
                  icon: state.isWishlisted(product)
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: state.isWishlisted(product)
                      ? AppColors.danger
                      : AppColors.ink,
                  onTap: () => state.toggleWishlist(product),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: _gallery.length,
                    onPageChanged: (i) => setState(() => _galleryIndex = i),
                    itemBuilder: (context, i) => HubImage(_gallery[i]),
                  ),
                  if (_gallery.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_gallery.length, (i) {
                          final active = i == _galleryIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.brand.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _StarRating(product: product),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(product.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (product.oldPrice != null)
                        Text(
                          formatPrice(product.oldPrice!),
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        '${product.reviewCount} reviews',
                        style:
                            TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                  if (product.isOnSale && product.discountPercent > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SAVE ${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 20),
                  if (product.colors.isNotEmpty) ...[
                    _SectionTitle(
                      title: 'Colour',
                      value: product.colorHexes[_selectedColor],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      children: List.generate(product.colors.length, (i) {
                        final color = product.colors[i];
                        final active = i == _selectedColor;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = i),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: active
                                    ? AppColors.accent
                                    : AppColors.border,
                                width: active ? 3 : 1,
                              ),
                            ),
                            child: active
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 20)
                                : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (product.sizes.isNotEmpty) ...[
                    _SectionTitle(title: 'Size', value: product.sizes[_selectedSize]),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(product.sizes.length, (i) {
                        final active = i == _selectedSize;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  active ? AppColors.accent : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? AppColors.accent
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              product.sizes[i],
                              style: TextStyle(
                                color: active
                                    ? Colors.white
                                    : AppColors.inkSoft,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text('Description',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(
                        color: AppColors.inkSoft, fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 26),
                  const Divider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity',
                          style: Theme.of(context).textTheme.titleMedium),
                      QuantityStepper(
                        value: _quantity,
                        onChanged: (v) =>
                            setState(() => _quantity = v < 1 ? 1 : v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 12),
              child: Text('You may also like',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                scrollDirection: Axis.horizontal,
                itemCount: _related.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) => SizedBox(
                  width: 170,
                  child: ProductCard(product: _related[i]),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        onAddToCart: () {
          AppState.instance.addToCart(
            product,
            quantity: _quantity,
            size: product.sizes.isEmpty
                ? null
                : product.sizes[_selectedSize],
            color: product.colors.isEmpty
                ? null
                : product.colors[_selectedColor],
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.title} added to cart'),
              action: SnackBarAction(
                label: 'View Cart',
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.value});
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          value ?? '',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
        const SizedBox(width: 4),
        Text(
          product.rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color ?? AppColors.ink, size: 20),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onAddToCart});
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: const [
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
            onPressed: onAddToCart,
            child: const Text('Add to Cart'),
          ),
        ),
      ),
    );
  }
}