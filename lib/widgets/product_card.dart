import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../screens/product/product_details_screen.dart';
import '../theme/app_theme.dart';

/// Product image with graceful offline fallback.
class HubImage extends StatelessWidget {
  const HubImage(this.url, {super.key, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, _) => const ColoredBox(
        color: Color(0xFF1B1B2F),
      ),
      errorWidget: (_, _, _) => const _ImageFallback(),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E2A4A), Color(0xFF1B1B2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xCCFFFFFF),
          size: 32,
        ),
      ),
    );
  }
}

/// Tappable product tile used in grids.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width,
  });

  final Product product;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(product: product),
                ),
              ),
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F111111),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: HubImage(product.image),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Badges(product: product),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _WishlistButton(product: product, small: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          formatPrice(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            formatPrice(product.oldPrice!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: AppColors.star, size: 15),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (product.isOnSale && product.discountPercent > 0)
          _Badge(
            label: '-${product.discountPercent}%',
            color: AppColors.surface,
            background: AppColors.danger,
          ),
        if (product.isNew) ...[
          const SizedBox(width: 6),
          const _Badge(
            label: 'NEW',
            color: Colors.white,
            background: AppColors.accent,
          ),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
  });
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Heart button synced with the app-wide wishlist.
class WishlistButton extends StatefulWidget {
  const WishlistButton({super.key, required this.product});
  final Product product;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final active = state.isWishlisted(widget.product);
        return GestureDetector(
          onTap: () => state.toggleWishlist(widget.product),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                active ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(active),
                color: active ? AppColors.danger : AppColors.ink,
                size: 21,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Small wrapper so ProductCard can inline a compact heart.
class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.product, required this.small});
  final Product product;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final active = state.isWishlisted(product);
        return GestureDetector(
          onTap: () => state.toggleWishlist(product),
          child: Container(
            width: small ? 34 : 38,
            height: small ? 34 : 38,
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
            child: Icon(
              active ? Icons.favorite : Icons.favorite_border,
              color: active ? AppColors.danger : AppColors.ink,
              size: small ? 19 : 21,
            ),
          ),
        );
      },
    );
  }
}